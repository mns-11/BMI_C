import 'package:flutter/material.dart';
import 'package:app_1/features/health_chat/data/repositories/ai_repository_impl.dart';

class VoiceAssistantChatPage extends StatefulWidget {
  const VoiceAssistantChatPage({super.key});

  @override
  State<VoiceAssistantChatPage> createState() => _VoiceAssistantChatPageState();
}

class _VoiceAssistantChatPageState extends State<VoiceAssistantChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  late final AiRepositoryImpl _aiRepository;

  // الأسئلة الشائعة والإجابات المُعدة مسبقاً (شاملة)
  final Map<String, String> _predefinedQuestions = {
    // أسئلة BMI الأساسية
    'ما هو مؤشر كتلة الجسم؟': 'مؤشر كتلة الجسم (BMI) هو قياس يستخدم لتقييم ما إذا كان وزن الشخص مناسب للطول. يُحسب بقسمة الوزن بالكيلوغرام على مربع الطول بالمتر. BMI = الوزن (كجم) ÷ (الطول بالمتر)²',
    'كيف أحسب BMI؟': 'للحصول على مؤشر كتلة الجسم، استخدم الآلة الحاسبة في التطبيق. أدخل وزنك بالكيلوغرام وطولك بالسنتيمتر، وسيتم حساب BMI تلقائياً. يمكنك أيضاً الحساب يدوياً: الوزن ÷ (الطول بالمتر)²',
    'ما هي الفئات حسب BMI؟': '• أقل من 18.5: نقص في الوزن (Underweight)\n• 18.5 - 24.9: وزن طبيعي (Normal)\n• 25 - 29.9: زيادة في الوزن (Overweight)\n• 30 - 34.9: سمنة درجة أولى (Obese Class I)\n• 35 - 39.9: سمنة درجة ثانية (Obese Class II)\n• 40 أو أكثر: سمنة مفرطة (Obese Class III)',
    'كيف أحسب الوزن المثالي؟': 'الوزن المثالي حسب الطول:\n• للرجال: 50 + 2.3 × (الطول بالبوصة - 60)\n• للنساء: 45.5 + 2.3 × (الطول بالبوصة - 60)\n• أو استخدم BMI بين 18.5-24.9 كمؤشر للوزن الصحي',

    // أسئلة الرياضة والتمارين
    'كيف أحافظ على وزن صحي؟': 'للحفاظ على وزن صحي:\n• مارس الرياضة بانتظام (30 دقيقة يومياً)\n• اتبع نظام غذائي متوازن\n• اشرب 8 أكواب من الماء يومياً\n• احصل على 7-8 ساعات نوم\n• راقب وزنك أسبوعياً\n• تجنب التوتر والضغط النفسي',
    'ما هي أفضل التمارين؟': 'أفضل التمارين تشمل:\n• المشي السريع (30 دقيقة يومياً)\n• الجري أو الركض\n• السباحة (3 مرات أسبوعياً)\n• ركوب الدراجات\n• تمارين القوة (عضلات)\n• اليوغا والتأمل\n• التمارين اليومية المنزلية',
    'كم من التمارين أحتاج يومياً؟': 'يُنصح بـ 150 دقيقة من التمارين المعتدلة أو 75 دقيقة من التمارين الشديدة أسبوعياً، بالإضافة إلى:\n• تمارين القوة مرتين أسبوعياً\n• تمارين المرونة يومياً\n• المشي 10,000 خطوة يومياً',
    'ما هي أفضل أوقات التمارين؟': 'أفضل أوقات التمارين:\n• الصباح الباكر (6-8 صباحاً): لزيادة الطاقة\n• المساء (5-7 مساءً): لتخفيف التوتر\n• تجنب التمارين قبل النوم بساعتين\n• اختر الوقت المناسب لجدولك اليومي',

    // أسئلة التغذية والأكل
    'ما هي أفضل الأطعمة الصحية؟': 'أفضل الأطعمة الصحية تشمل:\n• الخضروات الطازجة (خس، طماطم، جزر، بروكلي)\n• الفواكه الطازجة (تفاح، موز، برتقال، توت)\n• الحبوب الكاملة (أرز بني، خبز أسمر)\n• البروتينات الخالية من الدهون (دجاج، سمك، بيض)\n• المكسرات والبذور (لوز، جوز، بذور الشيا)\n• الأسماك الدهنية (سلمون، تونة، ساردين)',
    'كم من الماء يجب أن أشرب؟': 'يُنصح بشرب 8 أكواب من الماء يومياً (حوالي 2 لتر). قد تحتاج كمية أكبر إذا كنت:\n• تمارس الرياضة بانتظام\n• في الطقس الحار\n• حامل أو مرضع\n• تأخذ أدوية معينة\n• تعاني من بعض الأمراض',
    'ما هي الأطعمة الممنوعة؟': 'تجنب أو قلل من:\n• الأطعمة المصنعة والمعلبة\n• المشروبات الغازية والعصائر المحلاة\n• الدهون المشبعة (زيوت مهدرجة)\n• الأملاح الزائدة (أكثر من 5 جرام يومياً)\n• السكريات المضافة (أقل من 25 جرام يومياً)\n• الوجبات السريعة والمقليات',
    'ما هي أعراض نقص الحديد؟': 'أعراض نقص الحديد تشمل:\n• الإرهاق والضعف العام\n• شحوب الوجه والبشرة\n• ضيق التنفس عند المجهود\n• تساقط الشعر\n• تشقق الأظافر وتكسرها\n• صعوبة التركيز\n• الدوخة والصداع',

    // أسئلة الفيتامينات والمعادن
    'ما هي الفيتامينات المهمة؟': 'الفيتامينات الأساسية:\n• فيتامين D: للعظام والمناعة\n• فيتامين C: للمناعة ومضاد الأكسدة\n• فيتامين B: للطاقة والأعصاب\n• فيتامين A: للبصر والجلد\n• فيتامين E: للبشرة والشعر\n• فيتامين K: للتخثر والعظام',
    'كيف أحسن مناعتي؟': 'لتحسين المناعة:\n• تناول أطعمة غنية بفيتامين C (برتقال، فلفل، بروكلي)\n• احصل على قسط كافٍ من النوم (7-8 ساعات)\n• مارس الرياضة بانتظام\n• تجنب التوتر والضغط النفسي\n• تناول الخضروات والفواكه الملونة\n• اشرب الماء بانتظام',
    'ما هي أعراض نقص فيتامين D؟': 'أعراض نقص فيتامين D:\n• آلام العظام والعضلات\n• الإرهاق والضعف\n• الاكتئاب وتقلب المزاج\n• ضعف المناعة وكثرة الإصابة بالأمراض\n• تساقط الشعر\n• بطء التئام الجروح',

    // أسئلة الصحة النفسية
    'كيف أتعامل مع التوتر؟': 'لتعامل مع التوتر:\n• مارس تمارين التنفس العميق\n• مارس الرياضة بانتظام\n• احصل على قسط كافٍ من النوم\n• تواصل مع الأصدقاء والعائلة\n• جرب التأمل أو اليوغا\n• خصص وقت للاسترخاء والهوايات\n• استشر متخصص نفسي عند الحاجة',
    'كيف أحسن نومي؟': 'لتحسين النوم:\n• حافظ على جدول نوم منتظم\n• تجنب الكافيين بعد الظهر\n• اجعل غرفة النوم مظلمة وهادئة\n• مارس الرياضة بانتظام\n• تجنب الشاشات قبل النوم بساعة\n• خذ حمام دافئ قبل النوم\n• استخدم تقنيات الاسترخاء',

    // أسئلة الصحة العامة
    'ما هي العادات الصحية اليومية؟': 'أهم العادات الصحية اليومية:\n• الاستيقاظ مبكراً والنوم باكراً\n• تناول وجبة فطور صحية\n• المشي أو الرياضة اليومية\n• شرب الماء بانتظام\n• تناول 5 حصص من الخضروات والفواكه\n• تجنب التدخين والكحول\n• فحص الوزن والضغط بانتظام',
    'كيف أقلع عن التدخين؟': 'للإقلاع عن التدخين:\n• حدد تاريخ الإقلاع\n• تخلص من السجائر والولاعات\n• اشرب الماء بدلاً من التدخين\n• مارس الرياضة لتخفيف التوتر\n• استخدم بدائل النيكوتين إذا لزم\n• اطلب الدعم من العائلة والأصدقاء\n• استشر الطبيب للأدوية المساعدة',

    // أسئلة الأمراض الشائعة
    'ما هي أعراض السكري؟': 'أعراض السكري:\n• العطش الشديد\n• كثرة التبول\n• الإرهاق والجوع المستمر\n• فقدان الوزن غير المبرر\n• بطء التئام الجروح\n• تشوش الرؤية\n• تنميل في الأطراف',
    'كيف أحمي قلبي؟': 'لحماية القلب:\n• مارس الرياضة بانتظام\n• اتبع نظام غذائي صحي قليل الملح\n• حافظ على وزن صحي\n• تجنب التدخين والكحول\n• راقب ضغط الدم والكوليسترول\n• قلل التوتر والضغط النفسي\n• احصل على فحوصات دورية',

    // أسئلة خاصة بالنساء
    'ما هي أعراض الحمل؟': 'أعراض الحمل المبكرة:\n• غياب الدورة الشهرية\n• الغثيان والقيء الصباحي\n• الإرهاق والنعاس\n• ألم في الثديين\n• كثرة التبول\n• تقلب المزاج\n• الرغبة الشديدة في بعض الأطعمة',
    'كيف أحافظ على صحة المرأة؟': 'لصحة المرأة:\n• فحوصات دورية للثدي والرحم\n• اتباع نظام غذائي متوازن\n• ممارسة الرياضة المناسبة\n• الحفاظ على وزن صحي\n• تجنب التوتر والضغط\n• أخذ المكملات الغذائية عند الحاجة\n• استشارة الطبيب بانتظام',

    // أسئلة خاصة بالرجال
    'كيف أحافظ على صحة الرجل؟': 'لصحة الرجل:\n• فحوصات دورية للبروستاتا\n• ممارسة الرياضة بانتظام\n• اتباع نظام غذائي صحي\n• الحفاظ على وزن مثالي\n• تجنب العادات الضارة\n• فحص مستويات الهرمونات\n• استشارة الطبيب عند الحاجة',

    // أسئلة الأطفال والمراهقين
    'كيف أحافظ على صحة طفلي؟': 'لصحة الأطفال:\n• التطعيمات الدورية\n• نظام غذائي متوازن\n• النشاط البدني اليومي\n• النوم الكافي حسب العمر\n• النظافة الشخصية\n• الرعاية النفسية والعاطفية\n• متابعة النمو والتطور',
  };

  @override
  void initState() {
    super.initState();
    _aiRepository = AiRepositoryImpl();
    _initializeAiService();
    _addWelcomeMessage();
  }

  Future<void> _initializeAiService() async {
    try {
      await _aiRepository.initializeAi();
    } catch (e) {
      // AI service initialization failed, but we can continue with predefined answers
      // AI service initialization failed, but we can continue with predefined answers
    }
  }

  void _addWelcomeMessage() {
    _addMessage('مرحباً! أنا مساعدك الصحي الذكي الشامل. يمكنني:\n• الإجابة على 22 سؤال شائع بسرعة فائقة\n• تقديم نصائح مفصلة في جميع المجالات الصحية\n• العمل كمساعد ذكي متكامل بالذكاء الاصطناعي (بعد إضافة مفتاح API)\n\n📋 **الأسئلة المتاحة:**\n• أسئلة BMI والوزن\n• التمارين والرياضة\n• التغذية والأكل الصحي\n• الفيتامينات والمعادن\n• الصحة النفسية والتوتر\n• الأمراض الشائعة والوقاية\n• الصحة الخاصة بالنساء والرجال\n• صحة الأطفال والمراهقين\n\n💡 **نصيحة:** للحصول على إجابات ذكية من الذكاء الاصطناعي، أضف مفتاح Google AI API في ملف .env\n\nاسألني أي سؤال صحي وسأجيب عليه! 🤖✨', false);
  }

  void _addMessage(String content, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(
        content: content,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _addMessage(text, true);

    // تشغيل مؤشر التقدم
    setState(() {
      _isTyping = true;
    });

    // البحث عن إجابة مُعدة مسبقاً
    String? predefinedAnswer = _findPredefinedAnswer(text);
    if (predefinedAnswer != null) {
      // إجابة سريعة من قاعدة البيانات المعدة مسبقاً
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isTyping = false;
        });
        _addMessage(predefinedAnswer, false);
      });
    } else {
      // استخدام الذكاء الاصطناعي للأسئلة الجديدة
      _getAiResponse(text);
    }

    _textController.clear();
  }

  Future<void> _getAiResponse(String question) async {
    // Check if AI service is available
    if (_aiRepository.isAiAvailable) {
      try {
        String aiResponse = await _aiRepository.sendMessageToAi(question);

        setState(() {
          _isTyping = false;
        });

        _addMessage(aiResponse, false);
      } catch (e) {
        setState(() {
          _isTyping = false;
        });

        _addMessage('عذراً، حدث خطأ في الاتصال بالخدمة الذكية. يرجى التأكد من صحة مفتاح API أو المحاولة لاحقاً. يمكنك تجربة الأسئلة الشائعة المتاحة في قائمة ❓', false);
      }
    } else {
      // AI service not available, provide helpful fallback
      setState(() {
        _isTyping = false;
      });

      _addMessage('🤖 للحصول على إجابات ذكية من الذكاء الاصطناعي، يرجى إضافة مفتاح Google AI API في ملف .env\n\nفي الوقت الحالي، يمكنك تجربة الأسئلة الشائعة المتاحة في قائمة ❓ للحصول على إجابات فورية ومفيدة!\n\nالأسئلة المتاحة تشمل:\n• أسئلة BMI والوزن\n• التمارين والرياضة\n• التغذية والأكل الصحي\n• الفيتامينات والمعادن\n• الصحة النفسية\n• الأمراض والوقاية\n• صحة العائلة', false);
    }
  }

  String? _findPredefinedAnswer(String question) {
    String lowerQuestion = question.toLowerCase().trim();

    // البحث عن تطابق تام أولاً
    for (var entry in _predefinedQuestions.entries) {
      if (lowerQuestion.contains(entry.key.toLowerCase()) ||
          entry.key.toLowerCase().contains(lowerQuestion)) {
        return entry.value;
      }
    }

    // البحث الذكي عن كلمات مفتاحية
    if (lowerQuestion.contains('وزن') || lowerQuestion.contains('بي ام اي') || lowerQuestion.contains('bmi') ||
        lowerQuestion.contains('كتلة') || lowerQuestion.contains('مثالي')) {
      return _predefinedQuestions['ما هو مؤشر كتلة الجسم؟'];
    }

    if (lowerQuestion.contains('رياضة') || lowerQuestion.contains('تمارين') || lowerQuestion.contains('تمرين') ||
        lowerQuestion.contains('رياضي') || lowerQuestion.contains('مشي') || lowerQuestion.contains('جري')) {
      return _predefinedQuestions['ما هي أفضل التمارين؟'];
    }

    if (lowerQuestion.contains('طعام') || lowerQuestion.contains('أكل') || lowerQuestion.contains('غذاء') ||
        lowerQuestion.contains('وجبة') || lowerQuestion.contains('فواكه') || lowerQuestion.contains('خضروات')) {
      return _predefinedQuestions['ما هي أفضل الأطعمة الصحية؟'];
    }

    if (lowerQuestion.contains('ماء') || lowerQuestion.contains('سوائل') || lowerQuestion.contains('شرب') ||
        lowerQuestion.contains('عطش') || lowerQuestion.contains('ترطيب')) {
      return _predefinedQuestions['كم من الماء يجب أن أشرب؟'];
    }

    if (lowerQuestion.contains('حديد') || lowerQuestion.contains('أنيميا') || lowerQuestion.contains('دم') ||
        lowerQuestion.contains('شحوب') || lowerQuestion.contains('إرهاق')) {
      return _predefinedQuestions['ما هي أعراض نقص الحديد؟'];
    }

    if (lowerQuestion.contains('فيتامين') || lowerQuestion.contains('معدن') || lowerQuestion.contains('مكمل')) {
      return _predefinedQuestions['ما هي الفيتامينات المهمة؟'];
    }

    if (lowerQuestion.contains('مناعة') || lowerQuestion.contains('جهاز') || lowerQuestion.contains('مرض')) {
      return _predefinedQuestions['كيف أحسن مناعتي؟'];
    }

    if (lowerQuestion.contains('توتر') || lowerQuestion.contains('ضغط') || lowerQuestion.contains('عصبي') ||
        lowerQuestion.contains('قلق') || lowerQuestion.contains('اكتئاب')) {
      return _predefinedQuestions['كيف أتعامل مع التوتر؟'];
    }

    if (lowerQuestion.contains('نوم') || lowerQuestion.contains('راحة') || lowerQuestion.contains('استرخاء') ||
        lowerQuestion.contains('نعاس') || lowerQuestion.contains('أرق')) {
      return _predefinedQuestions['كيف أحسن نومي؟'];
    }

    if (lowerQuestion.contains('سكري') || lowerQuestion.contains('سكر') || lowerQuestion.contains('أنسولين')) {
      return _predefinedQuestions['ما هي أعراض السكري؟'];
    }

    if (lowerQuestion.contains('قلب') || lowerQuestion.contains('ضغط دم') || lowerQuestion.contains('كوليسترول')) {
      return _predefinedQuestions['كيف أحمي قلبي؟'];
    }

    if (lowerQuestion.contains('حمل') || lowerQuestion.contains('حامل') || lowerQuestion.contains('جنين')) {
      return _predefinedQuestions['ما هي أعراض الحمل؟'];
    }

    if (lowerQuestion.contains('طفل') || lowerQuestion.contains('أطفال') || lowerQuestion.contains('مراهق')) {
      return _predefinedQuestions['كيف أحافظ على صحة طفلي؟'];
    }

    if (lowerQuestion.contains('تدخين') || lowerQuestion.contains('سيجارة') || lowerQuestion.contains('إقلاع')) {
      return _predefinedQuestions['كيف أقلع عن التدخين؟'];
    }

    return null;
  }

  void _showPredefinedQuestions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأسئلة الشائعة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _predefinedQuestions.length,
                itemBuilder: (context, index) {
                  String question = _predefinedQuestions.keys.elementAt(index);
                  return ListTile(
                    title: Text(
                      question,
                      style: const TextStyle(fontSize: 16),
                    ),
                    leading: const Icon(Icons.question_answer, color: Colors.teal),
                    onTap: () {
                      Navigator.pop(context);
                      _sendMessage(question);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل أنت متأكد من أنك تريد مسح جميع الرسائل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _isTyping = false;
                _addWelcomeMessage();
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح المحادثة'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            child: const Text('مسح', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد الصحي الذكي الشامل'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.question_answer),
            onPressed: _showPredefinedQuestions,
            tooltip: 'الأسئلة الشائعة',
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('المساعد الصوتي قيد التطوير...'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            tooltip: 'المساعد الصوتي',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _messages.length > 1 ? _clearChat : null,
            tooltip: 'مسح المحادثة',
          ),
        ],
      ),
      body: Column(
        children: [
          // مؤشر التقدم أثناء التفكير
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isTyping ? 3 : 0,
            color: Colors.teal.withValues(alpha: 0.1),
            child: const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          ),

          // رسائل المحادثة
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // منطقة إدخال النص
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'اكتب أي سؤال صحي هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _sendMessage(_textController.text),
                  mini: true,
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.teal.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}
