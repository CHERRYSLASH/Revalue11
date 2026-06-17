abstract class FeedEvent {}

class LoadFeedPosts extends FeedEvent {}

class ToggleLikePost extends FeedEvent {
  final String postId;
  ToggleLikePost(this.postId);
}