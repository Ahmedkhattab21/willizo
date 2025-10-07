class HomeResponseModel {
  final bool status;
  final String message;
  final HomeData? data;

  HomeResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? HomeData.fromJson(json['data']) : null,
    );
  }
}

class HomeData {
  final List<BannerData> banners;
  final List<PostData> posts;

  HomeData({
    required this.banners,
    required this.posts,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      banners: (json['banners'] as List<dynamic>?)
              ?.map((item) => BannerData.fromJson(item))
              .toList() ??
          [],
      posts: (json['posts'] as List<dynamic>?)
              ?.map((item) => PostData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "banners": banners.map((b) => b.toJson()).toList(),
      "posts": posts.map((p) => p.toJson()).toList(),
    };
  }
}

class BannerData {
  final int id;
  final String image;
  final String title;

  BannerData({
    required this.id,
    required this.image,
    required this.title,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "title": title,
    };
  }
}

class PostData {
  final int id;
  final String userName;
  final String userImage;
  final String content;
  final String image;
  final int likes;
  final int comments;
  final String createdAt;

  PostData({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.image,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? '',
      userImage: json['user_image'] ?? '',
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_name": userName,
      "user_image": userImage,
      "content": content,
      "image": image,
      "likes": likes,
      "comments": comments,
      "created_at": createdAt,
    };
  }
}
