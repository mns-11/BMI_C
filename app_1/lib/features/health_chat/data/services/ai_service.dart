import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      // Don't throw error, just work without AI
      _isInitialized = false;
      return;
    }

    if (apiKey == 'your_gemini_api_key_here' || apiKey == 'demo_key_for_testing') {
      // Don't throw error, just work without AI
      _isInitialized = false;
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1500,
        topK: 40,
        topP: 0.95,
      ),
      systemInstruction: Content.system(
        'أنت مساعد صحي ذكي متخصص في تقديم المعلومات الصحية والتغذية. '
        'أجب دائماً باللغة العربية بطريقة ودية ومفيدة ودقيقة. '
        'ركز على النصائح الصحية العلمية والمثبتة. '
        'إذا كان السؤال خارج نطاق الصحة، أعد توجيه المحادثة بلطف نحو المواضيع الصحية. '
        'كن دقيقاً في المعلومات الطبية ولكن لا تشخص أو تصف أدوية.'
      ),
    );

    _chatSession = _model.startChat();
    _isInitialized = true;
  }

  Future<String> sendMessage(String message) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      return response.text ?? 'عذراً، لم أتمكن من فهم سؤالك. يرجى إعادة الصياغة.';
    } catch (e) {
      return 'عذراً، حدث خطأ في الاتصال بالخدمة. يرجى التأكد من صحة مفتاح API أو المحاولة لاحقاً.';
    }
  }

  Future<void> clearChatHistory() async {
    if (_isInitialized) {
      // Note: Gemini doesn't have a direct clear method, but we can reinitialize
      await initialize();
    }
  }

  bool get isInitialized => _isInitialized;
}
