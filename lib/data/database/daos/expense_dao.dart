import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses, Accounts, Categories])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  final AppDatabase db;
  ExpenseDao(this.db) : super(db);

  Future<List<Expense>> getAllExpenses() => select(expenses).get();
  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();

  // Get Expense by specific date
  Future<double> getExpenseByDate(DateTime date) async {
    final query = await (select(
      expenses,
    )..where((t) => t.date.equals(date))).get();
    final total = query.fold(0.0, (sum, item) => sum + item.amount);
    return total;
    // return query.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Get Expense by month
  Future<double> getExpenseByMonth(int month, int year) async {
    final query =
        await (select(expenses)..where(
              (t) => t.date.month.equals(month) & t.date.year.equals(year),
            ))
            .get();
    final total = query.fold(0.0, (sum, item) => sum + item.amount);
    return total;
    // return query.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Get Expense by year
  Future<double> getExpenseByYear(int year) async {
    final query = await (select(
      expenses,
    )..where((t) => t.date.year.equals(year))).get();
    final total = query.fold(0.0, (sum, item) => sum + item.amount);
    return total;
    // return query.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Get Expenses grouped by Category (for Pie Chart)
  Future<Map<String, double>> getExpensesByCategory(int month, int year) async {
    final query =
        await (select(expenses)..where(
              (t) => t.date.month.equals(month) & t.date.year.equals(year),
            ))
            .get();

    final Map<String, double> categoryTotals = {};
    for (var e in query) {
      categoryTotals[e.categoryId.toString()] =
          (categoryTotals[e.categoryId.toString()] ?? 0) + e.amount;
    }
    return categoryTotals;
  }

  Future<int> insertExpense(ExpensesCompanion entry) =>
      into(expenses).insert(entry);
  Future updateExpense(Expense expense) => update(expenses).replace(expense);
  Future deleteExpense(Expense expense) => delete(expenses).delete(expense);
}
