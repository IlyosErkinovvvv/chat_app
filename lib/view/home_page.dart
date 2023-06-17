import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final IO.Socket socket = IO.io("http://10.0.1.122:3000", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    socket.connect();
    super.initState();
    socket.on("chat message", (data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Chat App")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
              itemCount: messages.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Write a message",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    socket.emit("chat message", _messageController);
                    _messageController.clear();
                  },
                  child: const Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
