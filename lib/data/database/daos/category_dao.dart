import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  final AppDatabase db;
  CategoryDao(this.db) : super(db);

  Future<List<Category>> getAllCategories() => select(categories).get();
  Stream<List<Category>> watchAllCategories() => select(categories).watch();
  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);
  Future updateCategory(Category category) =>
      update(categories).replace(category);
  Future deleteCategory(Category category) =>
      delete(categories).delete(category);
}
