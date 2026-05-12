import 'package:flutter/material.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/glass_container.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/models/chat_models.dart';

class ChatRoomPage extends StatefulWidget {
  final String conversationId; // actually otherUserId

  const ChatRoomPage({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();

  final String currentUserId = "me";

  late final String otherUserId;

  late List<ChatMessage> messages;

  @override
  void initState() {
    super.initState();

    // Treat route param as other user id
    otherUserId = widget.conversationId;

    // Temporary mock conversation
    messages = [
      ChatMessage(
        id: "1",
        senderId: otherUserId,
        text: "Hi! Interested?",
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        id: "2",
        senderId: currentUserId,
        text: "Yes, is it still available?",
        timestamp: DateTime.now(),
      ),
    ];
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: currentUserId,
          text: text,
          timestamp: DateTime.now(),
        ),
      );
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            Column(
              children: [

                TopOverlayActionBar(
              title: otherUserId,
              ),
                
                /// Messages
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final msg = messages[i];
                      final isMe = msg.senderId == currentUserId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlassContainer(
                            borderRadius: BorderRadius.circular(18),
                            tint: isMe
                                ? const Color(0xFFB590F7)
                                : null,
                            padding: const EdgeInsets.all(12),
                            child: Text(msg.text),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                _inputBar(),
              ],
            ),

            
          ],
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(30),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:antipattern/widgets/app_background.dart';
// import 'package:antipattern/widgets/glass_container.dart';
// import 'package:antipattern/widgets/universal_action_bar.dart';
// import 'package:antipattern/models/chat_models.dart';

// class ChatRoomPage extends StatefulWidget {
//   final String conversationId; // actually otherUserId

//   const ChatRoomPage({
//     super.key,
//     required this.conversationId,
//   });

//   @override
//   State<ChatRoomPage> createState() => _ChatRoomPageState();
// }

// class _ChatRoomPageState extends State<ChatRoomPage> {
//   final TextEditingController _controller = TextEditingController();

//   final String currentUserId = "me";

//   late final String otherUserId;

//   late List<ChatMessage> messages;

//   @override
//   void initState() {
//     super.initState();

//     // Treat route param as other user id
//     otherUserId = widget.conversationId;

//     // Temporary mock conversation
//     messages = [
//       ChatMessage(
//         id: "1",
//         senderId: otherUserId,
//         text: "Hi! Interested?",
//         timestamp: DateTime.now(),
//       ),
//       ChatMessage(
//         id: "2",
//         senderId: currentUserId,
//         text: "Yes, is it still available?",
//         timestamp: DateTime.now(),
//       ),
//     ];
//   }

//   void _sendMessage() {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;

//     setState(() {
//       messages.add(
//         ChatMessage(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           senderId: currentUserId,
//           text: text,
//           timestamp: DateTime.now(),
//         ),
//       );
//     });

//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: AppBackground(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 const SizedBox(height: 100),

//                 /// Messages
//                 Expanded(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     itemCount: messages.length,
//                     itemBuilder: (_, i) {
//                       final msg = messages[i];
//                       final isMe = msg.senderId == currentUserId;

//                       return Align(
//                         alignment:
//                             isMe ? Alignment.centerRight : Alignment.centerLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 10),
//                           child: GlassContainer(
//                             borderRadius: BorderRadius.circular(18),
//                             tint: isMe
//                                 ? const Color(0xFFB590F7)
//                                 : null,
//                             padding: const EdgeInsets.all(12),
//                             child: Text(msg.text),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 _inputBar(),
//               ],
//             ),


//           ],
//         ),
//       ),
//     );
//   }

//   Widget _inputBar() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
//       child: GlassContainer(
//         borderRadius: BorderRadius.circular(30),
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   hintText: "Type a message...",
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send_rounded),
//               onPressed: _sendMessage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }