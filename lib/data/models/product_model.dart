import 'package:store/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.thumbnail,
    required super.name,
    required super.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'].toString(),
    thumbnail: json['thumbnail'],
    name: json['name'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['thumbnail'] = thumbnail;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
