part of 'index.dart';

class UserDetailsPage extends StatelessWidget {
  final UserDetails user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final profile = user.profile;
    final qr = user.qrcode;

    return Scaffold(
      appBar: AppBar(title: const Text('User Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ProfileHeader(user: user, profile: profile),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            _SectionCard(
              title: 'Contact Information',
              children: [
                _InfoRow('Email', user.email),
                _InfoRow('Phone', user.phoneNumber),
                _InfoRow('Role', user.role),
              ],
            ),

            _SectionCard(
              title: 'Personal Details',
              children: [
                _InfoRow('Age', profile?.age?.toString()),
                _InfoRow('Gender', profile?.gender),
                _InfoRow('Address', profile?.address),
                _InfoRow('State', profile?.state),
                _InfoRow('Pincode', profile?.pinCode),
                _InfoRow('Start Date', profile?.startDate),
                _InfoRow('End Date', profile?.endingDate),
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
                _InfoRow('Friend 1 Mobile', profile?.friend1Mobile),
                _InfoRow('Friend 2', profile?.friend2Name),
                _InfoRow('Friend 2 Mobile', profile?.friend2Mobile),
                _InfoRow('Friend 3', profile?.friend3Name),
                _InfoRow('Friend 3 Mobile', profile?.friend3Mobile),
              ],
            ),

            _SectionCard(
              title: 'Medical Details',
              children: [
                _InfoRow('Health Conditions', profile?.healthConditions),
                _InfoRow('Medicines', profile?.medicines),
              ],
            ),

            if (profile?.isReferrer == true)
              _SectionCard(
                title: 'Bank & Referral Details',
                children: [
                  _InfoRow('Referral Code', profile?.referralCode),
                  _InfoRow('Bank Name', profile?.bankName),
                  _InfoRow('Branch', profile?.bankBranch),
                  _InfoRow('Account Number', profile?.bankAccountNumber),
                  _InfoRow('IFSC', profile?.ifscCode),
                ],
              ),

            if (qr != null)
              _SectionCard(
                title: 'QR / Membership Details',
                children: [
                  _InfoRow('Serial Number', qr.serialNumber),
                  _InfoRow('Coupon Code', qr.couponCode),
                  _InfoRow('Status', qr.status),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserDetails user;
  final UserProfile? profile;

  const _ProfileHeader({required this.user, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Colors.blueAccent],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            backgroundImage: profile?.photo != null
                ? NetworkImage(profile!.photo!)
                : null,
            child: profile?.photo == null
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () async {
              await SharedStorages().clear();
              context.go(PageRoutes.welcome);
            },
            child: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
