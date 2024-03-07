class MessageModel {
  final String message;
  final WhoEnum who;

  MessageModel({required this.message, required this.who});
}

enum WhoEnum { me, bot }
