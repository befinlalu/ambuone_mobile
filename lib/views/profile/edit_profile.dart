part of 'index.dart';

class EditProfile extends StatefulWidget {
  final UserDetails? user;

  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages =
      4; // Step 1: Photo, 2: Address, 3: Contacts, 4: Medical
  final ImagePicker _picker = ImagePicker();
  File? _newPhotoFile;

  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

  // Controllers
  late TextEditingController _addressController;
  late TextEditingController _pinController;
  late TextEditingController _healthController;
  late TextEditingController _medicineController;

  // Emergency Contact Controllers
  late TextEditingController _spouseNameController;
  late TextEditingController _spouseMobileController;
  late TextEditingController _relativeNameController;
  late TextEditingController _relativeMobileController;
  late TextEditingController _friend1NameController;
  late TextEditingController _friend1MobileController;
  late TextEditingController _friend2NameController;
  late TextEditingController _friend2MobileController;
  late TextEditingController _friend3NameController;
  late TextEditingController _friend3MobileController;

  String? _selectedState;
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.user?.profile;

    // Address Info
    _addressController = TextEditingController(text: p?.address);
    _pinController = TextEditingController(text: p?.pinCode);
    _selectedState = p?.state;

    // Medical Info
    _healthController = TextEditingController(text: p?.healthConditions);
    _medicineController = TextEditingController(text: p?.medicines);

