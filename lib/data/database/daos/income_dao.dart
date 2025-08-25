import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'income_dao.g.dart';

@DriftAccessor(tables: [Incomes, Accounts])
class IncomeDao extends DatabaseAccessor<AppDatabase> with _$IncomeDaoMixin {
  final AppDatabase db;
  IncomeDao(this.db) : super(db);

  Future<List<Income>> getAllIncomes() => select(incomes).get();
  Stream<List<Income>> watchAllIncomes() => select(incomes).watch();
  // Get Income by specific date
  Future<double> getIncomeByDate(DateTime date) async {
    final query = await (select(
      incomes,
    )..where((t) => t.date.equals(date))).get();
    final total = query.fold(0.0, (sum, item) => sum + item.amount);
    return total;
    // return query.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Get Income by month
  Future<double> getIncomeByMonth(int month, int year) async {
    final query =
        await (select(incomes)..where(
              (t) => t.date.month.equals(month) & t.date.year.equals(year),
            ))
            .get();
    final total = query.fold(0.0, (sum, item) => sum + item.amount);
    return total;
    // return query.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Get Income by year
  Future<double> getIncomeByYear(int year) async {
    final query = await (select(
      incomes,
    )..where((t) => t.date.year.equals(year))).get();
    final total = query.fold(0.0, (sum, item) => sum + item.amount);
    return total;
    // return query.fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<int> insertIncome(IncomesCompanion entry) =>
      into(incomes).insert(entry);
  Future updateIncome(Income income) => update(incomes).replace(income);
  Future deleteIncome(Income income) => delete(incomes).delete(income);
}
