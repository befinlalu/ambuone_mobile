part of 'index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserDetails? userDetails;
  User? user;

  @override
  void initState() {
    super.initState();
    user = SharedStorages().getUser();
    if (user != null) {
      userDetails = SharedStorages().getUserDetails();
      context.read<HomeBloc>().add(
        GetUserDetailsEvent(
          userId: user?.id ?? 0,
          type: userDetails != null ? 'U' : 'G',
        ),
      );
    } else {
      context.go(PageRoutes.welcome);
    }
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
          if (state is SendAlertSuccessState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(context, 'Alert Sent Successfully');
          }
          if (state is SendAlertErrorState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(context, state.message);
          }
          if (state is GetUserSuccessState) {}
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
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Emergency Help', style: AppFontStyles.h3(context)),
              Text('Needed?', style: AppFontStyles.h3(context)),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [SOSButton(onCompleted: sendAlert)],
              ),
            ],
          );
        },
      ),
    );
  }

  sendAlert() async {
    try {
      // 1️⃣ Request permission
      final hasPermission = await PermissionService.requestLocationPermission();

      if (!hasPermission) {
        debugPrint("❌ Location permission not granted");
        return;
      }

      // 2️⃣ Get location
      final position = await LocationService.getCurrentLocation();

      final lat = position.latitude;
      final lng = position.longitude;

      debugPrint("📍 SOS Location: $lat , $lng");
    } catch (e) {
      debugPrint("❌ SOS Error: $e");
    }
  }
}
