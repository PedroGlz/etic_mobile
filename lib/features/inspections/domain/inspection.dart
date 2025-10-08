import 'package:etic_mobile/features/inspections/domain/finding.dart';

class Inspection {
  const Inspection({
    required this.id,
    required this.title,
    required this.client,
    required this.site,
    required this.status,
    required this.date,
    this.findings = const <Finding>[],
  });

  final String id;
  final String title;
  final String client;
  final String site;
  final String status;
  final DateTime date;
  final List<Finding> findings;

  Inspection copyWith({
    String? title,
    String? client,
    String? site,
    String? status,
    DateTime? date,
    List<Finding>? findings,
  }) {
    return Inspection(
      id: id,
      title: title ?? this.title,
      client: client ?? this.client,
      site: site ?? this.site,
      status: status ?? this.status,
      date: date ?? this.date,
      findings: findings ?? this.findings,
    );
  }
}
