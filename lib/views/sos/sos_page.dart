part of 'index.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: 'Home', isLeading: false, isLogo: true),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
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
            final userDetails = SharedStorages().getUserDetails();
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
            DialogManager.instance.showDialogSuccess(
              context,
              message: 'Alert sent successfully',
            );

            Future.delayed(const Duration(seconds: 2), () {
              DialogManager.instance.hideLoadingDialog(context);
            });
          }
          if (state is SendAlertErrorState) {
            DialogManager.instance.hideLoadingDialog(context);
            ToastService.showSuccess(context, state.message);
          }
        },
        builder: (context, state) {
          return Center(
            child: SOSButton(
              onCompleted: () {
                context.read<HomeBloc>().add(GetLocationEvent());
              },
            ),
          );
        },
      ),
    );
  }
}
