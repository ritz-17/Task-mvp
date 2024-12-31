import 'package:flutter/material.dart';

class VerificationCodeField extends StatefulWidget {
  final int codeLength; // Number of code digits

  const VerificationCodeField({super.key, required this.codeLength});

  @override
  State<VerificationCodeField> createState() => _VerificationCodeFieldState();
}

class _VerificationCodeFieldState extends State<VerificationCodeField> {
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();

    _controllers =
        List.generate(widget.codeLength, (index) => TextEditingController());
    _focusNodes = List.generate(widget.codeLength, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.codeLength, (index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: SizedBox(
            width: 40,
            height: 40,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (index < widget.codeLength - 1) {
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  }
                }
              },
              decoration: InputDecoration(
                counterText: '',
              ),
            ),
          ),
        );
      }),
    );
  }
}
