class Product {
  final int? id;
  final int? categoryId;
  final String? name;

  Product({
    this.id,
    this.categoryId,
    this.name,
  });

  Product copyWith({
    int? id,
    int? categoryId,
    String? name,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
    );
  }
}
