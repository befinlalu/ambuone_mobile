part of 'index.dart';

class MaintenancePage extends StatefulWidget {
  final VoidCallback? onRetrySuccess;

  const MaintenancePage({super.key, this.onRetrySuccess});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage>
    with SingleTickerProviderStateMixin {
  bool _retrying = false;
  String _statusMessage = 'We\'ll be back shortly.';

  final _repo = VersionRepoImpli();

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final Timer _autoRetryTimer;
  late final Timer _countdownTimer;
  int _countdown = 30;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _autoRetryTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _retry(auto: true),
    );

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _countdown = _countdown > 0 ? _countdown - 1 : 30);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _autoRetryTimer.cancel();
    _countdownTimer.cancel();
    super.dispose();
  }

  Future<void> _retry({bool auto = false}) async {
    if (_retrying) return;
    if (mounted) setState(() => _retrying = true);

    try {
      final response = await _repo.getVersion();
      final isMaintenance = response.data?.appMaintenance ?? true;

      if (!isMaintenance) {
        if (mounted) {
          setState(() => _statusMessage = 'Back online! Resuming...');
        }
        await Future.delayed(const Duration(milliseconds: 800));
        widget.onRetrySuccess?.call();
        return;
      }

      if (mounted) {
        setState(() {
          _statusMessage = auto
              ? 'Still under maintenance...'
              : 'Still down. Hang tight!';
          _countdown = 30;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _statusMessage = 'Could not reach server. Retrying...');
      }
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                // ── Animated icon ─────────────────────────────────────────
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.orange.shade200,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.construction_rounded,
                      size: 56,
                      color: Colors.orange.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Under Maintenance',
                  style: AppFontStyles.h2(context),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  'AmbuOne is currently undergoing scheduled maintenance '
                  'to improve your experience.',
                  style: AppFontStyles.bodySmall(context),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // ── Status message ────────────────────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    key: ValueKey(_statusMessage),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _statusMessage,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── What we're working on ─────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.secondary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: scheme.secondary.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.build_circle_outlined,
                            size: 15,
                            color: scheme.secondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'What we\'re working on',
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
                        'System upgrades for better reliability',
                        'Performance improvements',
                        'Ensuring SOS services remain stable',
                      ].map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.settings_outlined,
                                size: 13,
                                color: scheme.onSurface.withOpacity(0.45),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurface.withOpacity(0.7),
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

                // ── Countdown ─────────────────────────────────────────────
                Text(
                  'Auto-checking in $_countdown seconds',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurface.withOpacity(0.45),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Manual retry ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _retrying ? null : () => _retry(),
                    icon: _retrying
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.secondary,
                            ),
                          )
                        : const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(_retrying ? 'Checking...' : 'Check now'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'All app features are temporarily unavailable.',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurface.withOpacity(0.4),
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
