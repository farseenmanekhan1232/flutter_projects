import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:http/http.dart" as http;

class Products extends ChangeNotifier {
  List<String> _categories = [];
  final Map<String, List<Map<String, dynamic>>> _products = {};
  Map<String, Map<String, dynamic>> _wishlist = {};
  Map<String, Map<String, dynamic>> _cart = {};
  List<String> savedLocations = [];

  double _size = 0;
  bool scrolled = false;

  List<Map<String, dynamic>> searchResults = [];

  get categories => _categories;
  get cart => _cart;
  get wishlist => _wishlist;

  Future<List<String>> loadCategories() async {
    if (_categories.isNotEmpty) return _categories;

    var response = await http.get(
      Uri.parse("https://ecommerce-dummy-data.onrender.com/categories"),
    );

    List<String> data = List.from(jsonDecode(response.body)['categories']);

    _categories = data;
    notifyListeners();
    return _categories;
  }

  Future<List<Map<String, dynamic>>> loadProducts(String category) async {
    var response = await http
        .get(Uri.parse("https://ecommerce-dummy-data.onrender.com/$category"));

    List<Map<String, dynamic>> data = List.from(jsonDecode(response.body));

    _products[category] = [];

    for (final product in data) {
      _products[category]!.add(product);
    }

    return data;
  }

  Future<List<Map<String, dynamic>>> getProducts(String category) async {
    if (_products.containsKey(category)) return _products[category]!;

    return await loadProducts(category);
  }

  void loadEverything() {
    loadCategories();
    loadProducts('top');
    loadCart();
    loadWishlist();
  }

  void setSize(size) {
    _size = size;
  }

  void onScroll(offset, AnimationController? animationController) {
    if (offset > _size) {
      if (scrolled) return;
      scrolled = true;
    } else {
      if (!scrolled) return;
      scrolled = false;
    }
    notifyListeners();
  }

  void refreshScroll() {
    bool _ = scrolled;
    scrolled = _;
    notifyListeners();
  }

  Future searchProduct(String value) async {
    if (value.isNotEmpty) {
      return await http.get(
        Uri.parse("https://ecommerce-dummy-data.onrender.com/product/$value"),
      );
    }
    return [];
  }

  void loadCart() async {
    Map<String, Map<String, dynamic>> data = {};

    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('cart')
          .get()
          .then((cartItemsQuery_) {
        for (var doc in cartItemsQuery_.docs) {
          data[doc.id.toString()] = {
            "product": json.decode(doc.data()['product']),
            "quantity": doc.data()['quantity'],
            "selectedVariant": doc.data()['selectedVariant']
          };
        }
      });
      _cart = data;
    }
  }

  void addToCart(Map<String, dynamic> product, int variant) async {
    if (_cart.containsKey("${product['id']}:$variant")) return;

    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('cart')
            .doc("${product['id']}:$variant")
            .set(
          {
            'product': jsonEncode({
              ...product,
              if (variant > -1)
                "price": product['price'] + product['variants'][variant][1]
            }),
            "selectedVariant": variant,
            'quantity': 1
          },
        );

        _cart["${product['id']}:$variant"] = {
          'product': {
            ...product,
            if (variant > -1)
              "price": product['price'] + product['variants'][variant][1]
          },
          "selectedVariant": variant,
          'quantity': 1
        };
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  void removeFromCart(String id) async {
    try {
      DocumentReference cartItem = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('cart')
          .doc(id);

      await cartItem;

      _cart.remove(id);
    } catch (e) {
      rethrow;
    }

    _cart.remove(id);
    notifyListeners();
  }

  void clearCart() async {
    try {
      CollectionReference cart = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('cart');

      await cart.get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      _cart.clear();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void increaseQuantity(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('cart')
          .doc(id)
          .update({"quantity": _cart[id]!['quantity'] + 1});

      _cart[id]!['quantity'] = _cart[id]!['quantity'] + 1;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void decreateQuantity(String id) async {
    try {
      if (_cart[id]!['quantity'] > 1) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('cart')
            .doc(id)
            .update({"quantity": _cart[id]!['quantity'] - 1});

        _cart[id]!['quantity'] = _cart[id]!['quantity'] - 1;
      } else {
        removeFromCart(id);
      }
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  void loadWishlist() async {
    Map<String, Map<String, dynamic>> data = {};

    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('wishlist')
          .get()
          .then((wishlistItems) {
        for (var doc in wishlistItems.docs) {
          data[doc.id.toString()] = json.decode(doc.data()['product']);
        }
      });
      _wishlist = data;
    }

    notifyListeners();
  }

  void toggleWishList(Map<String, dynamic> product) async {
    try {
      if (_wishlist.containsKey(product['id'].toString())) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('wishlist')
            .doc(product['id'].toString())
            .delete();

        _wishlist.remove(product['id'].toString());
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('wishlist')
            .doc(product['id'].toString())
            .set(
          {
            "product": json.encode({...product})
          },
        );
        _wishlist[product['id'].toString()] = product;
      }
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  Future saveLocation(String input) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'locations': FieldValue.arrayUnion([input])
    });
  }

  Future<List<String>> loadSavedLocations() async {
    List data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((data) {
      return (data['locations']);
    });

    return List.from(data);
  }

  Future placeOrder(Map<String, dynamic>? product, double price,
      String paymentMedhod, String location) async {
    final date = DateTime.now();

    if (product != null) {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc(date.toString())
          .set({
        "paymentMethod": paymentMedhod,
        "products": {jsonEncode(product)},
        "price": price,
        "location": location
      });
    } else {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc(date.toString())
          .set({
        "paymentMethod": paymentMedhod,
        "products": jsonEncode({..._cart}),
        "price": price,
        "location": location
      });
    }
  }
}
