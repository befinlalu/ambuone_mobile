part of 'index.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;
  final ImagePicker _picker = ImagePicker();

  final _formKeys = List.generate(7, (_) => GlobalKey<FormState>());

  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'MALE';

  final _addressController = TextEditingController();
  final _pinController = TextEditingController();
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

  final _serialController = TextEditingController();
  DateTime startDate = DateTime.now();

  final _aadharNumController = TextEditingController();
  File? _photoFile;
  File? _aadharFile;

  final _spouseNameController = TextEditingController();
  final _relativeNameController = TextEditingController();

  final _healthController = TextEditingController();
  final _medicineController = TextEditingController();

  // Step 6: Bank & Referral
  final _bankNameController = TextEditingController();
  final _ifscController = TextEditingController();
  final _referralController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose all text controllers to free memory
    for (var controller in [
      _fNameController,
      _lNameController,
      _emailController,
      _phoneController,
      _ageController,
      _addressController,
      _pinController,
      _serialController,
      _aadharNumController,
      _spouseNameController,
      _relativeNameController,
      _healthController,
      _medicineController,
      _bankNameController,
      _ifscController,
      _referralController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- LOGIC METHODS ---

  Future<void> _pickImage(bool isPhoto) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        if (isPhoto) {
          _photoFile = File(pickedFile.path);
        } else {
          _aadharFile = File(pickedFile.path);
        }
      });
    }
  }

  void _nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      if (_currentPage < _totalPages - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitForm();
      }
    }
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submitForm() {
    if (_photoFile == null || _aadharFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload both Photo and Aadhar")),
      );
      return;
    }
    // Final logic to create your RegisterModel and call API
    debugPrint("Registration Submitted!");
  }

  Widget _personalInfoForm() => Form(
    key: _formKeys[0],
    child: Column(
      spacing: 10,
      children: [
        _imageUploadBox(_photoFile, "Photo", () => _pickImage(true)),
        PrimaryTextFormField(
          controller: _fNameController,
          label: 'First Name',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        PrimaryTextFormField(
          controller: _lNameController,
          label: 'Last Name',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        PrimaryTextFormField(
          controller: _phoneController,
          label: 'Phone Number',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
          keyboardType: TextInputType.phone,
        ),
        PrimaryTextFormField(controller: _emailController),
        DropdownButtonFormField(
          initialValue: _gender,
          items: const [
            DropdownMenuItem(value: 'MALE', child: Text('Male')),
            DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
          ],
          onChanged: (v) => setState(() => _gender = v!),
          decoration: const InputDecoration(labelText: "Gender"),
        ),
      ],
    ),
  );

  Widget _addressForm() => Form(
    key: _formKeys[1],
    child: Column(
      children: [
        PrimaryTextFormField(
          controller: _addressController,
          label: 'Address',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        PrimaryTextFormField(
          controller: _pinController,
          label: 'Pin Code',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          initialValue: _selectedState,
          hint: const Text("Select State"),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "State",
          ),
          items: _states
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedState = v),
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
      ],
    ),
  );

  Widget _identificationForm() => Form(
    key: _formKeys[3],
    child: Column(
      children: [
        PrimaryTextFormField(
          controller: _aadharNumController,
          label: 'Aadhar Number',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _imageUploadBox(_aadharFile, "Aadhar", () => _pickImage(false)),
          ],
        ),
      ],
    ),
  );

  Widget _imageUploadBox(File? file, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: file == null
                ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(file, fit: BoxFit.cover),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  // --- BUILD MAIN ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Registration (${_currentPage + 1}/$_totalPages)"),
      //   bottom: PreferredSize(
      //     preferredSize: const Size.fromHeight(6),
      //     child: LinearProgressIndicator(
      //       value: (_currentPage + 1) / _totalPages,
      //     ),
      //   ),
      // ),
      appBar: CommonAppbar(title: 'AmbuOne', isLeading: false, isLogo: true),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _stepWrapper("Personal Details", _personalInfoForm()),
          _stepWrapper("Residential Address", _addressForm()),
          _stepWrapper("Subscription Info", _serialFormPlaceholder()),
          _stepWrapper("Document Upload", _identificationForm()),
          _stepWrapper("Emergency Contact", _emergencyPlaceholder()),
          _stepWrapper("Medical History", _healthPlaceholder()),
          _stepWrapper("Bank Details", _finalPlaceholder()),
        ],
      ),
      bottomNavigationBar: _buildNavButtons(),
    );
  }

  Widget _stepWrapper(String title, Widget form) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              child: OutlinedButton(
                onPressed: _prevPage,
                child: const Text("PREVIOUS"),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage == _totalPages - 1 ? "FINISH" : "NEXT"),
            ),
          ),
        ],
      ),
    );
  }

  // Placeholders for remaining forms to keep code concise
  Widget _serialFormPlaceholder() => Form(
    key: _formKeys[2],
    child: PrimaryTextFormField(controller: _serialController),
  );
  Widget _emergencyPlaceholder() => Form(
    key: _formKeys[4],
    child: PrimaryTextFormField(controller: _spouseNameController),
  );
  Widget _healthPlaceholder() => Form(
    key: _formKeys[5],
    child: PrimaryTextFormField(controller: _healthController),
  );
  Widget _finalPlaceholder() => Form(
    key: _formKeys[6],
    child: PrimaryTextFormField(controller: _bankNameController),
  );
}
