import 'package:mocktail/mocktail.dart';
import 'package:rpc_api/src/data_base/categories/categories_imp.dart';
import 'package:rpc_api/src/data_base/data_base.dart';
import 'package:rpc_api/src/generated/grocries.pb.dart';
import 'package:test/test.dart';

class MockCategoriesService extends Mock implements CategoriesService {}

class MockCategory extends Mock implements Category {}

void main() {
  late CategoriesService categoriesService;
  late MockCategoriesService mockCategoriesService;
  late List<Category> categoriesList;

  setUp(() {
    categoriesList = [
      Category(
        id: 1,
        name: 'category name',
      )
    ];

    categoriesService = CategoriesService();

    mockCategoriesService = MockCategoriesService();

    when(() => mockCategoriesService.createCategory(Category(
          id: 1,
          name: 'category name',
        ))).thenAnswer((_) => MockCategory());
  });
  group('category testing', () {
    test('get all categories', () {
      when(() => mockCategoriesService.getAllCategory()).thenAnswer(
        (_) => categoriesList,
      );

      mockCategoriesService.getAllCategory();
    });
    test('add new category to category list', () async {
      when(() => mockCategoriesService.createCategory(Category(
            id: 1,
            name: 'category name',
          ))).thenAnswer((_) => MockCategory());
      mockCategoriesService.createCategory(Category(
        id: 1,
        name: 'category name',
      ));

      expect(
        categories.length,
        5,
      );
    });

    test('remove category from category list', () async {
      when(() => mockCategoriesService.deleteCategory(Category(
            id: 1,
            name: 'category name',
          ))).thenAnswer((_) => Empty());

      mockCategoriesService.deleteCategory(Category(
        id: 1,
        name: 'category name',
      ));

      expect(
        categories.length,
        4,
      );
    });
  });
}
