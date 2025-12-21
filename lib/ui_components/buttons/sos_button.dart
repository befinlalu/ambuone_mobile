part of 'index.dart';

class SOSButton extends StatefulWidget {
  final VoidCallback onCompleted;

  const SOSButton({super.key, required this.onCompleted});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isHolding = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addListener(() {
      if (_controller.value >= 1.0) {
        _completeSOS();
      }
    });
  }

  void _startHold() {
    setState(() => isHolding = true);
    _controller.forward(from: 0);

    // subtle haptic on start
    HapticFeedback.lightImpact();
  }

  void _cancelHold() {
    setState(() => isHolding = false);
    _controller.reset();
  }

  void _completeSOS() async {
    _controller.stop();
    setState(() => isHolding = false);

    // strong haptic on success
    HapticFeedback.heavyImpact();

    widget.onCompleted();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startHold(),
      onLongPressEnd: (_) => _cancelHold(),
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔵 Progress Ring
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(200, 200),
                  painter: RingPainter(_controller.value),
                );
              },
            ),

            // 🔴 SOS Button
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xfff44336), Color(0xffd32f2f)],
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                "SOS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
