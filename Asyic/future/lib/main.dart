import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<String>(
        future: Future.delayed(const Duration(seconds: 5), () => "mansoor"),
        builder: (ctx, snapshot) {
          final title = () {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return 'Loading...';
            }
            if (snapshot.hasError) {
              return 'Error';
            }
            if (snapshot.hasData) {
              return '${snapshot.data}';
            }
            return 'No data';
          }();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 50, 174, 223),

              title: Text(title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/5b42767f-2189-4ee6-ae18-831c079f8cf3 2.JPG',
                          ),
                          const SizedBox(height: 16),
                          AnimatedOpacity(
                            opacity:
                                snapshot.connectionState == ConnectionState.done
                                ? 1
                                : 0,
                            duration: const Duration(milliseconds: 600),
                            child: const Text(
                              'mansoor',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
