import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/model.dart';

Future<SolubilityTable> loadSolubilityTable() async {
  // Load the asset
  final String response = await rootBundle.loadString('assets/solubility_table.json');
  final Map<String, dynamic> data = jsonDecode(response);

  // Return the SolubilityTable object
  return SolubilityTable.fromJson(data);
}
