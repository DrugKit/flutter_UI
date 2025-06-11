import 'package:drugkit/logic/chatbot/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // To store chat messages (user and bot)

  @override
  void initState() {
    super.initState();
    _messages.add({
      'sender': 'bot',
      'message': "🌟 Welcome to DrugKit’s symptom checker!\nPlease enter your symptoms below to receive a suggestion.",
    });
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      // Add user message to the list
      setState(() {
        _messages.add({'sender': 'user', 'message': message});
      });
      // Clear the input field
      _controller.clear();
      // Send the message via Cubit
      ChatCubit.get(context).sendSymptom(message);
    }
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _messages.add({
        'sender': 'bot',
        'message': "🌟 Welcome to DrugKit’s symptom checker!\nPlease enter your symptoms below to receive a suggestion.",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          "Symptoms Diagnoses",
          style: TextStyle(
            color: Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is ChatSuccess) {
                      setState(() {
                        _messages.add({'sender': 'bot', 'message': state.response});
                      });
                    } else if (state is ChatError) {
                      setState(() {
                        _messages.add({'sender': 'bot', 'message': 'Error: ${state.message}'});
                      });
                    }
                  },
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final messageData = _messages[index];
                        if (messageData['sender'] == 'user') {
                          return _buildUserMessage(messageData['message']!);
                        } else {
                          return _buildBotMessage(messageData['message']!);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Conditionally display the New Chat button or input field
            _messages.length > 1 && _messages.last['sender'] == 'bot' ? _buildNewChatButton() : _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Message chatBot...",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: const Color(0xFF0C1467),
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildNewChatButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C1467),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _resetChat,
        child: const Text(
          "New Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBotMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildUserMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF8E91C7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}