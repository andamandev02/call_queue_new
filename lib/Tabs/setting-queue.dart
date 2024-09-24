import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

class SettingsQueueTab extends StatefulWidget {
  @override
  _SettingsQueueTabState createState() => _SettingsQueueTabState();
}

class _SettingsQueueTabState extends State<SettingsQueueTab> {
  int digits = 3;
  int? sizesqueue;

  final TextEditingController DigitController = TextEditingController();
  final TextEditingController SizeQueueController = TextEditingController();

  Color selectedBackgroundColor = Colors.black;
  final TextEditingController BackgroundColorController =
      TextEditingController();

  Color selectedTextColor = Colors.white;
  final TextEditingController TextColorController = TextEditingController();

  Color selectedTextBlinkColor = Colors.yellow;
  final TextEditingController TextBlinkColorController =
      TextEditingController();

  void BackgroundchangeColor(Color color) {
    setState(() {
      selectedBackgroundColor = color;
      BackgroundColorController.text = selectedColorToString(color);
    });
  }

  void TextchangeColor(Color color) {
    setState(() {
      selectedTextColor = color;
      TextColorController.text = selectedColorToString(color);
    });
  }

  void TextBlinkchangeColor(Color color) {
    setState(() {
      selectedTextBlinkColor = color;
      TextBlinkColorController.text = selectedColorToString(color);
    });
  }

  String selectedColorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  @override
  void initState() {
    super.initState();
    loadDataFromHive();

    BackgroundColorController.text =
        selectedColorToString(selectedBackgroundColor);
    TextColorController.text = selectedColorToString(selectedTextColor);
    TextBlinkColorController.text =
        selectedColorToString(selectedTextBlinkColor);
  }

  Future<void> loadDataFromHive() async {
    var box = await Hive.openBox('Digit');
    digits = box.get('Digit', defaultValue: 3);
    sizesqueue = box.get(
      'SizeQueue',
    );
    DigitController.text = digits.toString();
    SizeQueueController.text = sizesqueue.toString();

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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseFontSize = screenSize.height * 0.05;
    final double fontSize = baseFontSize * 0.5;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ป้อนจำนวนหลักคิว',
                style: TextStyle(fontSize: fontSize),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: DigitController,
                      onChanged: (value) {
                        digits = int.tryParse(value) ?? digits;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Digits',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: SizeQueueController,
                      onChanged: (value) {
                        sizesqueue = int.tryParse(value) ?? sizesqueue;
                      },
                      decoration: const InputDecoration(
                        labelText: 'ขนาดเลขคิว',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'เลือกสีที่พื้นหลัง',
                style: TextStyle(fontSize: fontSize),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('เลือกสี'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: selectedBackgroundColor,
                                onColorChanged: BackgroundchangeColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(2.0),
                                  topRight: Radius.circular(2.0),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('เลือก'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('เลือกสี'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: BackgroundColorController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'สีที่เลือก',
                        prefixIcon: Container(
                          width: 40,
                          height: 40,
                          color: selectedBackgroundColor,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'เลือกสีข้อความ',
                style: TextStyle(fontSize: fontSize),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('เลือกสีข้อความ'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: selectedTextColor,
                                onColorChanged: TextchangeColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(2.0),
                                  topRight: Radius.circular(2.0),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('เลือก'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('เลือกสีข้อความ'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: TextColorController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'ข้อความของสีที่เลือก',
                        prefixIcon: Container(
                          width: 40,
                          height: 40,
                          color: selectedTextColor,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'เลือกสีข้อความกระพริบ',
                style: TextStyle(fontSize: fontSize),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('เลือกสีข้อความกระพริบ'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: selectedTextBlinkColor,
                                onColorChanged: TextBlinkchangeColor,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(2.0),
                                  topRight: Radius.circular(2.0),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('เลือก'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('เลือกสีข้อความกระพริบ'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: TextBlinkColorController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'ข้อความกระพริบของสีที่เลือก',
                        prefixIcon: Container(
                          width: 40,
                          height: 40,
                          color: selectedTextBlinkColor,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var box = await Hive.openBox('Digit');
                      await box.put('Digit', digits);
                      await box.put('SizeQueue', sizesqueue);

                      var BackgroundcolorBox =
                          await Hive.openBox('BackgroundColor');
                      await BackgroundcolorBox.put('BackgroundColor',
                          selectedColorToString(selectedBackgroundColor));

                      var TextcolorBox = await Hive.openBox('TextColor');
                      await TextcolorBox.put('TextColor',
                          selectedColorToString(selectedTextColor));

                      var TextBlinkcolorBox =
                          await Hive.openBox('TextBlinkColor');
                      await TextBlinkcolorBox.put('TextBlinkColor',
                          selectedColorToString(selectedTextBlinkColor));

                      await box.close();
                      await BackgroundcolorBox.close();
                      await TextcolorBox.close();
                      await TextBlinkcolorBox.close();
                      await loadDataFromHive();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'บันทึกการตั้งค่าพื้นฐาน',
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
