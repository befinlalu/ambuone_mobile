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
    await LockSosService.setVolumeButtonEnabled(volume);
    setState(() {
      _notificationEnabled = notif;
      _volumeEnabled = volume;
      _loading = false;
    });
  }

  // Future<void> _refreshAccessibilityState() async {
  //   final volume = await LockSosService.isAccessibilityEnabled();
  //   if (!mounted) return;
  //   await LockSosService.setVolumeButtonEnabled(volume);
  //   await SharedStorages().setVolumeButtonSosEnabled(volume);
  //   setState(() => _volumeEnabled = volume);
  // }

  Future<void> _refreshAccessibilityState() async {
    final volume = await LockSosService.isAccessibilityEnabled();
    if (!mounted) return;

    // Was enabled before but now it's off — OEM killed the process
    // Show a persistent warning so the user knows their trigger is broken
    if (_volumeEnabled && !volume) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Volume SOS was disabled by your phone. Tap Fix to re-enable.',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'Fix',
            textColor: Colors.yellow,
            onPressed: () => LockSosService.openAccessibilitySettings(),
          ),
        ),
      );
    }

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
          MainButton(
            onPressed: () => Navigator.pop(ctx, true),
            buttonTitle: 'Disable battery optimization',
            buttonColor: Theme.of(context).colorScheme.tertiary,
          ),
          SizedBox(height: 8),
          // Decline button — clearly labelled, always enabled
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: AppFontStyles.errorTextStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
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
      // Show the compliant disclosure dialog with checkbox
      final agreed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const _AccessibilityConsentDialog(),
      );

      if (agreed != true) return;

      await LockSosService.openAccessibilitySettings();

      final nowEnabled = await LockSosService.isAccessibilityEnabled();
      if (!nowEnabled) return;

      await LockSosService.setVolumeButtonEnabled(true);
      await SharedStorages().setVolumeButtonSosEnabled(true);
      if (mounted) setState(() => _volumeEnabled = true);
      // if (mounted) await AutoStartHelper.checkAndOpenAutoStart(context);
    } else if (!value && _volumeEnabled) {
      await LockSosService.setVolumeButtonEnabled(false);
      await SharedStorages().setVolumeButtonSosEnabled(false);
      setState(() => _volumeEnabled = false);

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
            MainButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await LockSosService.openAccessibilitySettings();
              },
              buttonTitle: 'Open settings',
              buttonColor: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
      );
    }
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
// Accessibility consent dialog — Google Play compliant
// Extracted as StatefulWidget so the checkbox can manage its own state
// without requiring the parent to rebuild
// ─────────────────────────────────────────────────────────────────────────────

class _AccessibilityConsentDialog extends StatefulWidget {
  const _AccessibilityConsentDialog();

  @override
  State<_AccessibilityConsentDialog> createState() =>
      _AccessibilityConsentDialogState();
}

class _AccessibilityConsentDialogState
    extends State<_AccessibilityConsentDialog> {
  // Checkbox must be explicitly ticked before "I Agree" is enabled
  bool _hasConsented = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Permission Required'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── What the service does ──────────────────────────────
            const Text(
              'To trigger SOS by pressing the volume button 3 times '
              '(even when the screen is off), AmbuOne needs '
              'Accessibility Service permission.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),

            // ── Data accessed ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data accessed by this service:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  _DisclosureRow(
                    icon: Icons.touch_app_outlined,
                    text:
                        'Volume key presses only — to detect the '
                        '3× press pattern. No other keys are monitored.',
                  ),
                  const SizedBox(height: 6),
                  _DisclosureRow(
                    icon: Icons.location_on_outlined,
                    text:
                        'Precise & approximate location — collected '
                        'only when SOS is triggered, to dispatch '
                        'emergency services to your location.',
                  ),
                  const SizedBox(height: 6),
                  _DisclosureRow(
                    icon: Icons.block_outlined,
                    text:
                        'No screen content, keystrokes, or personal '
                        'data is ever read or transmitted.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Revoke info ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'You can revoke this permission anytime:\n'
                'Settings → Accessibility → AmbuOne SOS trigger → Toggle OFF',
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 12),

            // ── Steps ─────────────────────────────────────────────
            const Text(
              'Steps to enable:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 8),
            _DialogStep(
              number: '1',
              color: Colors.blue.shade700,
              title: 'Tap "I Agree & Continue" below',
              body: 'We will open Accessibility Settings for you.',
            ),
            const SizedBox(height: 6),
            _DialogStep(
              number: '2',
              color: Colors.blue.shade700,
              title: 'Tap "Downloaded apps" or "Installed apps"',
              body: 'Find AmbuOne SOS trigger in the list.',
            ),
            const SizedBox(height: 6),
            _DialogStep(
              number: '3',
              color: Colors.green.shade700,
              title: 'Toggle ON → tap Allow',
              body: 'Android will confirm — tap Allow to activate.',
            ),

            const SizedBox(height: 16),

            // ── Checkbox consent — required by Google Play policy ──
            // The "I Agree" button is disabled until this is checked.
            // This satisfies the "affirmative user action" requirement.
            GestureDetector(
              onTap: () => setState(() => _hasConsented = !_hasConsented),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _hasConsented,
                    onChanged: (val) =>
                        setState(() => _hasConsented = val ?? false),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'I understand how AmbuOne uses the Accessibility '
                      'Service and I consent to the data access '
                      'described above.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── Two explicit buttons — required by Google Play policy ─────
      actions: [
        // Agree button — only enabled after checkbox is ticked
        MainButton(
          onPressed: _hasConsented ? () => Navigator.pop(context, true) : null,
          buttonTitle: 'I Agree & Continue',
          buttonColor: _hasConsented
              ? Theme.of(context).colorScheme.tertiary
              : Colors.grey,
        ),
        SizedBox(height: 8),
        // Decline button — clearly labelled, always enabled
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: AppFontStyles.errorTextStyle(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Disclosure row — icon + text used inside the data disclosure box
// ─────────────────────────────────────────────────────────────────────────────

class _DisclosureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DisclosureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11))),
      ],
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
