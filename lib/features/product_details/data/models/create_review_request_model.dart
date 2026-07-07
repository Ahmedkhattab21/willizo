class CreateReviewRequestModel {
  final String productId;
  final int rating;
  final String title;
  final String comment;
  final String? orderId;

  CreateReviewRequestModel({
    required this.productId,
    required this.rating,
    required this.title,
    required this.comment,
    this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'rating': rating,
      'title': title,
      'comment': comment,
      if (orderId != null && orderId!.isNotEmpty) 'order_id': orderId,
    };
  }
}
