part of 'index.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLeading;
  final bool isTrailing;
  final bool isLogo;
  final Function()? onback;
  final Function(int value)? onTrailing;
  final List<PopupMenuEntry<int>>? menuItems;
  final bool isPreview;
  const CommonAppbar({
    super.key,
    required this.title,
    this.isLeading = true,
    this.isLogo = false,
    this.isTrailing = false,
    this.onback,
    this.onTrailing,
    this.menuItems,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: isPreview
          ? Theme.of(context).colorScheme.tertiary
          : Theme.of(context).colorScheme.primary,
      centerTitle: true,
      leading: isLeading
          ? GestureDetector(
              onTap: onback ?? () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            )
          : const Text(''),
      title: isLogo
          ? SizedBox(
              height: 52,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: SvgPicture.asset(AppImages.appLogo),
              ),
            )
          : Text(title, style: AppFontStyles.h5(context)),
      actions: [
        isTrailing
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.secondary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  position: PopupMenuPosition.under,
                  menuPadding: EdgeInsets.zero,
                  onSelected: onTrailing,
                  offset: const Offset(-12, 0),
                  itemBuilder: (context) {
                    return menuItems ?? [];
                  },
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              )
            : const Text(''),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
