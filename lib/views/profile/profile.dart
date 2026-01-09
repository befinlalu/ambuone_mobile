part of 'index.dart';

class UserDetailsPage extends StatefulWidget {
  final UserDetails user;

  const UserDetailsPage({super.key, required this.user});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  UserDetails? userDetails;

  @override
  void initState() {
    super.initState();
    userDetails = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    final profile = userDetails?.profile;
    final qr = userDetails?.qrcode;

    return Scaffold(
      appBar: AppBar(title: const Text('User Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ProfileHeader(
              user: userDetails,
              profile: profile,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value:
                          sl<
                            UserBloc
                          >(), // Inject your Service Locator instance here
                      child: EditProfile(user: widget.user),
                    ), // Pass widget.user here
                  ),
                ).then((value) {
                  if (value == true) {
                    print("this is working properly");
                    setState(() {
                      userDetails = SharedStorages().getUserDetails();
                    });
                  }
                });
              },
            ),
            const SizedBox(height: 24),

            // --- NEW: NON-EDITABLE PROFILE SECTION ---
            _SectionCard(
              title: 'Profile Information',
              children: [
                _InfoRow('First Name', userDetails?.firstName),
                _InfoRow('Last Name', userDetails?.lastName),
                _InfoRow('Email', userDetails?.email),
                _InfoRow('Phone Number', userDetails?.phoneNumber),
                _InfoRow('Gender', profile?.gender),
                _InfoRow('Age', profile?.age?.toString()),
              ],
            ),

            _SectionCard(
              title: 'Residential Details',
              children: [
                _InfoRow('Address', profile?.address),
                _InfoRow('State', profile?.state),
                _InfoRow('Pincode', profile?.pinCode),
              ],
            ),

            _SectionCard(
              title: 'Emergency Contacts',
              children: [
                _InfoRow('Spouse', profile?.spouseName),
                _InfoRow('Spouse Mobile', profile?.spouseMobile),
                _InfoRow('Relative', profile?.relativeName),
                _InfoRow('Relative Mobile', profile?.relativeMobile),
                _InfoRow('Friend 1', profile?.friend1Name),
                _InfoRow('Friend 2', profile?.friend2Name),
                _InfoRow('Friend 3', profile?.friend3Name),
              ],
            ),

            _SectionCard(
              title: 'Medical Details',
              children: [
                _InfoRow('Health Conditions', profile?.healthConditions),
                _InfoRow('Medicines', profile?.medicines),
              ],
            ),

            if (qr != null && qr.qrCode != null)
              _SectionCard(
                title: 'Membership QR',
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(qr.qrCode!, height: 200),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
