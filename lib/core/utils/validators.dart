typedef FieldValidator = String? Function(String? value);

String? requiredValidator(String? value, {String message = 'Requerido'}) {
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

String? emailValidator(String? value, {String message = 'Email inválido'}) {
  final input = value?.trim() ?? '';
  if (input.isEmpty) {
    return message;
  }
  final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  return emailRegExp.hasMatch(input) ? null : message;
}
