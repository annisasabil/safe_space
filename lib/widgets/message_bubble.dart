import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget{
  final String content;
  final String sender;
  final bool isMyChat;

  const MessageBubble({
    super.key,
    required this.content,
    required this.sender,
    required this.isMyChat,
  });

  static const Color myColor = Color(0xFF5976AC);
  static const Color otherTextColor = Color(0xFF78BF91);

  final senderBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );

  final otherBorderRadius = const BorderRadius.only(
    topRight: Radius.circular(20),
    topLeft: Radius.circular(20),
    bottomRight: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: 
          isMyChat? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
         Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: isMyChat ? myColor : Color(0xFF5976AC),
              fontWeight: FontWeight.w500,
            ),
          ),
          Card(
            color: isMyChat? Color(0xFF78BF91) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: isMyChat? senderBorderRadius : otherBorderRadius,
            ),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Text(
                content,
                style: TextStyle(
                  color: isMyChat ? Colors.white : otherTextColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}