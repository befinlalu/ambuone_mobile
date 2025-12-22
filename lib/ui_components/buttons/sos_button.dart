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

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _completeSOS();
      }
    });
  }

  void _startHold() {
    setState(() => isHolding = true);
    _controller.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  void _cancelHold() {
    setState(() => isHolding = false);
    ToastService.showError('SOS cancelled');
    _controller.reset();
  }

  void _completeSOS() {
    _controller.stop();
    _controller.reset();

    setState(() => isHolding = false);

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
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔵 PROGRESS RING
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(220, 220),
                  painter: RingPainter(_controller.value),
                );
              },
            ),

            // 🔴 3D SOS BUTTON
            AnimatedScale(
              scale: isHolding ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.2,
                    colors: [Color(0xffff6b6b), Color(0xffd32f2f)],
                  ),
                  boxShadow: [
                    // Bottom depth
                    BoxShadow(
                      color: Colors.black.withAlpha(35),
                      offset: const Offset(0, 8),
                      blurRadius: 16,
                    ),
                    // Top highlight
                    BoxShadow(
                      color: Colors.white.withAlpha(25),
                      offset: const Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Inner shadow when pressed
                    if (isHolding)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(25),
                              offset: const Offset(2, 2),
                              blurRadius: 6,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                      ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.wifi_tethering,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "SOS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
