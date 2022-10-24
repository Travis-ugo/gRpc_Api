import 'dart:io';
import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:rpc_api/src/generated/grocries.pbgrpc.dart';

class Client {
  ClientChannel? channel;
  GroceriesServiceClient? stub;
  late var response;
  bool executionInProgress = true;

  Future<void> main() async {
    channel = ClientChannel(
      'localhost',
      port: 14000,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    stub = GroceriesServiceClient(
      channel!,
      options: CallOptions(
        timeout: Duration(seconds: 30),
      ),
    );

    while (executionInProgress) {
      try {
        print('----- what do you want to do?? -----');

        print('👉 1: view all products');
        print('👉 2: add new products');
        print('👉 3: edit products');
        print('👉 4: get products');
        print('👉 5: delete products\n');

        print('👉 6: view all categories');
        print('👉 7: add new category');
        print('👉 8: edit category');
        print('👉 9: get category');
        print('👉 10: delete category\n');

        print('👉 11: get all products of category\n');

        var option = int.parse(stdin.readLineSync()!);

        switch (option) {
          case 1:
            var response = await stub!.getAllItems(Empty());
            print(' --- store products items --- ');
            response.items.forEach((item) {
              print(
                  '👉  : itemName: ${item.name}, (itemId: ${item.id}) categoryName: ${item.categoryId},');
            });
            break;
          case 2:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var item = await findItemByName(name);
            if (item.id != 0) {
              print(
                  '🔥 category already exist: category ${item.name}, categoryId ${item.id}');
            } else {
              item = Item()
                ..id = Random(999).nextInt(9999)
                ..name = name;

              response = await stub!.createItem(item);
              print(
                  '✅ item created: itemName ${item.name}, itemId ${item.id}, itemCategoryId ${item.categoryId}');
            }
            break;
          case 3:
            print('Enter item name to be edited');
            var name = stdin.readLineSync()!;
            var item = await findItemByName(name);
            if (item.id != 0) {
              print('Enter item new name');
              var name = stdin.readLineSync()!;
              var response = await stub!.editItem(Item(
                  id: item.id, categoryId: item.categoryId, name: item.name));

              if (response.name == name) {
                print(
                    '✅ item updated : itemName ${item.name}, itemId ${item.id},itemCategoryId ${item.categoryId}');
              } else {
                print('🔥 item update failed');
              }
            } else {
              print('item error occurred');
            }
            break;
          case 4:
            print('Enter item name');
            var name = stdin.readLineSync()!;
            var item = await findItemByName(name);
            if (item.id != 0) {
              print(
                  '✅ item  found: itemName ${item.name}, itemId ${item.id}, itemCategoryId ${item.categoryId}');
            } else {
              print('🔥 item not found, try creating a new item');
            }
            break;
          case 5:
            print('Enter Item name to be deleted');
            var name = stdin.readLineSync()!;
            var item = await findItemByName(name);
            if (item.id != 0) {
              await stub!.deleteItem(item);

              print('✅ item deleted');
            } else {
              print('😪🖕item name not found');
            }
            break;
          case 6:
            var response = await stub!.getAllCategories(Empty());
            print(' --- store products categories --- ');
            response.category.forEach((category) {
              print(
                  '✅  : categoryName: ${category.name}, (categoryId: ${category.id}) ');
            });
            break;
          case 7:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await findCategoryByName(name);
            if (category.id != 0) {
              print(
                  '🔥 category already exist: category ${category.name}, categoryId ${category.id}');
            } else {
              category = Category()
                ..id = Random(999).nextInt(9999)
                ..name = name;

              response = await stub!.createCategory(category);
              print(
                  '✅ category created: category ${category.name}, categoryId ${category.id}');
            }
            break;
          case 8:
            print('Enter category name to be edited');
            var name = stdin.readLineSync()!;
            var category = await findCategoryByName(name);
            if (category.id != 0) {
              print('Enter category new name');
              var name = stdin.readLineSync()!;
              var response = await stub!
                  .editCategory(Category(id: category.id, name: name));

              if (response.name == name) {
                print(
                    '✅ category updated: category ${category.name}, categoryId ${category.id}');
              } else {
                print('🔥 category update failed');
              }
            } else {
              print('category error occurred');
            }
            break;
          case 9:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await findCategoryByName(name);
            if (category.id != 0) {
              print(
                  '✅ category found: categoryName ${category.name}, categoryId ${category.id}');
            } else {
              print('🔥 category not found, try creating a new category');
            }
            break;
          case 10:
            print('Enter category name to be deleted');
            var name = stdin.readLineSync()!;
            var category = await findCategoryByName(name);
            if (category.id != 0) {
              await stub!.deleteCategory(category);

              print('✅ category deleted');
            } else {
              print('😪🖕category name not found');
            }
            break;
          case 11:
            print('Enter products category name: ');
            var name = stdin.readLineSync()!;
            var category = await findCategoryByName(name);
            if (category.id != 0) {
              var results = await stub!.getItemByCategory(category);

              print('--- all products of the $name category ---');
              results.items.forEach((item) {
                print('✅👉  ${item.name}');
              });
            } else {
              print('😪🖕category $name not found');
            }
            break;

          default:
            print('invalid option bitch 😪🖕');
        }
      } catch (e) {
        print(e);
      }
      print('Do you wish to exit the store? (y/n)');
      var result = stdin.readLineSync() ?? 'y';
      executionInProgress = result.toLowerCase() != 'y';
    }
    await channel!.shutdown();
  }

  Future<Category> findCategoryByName(String name) async {
    var category = Category()..name = name;
    category = await stub!.getCategory(category);
    return category;
  }

  Future<Item> findItemByName(String name) async {
    var item = Item()..name = name;
    item = await stub!.getItem(item);
    return item;
  }

  int randomId() => Random(1000).nextInt(9999);
}

void main() {
  var client = Client();
  client.main();
}
