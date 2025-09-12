class Post {
  final String? id;
  final String userId;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final int likes;
  final List<String> comments;
  final String title;
  final double? rate;
  final int? numOfVotes;

  Post({
    this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likes = 0,
    this.comments = const [],
    required this.title,
    this.rate,
    this.numOfVotes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments,
      'title': title,
      'rate': rate,
      'numOfVotes': numOfVotes,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      timestamp: (map['timestamp'] as DateTime),
      likes: map['likes']?.toInt() ?? 0,
      comments: List<String>.from(map['comments'] ?? []),
      title: map['title'] ?? '',
      rate: map['rate']?.toDouble(),
      numOfVotes: map['numOfVotes']?.toInt() ?? 0,
    );
  }
}
