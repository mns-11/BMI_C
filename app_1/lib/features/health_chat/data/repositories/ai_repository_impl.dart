import 'package:app_1/features/health_chat/data/services/ai_service.dart';

abstract class AiRepository {
  Future<String> sendMessageToAi(String message);
  Future<void> initializeAi();
  Future<void> clearAiHistory();
  bool get isAiAvailable;
}

class AiRepositoryImpl implements AiRepository {
  final AiService _aiService = AiService();

  @override
  Future<void> initializeAi() async {
    await _aiService.initialize();
  }

  @override
  Future<String> sendMessageToAi(String message) async {
    return await _aiService.sendMessage(message);
  }

  @override
  Future<void> clearAiHistory() async {
    await _aiService.clearChatHistory();
  }

  @override
  bool get isAiAvailable => _aiService.isInitialized;
}
