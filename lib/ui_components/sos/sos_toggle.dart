part of 'index.dart';

class LockSosToggle extends StatefulWidget {
  const LockSosToggle({super.key});

  @override
  State<LockSosToggle> createState() => _LockSosToggleState();
}

class _LockSosToggleState extends State<LockSosToggle> {
  bool _enabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    _enabled = SharedStorages().getSosStatus();
    setState(() => _loading = false);
  }

  Future<void> _onChanged(bool value) async {
    setState(() => _enabled = value);

    if (value) {
      await LockSosService.startSos();
      SharedStorages().setSosStatus(true);
    } else {
      await LockSosService.stopSos();
      SharedStorages().setSosStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const CircularProgressIndicator();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
        child: SwitchListTile(
          title: Text(
            'Enable Lock Screen SOS',
            style: AppFontStyles.h6(context),
          ),
          subtitle: Text(
            _enabled ? 'SOS is active' : 'SOS is disabled',
            style: TextStyle(
              color: _enabled ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: _enabled,
          onChanged: _onChanged,
          inactiveThumbColor: Colors.red.shade300,
          activeThumbColor: Theme.of(context).colorScheme.tertiary,
          inactiveTrackColor: AppColors.redColor,
          activeTrackColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
