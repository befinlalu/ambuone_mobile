part of 'index.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Page Control
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 7;
  final ImagePicker _picker = ImagePicker();

  // Form Keys for each page
  final _formKeys = List.generate(7, (_) => GlobalKey<FormState>());

  // --- CONTROLLERS ---
  // Step 0: Personal
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'MALE';

  // Step 1: Address
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

  // Step 2: Serial & Dates
  final _serialController = TextEditingController();
  DateTime startDate = DateTime.now();

  // Step 3: Identification
  final _aadharNumController = TextEditingController();
  File? _photoFile;
  File? _aadharFile;

  // Step 4: Emergency
  final _spouseNameController = TextEditingController();
  final _relativeNameController = TextEditingController();

  // Step 5: Health
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
      source: isPhoto ? ImageSource.camera : ImageSource.gallery,
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
    print("Registration Submitted!");
  }

  // --- UI SECTIONS (PAGES) ---

  Widget _personalInfoForm() => Form(
    key: _formKeys[0],
    child: Column(
      children: [
        TextFormField(
          controller: _fNameController,
          decoration: const InputDecoration(labelText: "First Name"),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          controller: _lNameController,
          decoration: const InputDecoration(labelText: "Last Name"),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: "Phone"),
          keyboardType: TextInputType.phone,
        ),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        DropdownButtonFormField(
          value: _gender,
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
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: "Full Address"),
        ),
        TextFormField(
          controller: _pinController,
          decoration: const InputDecoration(labelText: "Pin Code"),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: _selectedState,
          hint: const Text("Select State"),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "State",
          ),
          items: _states
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedState = v),
          validator: (v) => v == null ? 'Please select a state' : null,
        ),
      ],
    ),
  );

  Widget _identificationForm() => Form(
    key: _formKeys[3],
    child: Column(
      children: [
        TextFormField(
          controller: _aadharNumController,
          decoration: const InputDecoration(labelText: "Aadhar Number"),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _imageUploadBox(_photoFile, "Photo", () => _pickImage(true)),
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
      appBar: AppBar(
        title: Text("Registration (${_currentPage + 1}/$_totalPages)"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / _totalPages,
          ),
        ),
      ),
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
    child: TextFormField(
      controller: _serialController,
      decoration: const InputDecoration(labelText: "Serial"),
    ),
  );
  Widget _emergencyPlaceholder() => Form(
    key: _formKeys[4],
    child: TextFormField(
      controller: _spouseNameController,
      decoration: const InputDecoration(labelText: "Spouse Name"),
    ),
  );
  Widget _healthPlaceholder() => Form(
    key: _formKeys[5],
    child: TextFormField(
      controller: _healthController,
      decoration: const InputDecoration(labelText: "Health Issues"),
    ),
  );
  Widget _finalPlaceholder() => Form(
    key: _formKeys[6],
    child: TextFormField(
      controller: _bankNameController,
      decoration: const InputDecoration(labelText: "Bank Name"),
    ),
  );
}
