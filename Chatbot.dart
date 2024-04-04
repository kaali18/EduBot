import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userMessage = TextEditingController();

  static const apiKey = "AIzaSyAyJHb8GqhHy3eAZgi-Puq4iKoO6efV_hE";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    setState(() {
      // Add user message to the chat
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    // Send the user message to the bot and wait for the response
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      // Add bot's response to the chat
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('EduBot',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.w800,
            fontSize: 25

          ),),
          backgroundColor: Colors.black,
        ),
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      controller: _userMessage,
                      
                      decoration: InputDecoration(
                        
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        label: const Text("Enter your message"),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.all(15),
                    iconSize: 30,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(
                        const CircleBorder(),
                      ),
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? Color.fromARGB(255, 212, 113, 113)
            : Colors.grey.shade300,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
          topRight: const Radius.circular(10),
          bottomRight: isUser ? Radius.zero : const Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Color.fromARGB(255, 0, 0, 0)),
          ),
          Text(
            date,
            style: TextStyle(color: isUser ? Colors.white : Color.fromARGB(255, 23, 19, 19)),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}