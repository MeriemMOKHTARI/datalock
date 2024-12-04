import 'package:flutter/material.dart';

class OtpField extends StatelessWidget {
  final List<TextEditingController> controllers;

  const OtpField({
    Key? key,
    required this.controllers,
  
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                FocusScope.of(context).nextFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}

