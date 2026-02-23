part of 'index.dart';

class PageCanvas extends StatelessWidget {
  final Widget child;
  const PageCanvas({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(padding: EdgeInsetsGeometry.all(16), child: child),
    );
  }
}
