part of 'index.dart';

class MandatoryUpdatePage extends StatelessWidget {
  const MandatoryUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false, // blocks back button
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // ── Illustration ─────────────────────────────────────────
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: scheme.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.system_update_rounded,
                    size: 60,
                    color: scheme.secondary,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Title ─────────────────────────────────────────────────
                Text(
                  'Update Required',
                  style: AppFontStyles.h2(context),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'A newer version of AmbuOne is available. '
                  'Please update to continue using the app.',
                  style: AppFontStyles.bodySmall(context),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // ── Version chip row ──────────────────────────────────────
                const SizedBox(height: 40),

                // ── What's improved box ───────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.secondary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: scheme.secondary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 15,
                            color: scheme.secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "What's improved",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: scheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...[
                        'Faster SOS alert delivery',
                        'Improved lock screen reliability',
                        'Bug fixes and stability improvements',
                      ].map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 14,
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurface.withOpacity(0.75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Update button ─────────────────────────────────────────
                MainButton(
                  buttonColor: Theme.of(context).colorScheme.tertiary,
                  buttonTitle: 'Update Now',
                  textStyle: TextStyle(color: Colors.white),
                  onPressed: () async {
                    final url = Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.ambuone.prod',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),

                const SizedBox(height: 12),

                Text(
                  'You must update to continue using AmbuOne.',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurface.withOpacity(0.45),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
