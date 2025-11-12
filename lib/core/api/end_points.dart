class EndPoints {
  static const String baseUrl = "https://willizo.com/api";
  static const String _imageBaseUrl = "public/";

  static String getImageFromApi(String imageUrl) {
    return baseUrl + _imageBaseUrl + imageUrl;
  }
}
