import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();

  // dummy conversation
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hey👋', 'isUser': false},
    {'text': 'Hi , I need some help..', 'isUser': true},
    {'text': 'Sure, how can I assist?', 'isUser': false},
    {'text': 'I feel a headache and fever.', 'isUser': true},
    {'text': 'You might be having flu symptoms.', 'isUser': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'symptoms diagnoses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0C1467),
          ),
        ),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          // Chat area
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Align(
                    alignment: msg['isUser']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      constraints: BoxConstraints(maxWidth: 250),
                      decoration: BoxDecoration(
                        color: msg['isUser']
                            ? Color.fromARGB(255, 62, 62, 106) // user messages (light purple)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(
                          color:
                              msg['isUser'] ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Input area
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message chatBot...',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) return;
                      setState(() {
                        messages.add({
                          'text': _controller.text.trim(),
                          'isUser': true,
                        });
                        _controller.clear();
                      });
                    },
                    icon: Icon(Icons.send, color: Color(0xFF0C1467)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
