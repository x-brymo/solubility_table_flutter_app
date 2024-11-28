import 'dart:convert';

class SolubilityTable {
  final List<String> cations;
  final List<String> anions;
  final List<List<String>> data;
  final Map<String, String> legend;
  final String notes;

  SolubilityTable({
    required this.cations,
    required this.anions,
    required this.data,
    required this.legend,
    required this.notes,
  });

  factory SolubilityTable.fromJson(Map<String, dynamic> json) {
    return SolubilityTable(
      cations: List<String>.from(json['solubilityTable']['cations']),
      anions: List<String>.from(json['solubilityTable']['anions']),
      data: List<List<String>>.from(
          json['solubilityTable']['data'].map((item) => List<String>.from(item))),
      legend: Map<String, String>.from(json['solubilityTable']['legend']),
      notes: json['solubilityTable']['notes'],
    );
  }
}
