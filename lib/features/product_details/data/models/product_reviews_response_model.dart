class ProductReviewsResponseModel {
  final RatingSummary ratingSummary;
  final List<ReviewData> data;
  final Links? links;
  final Meta? meta;

  ProductReviewsResponseModel({
    required this.ratingSummary,
    required this.data,
    this.links,
    this.meta,
  });

  factory ProductReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewsResponseModel(
      ratingSummary: RatingSummary.fromJson(json['rating_summary'] ?? {}),
      data:
          (json['data'] as List?)
              ?.map((e) => ReviewData.fromJson(e))
              .toList() ??
          [],
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class RatingSummary {
  final double averageRating;
  final double averageStars;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  RatingSummary({
    required this.averageRating,
    required this.averageStars,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    final distribution = json['rating_distribution'];
    return RatingSummary(
      averageRating: _toDouble(json['average_rating']),
      averageStars: _toDouble(json['average_stars']),
      totalReviews: _toInt(json['total_reviews']),
      ratingDistribution: {
        for (var star = 1; star <= 5; star++)
          star: distribution is Map<String, dynamic>
              ? _toInt(distribution[star.toString()])
              : 0,
      },
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ReviewData {
  final String id;
  final String productId;
  final int rating;
  final String title;
  final String comment;
  final UserReviewData user;
  final String createdAt;
  final String updatedAt;

  ReviewData({
    required this.id,
    required this.productId,
    required this.rating,
    required this.title,
    required this.comment,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      rating: RatingSummary._toInt(json['rating']),
      title: json['title']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      user: UserReviewData.fromJson(json['user'] ?? {}),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}

class UserReviewData {
  final String id;
  final String name;

  UserReviewData({required this.id, required this.name});

  factory UserReviewData.fromJson(Map<String, dynamic> json) {
    return UserReviewData(
      id: json['id']?.toString() ?? '',
      name:
          json['name']?.toString() ??
          json['full_name']?.toString() ??
          json['email']?.toString() ??
          '',
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

class Meta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final List<MetaLink> links;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  Meta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 1,
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      links:
          (json['links'] as List?)?.map((e) => MetaLink.fromJson(e)).toList() ??
          [],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 20,
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }
}

class MetaLink {
  final String? url;
  final String label;
  final bool active;

  MetaLink({this.url, required this.label, required this.active});

  factory MetaLink.fromJson(Map<String, dynamic> json) {
    return MetaLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
