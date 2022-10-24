import 'package:rpc_api/src/data_base/data_base.dart';
import 'package:rpc_api/src/data_base/items/items_int.dart';
import 'package:rpc_api/src/generated/grocries.pb.dart';
import 'package:rpc_api/src/helpers/helper_methods.dart';

class ItemsService implements IItemsService {
  @override
  Item? createItem(Item item) {
    items.add({
      'id': item.id,
      'name': item.name,
      'categoryId': item.categoryId,
    });
    return item;
  }

  @override
  Empty deleteItem(Item item) {
    items.removeWhere((element) => element['id'] == item.id);

    return Empty();
  }

  @override
  Item? editItem(Item item) {
    try {
      var itemIndex = items.indexWhere((element) => element['id'] == item.id);

      items[itemIndex]['name'] = item.name;
    } catch (e) {
      print('Error:: $e');
    }

    return item;
  }

  @override
  Item? getItemById(int id) {
    var item = Item();
    var result = items.where((element) => element['id'] == id).toList();

    if (result.isNotEmpty) {
      item = helperMethods.getItemFromMap(result.first);
    }

    return item;
  }

  @override
  Item? getItemByName(String name) {
    var item = Item();
    var result = items.where((element) => element['name'] == name).toList();

    if (result.isNotEmpty) {
      item = helperMethods.getItemFromMap(result.first);
    }

    return item;
  }

  @override
  List<Item>? getItems() {
    return items.map((item) {
      return helperMethods.getItemFromMap(item);
    }).toList();
  }

  @override
  List<Item>? getItemsByCategory(int categoryId) {
    var itemList = <Item>[];
    var jsonList =
        items.where((element) => element['categoryId'] == categoryId).toList();
    itemList = jsonList.map((item) {
      return helperMethods.getItemFromMap(item);
    }).toList();

    return itemList;
  }
}
