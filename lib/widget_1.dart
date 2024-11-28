import 'package:flutter/material.dart';
import 'package:myapp/handler.dart';
import 'package:myapp/model.dart';
import 'package:flutter/material.dart';

class SolubilityTableScreen extends StatefulWidget {
  @override
  _SolubilityTableScreenState createState() => _SolubilityTableScreenState();
}

class _SolubilityTableScreenState extends State<SolubilityTableScreen> {
  late Future<SolubilityTable> solubilityTable;

  @override
  void initState() {
    super.initState();
    solubilityTable = loadSolubilityTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text('Solubility Table')),
      body: FutureBuilder<SolubilityTable>(
        future: solubilityTable,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final solubility = snapshot.data!;

          // Check the row lengths and ensure they match the number of anions (columns)
          for (var row in solubility.data) {
            if (row.length != solubility.anions.length) {
              print('Row length mismatch! Row: $row, Expected: ${solubility.anions.length}');
              // Optionally pad the row to match the correct length
              while (row.length < solubility.anions.length) {
                row.add('-');  // Fill with a placeholder value
              }
            }
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                   scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: solubility.anions
                          .map((anion) => DataColumn(label: Text(anion)))
                          .toList(),
                      rows: solubility.cations.map((cation) {
                        final cationIndex = solubility.cations.indexOf(cation);
                        return DataRow(
                          cells: solubility.data[cationIndex]
                              .map((value) {
                                // Check if value is null or missing and provide a default value
                                final cellValue = value ?? '-';
                                return DataCell(Text(solubility.legend[cellValue] ?? 'Not Available'));
                              })
                              .toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Notes: ${solubility.notes}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
