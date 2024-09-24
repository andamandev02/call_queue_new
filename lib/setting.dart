import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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

  bool ImageSlide = false;

  List<String> folderNamesSelectModeSounds = [];
  // List<List<String?>> selectedFoldersModeSoundsList = [[]];
  List<Map<String, dynamic>> selectedFoldersModeSoundsList = [];

  @override
  void initState() {
    super.initState();
    loadDataFromHive();
    loadDirectories();
    loadModeSounds();

    BackgroundColorController.text =
        selectedColorToString(selectedBackgroundColor);
    TextColorController.text = selectedColorToString(selectedTextColor);
    TextBlinkColorController.text =
        selectedColorToString(selectedTextBlinkColor);
  }

  Future<void> loadDirectories() async {
    String assetsPath = 'assets/sounds/';
    Directory directory = Directory(assetsPath);
    List<FileSystemEntity> entities = directory.listSync();
    folderNamesSelectModeSounds = entities
        .whereType<Directory>()
        .map((entity) => entity.path.split('/').last)
        .toList();
    setState(() {});
  }

  void _addDropdown() {
    setState(() {
      selectedFoldersModeSoundsList.add({
        'folders': <String>[],
        'selected': false,
      });
    });
  }

  void _deleteDropdown(int index) {
    setState(() {
      selectedFoldersModeSoundsList.removeAt(index);
    });
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

    var ImageSlideBox = await Hive.openBox('ImageSlideBoxChecked');
    bool? ImageSlideBoxString = ImageSlideBox.get('ImageSlideBoxChecked');
    setState(() {
      ImageSlide = ImageSlideBoxString!;
    });
  }

  Future<void> loadModeSounds() async {
    var modeSoundsBox = await Hive.openBox('ModeSounds');
    final List? storedList = modeSoundsBox.get('ModeSounds') as List?;
    if (storedList != null) {
      setState(() {
        selectedFoldersModeSoundsList = storedList.map((item) {
          final Map<String, dynamic> castedItem =
              Map<String, dynamic>.from(item);
          return {
            'folders': List<String>.from(castedItem['folders']),
            'selected': castedItem['selected'],
          };
        }).toList();
      });
    }
    print(selectedFoldersModeSoundsList);
    await modeSoundsBox.close();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การตั้งค่า'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ป้อนจำนวนหลักคิว'),
              TextField(
                controller: DigitController,
                onChanged: (value) {
                  digits = int.tryParse(value) ?? digits;
                },
                decoration: const InputDecoration(
                  labelText: 'Digits',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text('เลือกสีที่พื้นหลัง'),
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
              Text('เลือกสีข้อความ'),
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
              Text('เลือกสีข้อความกระพริบ'),
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
              SizedBox(height: 20),
              Text('ตั้งค่า Mode Sounds'),
              ElevatedButton(
                onPressed: _addDropdown,
                child: const Text('Add Dropdown'),
              ),
              ...selectedFoldersModeSoundsList.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> dropdownData = entry.value;
                List<String> selectedFolders =
                    List<String>.from(dropdownData['folders']);
                return buildDropdownAndCheckbox(
                    index, dropdownData, selectedFolders);
              }).toList(),
              SizedBox(height: 20),
              Text('ทำการเพิ่ม slid image'),
              Checkbox(
                value: ImageSlide,
                onChanged: (value) {
                  setState(() {
                    ImageSlide = value!;
                  });
                },
              ),
              if (ImageSlide)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          // controller: digitController,
                          decoration: InputDecoration(
                            labelText: 'กำหนดชื่อ USB',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          // controller: digitController,
                          decoration: InputDecoration(
                            labelText: 'กำหนดที่เก็บไฟล์ภาพ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          // controller: digitController,
                          decoration: InputDecoration(
                            labelText: 'กำหนดความเร็วในการเลื่อนภาพ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          // controller: digitController,
                          decoration: InputDecoration(
                            labelText: 'กำหนดขอบเขตรูปภาพ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          // controller: digitController,
                          decoration: InputDecoration(
                            labelText: 'กำหนดสีพื้นหลังรูปภาพ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var box = await Hive.openBox('Digit');
                  await box.put('Digit', digits);

                  var BackgroundcolorBox =
                      await Hive.openBox('BackgroundColor');
                  await BackgroundcolorBox.put('BackgroundColor',
                      selectedColorToString(selectedBackgroundColor));

                  var TextcolorBox = await Hive.openBox('TextColor');
                  await TextcolorBox.put(
                      'TextColor', selectedColorToString(selectedTextColor));

                  var TextBlinkcolorBox = await Hive.openBox('TextBlinkColor');
                  await TextBlinkcolorBox.put('TextBlinkColor',
                      selectedColorToString(selectedTextBlinkColor));

                  var ImageSlideBox =
                      await Hive.openBox('ImageSlideBoxChecked');
                  await ImageSlideBox.put('ImageSlideBoxChecked', ImageSlide);

                  var ModeSoundsBox = await Hive.openBox('ModeSounds');
                  List<Map<String, dynamic>> formattedList =
                      selectedFoldersModeSoundsList.map((dropdownData) {
                    return {
                      'folders': List<String>.from(dropdownData['folders']),
                      'selected': dropdownData['selected'],
                    };
                  }).toList();
                  await ModeSoundsBox.put('ModeSounds', formattedList);

                  await box.close();
                  await BackgroundcolorBox.close();
                  await TextcolorBox.close();
                  await TextBlinkcolorBox.close();
                  await ImageSlideBox.close();
                  await ModeSoundsBox.close();
                  await loadDataFromHive();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownAndCheckbox(int index, Map<String, dynamic> dropdownData,
      List<String> selectedFolders) {
    bool isSelected = dropdownData['selected'];
    String? dropdownValue =
        selectedFolders.isEmpty ? null : selectedFolders.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    dropdownData['selected'] = value!;
                  });
                },
              ),
              DropdownButton<String>(
                value: dropdownValue,
                items: folderNamesSelectModeSounds
                    .map((dir) => DropdownMenuItem(
                          value: dir,
                          child: Text(dir),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null && !selectedFolders.contains(value)) {
                    setState(() {
                      selectedFolders.add(value);
                      dropdownData['folders'] = selectedFolders;
                    });
                  }
                },
                hint: Text('Select a folder'),
              ),
            ],
          ),
        ),
        // Show selected folders
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedFolders
              .asMap()
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Dropdown ${index + 1}, Selected Folder ${entry.key + 1}: ${entry.value}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
        ),
        ElevatedButton(
          onPressed: () => _deleteDropdown(index),
          child: Text('Delete Dropdown'),
        ),
      ],
    );
  }
}
