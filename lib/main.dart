import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

import 'widget_1.dart';

void main() {
  runApp(MaterialApp(home: SolubilityTableScreen()));
}

class SolubilityTableApp extends StatefulWidget {
  const SolubilityTableApp({Key? key}) : super(key: key);

  @override
  State<SolubilityTableApp> createState() => _SolubilityTableAppState();
}

class _SolubilityTableAppState extends State<SolubilityTableApp> {
  Map<String, dynamic>? solubilityData;

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonString =
        await rootBundle.rootBundle.loadString('assets/solubility_table.json');
    setState(() {
      solubilityData = jsonDecode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solubility Table')),
      body: solubilityData == null
          ? const Center(child: CircularProgressIndicator())
          : buildScrollableTable(),
    );
  }

  Widget buildScrollableTable() {
    // Cast the dynamic values to List<String> explicitly
    List<String> cations =
        List<String>.from(solubilityData!['solubilityTable']['cations']);
    List<String> anions =
        List<String>.from(solubilityData!['solubilityTable']['anions']);
    List<List<String>> tableData = List<List<String>>.from(
      solubilityData!['solubilityTable']['data'].map(
        (e) => List<String>.from(e),
      ),
    );

    return Row(
      children: [
        // Fixed Column for "Pinned Data"
        Container(
          width: 100.0,
          color: Colors.grey.shade200,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pinned',
                  
                ),
              ),
              ...anions.map((anion) {
                return Container(
                  height: 48.3,
                  child: Text(anion),
                );
              }).toList(),
            ],
          ),
        ),
        // Scrollable Table for Main Data next to Fixed Column
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: Colors.black12),
              defaultColumnWidth: const FixedColumnWidth(80.0),
              children: [
                // Cation Headers Row
                TableRow(
                  children: [
                    const TableCell(
                      child: Center(
                          child: Text(
                        'Anion',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                    ...List.generate(
                      cations.length,
                      (index) => TableCell(
                        child: SizedBox(
                          width: 80.0,
                          height: 50,
                          child: Center(
                            child: Text(
                              cations[index],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Anion Rows with Solubility Data
                ...List.generate(
                  anions.length,
                  (rowIndex) => TableRow(
                    children: [
                      TableCell(
                        child: SizedBox(
                            width: 80.0,
                            height: 50,
                            child: Center(child: Text(anions[rowIndex]))),
                      ),
                      ...List.generate(
                        tableData[rowIndex].length,
                        (colIndex) => TableCell(
                          child: SizedBox(
                            width: 80.0,
                            height: 50,
                            child: Center(
                              child: Text(tableData[rowIndex][colIndex]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
