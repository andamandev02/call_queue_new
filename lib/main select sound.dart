import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Dropdown Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> folderNames = [];
  List<List<String?>> selectedFoldersList = [[]];

  @override
  void initState() {
    super.initState();
    _loadDirectories();
  }

  Future<void> _loadDirectories() async {
    String assetsPath = 'assets/sounds/';
    Directory directory = Directory(assetsPath);
    List<FileSystemEntity> entities = directory.listSync();
    folderNames = entities
        .whereType<Directory>()
        .map((entity) => entity.path.split('/').last)
        .toList();
    setState(() {});
  }

  void _addDropdown() {
    setState(() {
      selectedFoldersList.add([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Dropdown Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: _addDropdown,
            child: Text('Add Dropdown'),
          ),
          ...selectedFoldersList.asMap().entries.map((entry) {
            int index = entry.key;
            List<String?> selectedFolders = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value:
                        selectedFolders.isEmpty ? null : selectedFolders.last,
                    items: folderNames
                        .map((dir) => DropdownMenuItem(
                              value: dir,
                              child: Text(dir),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFolders.add(value);
                      });
                    },
                    hint: Text('Select a folder'),
                  ),
                ),
                // Show selected folders
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedFolders
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Dropdown ${index + 1}, Selected Folder ${entry.key + 1}: ${entry.value}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
