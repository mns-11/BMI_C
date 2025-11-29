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
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 5), (a) => a),
      builder: (ctx, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,

            title: Text(
              snapshot.hasData && snapshot.data! <= 10
                  ? "${snapshot.data.toString()}"
                  : "Loading...",
            ),
          ),
          body: Padding(
            padding: EdgeInsetsGeometry.only(right: 30, left: 30),
            child: Center(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? CircularProgressIndicator()
                  : Image.asset(
                      'assets/images/Gemini_Generated_Image_2sa8dq2sa8dq2sa8.png',
                    ),
            ),
          ),
        );
      },
    );
  }
}
