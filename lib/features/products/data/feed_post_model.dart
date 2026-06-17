import 'product_model.dart';

class FeedPost {
  final String id;
  final String authorName;
  final String authorHandle;
  final String authorInitials;
  final String postImageUrl;
  int likes;
  bool isLikedByMe;
  final List<Product> taggedProducts;

  FeedPost({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.authorInitials,
    required this.postImageUrl,
    this.likes = 0,
    this.isLikedByMe = false,
    required this.taggedProducts,
  });
}