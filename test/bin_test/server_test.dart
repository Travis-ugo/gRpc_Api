import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rpc_api/src/data_base/categories/categories_imp.dart';
import 'package:rpc_api/src/generated/grocries.pbgrpc.dart';
import 'package:test/test.dart';

import '../../bin/server.dart';

class MockGroceriesService extends Mock implements GroceriesServiceClient {}

class MockCategoriesService extends Mock implements CategoriesService {}

class MockCategory extends Mock implements Category {}

void main() {
  late MockGroceriesService mockGroceriesService;
  late MockCategoriesService mockCategoriesService;
  late MockCategory mockCategory;

  setUp(() {
    mockGroceriesService = MockGroceriesService();
    mockCategoriesService = MockCategoriesService();
    mockCategory = MockCategory();
  });

  group('Groceries service test', () {
    group('create groceries service category', () {
      setUp(() {
        when(() => mockCategoriesService.createCategory(
            Category(id: 2, name: 'flip'))).thenAnswer((_) => mockCategory);
      });
      test('calls createCategory', () async {
        await mockGroceriesService
            .createCategory(Category(id: 2, name: 'flip'));

        verify(() => mockCategoriesService
            .createCategory(Category(id: 2, name: 'flip'))).called(1);
      });

      test('succeeds when  createCategory completes', () {
        expect(
            mockGroceriesService.createCategory(
              Category(id: 2, name: 'flip'),
            ),
            completes);
      });
    });
  });
}
