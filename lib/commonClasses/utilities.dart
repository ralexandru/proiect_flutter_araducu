import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//ignore: must_be_immutable
class FilledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Icon icon;
  bool? editable = true;
  bool maskText = false;
  bool? askMask = false;

  FilledTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.labelText,
    required this.hintText,
    this.editable,
    this.askMask,
  });

  @override
  Widget build(BuildContext context) {
    if(askMask != null){
      maskText = askMask ?? false;
    }
    return TextField(
      controller: controller,
      enabled: editable,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: labelText,
        hintText: hintText,
        filled: false,
      ),
      obscureText: maskText
    );
  }
}

class NumericTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  NumericTextField(
      {required this.labelText,
      required this.hintText,
      required this.icon,
      required this.controller});
  @override
  _NumericTextFieldState createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        labelText: widget.labelText,
        hintText: widget.hintText,
        filled: false,
      ),
    );
  }
}

//ignore: must_be_immutable
class TextArea extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String labelText = '';
  int maxLines = 0;
  bool? editable = true;
  Icon? icon;
  TextArea(
      {required this.controller,
      required this.labelText,
      required this.maxLines,
      this.icon,
      this.editable});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: editable, // Set maxLines to null for multiline support
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;

  InitialsAvatar({required this.initials, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue, // Choose your preferred background color
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white, // Choose your preferred text color
            fontSize: size * 0.4, // Adjust the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
