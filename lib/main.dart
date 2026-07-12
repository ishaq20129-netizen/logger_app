import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const LoggerApp());

class LoggerApp extends StatelessWidget {
  const LoggerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Logger',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const ChatScreen(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  List<Map<String, dynamic>> messages = [];
  void sendMessage(String text) {
    messages.add({'text': text, 'isMe': true, 'time': DateTime.now()});
    Future.delayed(const Duration(seconds: 1), () {
      messages.add({'text': 'سلام! پیام شما دریافت شد ✅', 'isMe': false, 'time': DateTime.now()});
      notifyListeners();
    });
    notifyListeners();
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Logger Messenger'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: state.messages.length,
              itemBuilder: (ctx, i) {
                final msg = state.messages[state.messages.length - 1 - i];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg['text'], style: TextStyle(color: msg['isMe'] ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'پیام بنویسید...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        state.sendMessage(controller.text);
                        controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
