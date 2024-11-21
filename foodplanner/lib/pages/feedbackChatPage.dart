import 'package:flutter/material.dart';
import 'package:foodplanner/components/footer.dart'; // Import the FooterBar widget
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class Message {
  String text;
  final bool isSent;
  final DateTime date;
  bool showDate;
  final String sender;

  Message({required this.text, required this.isSent, required this.date, this.showDate = false, required this.sender});
}

class FeedbackChatPage extends StatefulWidget {
  const FeedbackChatPage({Key? key}) : super(key: key);

  @override
  _FeedbackChatPageState createState() => _FeedbackChatPageState();
}

class _FeedbackChatPageState extends State<FeedbackChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [
    Message(text: "Hej, hvordan var dagens måltid?", isSent: false, date: DateTime.now().subtract(Duration(days: 1)), sender: "Teacher"),
    Message(text: "Det var fantastisk, tak!", isSent: true, date: DateTime.now().subtract(Duration(days: 1)), sender: "Parent"),
    Message(text: "Har du nogen feedback til forbedring?", isSent: false, date: DateTime.now().subtract(Duration(days: 1)), sender: "Teacher"),
    Message(text: "Måske lidt mere variation i grøntsagerne.", isSent: true, date: DateTime.now().subtract(Duration(days: 1)), sender: "Parent"),
    Message(text: "Selvfølgelig, vi vil tage det i betragtning.", isSent: false, date: DateTime.now().subtract(Duration(days: 1)), sender: "Teacher"),
    Message(text: "Tak!", isSent: true, date: DateTime.now().subtract(Duration(days: 1)), sender: "Parent"),
  ];

  int? _editingMessageIndex;

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        if (_editingMessageIndex != null) {
          _messages[_editingMessageIndex!].text = _controller.text;
          _editingMessageIndex = null;
        } else {
          _messages.add(Message(text: _controller.text, isSent: true, date: DateTime.now(), sender: "Parent"));
        }
        _controller.clear();
      });
    }
  }

  Future<void> _deleteMessage(int index) async {
    setState(() {
      _messages[index].text = "Denne besked er blevet slettet.";
    });
  }

  void _editMessage(int index) {
    setState(() {
      _controller.text = _messages[index].text;
      _editingMessageIndex = index;
    });
  }

  void _cancelEdit() {
    setState(() {
      _controller.clear();
      _editingMessageIndex = null;
    });
  }

  void _showEditDeleteDialog(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150, // Set the height of the bottom sheet
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _editMessage(index);
                    },
                  ),
                  Text("Rediger"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showDeleteConfirmationDialog(index);
                    },
                  ),
                  Text("Slet"),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text("Annuller"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Slet besked"),
          content: Text("Er du sikker på, at du vil slette denne besked?"),
          actions: [
            TextButton(
              child: Text("Annuller"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Slet"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMessage(index);
              },
            ),
          ],
        );
      },
    );
  }

  void navigateBack() {
    final GoRouterState state = GoRouterState.of(context);
    final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
    final String? from = extra?['from'];
    GoRouter.of(context).go(from ?? '/');
  }

  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
    final String? from = extra?['from'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Feedback', style: AppTextStyles.headline3),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: navigateBack,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure footer is at the bottom
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final previousMessage = index > 0 ? _messages[index - 1] : null;
                final isNewDate = previousMessage == null || message.date.day != previousMessage.date.day;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isNewDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                DateFormat('dd MMMM yyyy').format(message.date),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          message.showDate = !message.showDate;
                        });
                      },
                      onLongPress: () {
                        if (message.isSent) {
                          _showEditDeleteDialog(index);
                        }
                      },
                      child: Align(
                        alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: message.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (!message.isSent)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  message.sender,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            if (message.showDate)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  DateFormat('dd MMMM yyyy, HH:mm').format(message.date),
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: message.isSent ? Colors.orange : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(color: message.isSent ? Colors.white : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (_editingMessageIndex != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rediger besked",
                    style: TextStyle(color: Colors.grey),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: _cancelEdit,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Indtast besked...',
                filled: true,
                fillColor: AppColors.textFieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
            ),
          ),
          FooterBar(), // Add the footer widget here
        ],
      ),
    );
  }
}