import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sneaker_drops/features/sneaker_marketplace/controllers/cart_view_model.dart';
import 'package:sneaker_drops/features/sneaker_marketplace/data/models/sneaker_model.dart';

void main() {
  late CartViewModel cartVM;

  /// Creates a test sneaker model with customizable parameters.
  SneakerModel createTestSneaker({
    String id = 'test-1',
    String name = 'Test Sneaker',
    String brand = 'Test Brand',
    double price = 170.0,
    double marketPrice = 200.0,
    List<double> availableSizes = const [9.0, 10.0, 11.0],
    SneakerRarity rarity = SneakerRarity.common,
  }) {
    return SneakerModel(
      id: id,
      name: name,
      brand: brand,
      colorway: 'Test/White',
      price: price,
      marketPrice: marketPrice,
      imageUrl: 'https://example.com/image.png',
      images: const ['image1.png', 'image2.png'],
      description: 'Test description',
      releaseDate: DateTime.now(),
      sizes: availableSizes
          .map((s) => SneakerSize(size: s, stock: 5, isAvailable: true))
          .toList(),
      rarity: rarity,
    );
  }

  setUp(() {
    Get.testMode = true;
    cartVM = CartViewModel();
  });

  tearDown(() {
    Get.reset();
  });

  group('CartViewModel - Initial State', () {
    test('starts with empty cart', () {
      expect(cartVM.isEmpty, true);
      expect(cartVM.itemCount, 0);
      expect(cartVM.uniqueItemCount, 0);
    });

    test('has zero subtotal when empty', () {
      expect(cartVM.subtotal, 0.0);
    });

    test('has shipping cost for empty cart under threshold', () {
      // Empty cart has $0 subtotal, which is under $500 threshold
      expect(cartVM.shipping, CartViewModel.flatShippingRate);
    });
  });

  group('CartViewModel - Add Items', () {
    test('addItem adds sneaker to cart', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.isEmpty, false);
      expect(cartVM.itemCount, 1);
      expect(cartVM.items.first.sneaker.id, 'test-1');
      expect(cartVM.items.first.selectedSize, 9.0);
    });

    test('addItem increments quantity for duplicate sneaker/size', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.uniqueItemCount, 1);
      expect(cartVM.itemCount, 2);
      expect(cartVM.items.first.quantity, 2);
    });

    test('addItem creates separate items for different sizes', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      cartVM.addItem(sneaker, size: 10.0);

      expect(cartVM.uniqueItemCount, 2);
      expect(cartVM.itemCount, 2);
    });

    test('addItem with custom quantity', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0, quantity: 3);

      expect(cartVM.itemCount, 3);
      expect(cartVM.items.first.quantity, 3);
    });
  });

  group('CartViewModel - Remove Items', () {
    test('removeItem removes sneaker from cart', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      final item = cartVM.items.first;
      cartVM.removeItem(item);

      expect(cartVM.isEmpty, true);
      expect(cartVM.itemCount, 0);
    });

    test('removeItemById removes sneaker by ID', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      final itemId = cartVM.items.first.id;
      cartVM.removeItemById(itemId);

      expect(cartVM.isEmpty, true);
    });
  });

  group('CartViewModel - Update Quantity', () {
    test('updateQuantity changes item quantity', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      final item = cartVM.items.first;
      cartVM.updateQuantity(item, 5);

      expect(cartVM.items.first.quantity, 5);
      expect(cartVM.itemCount, 5);
    });

    test('updateQuantity removes item when quantity is 0', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      final item = cartVM.items.first;
      cartVM.updateQuantity(item, 0);

      expect(cartVM.isEmpty, true);
    });

    test('incrementQuantity increases by 1', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      final item = cartVM.items.first;
      cartVM.incrementQuantity(item);

      expect(cartVM.items.first.quantity, 2);
    });

    test('decrementQuantity decreases by 1', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0, quantity: 3);
      final item = cartVM.items.first;
      cartVM.decrementQuantity(item);

      expect(cartVM.items.first.quantity, 2);
    });

    test('decrementQuantity removes item at quantity 1', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);
      final item = cartVM.items.first;
      cartVM.decrementQuantity(item);

      expect(cartVM.isEmpty, true);
    });
  });

  group('CartViewModel - Pricing Calculations', () {
    test('subtotal calculates correctly for single item', () {
      final sneaker = createTestSneaker(marketPrice: 200.0);

      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.subtotal, 200.0);
    });

    test('subtotal calculates correctly for multiple items', () {
      final sneaker1 = createTestSneaker(id: 'test-1', marketPrice: 200.0);
      final sneaker2 = createTestSneaker(id: 'test-2', marketPrice: 300.0);

      cartVM.addItem(sneaker1, size: 9.0);
      cartVM.addItem(sneaker2, size: 10.0);

      expect(cartVM.subtotal, 500.0);
    });

    test('subtotal includes quantity multiplier', () {
      final sneaker = createTestSneaker(marketPrice: 200.0);

      cartVM.addItem(sneaker, size: 9.0, quantity: 3);

      expect(cartVM.subtotal, 600.0);
    });

    test('shipping is free over 500 dollar threshold', () {
      final sneaker = createTestSneaker(marketPrice: 550.0);

      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.shipping, 0.0);
    });

    test('shipping is 15 dollars under 500 dollar threshold', () {
      final sneaker = createTestSneaker(marketPrice: 200.0);

      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.shipping, 15.0);
    });

    test('tax calculates at 8%', () {
      final sneaker = createTestSneaker(marketPrice: 100.0);

      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.tax, 8.0);
    });

    test('total combines subtotal, shipping, and tax', () {
      final sneaker = createTestSneaker(marketPrice: 100.0);

      cartVM.addItem(sneaker, size: 9.0);

      // subtotal: 100, shipping: 15, tax: 8 = 123
      expect(cartVM.total, 123.0);
    });
  });

  group('CartViewModel - Clear Cart', () {
    test('clear removes all items', () {
      final sneaker1 = createTestSneaker(id: 'test-1');
      final sneaker2 = createTestSneaker(id: 'test-2');

      cartVM.addItem(sneaker1, size: 9.0);
      cartVM.addItem(sneaker2, size: 10.0);
      cartVM.clear();

      expect(cartVM.isEmpty, true);
      expect(cartVM.itemCount, 0);
    });

    test('clear resets error state', () {
      cartVM.setError('Some error');
      cartVM.clear();

      expect(cartVM.error, null);
    });
  });

  group('CartViewModel - Query Methods', () {
    test('containsItem returns true for existing item', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.containsItem('test-1', 9.0), true);
    });

    test('containsItem returns false for non-existing item', () {
      expect(cartVM.containsItem('non-existent', 9.0), false);
    });

    test('containsItem returns false for wrong size', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0);

      expect(cartVM.containsItem('test-1', 10.0), false);
    });

    test('getQuantity returns correct quantity', () {
      final sneaker = createTestSneaker();

      cartVM.addItem(sneaker, size: 9.0, quantity: 3);

      expect(cartVM.getQuantity('test-1', 9.0), 3);
    });

    test('getQuantity returns 0 for non-existing item', () {
      expect(cartVM.getQuantity('non-existent', 9.0), 0);
    });
  });

  group('CartViewModel - Loading and Error States', () {
    test('setLoading updates loading state', () {
      cartVM.setLoading(true);
      expect(cartVM.isLoading, true);

      cartVM.setLoading(false);
      expect(cartVM.isLoading, false);
    });

    test('setError updates error state', () {
      cartVM.setError('Test error');
      expect(cartVM.error, 'Test error');

      cartVM.setError(null);
      expect(cartVM.error, null);
    });
  });
}
