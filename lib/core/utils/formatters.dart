String capitalize(String value) {
  if (value.isEmpty) return value;
  final lower = value.toLowerCase();
  return lower[0].toUpperCase() + lower.substring(1);
}

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  return '$day/$month/$year';
}
