part of 'index.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> _content = [
    {
      "title": "Welcome to AmbuOne",
      "desc":
          "We're here to help you in emergencies, ensuring you get the care you need when it matters most.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: ResponsiveCurvePainter()),
          ),

          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),

              // Scrollable Area
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _content.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.05),

                        SizedBox(
                          height: size.height * 0.35,
                          child: Center(
                            child: Image.asset(AppImages.appLogo, height: 200),
                          ),
                        ),

                        const Spacer(),
                        // Text Area
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              Text(
                                _content[index]['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _content[index]['desc'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.15),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          Positioned(
            bottom: size.height * 0.05,
            left: 40,
            right: 40,
            child: MainButton(
              buttonColor: Theme.of(context).primaryColor,
              buttonTitle: 'Get Started',
              onPressed: () {
                context.go(PageRoutes.login);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.redColor
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height);

    path.lineTo(0, size.height * 0.55);

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.80,
      size.width,
      size.height * 0.35,
    );

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
