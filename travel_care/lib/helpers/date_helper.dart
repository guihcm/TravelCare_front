import 'package:flutter/material.dart';
import 'package:travel_care/helpers/string_helper.dart';

Future<DateTime> handleDate(BuildContext context,
    TextEditingController controller, bool dataFutura) async {
  DateTime? picked = await selectDate(context, dataFutura);
  DateTime date = DateTime.now();
  if (picked != null) {
    controller.text = picked.toString();
    date = DateTime.parse(controller.text);
    formatControllerDate(controller);
  }
  return date;
}

Future<DateTime?> selectDate(
  BuildContext context, bool dataFutura) async {

  return await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: dataFutura ? DateTime.now() : DateTime(1900),
      lastDate: dataFutura ? DateTime(2100) : DateTime.now());
}

void formatControllerDate(TextEditingController controller) {
  controller.text = formatDateString(controller.text);
}

Future<DateTime?> selectTime(
    BuildContext context, TextEditingController timeController) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  DateTime? date;

  if (picked != null) {
    timeController.text = picked.format(context);
    date = hourToDate(picked);
  }
  return date;
}

DateTime hourToDate(TimeOfDay picked) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
}