class ClearCartResponse {
  final String message;

  ClearCartResponse({required this.message});

  factory ClearCartResponse.fromJson(Map<String, dynamic> json) {
    return ClearCartResponse(message: json['message'] ?? '');
  }
}

