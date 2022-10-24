import 'package:rpc_api/src/data_base/items/items_imp.dart';
import 'package:rpc_api/src/generated/grocries.pb.dart';

abstract class IItemsService {
  factory IItemsService() => ItemsService();

  Item? getItemByName(String name);
  Item? getItemById(int id);
  Item? createItem(Item item);
  Item? editItem(Item item);
  Empty deleteItem(Item item);
  List<Item?>? getItems();
  List<Item?>? getItemsByCategory(int categoryId);
}

final iItemsService = IItemsService();
