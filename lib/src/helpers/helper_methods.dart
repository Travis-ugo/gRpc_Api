import 'package:rpc_api/src/generated/grocries.pb.dart';

class HelperMethods {
  Category getCategoryFromMap(Map category) {
    var idTag = 1;
    var nameTag = 2;
    int id = category['id'];
    String name = category['name'];

    return Category.fromJson('{"$idTag" : "$id", "$nameTag" : "$name"}');
  }

  Item getItemFromMap(Map item) {
    var idTag = 1;
    var nameTag = 2;
    var categoryTag = 3;

    int id = item['id'];
    String name = item['name'];
    int category = item['categoryId'];

    return Item.fromJson(
        '{"$idTag" : "$id", "$nameTag" : "$name", "$categoryTag": "$category"}');
  }
}

final helperMethods = HelperMethods();
