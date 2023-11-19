import 'package:flutter/material.dart';
import 'package:travel_care/helpers/string_helper.dart';

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

  return await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now()); 
}

void formatControllerDate(TextEditingController controller) {
  controller.text = formatDateString(controller.text);
}

Future<void> selectTime(
    BuildContext context, TextEditingController timeController) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (!context.mounted) return;

  if (picked != null) {
    timeController.text = picked.format(context);
  }
}