    // Emergency Contacts
    _spouseNameController = TextEditingController(text: p?.spouseName);
    _spouseMobileController = TextEditingController(text: p?.spouseMobile);
    _relativeNameController = TextEditingController(text: p?.relativeName);
    _relativeMobileController = TextEditingController(text: p?.relativeMobile);
    _friend1NameController = TextEditingController(text: p?.friend1Name);
    _friend1MobileController = TextEditingController(text: p?.friend1Mobile);
    _friend2NameController = TextEditingController(text: p?.friend2Name);
    _friend2MobileController = TextEditingController(text: p?.friend2Mobile);
    _friend3NameController = TextEditingController(text: p?.friend3Name);
    _friend3MobileController = TextEditingController(text: p?.friend3Mobile);
  }

  @override
  void dispose() {
    // Page controller
    _pageController.dispose();

    // Address
    _addressController.dispose();
    _pinController.dispose();

    // Medical
    _healthController.dispose();
    _medicineController.dispose();

    // Emergency Contacts
    _spouseNameController.dispose();
    _spouseMobileController.dispose();
    _relativeNameController.dispose();
    _relativeMobileController.dispose();

    _friend1NameController.dispose();
    _friend1MobileController.dispose();
    _friend2NameController.dispose();
    _friend2MobileController.dispose();
    _friend3NameController.dispose();
    _friend3MobileController.dispose();

    super.dispose();
  }

  RegisterModel _buildUpdateModel() {
    return RegisterModel(
      // Address
      address: _addressController.text.trim(),
      pinCode: _pinController.text.trim(),
      state: _selectedState,

      // Medical
      healthConditions: _healthController.text.trim(),
      medicines: _medicineController.text.trim(),

      // Emergency Contacts
      spouseName: _spouseNameController.text.trim(),
      spouseMobile: _spouseMobileController.text.trim(),
      relativeName: _relativeNameController.text.trim(),
      relativeMobile: _relativeMobileController.text.trim(),

      friend1Name: _friend1NameController.text.trim(),
      friend1Mobile: _friend1MobileController.text.trim(),
      friend2Name: _friend2NameController.text.trim(),
      friend2Mobile: _friend2MobileController.text.trim(),
      friend3Name: _friend3NameController.text.trim(),
      friend3Mobile: _friend3MobileController.text.trim(),

      // Files
      photo: _newPhotoFile,
    );
  }

  // Navigation Logic
  void _nextPage() {
    if (!_formKeys[_currentPage].currentState!.validate()) return;
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleSave();
    }
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleSave() {
    // Validate last form
    if (!_formKeys[_currentPage].currentState!.validate()) return;

    final updateModel = _buildUpdateModel();

    final fields = updateModel.toUpdateFields();
    final files = updateModel.toUpdateFiles();

    debugPrint("UPDATE FIELDS: $fields");
    debugPrint("UPDATE FILES: ${files.keys}");

    context.read<UserBloc>().add(UpdateProfileEvent(form: updateModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: 'Edit Profile', isLeading: true),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {},
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _stepWrapper("Change Profile Photo", _photoStep()),
              _stepWrapper("Residential Address", _addressStep()),
              _stepWrapper("Emergency Contacts", _emergencyStep()),
              _stepWrapper("Medical History", _medicalStep()),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildNavButtons(),
    );
  }

  Widget _photoStep() => Form(
    key: _formKeys[0],
    child: Column(
      spacing: 15,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _newPhotoFile != null
                    ? FileImage(_newPhotoFile!) as ImageProvider
                    : (widget.user?.profile?.photo != null
                          ? NetworkImage(widget.user!.profile!.photo!)
                          : null),
                child:
                    (_newPhotoFile == null &&
                        widget.user?.profile?.photo == null)
                    ? const Icon(Icons.person, size: 70, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: _updatePhoto,
                  ),
                ),
              ),
            ],
          ),
        ),
        PrimaryTextFormField(
          controller: TextEditingController(text: widget.user?.firstName),
          label: 'First Name',
          enabled: false,
        ),
        PrimaryTextFormField(
          controller: TextEditingController(text: widget.user?.lastName),
          label: 'Last Name',
          enabled: false,
        ),
        PrimaryTextFormField(
          controller: TextEditingController(text: widget.user?.phoneNumber),
          label: 'Phone Number',
          enabled: false,
        ),
        PrimaryTextFormField(
          controller: TextEditingController(text: widget.user?.email),
          label: 'Email',
          enabled: false,
        ),
        PrimaryTextFormField(
          controller: TextEditingController(text: widget.user?.profile?.gender),
          label: 'Gender',
          enabled: false,
        ),
        PrimaryTextFormField(
          controller: TextEditingController(
            text: widget.user?.profile?.age?.toString(),
          ),
          label: 'Age',
          enabled: false,
        ),
      ],
    ),
  );

  Widget _addressStep() => Form(
    key: _formKeys[1],
    child: Column(
      spacing: 12,
      children: [
        PrimaryTextFormField(
          controller: _addressController,
          label: 'Address',
          maxLine: 3,
        ),
        PrimaryTextFormField(
          controller: _pinController,
          label: 'Pin Code',
          maxLenth: 6,
          keyboardType: TextInputType.number,
        ),
        PrimaryDropdownFields<String>(
          initialValue: _selectedState,
          label: "Select State",
          items: _states
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedState = v),
        ),
      ],
    ),
  );

  Widget _emergencyStep() => Form(
    key: _formKeys[2],
    child: Column(
      children: [
        _buildContactSection(
          "Spouse Details",
          _spouseNameController,
          _spouseMobileController,
        ),
        const Divider(height: 32),
        _buildContactSection(
          "Relative Details",
          _relativeNameController,
          _relativeMobileController,
        ),
        const Divider(height: 32),
        _buildContactSection(
          "Friend 1",
          _friend1NameController,
          _friend1MobileController,
        ),
        const Divider(height: 32),
        _buildContactSection(
          "Friend 2",
          _friend2NameController,
          _friend2MobileController,
        ),
        const Divider(height: 32),
        _buildContactSection(
          "Friend 3",
          _friend3NameController,
          _friend3MobileController,
        ),
      ],
    ),
  );

  Widget _medicalStep() => Form(
    key: _formKeys[3],
    child: Column(
      spacing: 12,
      children: [
        PrimaryTextFormField(
          controller: _healthController,
          label: "Health Conditions",
          hintText: "Update health conditions or allergies",
          maxLine: 3,
        ),
        PrimaryTextFormField(
          controller: _medicineController,
          label: "Current Medications",
          hintText: "Update medicines and dosages",
          maxLine: 3,
        ),
      ],
    ),
  );

  // --- REUSED UTILS FROM REGISTER ---

  Widget _stepWrapper(String title, Widget form) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Step ${_currentPage + 1} of $_totalPages",
            style: AppFontStyles.bodySmall(context).copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8),
          StepProgressIndicator(
            totalSteps: _totalPages,
            currentStep: _currentPage + 1,
            size: 8,
            padding: 4,
            selectedColor: Theme.of(context).colorScheme.tertiary,
            unselectedColor: Theme.of(context).colorScheme.secondary,
            roundedEdges: const Radius.circular(10),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(title, style: AppFontStyles.h5(context))],
          ),
          const SizedBox(height: 20),
          form,
        ],
      ),
    );
  }

  Widget _buildNavButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: MainButton(
                buttonColor: Theme.of(context).colorScheme.secondary,
                onPressed: _prevPage,
                buttonTitle: 'Previous',
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 15),
          Expanded(
            child: MainButton(
              onPressed: _nextPage,
              buttonTitle: _currentPage == _totalPages - 1 ? "Update" : "Next",
              buttonColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSED CONTACT PICKER LOGIC ---
  Future<void> _updatePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() => _newPhotoFile = File(pickedFile.path));
    }
  }

  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();

  Future<void> _pickContactForFields({
    required TextEditingController nameController,
    required TextEditingController mobileController,
  }) async {
    try {
      final Contact? contact = await _contactPicker.selectContact();
      if (contact != null) {
        setState(() {
          nameController.text = contact.fullName ?? "";
          if (contact.phoneNumbers != null &&
              contact.phoneNumbers!.isNotEmpty) {
            String cleaned = contact.phoneNumbers!.first.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            );
            mobileController.text = cleaned.length > 10
                ? cleaned.substring(cleaned.length - 10)
                : cleaned;
          }
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Widget _buildContactSection(
    String title,
    TextEditingController nameCtrl,
    TextEditingController mobileCtrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: AppFontStyles.bodySmall(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        PrimaryTextFormField(
          controller: nameCtrl,
          label: 'Full Name',
          suffixWidget: IconButton(
            icon: const Icon(Icons.quick_contacts_dialer_outlined),
            onPressed: () => _pickContactForFields(
              nameController: nameCtrl,
              mobileController: mobileCtrl,
            ),
          ),
        ),
        PrimaryTextFormField(
          controller: mobileCtrl,
          label: 'Mobile Number',
          keyboardType: TextInputType.number,
          maxLenth: 10,
          suffixWidget: IconButton(
            icon: const Icon(Icons.quick_contacts_dialer_outlined),
            onPressed: () => _pickContactForFields(
              nameController: nameCtrl,
              mobileController: mobileCtrl,
            ),
          ),
        ),
      ],
    );
  }
}
