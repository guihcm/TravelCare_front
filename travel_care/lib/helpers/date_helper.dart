import 'package:flutter/material.dart';

Future<DateTime> handleDate(BuildContext context, TextEditingController controller) async {
  DateTime? picked = await selectDate(context);
  DateTime date = DateTime.now();
  if (picked != null) {
    controller.text = picked.toString();
    date = DateTime.parse(controller.text);
    formatControllerDate(controller);
  }
  return date;
}

Future<DateTime?> selectDate(
  BuildContext context) async {
  FocusScope.of(context).requestFocus(FocusNode());

  return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now()); 
}

void formatControllerDate(TextEditingController controller) {
  DateTime date = DateTime.parse(controller.text);

  controller.text =
      "${date.day.toString().length > 1 ? date.day.toString() : "0${date.day}"}-"
      "${date.month.toString().length > 1 ? date.month.toString() : "0${date.month}"}-"
      "${date.year.toString()}";
}
