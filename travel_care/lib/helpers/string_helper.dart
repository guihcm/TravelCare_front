String getFirstName(String? nomeCompleto) {
  if (nomeCompleto != null) {
    return nomeCompleto.split(" ").first;
  }
  return "Prezado Usuário";
}

String formatDateString(String dateString) {
  final date = DateTime.parse(dateString);
  return "${date.day.toString().length > 1 ? date.day.toString() : "0${date.day}"}/"
      "${date.month.toString().length > 1 ? date.month.toString() : "0${date.month}"}/"
      "${date.year.toString()}";
}

  String formatHourString(String hourString) {
  final date = DateTime.parse(hourString);
  return "${date.hour.toString().length > 1 ? date.hour.toString() : "0${date.hour}"}:"
      "${date.minute.toString().length > 1 ? date.minute.toString() : "0${date.minute}"}";
}
