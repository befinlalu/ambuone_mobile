part of 'index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserDetails? userDetails;
  User? user;

  // Connectivity state
  bool _locationEnabled = true;
  bool _networkEnabled = true;

  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _requestStandardPermissions();
    _lifecycleListener = AppLifecycleListener(onResume: _checkConnectivity);
    user = SharedStorages().getUser();
    if (user != null) {
      userDetails = SharedStorages().getUserDetails();
      context.read<HomeBloc>().add(
        GetUserDetailsEvent(
          userId: user?.id ?? 0,
          type:
              userDetails != null &&
                  userDetails?.id != null &&
                  userDetails?.firstName != null &&
                  userDetails?.firstName?.isNotEmpty == true
              ? 'U'
              : 'G',
        ),
      );
    } else {
      context.go(PageRoutes.welcome);
    }
    // Check after first frame so context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkConnectivity());
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _requestStandardPermissions() async {
    await [Permission.location, Permission.notification].request();
  }

  // Re-checks location and network every time app comes to foreground
  Future<void> _checkConnectivity() async {
    final locationStatus = await Permission.location.serviceStatus;
    final connectivity = await Connectivity().checkConnectivity();

    if (!mounted) return;
    setState(() {
      _locationEnabled = locationStatus == ServiceStatus.enabled;
      _networkEnabled = connectivity != ConnectivityResult.none;
    });

    // Show banners if something is off — only once per resume
    if (!_locationEnabled) _showLocationBanner();
    if (!_networkEnabled) _showNetworkBanner();
  }

  void _showLocationBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        content: const Text(
          'Location is off — SOS alert cannot include your coordinates.',
          style: TextStyle(fontSize: 13),
        ),
        leading: const Icon(Icons.location_off_rounded, color: Colors.orange),
        backgroundColor: Colors.orange.shade50,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Dismiss'),
          ),
          TextButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              await openAppSettings();
            },
            child: const Text('Turn on'),
          ),
        ],
      ),
    );
  }

  void _showNetworkBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        content: const Text(
          'No internet connection — SOS alert cannot be sent.',
          style: TextStyle(fontSize: 13),
        ),
        leading: const Icon(Icons.wifi_off_rounded, color: Colors.red),
        backgroundColor: Colors.red.shade50,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Dismiss'),
          ),
          TextButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              // Opens Wi-Fi settings — user can also enable mobile data from there
              await AppSettings.openAppSettings(type: AppSettingsType.wireless);
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }

  void sendAlert() {
    // Guard before sending
    if (!_networkEnabled) {
      _showNetworkBanner();
      return;
    }
    context.read<HomeBloc>().add(GetLocationEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: 'Home', isLeading: false, isLogo: true),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          debugPrint('state: $state');
          if (state is SendAlertLoadingState) {
            DialogManager.instance.showLoadingDialog(
              context,
              message: 'Please wait. Sending alert ....',
            );
          }
          if (state is GetLocationLoadingState) {
            DialogManager.instance.showLoadingDialog(
              context,
              message: 'Please wait. Fetching Location ....',
            );
          }
          if (state is GetLocationErrorState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(context, state.message);
          }
          if (state is GetLocationSuccessState) {
            DialogManager.instance.hideLoadingDialog(context);
            context.read<HomeBloc>().add(
              SendAlertEvent(
                alertRequest: AlertRequestModel(
                  latitude: state.latitude,
                  longitude: state.longitude,
                  serialNumber: userDetails?.qrcode?.serialNumber,
                ),
              ),
            );
          }
          if (state is SendAlertSuccessState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(context, 'Alert Sent Successfully');
          }
          if (state is SendAlertErrorState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(context, state.message);
          }
          if (state is GetUserSuccessState) {
            setState(() {
              userDetails = state.userDetails;
            });
          }
        },
        builder: (context, state) {
          if (state is GetUserLoadingState && state.type == 'G') {
            return Center(child: DialogManager.instance.showLoading(context));
          }
          if (state is GetUserErrorState && userDetails == null) {
            return Center(
              child: MainButton(
                buttonColor: Theme.of(context).colorScheme.secondary,
                buttonTitle: 'Retry',
                onPressed: () {
                  context.read<HomeBloc>().add(
                    GetUserDetailsEvent(userId: user?.id ?? 0),
                  );
                },
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Connectivity status row ────────────────────────────
                  if (!_locationEnabled || !_networkEnabled)
                    _ConnectivityBar(
                      locationEnabled: _locationEnabled,
                      networkEnabled: _networkEnabled,
                      onLocationTap: () async {
                        await openAppSettings();
                      },
                      onNetworkTap: () async {
                        await AppSettings.openAppSettings(
                          type: AppSettingsType.wireless,
                        );
                      },
                    ),

                  if (!_locationEnabled || !_networkEnabled)
                    const SizedBox(height: 12),

                  // ── Profile card ───────────────────────────────────────
                  GestureDetector(
                    onTap: () {
                      context.push(PageRoutes.profile, extra: userDetails);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userDetails?.profile?.photo ?? '',
                          ),
                        ),
                        title: Text(
                          "${userDetails?.firstName ?? ''} ${userDetails?.lastName ?? ''}",
                          style: AppFontStyles.bodySmallBold(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${userDetails?.phoneNumber ?? ''}",
                          style: AppFontStyles.bodySmallHint(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.arrow_outward_rounded),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── SOS button ─────────────────────────────────────────
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Emergency Help',
                        style: AppFontStyles.h3(context),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Needed?',
                        style: AppFontStyles.h3(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SOSButton(onCompleted: sendAlert),
                      const SizedBox(height: 10),
                      Text(
                        'Hold 5 seconds to send alert',
                        style: AppFontStyles.bodySmall(context),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Emergency access panel ─────────────────────────────
                  const LockSosToggle(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Connectivity status bar — shown inline when location or network is off
// ─────────────────────────────────────────────────────────────────────────────

class _ConnectivityBar extends StatelessWidget {
  final bool locationEnabled;
  final bool networkEnabled;
  final VoidCallback onLocationTap;
  final VoidCallback onNetworkTap;

  const _ConnectivityBar({
    required this.locationEnabled,
    required this.networkEnabled,
    required this.onLocationTap,
    required this.onNetworkTap,
  });

  @override
  Widget build(BuildContext context) {
    // final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Action needed for SOS to work',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!locationEnabled)
            _ConnectivityRow(
              icon: Icons.location_off_rounded,
              label: 'Location is off',
              actionLabel: 'Turn on',
              onTap: onLocationTap,
            ),
          if (!locationEnabled && !networkEnabled) const SizedBox(height: 4),
          if (!networkEnabled)
            _ConnectivityRow(
              icon: Icons.wifi_off_rounded,
              label: 'No internet connection',
              actionLabel: 'Fix',
              onTap: onNetworkTap,
            ),
        ],
      ),
    );
  }
}

class _ConnectivityRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String actionLabel;
  final VoidCallback onTap;

  const _ConnectivityRow({
    required this.icon,
    required this.label,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.orange.shade700),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.orange.shade800,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
