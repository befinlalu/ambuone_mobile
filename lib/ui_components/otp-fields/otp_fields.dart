part of 'index.dart';

class OtpFields extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const OtpFields({super.key, this.length = 6, required this.onCompleted});

  @override
  State<OtpFields> createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  void _onChanged(String value, int index) {
    // Handle full OTP paste
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    // Move forward
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Move backward on delete
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    _checkCompleted();
  }

  void _handlePaste(String value) {
    final chars = value.replaceAll(RegExp(r'\D'), '').split('');
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].text = i < chars.length ? chars[i] : '';
    }
    _focusNodes.last.requestFocus();
    _checkCompleted();
  }

  void _checkCompleted() {
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      final otp = _controllers.map((c) => c.text).join();
      widget.onCompleted(otp);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AspectRatio(
              aspectRatio: 1,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 1,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.oneTimeCode],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) => _onChanged(value, index),
              ),
            ),
          ),
        );
      }),
    );
  }
}
