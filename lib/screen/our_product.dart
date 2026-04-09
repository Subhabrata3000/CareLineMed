import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/custom_colors.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model/font_family_model.dart';
import 'our_product_checkout_screen.dart';

class ProductCategory {
  final String id;
  final String name;

  ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}

class ProductItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double discountPrice;
  final String image;
  final String categoryName;
  final int stock;
  final String rating;

  ProductItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.image,
    required this.categoryName,
    required this.stock,
    required this.rating,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      discountPrice: double.tryParse(json['discount_price']?.toString() ?? '0') ?? 0,
      image: json['image'] ?? '',
      categoryName: json['category_name'] ?? 'Health',
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      rating: json['rating']?.toString() ?? '4.5',
    );
  }
}

class OurProduct extends StatefulWidget {
  const OurProduct({super.key});

  @override
  State<OurProduct> createState() => _OurProductState();
}

class _OurProductState extends State<OurProduct> {
  int selectedCategoryIndex = 0;
  List<ProductCategory> categories = [ProductCategory(id: 'all', name: 'All')];
  List<ProductItem> products = [];
  bool isLoadingCategories = true;
  bool isLoadingProducts = true;

  // === LOCAL CART STATE ===
  // Map<productId, quantity>
  Map<String, int> cartQuantities = {};

  @override
  void initState() {
    super.initState();
    _loadCart();
    fetchCategories();
    fetchProducts('all');
  }

  // --- Cart persistence ---
  void _loadCart() {
    final stored = getData.read("OurProductCart");
    if (stored != null && stored is List) {
      for (var item in stored) {
        if (item is Map) {
          cartQuantities[item["id"].toString()] = item["qty"] as int;
        }
      }
    }
    setState(() {});
  }

  void _saveCart() {
    // Build the full cart list with product details for checkout
    List<Map<String, dynamic>> cartList = [];
    for (var entry in cartQuantities.entries) {
      if (entry.value > 0) {
        // Find the product in our loaded products
        final product = products.cast<ProductItem?>().firstWhere(
              (p) => p?.id == entry.key,
              orElse: () => null,
            );
        if (product != null) {
          cartList.add({
            "id": product.id,
            "name": product.name,
            "price": product.price,
            "image": product.image,
            "qty": entry.value,
            "ptype": "Regular",
          });
        } else {
          // Product not in current list (different category), keep existing data
          final existing = getData.read("OurProductCart");
          if (existing != null && existing is List) {
            final existingItem = existing.cast<Map?>().firstWhere(
                  (e) => e?["id"].toString() == entry.key,
                  orElse: () => null,
                );
            if (existingItem != null) {
              cartList.add({
                ...Map<String, dynamic>.from(existingItem),
                "qty": entry.value,
              });
            }
          }
        }
      }
    }
    save("OurProductCart", cartList);
  }

  void _addToCart(ProductItem product) {
    setState(() {
      cartQuantities[product.id] = (cartQuantities[product.id] ?? 0) + 1;
      _saveCart();
    });
  }

  void _incrementQty(String productId) {
    setState(() {
      cartQuantities[productId] = (cartQuantities[productId] ?? 0) + 1;
      _saveCart();
    });
  }

  void _decrementQty(String productId) {
    setState(() {
      int current = cartQuantities[productId] ?? 0;
      if (current <= 1) {
        cartQuantities.remove(productId);
      } else {
        cartQuantities[productId] = current - 1;
      }
      _saveCart();
    });
  }

