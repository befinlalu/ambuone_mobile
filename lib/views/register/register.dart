part of 'index.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 9;
  final ImagePicker _picker = ImagePicker();
  bool _isReferrer = false;
  bool _isTermsAccepted = false;
  String _otp = '';
  bool _isSubmitting = false;

  final _formKeys = List.generate(9, (_) => GlobalKey<FormState>());

  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String? _gender;

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
  String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _aadharNumController = TextEditingController();
  File? _photoFile;
  File? _aadharFile;

  final _spouseNameController = TextEditingController();
  final _spouseMobileController = TextEditingController();

  final _relativeNameController = TextEditingController();
  final _relativeMobileController = TextEditingController();

  final _friend1NameController = TextEditingController();
  final _friend1MobileController = TextEditingController();

  final _friend2NameController = TextEditingController();
  final _friend2MobileController = TextEditingController();

  final _friend3NameController = TextEditingController();
  final _friend3MobileController = TextEditingController();

  // Step 5: Medical

  final _healthController = TextEditingController();
  final _medicineController = TextEditingController();

  final _couponController = TextEditingController();

  // Step 6: Bank & Referral
  final _bankNameController = TextEditingController();
  final _ifscController = TextEditingController();
  final _branchController = TextEditingController();
  final _accNumberController = TextEditingController();
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
      _branchController,
      _accNumberController,
      _friend1NameController,
      _friend1MobileController,
      _friend2NameController,
      _friend2MobileController,
      _friend3NameController,
      _friend3MobileController,
      _spouseMobileController,
      _relativeMobileController,
      _couponController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

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
    final currentForm = _formKeys[_currentPage];

    if (!currentForm.currentState!.validate()) return;

    /// Step 1 – Photo required
    if (_currentPage == 0 && _photoFile == null) {
      ToastService.showError("Please upload photo");
      return;
    }

    /// Step 3 – Verify Serial
    if (_currentPage == 2) {
      context.read<AuthBloc>().add(
        VerfiySerialEvent(serial: _serialController.text),
      );
      return; // wait for bloc success to move
    }

    /// Step 4 – Aadhaar required
    if (_currentPage == 3 && _aadharFile == null) {
      ToastService.showError("Please upload aadhar card");
      return;
    }

    /// Last Step – Terms required
    if (_currentPage == _totalPages - 1 && !_isTermsAccepted) {
      ToastService.showError("Please accept terms and conditions");
      return;
    }

    /// Last Step – Get OTP
    if (_currentPage == _totalPages - 1) {
      context.read<AuthBloc>().add(
        GetRegisterOtpEvent(phoneNumber: _phoneController.text),
      );
      return;
    }

    /// Default – Move to next page
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submitForm() {
    final registerForm = RegisterModel(
      // Step 1 – Personal
      firstName: _fNameController.text.trim().isEmpty
          ? null
          : _fNameController.text.trim(),
      lastName: _lNameController.text.trim().isEmpty
          ? null
          : _lNameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      age: _ageController.text.trim().isEmpty
          ? null
          : int.tryParse(_ageController.text.trim()),
      gender: _gender,

      photo: _photoFile,

      // Step 2 – Address
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      pinCode: _pinController.text.trim().isEmpty
          ? null
          : _pinController.text.trim(),
      state: _selectedState,

      // Step 3 – Subscription
      serialNumber: _serialController.text.trim().isEmpty
          ? null
          : _serialController.text.trim(),
      startDate: startDate,

      // Step 4 – Identification
      aadharNumber: _aadharNumController.text.trim().isEmpty
          ? null
          : _aadharNumController.text.trim(),
      aadharUpload: _aadharFile,

      // Step 5 – Emergency Contacts
      spouseName: _spouseNameController.text.trim().isEmpty
          ? null
          : _spouseNameController.text.trim(),
      spouseMobile: _spouseMobileController.text.trim().isEmpty
          ? null
          : _spouseMobileController.text.trim(),

      relativeName: _relativeNameController.text.trim().isEmpty
          ? null
          : _relativeNameController.text.trim(),
      relativeMobile: _relativeMobileController.text.trim().isEmpty
          ? null
          : _relativeMobileController.text.trim(),

      friend1Name: _friend1NameController.text.trim().isEmpty
          ? null
          : _friend1NameController.text.trim(),
      friend1Mobile: _friend1MobileController.text.trim().isEmpty
          ? null
          : _friend1MobileController.text.trim(),

      friend2Name: _friend2NameController.text.trim().isEmpty
          ? null
          : _friend2NameController.text.trim(),
      friend2Mobile: _friend2MobileController.text.trim().isEmpty
          ? null
          : _friend2MobileController.text.trim(),

      friend3Name: _friend3NameController.text.trim().isEmpty
          ? null
          : _friend3NameController.text.trim(),
      friend3Mobile: _friend3MobileController.text.trim().isEmpty
          ? null
          : _friend3MobileController.text.trim(),

      // Step 6 – Medical
      healthConditions: _healthController.text.trim().isEmpty
          ? null
          : _healthController.text.trim(),
      medicines: _medicineController.text.trim().isEmpty
          ? null
          : _medicineController.text.trim(),

      // Step 7 – Coupon
      couponCode: _couponController.text.trim().isEmpty
          ? null
          : _couponController.text.trim(),

      // Step 8 – Referral + Bank
      isReferrer: _isReferrer,
      referralCode: _referralController.text.trim().isEmpty
          ? null
          : _referralController.text.trim(),
      bankName: _bankNameController.text.trim().isEmpty
          ? null
          : _bankNameController.text.trim(),
      bankAccountNumber: _accNumberController.text.trim().isEmpty
          ? null
          : _accNumberController.text.trim(),
      bankBranch: _branchController.text.trim().isEmpty
          ? null
          : _branchController.text.trim(),
      ifscCode: _ifscController.text.trim().isEmpty
          ? null
          : _ifscController.text.trim(),

      otp: _otp,
    );

    context.read<AuthBloc>().add(
      VerifyRegisterOtpEvent(registerModel: registerForm),
    );

    debugPrint("Registration Submitted!");
  }

  Widget _personalInfoForm() => Form(
    key: _formKeys[0],
    child: Column(
      spacing: 12,
      children: [
        _imageUploadBox(_photoFile, "Photo", () => _pickImage(true)),
        PrimaryTextFormField(
          maxLenth: 50,
          controller: _fNameController,
          label: 'First Name',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        PrimaryTextFormField(
          maxLenth: 50,
          controller: _lNameController,
          label: 'Last Name',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        PrimaryTextFormField(
          maxLenth: 10,
          controller: _phoneController,
          label: 'Phone Number',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
          keyboardType: TextInputType.phone,
        ),
        PrimaryTextFormField(
          maxLenth: 50,
          controller: _emailController,
          label: 'Email',
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        PrimaryDropdownFields(
          initialValue: _gender,
          items: const [
            DropdownMenuItem(value: 'MALE', child: Text('Male')),
            DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
          ],
          onChanged: (v) => setState(() => _gender = v!),
          label: "Gender",
          validator: (v) =>
              (v == null || v.isEmpty) ? 'This field is required' : null,
        ),
      ],
    ),
  );

  Widget _addressForm() => Form(
    key: _formKeys[1],
    child: Column(
      spacing: 10,
      children: [
        PrimaryTextFormField(
          maxLenth: 150,
          controller: _addressController,
          label: 'Address',
          maxLine: 3,
          validator: (v) => v!.isEmpty ? 'This field is required' : null,
        ),
        PrimaryTextFormField(
          maxLenth: 6,
          controller: _pinController,
          label: 'Pin Code',
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'This field is required';
            }
            if (v.length != 6) {
              return 'Pin code must be exactly 12 digits';
            }
            return null;
          },
          keyboardType: TextInputType.number,
        ),
        PrimaryDropdownFields<String>(
          initialValue: _selectedState,
          label: "Select State",
          items: _states
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedState = v),
          validator: (v) =>
              (v == null || v.isEmpty) ? 'This field is required' : null,
        ),
      ],
    ),
  );

  Widget _identificationForm() => Form(
    key: _formKeys[3],
    child: Column(
      spacing: 10,
      children: [
        PrimaryTextFormField(
          maxLenth: 12,
          controller: _aadharNumController,
          keyboardType: TextInputType.number,
          label: 'Aadhar Number',
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'This field is required';
            }
            if (v.length != 12) {
              return 'Aadhar number must be exactly 12 digits';
            }
            return null;
          },
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
            height: label == 'Photo' ? 120 : 120,
            width: label == 'Photo' ? 120 : 200,
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
        Text('Upload $label', style: AppFontStyles.bodySmall(context)),
        const SizedBox(height: 5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: 'AmbuOne', isLeading: false, isLogo: true),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            DialogManager.instance.showLoadingDialog(context);
          }
          if (state is VerfiySerialErrorState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showError(state.message);
          }
          if (state is VerfiySerialSuccessState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(
              context,
              "Serial number verified successfully.",
            );
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }

          if (state is GetOtpSuccessState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(context, "OTP sent successfully.");
            _showOtpSubscribeDialog();
          }
          if (state is GetOtpErrorState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showError(state.message);
          }

          if (state is VerfiyRegisterOtpSuccessState) {
            ToastService.showSuccess(context, 'Subscription successfull.');
            context.go(PageRoutes.login);
          }
          if (state is RegisterErrorState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showError(state.message);
          }
        },
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _stepWrapper("Personal Details", _personalInfoForm()),
              _stepWrapper("Residential Address", _addressForm()),
              _stepWrapper("Subscription Info", _serialFormPlaceholder()),
              _stepWrapper("Identificaton Info", _identificationForm()),
              _stepWrapper("Emergency Contact", _emergencyPlaceholder()),
              _stepWrapper("Medical History", _healthPlaceholder()),
              _stepWrapper("Coupon Code(Optional)", _couponPlaceholder()),
              _stepWrapper("Referral Code(Optional)", _referralPlaceholder()),
              _stepWrapper("Terms and Conditions", _finalPlaceholder()),
            ],
          );
        },
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
          Column(
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
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(title, style: AppFontStyles.h5(context))],
              ),
            ],
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
              buttonTitle: _currentPage == _totalPages - 1
                  ? "Subscribe"
                  : "Next",
              buttonColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serialFormPlaceholder() {
    final DateTime startDate = DateTime.now();
    final DateTime endDate = startDate.add(const Duration(days: 365));

    String formatDate(DateTime date) {
      return "${date.day.toString().padLeft(2, '0')}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.year}";
    }

    return Form(
      key: _formKeys[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            "Enter the serial number from the QR",
            style: AppFontStyles.bodySmall(context),
          ),

          PrimaryTextFormField(
            controller: _serialController,
            label: "Serial Number",
            textCapitalization: TextCapitalization.characters,
            maxLenth: 12,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'This field is required';
              }
              if (v.length != 12) {
                return 'Serial Number must be exactly 12 characters';
              }
              return null;
            },
          ),

          Text(
            "Subscription validity Period",
            style: AppFontStyles.bodySmall(context),
          ),

          _dateInfoRow("Start Date", formatDate(startDate)),
          _dateInfoRow("End Date", formatDate(endDate)),
        ],
      ),
    );
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
            String rawPhone = contact.phoneNumbers!.first;
            String cleaned = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');
            if (cleaned.length > 10) {
              cleaned = cleaned.substring(cleaned.length - 10);
            }

            mobileController.text = cleaned;
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking contact: $e");
    }
  }

  Widget _emergencyPlaceholder() => Form(
    key: _formKeys[4],
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

  Widget _healthPlaceholder() => Form(
    key: _formKeys[5],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          "Medical conditions and current medications",
          style: AppFontStyles.bodySmall(context),
        ),
        PrimaryTextFormField(
          controller: _healthController,
          maxLenth: 150,
          hintText:
              'List any existing health conditions, allergies, or medical concerns',
          maxLine: 3,
          label: "Health Conditions",
        ),
        PrimaryTextFormField(
          controller: _medicineController,
          label: "Current Medications",
          maxLenth: 150,
          hintText: 'List current medications with dosage and frequency.',
          maxLine: 3,
        ),
      ],
    ),
  );

  Widget _couponPlaceholder() => Form(
    key: _formKeys[6],
    child: Column(
      spacing: 12,
      children: [
        PrimaryTextFormField(
          controller: _couponController,
          label: 'Coupon Code',
          hintText: 'Enter the coupon code of creator/influencer(Otpional)',
        ),
      ],
    ),
  );

  Widget _referralPlaceholder() => Form(
    key: _formKeys[7],
    child: Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Referral Code
        PrimaryTextFormField(
          controller: _referralController,
          label: 'Referral Code (Optional)',
          hintText: 'Enter referral code if you have one',
          maxLenth: 10,
          keyboardType: TextInputType.text,
        ),

        /// Become Referrer Checkbox
        Row(
          children: [
            Checkbox(
              value: _isReferrer,
              activeColor: Theme.of(context).colorScheme.tertiary,
              onChanged: (value) {
                setState(() {
                  _isReferrer = value ?? false;
                });
              },
            ),
            Expanded(
              child: Text(
                'Do you want to become a referrer?',
                style: AppFontStyles.bodySmall(context),
              ),
            ),
          ],
        ),

        /// Bank details shown ONLY if user is referrer
        if (_isReferrer) ...[
          const SizedBox(height: 4),

          PrimaryTextFormField(
            controller: _bankNameController,
            label: 'Bank Name',
            hintText: 'e.g. State Bank of India',
            maxLenth: 50,
            keyboardType: TextInputType.name,
          ),

          PrimaryTextFormField(
            controller: _accNumberController,
            label: 'Account Number',
            hintText: 'Enter your bank account number',
            maxLenth: 18,
            keyboardType: TextInputType.number,
          ),

          PrimaryTextFormField(
            controller: _branchController,
            label: 'Branch Name',
            hintText: 'e.g. MG Road Branch',
            maxLenth: 50,
            keyboardType: TextInputType.text,
          ),

          PrimaryTextFormField(
            controller: _ifscController,
            label: 'IFSC Code',
            hintText: 'e.g. SBIN0001234',
            maxLenth: 11,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ],
    ),
  );

  Widget _dateInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFontStyles.bodySmall(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          Text(value, style: AppFontStyles.bodySmall(context)),
        ],
      ),
    );
  }

  Widget _finalPlaceholder() => Form(
    key: _formKeys[8],
    child: Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(
          'Terms & Conditions – Emergency Care Service',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        Text(
          'Please read carefully before proceeding.',
          style: Theme.of(context).textTheme.bodySmall,
        ),

        /// Scrollable Terms Box
        Container(
          height: 260,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _TermTitle('1. Service Scope'),
                  _TermText(
                    'The service provides coordination and dispatch of an ambulance in case of an emergency. '
                    'Ambulance services may be operated by third-party providers. '
                    'Response time depends on location, traffic, and availability.',
                  ),

                  _TermTitle('2. Eligibility'),
                  _TermText(
                    'The service is available only to registered subscribers under an active plan. '
                    'Users must provide accurate personal and location details.',
                  ),

                  _TermTitle('3. User Responsibility'),
                  _TermText(
                    'Users must keep their subscription active and provide precise location details '
                    'to enable ambulance access.',
                  ),

                  _TermTitle('4. Limitations of Service'),
                  _BulletText(
                    'No guarantee of ambulance availability at all times.',
                  ),
                  _BulletText(
                    'Response time depends on traffic, weather, and operational conditions.',
                  ),
                  _BulletText(
                    'No guarantee of patient recovery or survival. Service is limited to transportation and support.',
                  ),

                  _TermTitle('5. Charges & Payment'),
                  _TermText(
                    'Subscription charges must be paid in advance. Additional ambulance usage fees, '
                    'consumables, or hospital costs are payable directly.',
                  ),

                  _TermTitle('6. Third-Party Services'),
                  _TermText(
                    'Ambulances may be operated by third-party providers. We are not responsible '
                    'for their actions or delays.',
                  ),

                  _TermTitle('7. Liability Disclaimer'),
                  _TermText(
                    'We are not liable for delays, non-availability, injuries, or losses. '
                    'Liability is limited strictly to the subscription fee paid.',
                  ),

                  _TermTitle('8. Privacy & Data Use'),
                  _TermText(
                    'User details may be shared with ambulance providers or hospitals '
                    'for emergency purposes only.',
                  ),

                  _TermTitle('9. Termination of Service'),
                  _TermText(
                    'Service may be terminated if false information is provided or '
                    'subscription fees remain unpaid.',
                  ),

                  _TermTitle('10. Governing Law'),
                  _TermText(
                    'Governed by the laws of India. Disputes fall under the courts of Kochi, Kerala.',
                  ),
                ],
              ),
            ),
          ),
        ),

        /// Accept Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              activeColor: Theme.of(context).colorScheme.tertiary,
              value: _isTermsAccepted,
              onChanged: (value) {
                setState(() {
                  _isTermsAccepted = value ?? false;
                });
              },
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isTermsAccepted = !_isTermsAccepted;
                  });
                },
                child: Text(
                  'I have read and agree to the Terms & Conditions',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Future<void> _showOtpSubscribeDialog() async {
    _otp = '';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the 6-digit OTP sent to your mobile number',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    /// OTP Fields (now responsive)
                    OtpFields(
                      length: 6,
                      onCompleted: (value) {
                        setDialogState(() {
                          _otp = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: MainButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.pop(context),
                            buttonTitle: 'Cancel',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MainButton(
                            buttonColor: Theme.of(context).colorScheme.tertiary,
                            onPressed: (_otp.length != 6 || _isSubmitting)
                                ? null
                                : () async {
                                    setDialogState(() {
                                      _isSubmitting = true;
                                    });

                                    _submitForm();

                                    setDialogState(() {
                                      _isSubmitting = false;
                                    });

                                    Navigator.pop(context);
                                  },
                            buttonTitle: 'Subscribe',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
