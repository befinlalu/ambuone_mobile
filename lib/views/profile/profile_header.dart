part of 'index.dart';

class _ProfileHeader extends StatelessWidget {
  final UserDetails? user;
  final UserProfile? profile;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ProfileHeader({
    required this.user,
    required this.profile,
    required this.onEdit,
    required this.onDelete,
  });

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
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                  style: AppFontStyles.h6(context),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: AppFontStyles.bodySmall(context),
                ),
              ],
            ),
          ),

          // --- NEW POPUP MENU BUTTON ---
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case 'edit':
                  // Replace with your Edit Profile route
                  onEdit();
                  break;
                case 'referral':
                  // Replace with your Referral route
                  // context.push(PageRoutes.referral);
                  break;
                case 'logout':
                  await SharedStorages().clear();
                  await LockSosService.stopSos();
                  context.go(PageRoutes.welcome);
                  break;
                case 'delete':
                  if (await DialogManager.instance.showAppDialog(
                    context,
                    title: 'Confirmation',
                    subTitle: 'Are you sure you want to delete your account?',
                  )) {
                    onDelete();
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit, size: 20),
                  title: Text('Edit Profile'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              // const PopupMenuItem(
              //   value: 'referral',
              //   child: ListTile(
              //     leading: Icon(Icons.card_giftcard, size: 20),
              //     title: Text('Referral'),
              //     contentPadding: EdgeInsets.zero,
              //     dense: true,
              //   ),
              // ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red, size: 20),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red, size: 20),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
