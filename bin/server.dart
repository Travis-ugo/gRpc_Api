// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:grpc/grpc.dart';

import 'package:rpc_api/src/data_base/categories/categories_imp.dart';
import 'package:rpc_api/src/data_base/items/items_imp.dart';
import 'package:rpc_api/src/generated/grocries.pbgrpc.dart';

class GroceriesService extends GroceriesServiceBase {
  final CategoriesService _categoriesService;
  final ItemsService _itemsService;

  GroceriesService(
    this._categoriesService,
    this._itemsService,
  );
  @override
  Future<Category> createCategory(ServiceCall call, Category request) async {
    return _categoriesService.createCategory(request)!;
  }

  @override
  Future<Item> createItem(ServiceCall call, Item request) async {
    return _itemsService.createItem(request)!;
  }

  @override
  Future<Empty> deleteCategory(ServiceCall call, Category request) async {
    return _categoriesService.deleteCategory(request);
  }

  @override
  Future<Empty> deleteItem(ServiceCall call, Item request) async {
    return _itemsService.deleteItem(request);
  }

  @override
  Future<Category> editCategory(ServiceCall call, Category request) async {
    return _categoriesService.editCategory(request)!;
  }

  @override
  Future<Item> editItem(ServiceCall call, Item request) async {
    return _itemsService.editItem(request)!;
  }

  @override
  Future<Categories> getAllCategories(ServiceCall call, Empty request) async {
    return Categories()..category.addAll(_categoriesService.getAllCategory()!);
  }

  @override
  Future<Items> getAllItems(ServiceCall call, Empty request) async {
    return Items()..items.addAll(_itemsService.getItems()!);
  }

  @override
  Future<Category> getCategory(ServiceCall call, Category request) async {
    return _categoriesService.getCategoryByName(request.name)!;
  }

  @override
  Future<Item> getItem(ServiceCall call, Item request) async {
    return _itemsService.getItemByName(request.name)!;
  }

  @override
  Future<AllItemsOfCategory> getItemByCategory(
      ServiceCall call, Category request) async {
    return AllItemsOfCategory(
      items: _itemsService.getItemsByCategory(request.id),
      categoryId: request.id,
    );
  }
}

Future<void> main(List<String> args) async {
  final server = Server(
    [
      GroceriesService(
        CategoriesService(),
        ItemsService(),
      ),
    ],
    const <Interceptor>[],
    CodecRegistry(
      codecs: const [
        GzipCodec(),
        IdentityCodec(),
      ],
    ),
  );
  await server.serve(port: 14000);

  print('✅ server listening on port ${server.port} ✅.....🔥🔥🔥');
}
