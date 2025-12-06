class EndPoints {
  static const String baseUrl = "https://willizo.com/api";
  static const String _imageBaseUrl = "public/";
  static const String refreshTokenUrl = "$baseUrl/auth/refresh";

  static String getImageFromApi(String imageUrl) {
    return baseUrl + _imageBaseUrl + imageUrl;
  }
}
