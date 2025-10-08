enum FindingSeverity { low, medium, high }

class Finding {
  const Finding({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
  });

  final String id;
  final String title;
  final String description;
  final FindingSeverity severity;
}
