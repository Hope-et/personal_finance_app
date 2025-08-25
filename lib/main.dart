import 'package:flutter/material.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/expense_screen.dart';
import 'ui/screens/income_screen.dart';
import 'ui/screens/accounts_screen.dart';
import '../../data/database/app_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final AppDatabase myDbInstance = AppDatabase();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardScreen(db: myDbInstance),
      ExpenseScreen(),
      IncomeScreen(),
      AccountsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: "Expenses",
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            label: "Income",
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance),
            label: "Accounts",
          ),
        ],
      ),
    );
  }
}
