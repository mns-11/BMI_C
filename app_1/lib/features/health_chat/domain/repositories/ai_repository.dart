abstract class AiRepository {
  Future<String> sendMessageToAi(String message);
  Future<void> initializeAi();
  Future<void> clearAiHistory();
  bool get isAiAvailable;
}
