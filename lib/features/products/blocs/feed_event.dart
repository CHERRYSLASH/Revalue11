abstract class FeedEvent {}

// Fired when the screen first opens (inside initState)
class LoadFeedPosts extends FeedEvent {}

// Fired when the user taps the heart icon on a specific post
class ToggleLikePost extends FeedEvent {
  final String postId;
  ToggleLikePost(this.postId);
}