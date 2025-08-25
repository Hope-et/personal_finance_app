import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  final AppDatabase db;
  AccountDao(this.db) : super(db);

  Future<List<Account>> getAllAccounts() => select(accounts).get();
  Stream<List<Account>> watchAllAccounts() => select(accounts).watch();
  Future<int> insertAccount(AccountsCompanion entry) =>
      into(accounts).insert(entry);
  Future updateAccount(Account account) => update(accounts).replace(account);
  Future deleteAccount(Account account) => delete(accounts).delete(account);
}
