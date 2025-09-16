import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_data.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new post
  Future<void> createPost(Post post) async {
    try {
      await _firestore.collection('posts').add({
        'userId': post.userId,
        'content': post.content,
        'imageUrl': post.imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
        'comments': [],
        'title': post.title,
        'rate': post.rate,
        'numOfVotes': post.numOfVotes,
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Get all posts
  Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          userId: data['userId'],
          content: data['content'],
          imageUrl: data['imageUrl'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          likes: data['likes'],
          comments: List<String>.from(data['comments']),
          title: data['title'],
          rate: data['rate']?.toDouble(),
          numOfVotes: data['numOfVotes']?.toInt() ?? 0,
        );
      }).toList();
    });
  }

  // Get user posts
  Stream<List<Post>> getUserPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          userId: data['userId'],
          content: data['content'],
          imageUrl: data['imageUrl'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          likes: data['likes'],
          comments: List<String>.from(data['comments']),
          title: data['title'],
          rate: data['rate']?.toDouble(),
          numOfVotes: data['numOfVotes']?.toInt() ?? 0,
        );
      }).toList();
    });
  }

  // Like a post
  Future<void> likePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Add comment to a post
  Future<void> addComment(String postId, String comment) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.arrayUnion([comment]),
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
