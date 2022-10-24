import 'package:rpc_api/src/data_base/categories/categories_int.dart';
import 'package:rpc_api/src/data_base/data_base.dart';
import 'package:rpc_api/src/generated/grocries.pb.dart';
import 'package:rpc_api/src/helpers/helper_methods.dart';

class CategoriesService implements ICategoriesService {
  @override
  Category? createCategory(Category category) {
    categories.add({"id": category.id, "name": category.name});
    return category;
  }

  @override
  Empty deleteCategory(Category category) {
    categories.removeWhere((element) => element['id'] == category.id);
    return Empty();
  }

  @override
  Category? editCategory(Category category) {
    try {
      var categoryIndex =
          categories.indexWhere((element) => element['id'] == category.id);
      categories[categoryIndex]['name'] = category.name;
    } catch (e) {
      print('Error:: $e');
    }

    return category;
  }

  @override
  List<Category>? getAllCategory() {
    return categories.map((category) {
      return helperMethods.getCategoryFromMap(category);
    }).toList();
  }

  @override
  Category? getCategoryById(int id) {
    var category = Category();
    var result = categories.where((element) => element['id'] == id).toList();

    if (result.isNotEmpty) {
      category = helperMethods.getCategoryFromMap(result.first);
    }
    return category;
  }

  @override
  Category? getCategoryByName(String name) {
    var category = Category();
    var result =
        categories.where((element) => element['name'] == name).toList();

    if (result.isNotEmpty) {
      category = helperMethods.getCategoryFromMap(result.first);
    }
    return category;
  }
}
