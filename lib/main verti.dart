import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Queue Display',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QueueDisplayScreen(),
    );
  }
}

class QueueDisplayScreen extends StatefulWidget {
  @override
  _QueueDisplayScreenState createState() => _QueueDisplayScreenState();
}

class _QueueDisplayScreenState extends State<QueueDisplayScreen> {
  bool isSingleRow = true;

  void toggleDisplay() {
    setState(() {
      isSingleRow = !isSingleRow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Queue Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSingleRow)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('000')],
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) => Text('000')),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleDisplay,
              child: Text('Toggle Display'),
            ),
          ],
        ),
      ),
    );
  }
}
