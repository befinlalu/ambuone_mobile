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
          return PageCanvas(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(PageRoutes.profile, extra: userDetails);
                  },
                  child: Container(
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
                        "${userDetails?.firstName} ${userDetails?.lastName}",
                        style: AppFontStyles.bodySmallBold(context),
                      ),
                      subtitle: Text(
                        "${userDetails?.phoneNumber}",
                        style: AppFontStyles.bodySmallHint(context),
                      ),
                      trailing: Icon(Icons.arrow_outward_rounded),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text('Emergency Help', style: AppFontStyles.h3(context)),
                    Text('Needed?', style: AppFontStyles.h3(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [SOSButton(onCompleted: sendAlert)],
                    ),
                    Text(
                      'Hold 5 seconds to send alert',
                      style: AppFontStyles.bodySmall(context),
                    ),
                  ],
                ),
                LockSosToggle(),
              ],
            ),
          );
        },
      ),
    );
  }

  sendAlert() {
    context.read<HomeBloc>().add(GetLocationEvent(context));
  }
}
