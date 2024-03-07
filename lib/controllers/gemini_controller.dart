import 'dart:typed_data';
import 'package:chat_gemini/model/messege_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiController {
  final GenerativeModel _model;
  final GenerativeModel _visionModel;

  GeminiController(this._model, this._visionModel);

  final isLoading = ValueNotifier(false);

  late final ChatSession _chat;

  final messages = <MessageModel>[];

  void startChat() {
    _chat = _model.startChat();
  }

  Future<void> onSendMessage(String prompt) async {
    isLoading.value = true;

    messages.add(MessageModel(message: prompt, who: WhoEnum.me));

    final botMessageResponse = await _chat.sendMessage(Content.text(prompt));

    if (botMessageResponse.text != null) {
      messages.add(
          MessageModel(message: botMessageResponse.text!, who: WhoEnum.bot));
    }
    isLoading.value = false;
  }

  Future<void> onSendImageMessage(Uint8List imageBytes, String prompt) async {
    isLoading.value = true;
    messages.add(MessageModel(message: prompt, who: WhoEnum.me));

    final content = [
      Content.multi(
        [
          TextPart(prompt),
          DataPart(
            'image/jpeg',
            imageBytes,
          ),
        ],
      ),
    ];

    final botMessageResponse = await _visionModel.generateContent(content);
    if (botMessageResponse.text != null) {
      messages.add(
        MessageModel(message: botMessageResponse.text!, who: WhoEnum.bot),
      );
    }
    isLoading.value = false;
  }
}