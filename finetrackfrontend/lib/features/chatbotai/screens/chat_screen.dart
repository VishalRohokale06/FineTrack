import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  final ChatService chatService = ChatService();

  final List<ChatMessage> messages = [];

  bool isLoading = false;

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    String userMessage = controller.text;

    messages.add(ChatMessage(message: userMessage, isUser: true));

    controller.clear();

    setState(() {
      isLoading = true;
    });

    try {
      String aiResponse = await chatService.sendMessage(userMessage);

      messages.add(ChatMessage(message: aiResponse, isUser: false));
    } catch (e) {
      print("CHAT ERROR: $e");

      messages.add(ChatMessage(message: e.toString(), isUser: false));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Financial Assistant")),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return Align(
                  alignment:
                      message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.all(8),

                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color:
                          message.isUser ? Colors.blue : Colors.grey.shade300,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      message.message,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),

                  child: TextField(
                    controller: controller,

                    decoration: const InputDecoration(
                      hintText: "Ask about your finances...",
                    ),
                  ),
                ),
              ),

              IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
