import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:foodplanner/services/fetch_feedbackMessages.dart';
import 'package:foodplanner/components/nav_bar.dart';

class Message {
  int MessageID;
  String Content;
  String firstName;
  DateTime Date;
  int UserId;
  int ChatThreadId;
  bool Archived;
  bool isSent;
  bool showDate;
  bool isEdited;

  Message(
      {required this.Content,
      required this.isSent,
      required this.Date,
      required this.firstName,
      this.showDate = false,
      this.MessageID = 0,
      this.UserId = 0,
      this.ChatThreadId = 0,
      this.Archived = false,
      this.isEdited = false});

  factory Message.fromJson(Map<String, dynamic> json, int currentUserId) {
    return Message(
      MessageID: json['messageID'],
      Content: json['content'] ?? '',
      firstName: json['firstName'] ?? '',
      Date: DateTime.parse(json['date']),
      UserId: json['userId'],
      ChatThreadId: json['chatThreadId'],
      Archived: json['archived'] ?? false,
      // Check if the message was sent by the current user
      isSent: json['userId'] == currentUserId,
      isEdited: json['isEdited'] ?? false,
    );
  }
}

class FeedbackChatPage extends StatefulWidget {
  const FeedbackChatPage({Key? key}) : super(key: key);
  static final FeedbackService feedbackService =
      FeedbackService(apiUrl: ApiConfig.baseUrl);
  static bool isEditing = false;

  @override
  _FeedbackChatPageState createState() => _FeedbackChatPageState();
}

class _FeedbackChatPageState extends State<FeedbackChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _messages = [];
  int? _childId;
  Timer? _timer;
  int? _editingMessageIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final GoRouterState state = GoRouterState.of(context);
      final Map<String, dynamic>? extra = state.extra as Map<String, dynamic>?;
      final int? childId = extra != null && extra['childId'] != null
          ? int.tryParse(extra['childId']) // Safely parse the value to int
          : null;
      setState(() {
        _childId = childId;
      });
      fetchMessages();
      // Set up a timer to call fetchMessages every 5 seconds
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        fetchMessages();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    if (_childId == null) {
      await fetchMessagesFromToken();
    } else {
      await fetchMessagesFromChildId(_childId!);
    }
    // Scroll to the bottom of the message list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> fetchMessagesFromToken() async {
    try {
      final Map<String, dynamic> chatThreadAndUserId = await FeedbackChatPage
          .feedbackService
          .fetchGetChatThreadIdAndUserIdFromToken(AuthProvider());

      final int chatThreadId = chatThreadAndUserId['chatThreadId'];
      final int userId = chatThreadAndUserId['userId'];

      final List<Map<String, dynamic>> messagesData = await FeedbackChatPage
          .feedbackService
          .fetchGetFeedbackMessages(chatThreadId, AuthProvider());

      setState(() {
        _messages = messagesData
            .map((messageJson) => Message.fromJson(messageJson, userId))
            .toList();
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> fetchMessagesFromChildId(int childId) async {
    try {
      final Map<String, dynamic> chatThreadAndUserId = await FeedbackChatPage
          .feedbackService
          .fetchGetChatThreadIdAndUserIdFromChildIdAndToken(
              childId, AuthProvider());
      final int chatThreadId = chatThreadAndUserId['chatThreadId'];
      final int userId = chatThreadAndUserId['userId'];
      final List<Map<String, dynamic>> messagesData = await FeedbackChatPage
          .feedbackService
          .fetchGetFeedbackMessages(chatThreadId, AuthProvider());

      setState(() {
        _messages = messagesData
            .map((messageJson) => Message.fromJson(messageJson, userId))
            .toList();
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    fetchMessages();
    if (_controller.text.isNotEmpty) {
      final String messageContent = _controller.text;

      setState(() {
        if (_editingMessageIndex != null) {
          // Edit the message locally
          _messages[_editingMessageIndex!].Content = messageContent;
          _editingMessageIndex = null;
        }
        _controller.clear(); // Clear the input field
      });

      try {
        // Send the message to the backend
        int _chatThreadId = 0;

        if (_childId == null) {
          final Map<String, dynamic> chatThreadAndUserId =
              await FeedbackChatPage.feedbackService
                  .fetchGetChatThreadIdAndUserIdFromToken(AuthProvider());
          _chatThreadId = chatThreadAndUserId['chatThreadId'];
        } else {
          _chatThreadId = await FeedbackChatPage.feedbackService
              .fetchGetChatThreadIdByChildId(_childId!, AuthProvider());
        }

        await FeedbackChatPage.feedbackService.fetchSendFeedbackMessage(
          chatThreadId: _chatThreadId, // Replace with the actual chatThreadId
          content: messageContent,
          authProvider: AuthProvider(),
        );

        // Optionally refresh messages from the server to reflect the updated state
        await fetchMessages();
      } catch (e) {
        print('Error sending message: $e');
        // Handle error by optionally showing a message to the user or retrying
        setState(() {
          _messages.removeWhere(
              (msg) => msg.Content == messageContent && msg.isSent);
        });
      }
    }
  }

  Future<void> _deleteMessage(int index) async {
    FeedbackChatPage.feedbackService.fetchArchieveMessageFromMessageID(
        _messages[index].MessageID, AuthProvider());
    setState(() {
      _messages[index].Content = "Denne besked er blevet slettet.";
    });
  }

  void _editMessage(int index) async {
    setState(() {
      _controller.text = _messages[index].Content;
      _editingMessageIndex = index;
    });
  }

  void _sendEditMessage(int index) async {
    bool response = await FeedbackChatPage.feedbackService
        .fetchUpdateMessageFromMessageID(
            _messages[index].MessageID, _controller.text, AuthProvider());
    if (response) {
      fetchMessages();
      _cancelEdit();
    }
  }

  void _cancelEdit() {
    FeedbackChatPage.isEditing = false;
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
                      FeedbackChatPage.isEditing = true;
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
      bottomNavigationBar: NavBar(currentPageIndex: 0),
      //backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final previousMessage = index > 0 ? _messages[index - 1] : null;
                final isNewDate = previousMessage == null ||
                    message.Date.day != previousMessage.Date.day;

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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                DateFormat('dd MMMM yyyy').format(message.Date),
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                        if (message.isSent && !message.Archived) {
                          _showEditDeleteDialog(index);
                        }
                      },
                      child: Align(
                        alignment: message.isSent
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: message.isSent
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!message.isSent && !message.Archived)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, bottom: 5),
                                child: Text(
                                  message.firstName,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            if (message.isEdited)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14, left: 14, bottom: 5),
                                child: Text(
                                  "Redigeret",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ),
                            if (message.showDate)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 12, left: 12, bottom: 5),
                                child: Text(
                                  DateFormat('dd MMMM yyyy, HH:mm')
                                      .format(message.Date),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: message.isSent
                                    ? Colors.orange
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                message.Content,
                                style: TextStyle(
                                    color: message.isSent
                                        ? Colors.white
                                        : Colors.black),
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
                  onPressed: FeedbackChatPage.isEditing
                      ? () => _sendEditMessage(_editingMessageIndex!)
                      : _sendMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
