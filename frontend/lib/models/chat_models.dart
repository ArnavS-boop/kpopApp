class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}

class ChatConversation {
  final String id;
  final String otherUserId;
  final String otherUsername;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? otherAvatarUrl;

  ChatConversation({
    required this.id,
    required this.otherUserId,
    required this.otherUsername,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.otherAvatarUrl,
  });
}
// class ChatMessage {
//   final String id;
//   final String senderId;
//   final String text;
//   final DateTime timestamp;

//   ChatMessage({
//     required this.id,
//     required this.senderId,
//     required this.text,
//     required this.timestamp,
//   });
// }

// class ChatConversation {
//   final String id;
//   final String otherUserId;
//   final String otherUsername;
//   final String lastMessage;
//   final DateTime lastMessageTime;
//   final int unreadCount;
//   final String? otherAvatarUrl;

//   ChatConversation({
//     required this.id,
//     required this.otherUserId,
//     required this.otherUsername,
//     required this.lastMessage,
//     required this.lastMessageTime,
//     this.unreadCount = 0,
//     this.otherAvatarUrl,
//   });
// }