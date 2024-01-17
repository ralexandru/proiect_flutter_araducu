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

// Ignore: must_be_immutable
class TextArea extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  String labelText = '';
  int maxLines = 0;
  int? maxCharacters;
  bool? editable = true;
  Icon? icon;

  TextArea({
    required this.controller,
    required this.labelText,
    required this.maxLines,
    this.icon,
    this.editable,
    this.maxCharacters,
  });

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          enabled: widget.editable,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
          ),
          onChanged: (text) {
            setState(() {
              // If you want to limit the characters, uncomment the next line
              // text = text.length <= maxCharacters ? text : text.substring(0, maxCharacters);
              widget.controller.text = text;
            });
          },
        ),
        SizedBox(height: 10),
        Text(
          'Minimum number of characters: ${widget.controller.text.length} / ${widget.maxCharacters ?? 0}',
          style: TextStyle(color: Colors.grey),
        ),
      ],
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
        color: Colors.blue, 
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
