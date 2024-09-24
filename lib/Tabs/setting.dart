import 'package:call_queue_new/Tabs/SettingImportSound.dart';
import 'package:call_queue_new/Tabs/setting-modesound.dart';
import 'package:call_queue_new/Tabs/setting-queue.dart';
import 'package:call_queue_new/Tabs/setting-slide.dart';
import 'package:call_queue_new/Tabs/setting-theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('การตั้งค่าโหมดเสียง'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'ตั้งค่าจัดการพื้นฐาน'),
              Tab(text: 'ตั้งค่าโหมดเสียง'),
              Tab(text: 'ตั้งค่ารูปภาพสไลด์'),
              Tab(text: 'ตั้งค่ารูปแบบหน้าจอ'),
              Tab(text: 'นำเข้าไฟล์เสียง'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  SettingsQueueTab(),
                  SettingsModeSoundTab(),
                  SettingsSlideTab(),
                  SettingThemeTab(),
                  SettingImportSoundTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int digits = 3;
  final TextEditingController DigitController = TextEditingController();

  Color selectedBackgroundColor = Colors.black;
  final TextEditingController BackgroundColorController =
      TextEditingController();

  Color selectedTextColor = Colors.white;
  final TextEditingController TextColorController = TextEditingController();

  Color selectedTextBlinkColor = Colors.yellow;
  final TextEditingController TextBlinkColorController =
      TextEditingController();

  String selectedColorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Future<void> loadDataFromHive() async {
    var box = await Hive.openBox('Digit');
    digits = box.get('Digit', defaultValue: 3);
    DigitController.text = digits.toString();

    var backgroundcolorBox = await Hive.openBox('BackgroundColor');
    String? BackgroundcolorString = backgroundcolorBox.get('BackgroundColor');
    if (BackgroundcolorString != null) {
      setState(() {
        selectedBackgroundColor =
            Color(int.parse(BackgroundcolorString.substring(1), radix: 16));
        BackgroundColorController.text =
            selectedColorToString(selectedBackgroundColor);
      });
    }

    var TextcolorBox = await Hive.openBox('TextColor');
    String? TextcolorString = TextcolorBox.get('TextColor');
    if (TextcolorString != null) {
      setState(() {
        selectedTextColor =
            Color(int.parse(TextcolorString.substring(1), radix: 16));
        TextColorController.text = selectedColorToString(selectedTextColor);
      });
    }

    var TextBlinkcolorBox = await Hive.openBox('TextBlinkColor');
    String? TextBlinkcolorString = TextBlinkcolorBox.get('TextBlinkColor');
    if (TextBlinkcolorString != null) {
      setState(() {
        selectedTextBlinkColor =
            Color(int.parse(TextBlinkcolorString.substring(1), radix: 16));
        TextBlinkColorController.text =
            selectedColorToString(selectedTextBlinkColor);
      });
    }
  }
}
