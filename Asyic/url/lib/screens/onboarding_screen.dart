import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Method to mark onboarding as completed
  _markOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
  }

  // Navigate to home screen
  _navigateToHome() {
    _markOnboardingCompleted();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
                _isLastPage = page == 2;
              });
            },
            children: [
              // Page 1: Welcome
              _buildPage(
                Icons.menu_book,
                'أهلا بك في تطبيق المكتبة الإسلامية',
                'مرحباً بك في تطبيق المكتبة الإسلامية، منصة شاملة لجميع المصادر الإسلامية',
                false,
              ),
              // Page 2: Dedication
              _buildDedicationPage(),
              // Page 3: Logo and Start
              _buildPage(
                null, // No icon for this page
                '', // No title for this page
                '', // No description for this page
                true, // Last page
              ),
            ],
          ),
          // Skip button (only visible before the last page)
          if (_currentPage < 2)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: _navigateToHome,
                child: Text(
                  'تخطي',
                  style: TextStyle(
                    color: Color(0xFF1967D2),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          // Page indicators
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Color(0xFF1967D2)
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Navigation buttons
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button (only visible after page 1 and not on last page)
                if (_currentPage > 0 && _currentPage < 2)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'رجوع',
                      style: TextStyle(
                        color: Color(0xFF1967D2),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(), // Empty container for spacing
                // Next/Start button
                ElevatedButton(
                  onPressed: _isLastPage
                      ? _navigateToHome
                      : () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1967D2),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Icon(
                    _isLastPage ? Icons.check : Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build standard onboarding page
  Widget _buildPage(
    IconData? icon,
    String title,
    String description,
    bool isLastPage,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 100, color: Color(0xFF1967D2)),
          if (icon != null) SizedBox(height: 30),
          if (title.isNotEmpty)
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1967D2),
              ),
              textAlign: TextAlign.center,
            ),
          if (title.isNotEmpty) SizedBox(height: 20),
          if (description.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
          if (isLastPage) SizedBox(height: 30),
          if (isLastPage)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1967D2),
              ),
              child: Icon(Icons.menu_book, size: 80, color: Colors.white),
            ),
          if (isLastPage) SizedBox(height: 30),
          if (isLastPage)
            // Add a start button on the last page
            if (isLastPage) SizedBox(height: 10),
          if (isLastPage)
            ElevatedButton(
              onPressed: _navigateToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1967D2),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'ابدأ الآن',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build dedication page with content positioned between skip button and page indicators
  Widget _buildDedicationPage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // This empty space pushes content down from the top
          SizedBox(height: 100), // Space for skip button area
          // Main content area - centered between skip button and indicators
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 100, color: Color(0xFF1967D2)),
                  SizedBox(height: 30),
                  Text(
                    'إهداء',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1967D2),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        '''
صفحة الإهداء والوقف الخيري
صدقة جارية ممتدة

بسم الله الرحمن الرحيم
الحمد لله رب العالمين، والصلاة والسلام على أشرف الأنبياء والمرسلين.

هذا العمل المبارك وقفٌ خالصٌ لوجه الله تعالى منّي منصور أحمد باسلَمه، وعن أهلي وإخواني جميعاً، الأحياء منهم والأموات، راجياً لهم المغفرة والرحمة والتوفيق والسداد.

نخص بالدعاء والثواب الجاري:

المرحوم: جدي عبيد عمر باربود
المرحوم: صديقي فهد العرادي
المرحوم: عبدالله أبو بكر باعثمان
المرحومة: رحمه الهميمي

دعاء الختام
اللهم تقبّل منّا هذا العمل واجعله صدقة جارية في صحائف كل من شارك فيه، وكل من انتفع به.
اللهم آنس وحشة أمواتنا، ونوّر قبورهم، واغفر لهم، وارفع درجتهم، واجمعنا بهم في جنات النعيم يا رب العالمين.

وقف لله تعالى
هذا التطبيق، بما يحمله من علم شرعي، هو وقفٌ لله تعالى.
نسأل الله أن يجعله من العلم الذي يُنتفع به، وأن يجعله خالصاً لوجهه الكريم.
يا رب العالمين، آمين.
''',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Space above page indicators
          SizedBox(height: 120), // Space for navigation buttons area
        ],
      ),
    );
  }
}
