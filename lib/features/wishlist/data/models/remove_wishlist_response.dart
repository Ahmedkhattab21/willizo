class RemoveWishlistResponse {
  final String message;

  RemoveWishlistResponse({required this.message});

  factory RemoveWishlistResponse.fromJson(Map<String, dynamic> json) {
    return RemoveWishlistResponse(message: json['message'] ?? '');
  }
}

