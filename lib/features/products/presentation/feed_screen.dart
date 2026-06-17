import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cart/presentation/cart_screen.dart';
import '../blocs/feed_bloc.dart';

import '../blocs/feed_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    // Fire the event to load data as soon as the screen initializes
    // context.read<FeedBloc>().add(LoadFeedPosts()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 24),
          onPressed: () {},
        ),
        title: const Text(
          'Feed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Wrap your body in a BlocBuilder to listen for state changes
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          
          if (state is FeedError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          // IF IT SUCCESSFULLY LOADS, RETURN THE LIST
          if (state is FeedLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ...state.posts.map((post) => _buildFeedPost(context, post)),
                  const SizedBox(height: 100), // Padding for the bottom navbar
                ],
              ),
            );
          }

          // If it's stuck in Initial, show a text message instead of a blank screen so we know!
          return const Center(child: Text("Waiting for data...", style: TextStyle(color: Colors.grey)));
        },
      ),
    );
  }

  // Passing the specific 'post' data model into the UI builder
  Widget _buildFeedPost(BuildContext context, dynamic post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Added vertical margin for spacing
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212), 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header (User Info)
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade800,
                // Replace hardcoded values with post.userInitials
                child: const Text('CM', style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chris Madison', // Replace with post.authorName
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    '@madchris', // Replace with post.authorHandle
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),

          // Main Visual Outfit Canvas (Stack for Hotspot Tags)
          AspectRatio(
            aspectRatio: 0.9, 
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(20),
                    // If you have an image URL:
                    // image: DecorationImage(image: NetworkImage(post.imageUrl), fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.checkroom_outlined, 
                      size: 80, 
                      color: Colors.white.withOpacity(0.05)
                    ),
                  ),
                ),
                
                // Hotspot Tags
                Positioned(top: 70, left: 30, child: _buildOutfitTag('Fleece Oversized Hoodie')),
                Positioned(top: 130, right: 40, child: _buildOutfitTag('Cotton Chinos')),
                Positioned(bottom: 120, left: 80, child: _buildOutfitTag('Sneakers')),

                // "View items in this look" Floating Bar
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_mall_outlined, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'View items in this look',
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Social Engagement Action Bar
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, size: 22),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(right: 16),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 21),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(right: 16),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined, size: 21),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border, size: 22),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}