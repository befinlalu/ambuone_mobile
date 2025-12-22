part of 'index.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SOSButton(
          onCompleted: () {
            print('Check');
          },
        ),
      ),
    );
  }
}
