import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/bmi/data/repositories/bmi_repository_impl.dart';
import 'features/bmi/domain/repositories/bmi_repository.dart';
import 'features/bmi/presentation/pages/home_page.dart';
import 'features/health_chat/presentation/pages/voice_assistant_chat_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<BmiRepository>(
          create: (context) => BmiRepositoryImpl(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health & Nutrition Assistant',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.black87,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 90),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const VoiceAssistantChatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'BMI Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Health Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
