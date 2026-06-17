import '../data/feed_post_model.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<FeedPost> posts;
  
  // We pass the posts into the state so the UI can draw them
  FeedLoaded({required this.posts});
}

class FeedError extends FeedState {
  final String message;
  FeedError({required this.message});
}