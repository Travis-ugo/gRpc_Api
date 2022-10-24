import 'package:rpc_api/src/data_base/categories/categories_imp.dart';
import 'package:rpc_api/src/generated/grocries.pb.dart';
import 'package:rpc_api/src/generated/grocries.pb.dart';

abstract class ICategoriesService {
  factory ICategoriesService() => CategoriesService();

  Category? getCategoryByName(String name);
  Category? getCategoryById(int id);
  Category? createCategory(Category category);
  Category? editCategory(Category category);
  Empty deleteCategory(Category category);
  List<Category>? getAllCategory();
}

final iCategoriesService = ICategoriesService();
