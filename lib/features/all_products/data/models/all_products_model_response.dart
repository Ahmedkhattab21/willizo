import 'package:willizo/features/shop/data/models/shop_model_response.dart';

class AllProductsResponseModel {
  final List<Product> data;
  final Meta meta;
  final Links links;

  AllProductsResponseModel({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory AllProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return AllProductsResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
      links: Links.fromJson(json['links'] ?? {}),
    );
  }
}

class Meta {
  final List<int> total;
  final List<int> perPage;
  final List<int> currentPage;
  final List<int> lastPage;
  final int from;
  final List<LinkItem> links;
  final String path;
  final int to;

  Meta({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.links,
    required this.path,
    required this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total:
          (json['total'] as List<dynamic>?)
              ?.map((item) => item as int)
              .toList() ??
          [],
      perPage:
          (json['per_page'] as List<dynamic>?)
              ?.map((item) => item as int)
              .toList() ??
          [],
      currentPage:
          (json['current_page'] as List<dynamic>?)
              ?.map((item) => item as int)
              .toList() ??
          [],
      lastPage:
          (json['last_page'] as List<dynamic>?)
              ?.map((item) => item as int)
              .toList() ??
          [],
      from: json['from'] ?? 0,
      links:
          (json['links'] as List<dynamic>?)
              ?.map((item) => LinkItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      path: json['path'] ?? "",
      to: json['to'] ?? 0,
    );
  }
}

class LinkItem {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  LinkItem({this.url, required this.label, this.page, required this.active});

  factory LinkItem.fromJson(Map<String, dynamic> json) {
    return LinkItem(
      url: json['url'],
      label: json['label'] ?? "",
      page: json['page'],
      active: json['active'] ?? false,
    );
  }
}

class Links {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}
