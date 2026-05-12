import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/models/chat_models.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = _mockConversations();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
              itemCount: conversations.length,
              itemBuilder: (_, i) {
                final convo = conversations[i];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        '/chat/${convo.id}',
                        extra: convo,
                      );
                    },
                    child: GlassContainer(
                      borderRadius: BorderRadius.circular(20),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: convo.otherAvatarUrl != null
                                ? NetworkImage(convo.otherAvatarUrl!)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  convo.otherUsername,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  convo.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (convo.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFB590F7),
                              ),
                              child: Text(
                                convo.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const TopOverlayActionBar(),
          ],
        ),
      ),
    );
  }

  List<ChatConversation> _mockConversations() {
    return [
      ChatConversation(
        id: "1",
        otherUserId: "seller1",
        otherUsername: "BangtanTradeHub",
        lastMessage: "Yes it's still available!",
        lastMessageTime: DateTime.now(),
        unreadCount: 2,
      ),
      ChatConversation(
        id: "2",
        otherUserId: "buyer2",
        otherUsername: "PhotocardQueen",
        lastMessage: "Shipping tomorrow.",
        lastMessageTime: DateTime.now(),
      ),
    ];
  }
}
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:antipattern/widgets/app_background.dart';
// import 'package:antipattern/widgets/glass_container.dart';
// import 'package:antipattern/widgets/universal_action_bar.dart';
// import 'package:antipattern/models/chat_models.dart';

// class ChatListPage extends StatelessWidget {
//   const ChatListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final conversations = _mockConversations();

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: AppBackground(
//         child: Stack(
//           children: [
//             ListView.builder(
//               padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
//               itemCount: conversations.length,
//               itemBuilder: (_, i) {
//                 final convo = conversations[i];

//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: GestureDetector(
//                     onTap: () {
//                       context.push(
//                         '/chat/${convo.id}',
//                         extra: convo,
//                       );
//                     },
//                     child: GlassContainer(
//                       borderRadius: BorderRadius.circular(20),
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 26,
//                             backgroundImage: convo.otherAvatarUrl != null
//                                 ? NetworkImage(convo.otherAvatarUrl!)
//                                 : null,
//                           ),
//                           const SizedBox(width: 14),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   convo.otherUsername,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   convo.lastMessage,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (convo.unreadCount > 0)
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFFB590F7),
//                               ),
//                               child: Text(
//                                 convo.unreadCount.toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const TopOverlayActionBar(),
//           ],
//         ),
//       ),
//     );
//   }

//   List<ChatConversation> _mockConversations() {
//     return [
//       ChatConversation(
//         id: "1",
//         otherUserId: "seller1",
//         otherUsername: "BangtanTradeHub",
//         lastMessage: "Yes it's still available!",
//         lastMessageTime: DateTime.now(),
//         unreadCount: 2,
//       ),
//       ChatConversation(
//         id: "2",
//         otherUserId: "buyer2",
//         otherUsername: "PhotocardQueen",
//         lastMessage: "Shipping tomorrow.",
//         lastMessageTime: DateTime.now(),
//       ),
//     ];
//   }
// }