  int get totalCartItems {
    int count = 0;
    cartQuantities.forEach((_, qty) => count += qty);
    return count;
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('${Config.socketUrlDoctor}/customer/product_categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ResponseCode'] == 200 && data['categories'] != null) {
          final List<dynamic> catList = data['categories'];
          setState(() {
            categories = [ProductCategory(id: 'all', name: 'All')];
            categories.addAll(catList.map((e) => ProductCategory.fromJson(e)).toList());
            isLoadingCategories = false;
          });
        } else {
          setState(() => isLoadingCategories = false);
        }
      } else {
        setState(() => isLoadingCategories = false);
      }
    } catch (e) {
      setState(() => isLoadingCategories = false);
    }
  }

  Future<void> fetchProducts(String categoryId) async {
    setState(() {
      isLoadingProducts = true;
    });
    try {
      final response = await http.post(
        Uri.parse('${Config.socketUrlDoctor}/customer/products_list'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'category_id': categoryId}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ResponseCode'] == 200 && data['products'] != null) {
          final List<dynamic> prodList = data['products'];
          setState(() {
            products = prodList.map((e) => ProductItem.fromJson(e)).toList();
            isLoadingProducts = false;
          });
        } else {
          setState(() {
            products = [];
            isLoadingProducts = false;
          });
        }
      } else {
        setState(() {
          products = [];
          isLoadingProducts = false;
        });
      }
    } catch (e) {
      setState(() {
        products = [];
        isLoadingProducts = false;
      });
    }
  }

  String getImageUrl(String imageName) {
    if (imageName.isEmpty) return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80';
    if (imageName.startsWith('http')) return imageName;
    return '${Config.socketUrlDoctor}/images/$imageName';
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 800 ? 4 : (screenWidth > 500 ? 3 : 2);
    double childAspectRatio = screenWidth > 500 ? 0.65 : 0.58;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primeryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Our Products",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      // === VIEW CART FLOATING BUTTON ===
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: totalCartItems > 0
          ? InkWell(
              onTap: () {
                Get.to(() => const OurProductCheckoutScreen())!
                    .then((_) {
                  // Reload cart when returning from checkout
                  cartQuantities.clear();
                  _loadCart();
                });
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: gradient.defoultColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: BlackColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Cart".tr,
                            style: TextStyle(
                              color: WhiteColor,
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "$totalCartItems ${"items".tr}",
                            style: TextStyle(
                              color: WhiteColor,
                              fontFamily: FontFamily.gilroyMedium,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          if (isLoadingCategories)
            const Center(child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(categories.length, (index) {
                  bool isSelected = selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                        fetchProducts(categories[index].id);
                      },
                      hoverColor: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          categories[index].name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoadingProducts
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(
                        child: Text(
                          "No products available matching this category.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 5,
                          bottom: totalCartItems > 0 ? 100 : 15,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return _productCard(products[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(ProductItem product) {
    bool isDiscounted = product.discountPrice > product.price && product.discountPrice > 0;
    int discountPercent = 0;
    if (isDiscounted) {
      discountPercent = (((product.discountPrice - product.price) / product.discountPrice) * 100).round();
    }
    bool isOutOfStock = product.stock <= 0;
    int qty = cartQuantities[product.id] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey.shade50,
                    child: Image.network(
                      getImageUrl(product.image),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                if (isDiscounted)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "$discountPercent% OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (isOutOfStock)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "OUT OF STOCK",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.categoryName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: primeryColor,
                          letterSpacing: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${product.rating} (120+)",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "₹${product.price.toStringAsFixed(0)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (isDiscounted)
                            Text(
                              "₹${product.discountPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // === CART BUTTON: Add to Bag / Quantity Controls ===
                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: qty > 0
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: gradient.defoultColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () => _decrementQty(product.id),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Icon(Icons.remove, size: 18, color: gradient.defoultColor),
                                      ),
                                    ),
                                    Text(
                                      "$qty",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.gilroyBold,
                                        color: gradient.defoultColor,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _incrementQty(product.id),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Icon(Icons.add, size: 18, color: gradient.defoultColor),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: isOutOfStock ? null : () => _addToCart(product),
                                icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                                label: Text(
                                  isOutOfStock ? "Out of Stock" : "Add to Bag",
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  disabledForegroundColor: Colors.grey.shade600,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}