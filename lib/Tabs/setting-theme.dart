import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingThemeTab extends StatefulWidget {
  @override
  _SettingThemeTabState createState() => _SettingThemeTabState();
}

class _SettingThemeTabState extends State<SettingThemeTab> {
  final TextEditingController CountRowController = TextEditingController();
  int? countrownum;
  bool CountRow = false;

  @override
  void initState() {
    super.initState();
    loadDataFromHive();
  }

  Future<void> loadDataFromHive() async {
    var CountRowBox = await Hive.openBox('CountRowBoxChecked');
    bool? CountRowBoxChecked = CountRowBox.get('CountRowBoxChecked');
    int? CountRowValue = CountRowBox.get('CountRow');

    setState(() {
      CountRow = CountRowBoxChecked ?? false;
      countrownum = CountRowValue ?? 1;
      CountRowController.text = countrownum.toString();
    });

    await CountRowBox.close();
  }

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
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var CountRowBox = await Hive.openBox('CountRowBoxChecked');
                    await CountRowBox.put('CountRowBoxChecked', CountRow);
                    await CountRowBox.put('CountRow', countrownum);
                    await CountRowBox.close();
                    await loadDataFromHive();
                  },
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
            ],
          ),
        ),
      ),
    );
  }
}
