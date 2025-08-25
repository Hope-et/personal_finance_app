import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables.dart';
import 'daos/account_dao.dart';
import 'daos/category_dao.dart';
import 'daos/income_dao.dart';
import 'daos/expense_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Accounts, Categories, Incomes, Expenses, CapitalHistory],
  daos: [AccountDao, CategoryDao, IncomeDao, ExpenseDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'personal_finance_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
