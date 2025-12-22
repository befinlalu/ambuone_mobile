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
    _enabled = await SosState.isActive();
    setState(() => _loading = false);
  }

  Future<void> _onChanged(bool value) async {
    setState(() => _enabled = value);

    if (value) {
      await LockSosService.startSos();
    } else {
      await LockSosService.stopSos();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const CircularProgressIndicator();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SwitchListTile(
          title: const Text('Enable Lock Screen SOS'),
          subtitle: Text(
            _enabled ? 'SOS is active' : 'SOS is disabled',
            style: TextStyle(color: _enabled ? Colors.green : Colors.red),
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
