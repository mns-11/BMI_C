import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart' as toast;
import 'chat.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return toast.OKToast(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ******* تم تعريف الدالة هنا *******
  //لتفعيل المكتبه لابد من استدعاء بالبكج الخاص فيها من  موقع pub.dev
  //اسم البكج oktoast
  void showCustomToast() {
    toast.showToast(
      'This is a toast message',
      duration: const Duration(seconds: 3),
      position: toast.ToastPosition.center,
      backgroundColor: Colors.teal[400],
      radius: 18.0,
      textStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
    );
  }

  @override // لا تنس إضافة @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Toast Example'),
      ),
      // ... (بقية الـ Scaffold) ...
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        onPressed: () {
          toast.showToast(
            "hello styled toast",
            position: toast.ToastPosition.center,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.teal,
            textStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            radius: 10.0,
            context: context,
          );

          // showCustomToast();
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => const ChatScreen()),
          // );
        },
        child: Icon(Icons.add),
      ),

      body: null,
    );
  }
}
