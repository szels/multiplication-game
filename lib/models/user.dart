class User {
  final String username;
  final DateTime timestamp;

  User({
    required this.username,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'username': username,
    'timestamp': timestamp.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    username: json['username'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
} 