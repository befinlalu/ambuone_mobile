part of 'index.dart';

class LockSosToggle extends StatefulWidget {
  const LockSosToggle({super.key});

  @override
  State<LockSosToggle> createState() => _LockSosToggleState();
}

class _LockSosToggleState extends State<LockSosToggle> {
  bool _notificationEnabled = false;
  bool _volumeEnabled = false;
  bool _loading = true;

  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: _refreshAccessibilityState,
    );
    _loadState();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final notif = SharedStorages().getSosStatus();
    final volume = await LockSosService.isAccessibilityEnabled();
    if (!mounted) return;
    // Sync pref on load — covers case where user toggled accessibility
    // outside the app since last launch
    await LockSosService.setVolumeButtonEnabled(volume);
    setState(() {
      _notificationEnabled = notif;
      _volumeEnabled = volume;
      _loading = false;
    });
  }

  // Called when user returns from any system settings screen
  Future<void> _refreshAccessibilityState() async {
    final volume = await LockSosService.isAccessibilityEnabled();
    if (!mounted) return;
    // Sync the pref to match real accessibility state
    await LockSosService.setVolumeButtonEnabled(volume);
    await SharedStorages().setVolumeButtonSosEnabled(volume);
    setState(() => _volumeEnabled = volume);
  }

  // ── Notification toggle ───────────────────────────────────────────────────

  Future<void> _onNotificationChanged(bool value) async {
    setState(() => _notificationEnabled = value);
    if (value) {
      await LockSosService.startSos();
      await SharedStorages().setSosStatus(true);
      if (mounted) await _showNotificationSetupDialog();
      // if (mounted) await AutoStartHelper.checkAndOpenAutoStart(context);
    } else {
      await LockSosService.stopSos();
      await SharedStorages().setSosStatus(false);
    }
  }

  Future<void> _showNotificationSetupDialog() async {
    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.blue.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text('Important setup'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your SOS notification is now active. To keep it reliable:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 12),
              _DialogStep(
                number: '1',
                color: Colors.orange.shade700,
                title: 'Disable battery optimization',
                body:
                    'Android may automatically hide or stop the notification '
                    'to save battery.\n\nOn the next screen, tap "Allow" to '
                    'exclude AmbuOne — this keeps the notification pinned '
                    'even when your phone is idle.',
              ),
              const SizedBox(height: 10),
              _DialogStep(
                number: '2',
                color: Colors.blue.shade700,
                title: 'Do not clear notifications manually',
                body:
                    'If you swipe away the SOS notification, it will '
                    'restart automatically. However on some phones '
                    '(Xiaomi, OPPO, Samsung, Vivo) the OS may block this — '
                    'battery optimization exemption prevents that.',
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Without battery optimization disabled, your phone '
                        'may hide the notification on its own.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Skip'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Disable battery optimization'),
          ),
        ],
      ),
    );
    if (proceed == true) {
      await LockSosService.requestBatteryOptimizationExemption();
    }
  }

  // ── Volume / Accessibility toggle ─────────────────────────────────────────

  Future<void> _onVolumeChanged(bool value) async {
    if (value && !_volumeEnabled) {
      // Turning ON — show disclosure then open settings
      final proceed = await _showVolumeSetupDialog();
      if (proceed != true) return;

      await LockSosService.openAccessibilitySettings();

      // After returning from settings, check if user actually enabled it
      final nowEnabled = await LockSosService.isAccessibilityEnabled();
      if (!nowEnabled) return; // user didn't enable — do nothing

      // ── CRITICAL: write the pref ──────────────────────────────────────
      // This is what SosAccessibilityService.onKeyEvent() reads.
      // Without this the service ignores all volume presses.
      await LockSosService.setVolumeButtonEnabled(true);
      await SharedStorages().setVolumeButtonSosEnabled(true);
      if (mounted) setState(() => _volumeEnabled = true);

      // OEM autostart prompt — keeps the process alive on Xiaomi/OPPO/Vivo
      // if (mounted) await AutoStartHelper.checkAndOpenAutoStart(context);
    } else if (!value && _volumeEnabled) {
      // Turning OFF — clear the pref immediately so service stops reacting
      await LockSosService.setVolumeButtonEnabled(false);
      await SharedStorages().setVolumeButtonSosEnabled(false);
      setState(() => _volumeEnabled = false);

      // Also guide user to disable in accessibility settings
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Disable volume trigger'),
          content: const Text(
            'To fully turn this off:\n\n'
            '1. Open Accessibility Settings\n'
            '2. Tap "Downloaded apps" or "Installed apps"\n'
            '3. Tap "AmbuOne SOS trigger"\n'
            '4. Toggle it OFF',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await LockSosService.openAccessibilitySettings();
              },
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool?> _showVolumeSetupDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.volume_down_rounded,
              color: Colors.blue.shade700,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text('Set up volume trigger'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'AmbuOne only detects triple volume-down presses. '
                        'No screen content or keystrokes are ever read.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Follow these steps:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 10),
              _DialogStep(
                number: '1',
                color: Colors.blue.shade700,
                title: 'Open Accessibility Settings',
                body: 'Tap "Continue" below — we\'ll open it for you.',
              ),
              const SizedBox(height: 8),
              _DialogStep(
                number: '2',
                color: Colors.blue.shade700,
                title: 'Tap "Downloaded apps" or "Installed apps"',
                body:
                    'This section lists apps that have requested '
                    'accessibility access.',
              ),
              const SizedBox(height: 8),
              _DialogStep(
                number: '3',
                color: Colors.blue.shade700,
                title: 'Tap "AmbuOne SOS trigger"',
                body: 'You\'ll see it listed under AmbuOne.',
              ),
              const SizedBox(height: 8),
              _DialogStep(
                number: '4',
                color: Colors.green.shade700,
                title: 'Toggle it ON and tap Allow',
                body:
                    'Android will show a confirmation prompt — '
                    'tap "Allow" to enable it.',
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green.shade700,
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Once enabled, the toggle here will update '
                        'automatically when you come back.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  // ── Widget action ─────────────────────────────────────────────────────────

  Future<void> _onAddWidget() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add SOS widget'),
        content: const Text(
          'This opens your launcher\'s "Add to home screen" prompt.\n\n'
          'Tap "Add" or "Confirm" on the next screen to place a '
          'one-tap red SOS button on your home screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add widget'),
          ),
        ],
      ),
    );

    if (proceed == true) {
      await LockSosService.pinWidget();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Widget added! Go to your home screen to find the SOS button.',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final activeCount = [
      _notificationEnabled,
      _volumeEnabled,
    ].where((e) => e).length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: scheme.secondary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency access',
                        style: AppFontStyles.h6(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        activeCount == 0
                            ? 'No triggers enabled — set up at least one'
                            : '$activeCount of 2 trigger${activeCount == 1 ? '' : 's'} active',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: activeCount == 0
                              ? Colors.red.shade400
                              : Colors.green.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StatusDot(active: _volumeEnabled),
                    const SizedBox(width: 5),
                    _StatusDot(active: _notificationEnabled),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: scheme.secondary.withOpacity(0.2)),

          // ── Toggle 1: Volume button ────────────────────────────────────
          _FeatureTile(
            icon: Icons.volume_down_rounded,
            title: 'Volume down button (3× press)',
            subtitle: _volumeEnabled
                ? 'Active — works even in the lock screen'
                : 'Triple press volume down to trigger SOS',
            tags: [
              _Tag('Recommended', Colors.blue.shade700),
              _Tag(
                _volumeEnabled ? 'Accessibility on' : 'Needs accessibility',
                _volumeEnabled ? Colors.green.shade700 : Colors.orange.shade700,
              ),
            ],
            isToggle: true,
            toggleValue: _volumeEnabled,
            onToggle: _onVolumeChanged,
          ),

          Divider(
            height: 1,
            indent: 56,
            color: scheme.secondary.withOpacity(0.12),
          ),

          // ── Toggle 2: Lock screen notification ────────────────────────
          _FeatureTile(
            icon: Icons.notifications_active_outlined,
            title: 'Lock screen notification',
            subtitle: _notificationEnabled
                ? 'Pinned — tap to open SOS without unlocking'
                : 'Permanent notification on your lock screen',
            tags: [_Tag('May hide on some phones', Colors.orange.shade700)],
            isToggle: true,
            toggleValue: _notificationEnabled,
            onToggle: _onNotificationChanged,
          ),

          Divider(
            height: 1,
            indent: 56,
            color: scheme.secondary.withOpacity(0.12),
          ),

          // ── Action: Home screen widget ─────────────────────────────────
          _FeatureTile(
            icon: Icons.widgets_outlined,
            title: 'Home screen widget',
            subtitle: 'One-tap red SOS button on your home screen',
            tags: [_Tag('Works independently', Colors.green.shade700)],
            isToggle: false,
            onTap: _onAddWidget,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tag model
// ─────────────────────────────────────────────────────────────────────────────

class _Tag {
  final String label;
  final Color color;
  const _Tag(this.label, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Dialog step
// ─────────────────────────────────────────────────────────────────────────────

class _DialogStep extends StatelessWidget {
  final String number;
  final Color color;
  final String title;
  final String body;

  const _DialogStep({
    required this.number,
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature tile
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<_Tag> tags;
  final bool isToggle;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;
  final bool isLast;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.tags = const [],
    required this.isToggle,
    this.toggleValue,
    this.onToggle,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = toggleValue ?? false;

    return InkWell(
      onTap: isToggle ? null : onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(14))
          : BorderRadius.zero,
      child: Padding(
        padding: EdgeInsets.only(
          top: 4,
          bottom: isLast ? 10 : 4,
          left: 14,
          right: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (isToggle ? active : true)
                    ? scheme.secondary.withOpacity(0.15)
                    : scheme.onSurface.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: (isToggle ? active : true)
                    ? scheme.secondary
                    : scheme.onSurface.withOpacity(0.35),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurface.withOpacity(0.55),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tags
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: t.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                t.label,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: t.color,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            if (isToggle)
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: toggleValue ?? false,
                  onChanged: onToggle,
                  activeColor: scheme.tertiary,
                  activeTrackColor: scheme.secondary,
                  inactiveThumbColor: scheme.onSurface.withOpacity(0.25),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 22,
                  color: scheme.secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status dot
// ─────────────────────────────────────────────────────────────────────────────

class _StatusDot extends StatelessWidget {
  final bool active;
  const _StatusDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.green.shade500 : Colors.grey.shade300,
      ),
    );
  }
}
