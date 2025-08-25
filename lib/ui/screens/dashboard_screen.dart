import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/database/app_database.dart';

class DashboardScreen extends StatefulWidget {
  final AppDatabase db;

  const DashboardScreen({super.key, required this.db});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedFilter = 'Month'; // Day | Month | Year

  double totalIncome = 0;
  double totalExpenses = 0;
  double balance = 0;
  Map<String, double> expensesByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (selectedFilter == 'Day') {
      await _loadDayData();
    } else if (selectedFilter == 'Month') {
      await _loadMonthData();
    } else {
      await _loadYearData();
    }
  }

  Future<void> _loadDayData() async {
    final incomes = await widget.db.incomeDao.getIncomeByDate(selectedDate);
    final expenses = await widget.db.expenseDao.getExpenseByDate(selectedDate);
    _updateTotals(incomes, expenses);
  }

  Future<void> _loadMonthData() async {
    final incomes = await widget.db.incomeDao.getIncomeByMonth(
      selectedDate.month,
      selectedDate.year,
    );
    final expenses = await widget.db.expenseDao.getExpenseByMonth(
      selectedDate.month,
      selectedDate.year,
    );
    _updateTotals(incomes, expenses);
  }

  Future<void> _loadYearData() async {
    final incomes = await widget.db.incomeDao.getIncomeByYear(
      selectedDate.year,
    );
    final expenses = await widget.db.expenseDao.getExpenseByYear(
      selectedDate.year,
    );
    _updateTotals(incomes, expenses);
  }

  void _updateTotals(double incomes, double expenses) {
    setState(() {
      totalIncome = incomes;
      totalExpenses = expenses;
      balance = totalIncome - totalExpenses;

      expensesByCategory = {};
      // for (var e in expenses) {
      //   expensesByCategory[e.accountId.toString()] =
      //       (expensesByCategory[e.accountId.toString()] ?? 0) + e.amount;
      // }
    });
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Personal Finance Dashboard"),
        actions: [
          DropdownButton<String>(
            value: selectedFilter,
            items: const [
              "Day",
              "Month",
              "Year",
            ].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => selectedFilter = val);
                _loadData();
              }
            },
          ),
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDate),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildSummaryCard("Income", totalIncome, Colors.green),
                const SizedBox(width: 12),
                _buildSummaryCard("Expenses", totalExpenses, Colors.red),
                const SizedBox(width: 12),
                _buildSummaryCard("Balance", balance, Colors.blue),
              ],
            ),
            const SizedBox(height: 24),
            _buildBarChart(),
            const SizedBox(height: 24),
            _buildPieChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double value, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 16, color: color)),
              const SizedBox(height: 8),
              Text(
                "ETB ${value.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(toY: totalIncome, color: Colors.green)],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [BarChartRodData(toY: totalExpenses, color: Colors.red)],
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  return Text(value == 0 ? "Income" : "Expenses");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: expensesByCategory.entries
              .map(
                (e) => PieChartSectionData(
                  value: e.value,
                  title: e.key,
                  color:
                      Colors.primaries[expensesByCategory.keys.toList().indexOf(
                            e.key,
                          ) %
                          Colors.primaries.length],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
