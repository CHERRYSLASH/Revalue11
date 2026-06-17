import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/feed_post_model.dart';
import '../data/product_model.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  List<FeedPost> _currentPosts = [];

  FeedBloc() : super(FeedInitial()) {
    
    on<LoadFeedPosts>((event, emit) async {
      print("🚀 FEED BLOC: Fetching posts..."); // ADD THIS LINE
      emit(FeedLoading());
      
      try {
        await Future.delayed(const Duration(seconds: 1)); 
        _currentPosts = _getMockFeed();
        
        print("✅ FEED BLOC: Found ${_currentPosts.length} posts!"); // ADD THIS LINE
        emit(FeedLoaded(posts: List.from(_currentPosts)));
      } catch (e) {
        emit(FeedError(message: "Failed to load feed."));
      }
    });

    on<ToggleLikePost>((event, emit) {
      if (state is FeedLoaded) {
        final postIndex = _currentPosts.indexWhere((post) => post.id == event.postId);
        
        if (postIndex != -1) {
          final post = _currentPosts[postIndex];
          
          post.isLikedByMe = !post.isLikedByMe;
          post.likes += post.isLikedByMe ? 1 : -1;

          // Emit a brand new state with the updated list so the UI repaints the heart icon
          emit(FeedLoaded(posts: List.from(_currentPosts)));
        }
      }
    });
  }

  List<FeedPost> _getMockFeed() {
    return [
      FeedPost(
        id: 'post_1',
        authorName: 'Chris Madison',
        authorHandle: '@madchris',
        authorInitials: 'CM',
        postImageUrl: 'https://via.placeholder.com/400x500',
        likes: 1240,
        taggedProducts: [
          Product(
            id: 'p1', 
            name: 'Fleece Oversized Hoodie', 
            description: 'A cozy, premium fleece hoodie perfect for winter layering.', // ADDED
            price: 24.99, 
            stock: 50, // ADDED
            imageUrl: ''
          ),
          Product(
            id: 'p2', 
            name: 'Cotton Chinos', 
            description: 'Relaxed fit cotton chinos for everyday wear.', // ADDED
            price: 17.99, 
            stock: 30, // ADDED
            imageUrl: ''
          ),
          Product(
            id: 'p3', 
            name: 'Sneakers', 
            description: 'Classic low-top street sneakers.', // ADDED
            price: 27.99, 
            stock: 15, // ADDED
            imageUrl: ''
          ),
        ],
      ),
      FeedPost(
        id: 'post_2',
        authorName: 'Jane Irish',
        authorHandle: '@janeirish',
        authorInitials: 'JI',
        postImageUrl: 'https://via.placeholder.com/400x500', 
        likes: 892,
        taggedProducts: [
          Product(
            id: 'p4', 
            name: 'Vintage Graphic Tee', 
            description: 'Washed graphic tee with distressed edges.', // ADDED
            price: 110.59, 
            stock: 5, // ADDED
            imageUrl: ''
          ),
        ],
      ),
    ];
  }
}