import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsModeSoundTab extends StatefulWidget {
  @override
  _SettingsModeSoundTabState createState() => _SettingsModeSoundTabState();
}

class _SettingsModeSoundTabState extends State<SettingsModeSoundTab> {
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: ElevatedButton(
                  onPressed: _addDropdown,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.maxFinite, 10),
                  ),
                  child: Text(
                    'เพิ่มโหมดเสียง',
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ...selectedFoldersModeSoundsList.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> dropdownData = entry.value;
                List<String> selectedFolders =
                    List<String>.from(dropdownData['folders']);
                return buildDropdownAndCheckbox(
                    index, dropdownData, selectedFolders);
              }).toList(),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var ModeSoundsBox = await Hive.openBox('ModeSounds');
                      List<Map<String, dynamic>> formattedList =
                          selectedFoldersModeSoundsList.map((dropdownData) {
                        return {
                          'folders': List<String>.from(dropdownData['folders']),
                          'selected': dropdownData['selected'],
                        };
                      }).toList();
                      await ModeSoundsBox.put('ModeSounds', formattedList);
                      await ModeSoundsBox.close();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'บันทึกการตั้งค่าโหมดเสียง',
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

  List<String> folderNamesSelectModeSounds = [];
  // List<List<String?>> selectedFoldersModeSoundsList = [[]];
  List<Map<String, dynamic>> selectedFoldersModeSoundsList = [];

  @override
  void initState() {
    super.initState();
    loadModeSounds();
    loadDirectories();
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

  Widget buildDropdownAndCheckbox(int index, Map<String, dynamic> dropdownData,
      List<String> selectedFolders) {
    bool isSelected = dropdownData['selected'];
    String? dropdownValue =
        selectedFolders.isEmpty ? null : selectedFolders.last;
    final Size screenSize = MediaQuery.of(context).size;
    final double baseFontSize = screenSize.height * 0.05;
    final double fontSize = baseFontSize * 0.8;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Transform.scale(
                scale: 2, // ปรับขนาดของ Checkbox
                child: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      dropdownData['selected'] = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    items: folderNamesSelectModeSounds
                        .map((dir) => DropdownMenuItem(
                              value: dir,
                              child: Text(
                                dir,
                                style: TextStyle(fontSize: fontSize),
                              ),
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
                    hint: Text(
                      'เลือกภาษา',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        // Show selected folders
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: selectedFolders
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Mode  ${index + 1} => รายการเสียงลำดับที่  ${entry.key + 1} : ${entry.value}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: fontSize),
                        ),
                      ))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: () => _deleteDropdown(index),
              child: Text(
                'ลบ Mode',
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 0, 0), // สีเขียว
              ),
            ),
          ],
        ),
      ],
    );
  }
}
