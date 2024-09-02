import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataVisualizationScreen extends StatefulWidget {
  @override
  _DataVisualizationScreenState createState() =>
      _DataVisualizationScreenState();
}

class _DataVisualizationScreenState extends State<DataVisualizationScreen> {
  String _selectedMonth = DateFormat('yyyy-MM').format(DateTime.now());
  bool _isLoading = true;
  Map<String, double> _personalData = {};
  Map<String, double> _sharedData = {};
  List<FlSpot> _personalTrends = [];
  List<FlSpot> _sharedTrends = [];

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final startDate = DateTime.parse('$_selectedMonth-01');
      final endDate = startDate.add(
          Duration(days: DateTime(startDate.year, startDate.month + 1, 0).day));

      // Personal Data
      final personalSnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user?.uid)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThan: endDate)
          .get();

      _personalData = {'Renda': 0, 'Despesa': 0};
      _personalTrends = [];

      personalSnapshot.docs.forEach((doc) {
        final data = doc.data();
        final type = data['type'] as String;
        final amount = data['amount'] as double;
        final date = (data['date'] as Timestamp).toDate();
        final day = DateFormat('yyyy-MM-dd').format(date);

        if (_personalData.containsKey(type)) {
          _personalData[type] = (_personalData[type] ?? 0) + amount;
        }

        final spot = FlSpot(
            DateTime.parse(day).millisecondsSinceEpoch.toDouble(), amount);
        _personalTrends.add(spot);
      });

      // Shared Data
      final sharedSnapshot = await _firestore
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThan: endDate)
          .get();

      _sharedData = {};
      _sharedTrends = [];

      sharedSnapshot.docs.forEach((doc) {
        final data = doc.data();
        final description = data['description'] as String;
        final amount = data['amount'] as double;
        final date = (data['date'] as Timestamp).toDate();
        final day = DateFormat('yyyy-MM-dd').format(date);

        if (!_sharedData.containsKey(description)) {
          _sharedData[description] = 0;
        }
        _sharedData[description] = (_sharedData[description] ?? 0) + amount;

        final spot = FlSpot(
            DateTime.parse(day).millisecondsSinceEpoch.toDouble(), amount);
        _sharedTrends.add(spot);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao carregar dados: ${error.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualização de Dados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seletor de mês
                  DropdownButtonFormField<String>(
                    value: _selectedMonth,
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value!;
                        _loadData();
                      });
                    },
                    items: List.generate(
                      12,
                      (index) {
                        final month =
                            DateTime.now().subtract(Duration(days: 30 * index));
                        final formattedMonth =
                            DateFormat('yyyy-MM').format(month);
                        return DropdownMenuItem(
                          value: formattedMonth,
                          child: Text(DateFormat('MMMM yyyy').format(month)),
                        );
                      },
                    ),
                    decoration: InputDecoration(
                      labelText: 'Selecionar Mês',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Gráfico de Tendência de Renda e Despesas
                  Text(
                    'Tendência de Renda e Despesas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt());
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    DateFormat('dd/MM').format(date),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _personalTrends,
                            isCurved: true,
                            color: Colors.green,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                          LineChartBarData(
                            spots: _sharedTrends,
                            isCurved: true,
                            color: Colors.blue,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Gráfico de Gastos Compartilhados
                  Text(
                    'Gastos Compartilhados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                final title = _sharedData.keys.elementAt(index);
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    title,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        barGroups: _sharedData.entries.map((entry) {
                          final index =
                              _sharedData.keys.toList().indexOf(entry.key);
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
                                color: Colors.blue,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
