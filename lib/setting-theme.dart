import 'package:flutter/material.dart';

class SettingThemeTab extends StatefulWidget {
  @override
  _SettingThemeTabState createState() => _SettingThemeTabState();
}

class _SettingThemeTabState extends State<SettingThemeTab> {
  final TextEditingController CountRowController = TextEditingController();
  int? countrownum;
  bool CountRow = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseFontSize = screenSize.height * 0.05;
    final double fontSize = baseFontSize * 0.8;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'กำหนดจำนวนแถว',
                style: TextStyle(fontSize: fontSize),
              ),
              SizedBox(
                height: 20,
              ),
              Transform.scale(
                scale: 2,
                child: Checkbox(
                  value: CountRow,
                  onChanged: (value) {
                    setState(() {
                      CountRow = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (CountRow)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: CountRowController,
                        onChanged: (value) {
                          countrownum = int.tryParse(value) ?? countrownum;
                        },
                        decoration: const InputDecoration(
                          labelText: 'จำนวนแถว',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'บันทึกการตั้งค่า รูปแบบหน้าจอ',
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
