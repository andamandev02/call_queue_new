import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'dart:io';

class SettingsSlideTab extends StatefulWidget {
  @override
  _SettingsSlideTabState createState() => _SettingsSlideTabState();
}

class _SettingsSlideTabState extends State<SettingsSlideTab> {
  final TextEditingController _folderUSBImageController =
      TextEditingController();
  final TextEditingController _folderUSBLOGOController =
      TextEditingController();
  bool _isVisible = false; // สถานะสำหรับซ่อน/แสดง UI
  final String _correctPassword = "0641318526"; // รหัสผ่านที่ถูกต้อง

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseFontSize = screenSize.height * 0.05;
    final double fontSize = baseFontSize * 0.5;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ปุ่มไอคอนเล็ก ๆ ที่มุมซ้ายบน
            IconButton(
              icon: Icon(Icons.lock), // ใช้ไอคอนที่ต้องการ
              onPressed: () => _showPasswordDialog(context),
            ),
            // แสดง UI ตามสถานะ
            if (_isVisible)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ทำการเพิ่ม slid image',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Transform.scale(
                      scale: 2, // ปรับขนาดของ Checkbox
                      child: Checkbox(
                        value: ImageSlide,
                        onChanged: (value) {
                          setState(() {
                            ImageSlide = value!;
                          });
                        },
                      ),
                    ),
                    if (ImageSlide) // แสดง ListView เมื่อ ImageSlide เป็น true
                      SizedBox(
                        height: 200, // กำหนดความสูงให้กับ ListView
                        child: ListView.builder(
                          itemCount: _storagePaths.length,
                          itemBuilder: (context, index) {
                            final path = _storagePaths[index];
                            final folderName = path.split('/').last;

                            return ListTile(
                              title: Text(path),
                              onTap: () {
                                _navigateToImagesFolder(path);
                                _folderUSBImageController.text = path;
                              },
                            );
                          },
                        ),
                      ),
                    if (ImageSlide)
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  DropdownButton<String>(
                                    value: PositionImageSlide,
                                    hint: Text('กำหนดตำแหน่งโลโก้'),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          PositionImageSlide = newValue;
                                        });
                                      }
                                    },
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    items: <String>['ซ้าย', 'ขวา']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _folderUSBImageController,
                                    decoration: const InputDecoration(
                                      labelText: 'กำหนดชื่อ USB',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'กำหนดที่เก็บไฟล์ภาพ',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'กำหนดความเร็วในการเลื่อนภาพ',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'กำหนดขอบเขตรูปภาพ',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const TextField(
                                    decoration: InputDecoration(
                                      labelText: 'กำหนดสีพื้นหลังรูปภาพ',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Text(
                      'ทำการเพิ่ม logo',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    const SizedBox(height: 20),
                    Transform.scale(
                      scale: 2,
                      child: Checkbox(
                        value: LogoSlide,
                        onChanged: (value) {
                          setState(() {
                            LogoSlide = value!;
                          });
                        },
                      ),
                    ),
                    if (LogoSlide) // แสดง ListView เมื่อ ImageSlide เป็น true
                      SizedBox(
                        height: 200, // กำหนดความสูงให้กับ ListView
                        child: ListView.builder(
                          itemCount: _storagePaths.length,
                          itemBuilder: (context, index) {
                            final path = _storagePaths[index];
                            final folderName = path.split('/').last;

                            return ListTile(
                              title: Text(folderName),
                              onTap: () {
                                _navigateToImagesFolder(path);
                                _folderUSBLOGOController.text = folderName;
                              },
                            );
                          },
                        ),
                      ),
                    if (LogoSlide) // แสดง ListView เมื่อ ImageSlide เป็น true
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  DropdownButton<String>(
                                    value: PositionLogoSlide,
                                    hint: const Text('กำหนดตำแหน่งโลโก้'),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          PositionLogoSlide = newValue;
                                        });
                                      }
                                    },
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    items: <String>[
                                      'บนฝั่งซ้าย',
                                      'บนฝั่งกลาง',
                                      'บนฝั่งขวา'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _folderUSBLOGOController,
                                    decoration: const InputDecoration(
                                      labelText: 'กำหนดที่เก็บไฟล์ภาพ',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          var ImageSlideBox =
                              await Hive.openBox('ImageSlideBoxChecked');
                          await ImageSlideBox.put(
                              'ImageSlideBoxChecked', ImageSlide);
                          await ImageSlideBox.put(
                              'ImageSlidePosition', PositionImageSlide);
                          await ImageSlideBox.put(
                              'ImageFolderUSB', _folderUSBImageController.text);

                          var LogoSlideBox =
                              await Hive.openBox('LogoSlideBoxChecked');
                          await LogoSlideBox.put(
                              'LogoSlideBoxChecked', LogoSlide);
                          await LogoSlideBox.put(
                              'LogoSlidePosition', PositionLogoSlide);
                          await LogoSlideBox.put(
                              'LogoFolderUSB', _folderUSBLOGOController.text);

                          await LogoSlideBox.close();
                          await ImageSlideBox.close();
                          await loadDataFromHive();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          'บันทึกการตั้งค่า Slide Image',
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool ImageSlide = false;
  bool LogoSlide = false;
  String? PositionImageSlide;
  String? PositionLogoSlide;
  final List<String> paths = [];
  List<String> _storagePaths = [];

  @override
  void initState() {
    super.initState();
    loadDataFromHive();
    _listStoragePaths();
  }

  Future<void> _listStoragePaths() async {
    final List<String> paths = [];

    // ที่เก็บข้อมูลในเครื่อง
    final directory = await getApplicationDocumentsDirectory();
    paths.add(directory.path);

    // ที่เก็บข้อมูล USB (External Storage)
    try {
      final usbPaths = await ExternalPath.getExternalStorageDirectories();
      if (usbPaths.isNotEmpty) {
        paths.addAll(usbPaths);
      }
    } catch (e) {
      print("Error accessing USB storage: $e");
    }

    setState(() {
      _storagePaths = paths;
    });
  }

  Future<void> loadDataFromHive() async {
    var ImageSlideBox = await Hive.openBox('ImageSlideBoxChecked');
    bool? ImageSlideBoxString = ImageSlideBox.get('ImageSlideBoxChecked');
    String? ImageSlidePositionString = ImageSlideBox.get('ImageSlidePosition');
    String? ImageFolrderUSBString = ImageSlideBox.get('ImageFolderUSB');

    var LogoSlideBox = await Hive.openBox('LogoSlideBoxChecked');
    bool? LogoSlideBoxString = LogoSlideBox.get('LogoSlideBoxChecked');
    String? LogoSlidePositionString = LogoSlideBox.get('LogoSlidePosition');
    String? LogoFolrderUSBString = LogoSlideBox.get('LogoFolderUSB');

    setState(() {
      ImageSlide = ImageSlideBoxString ?? false;
      PositionImageSlide = ImageSlidePositionString ?? '';

      LogoSlide = LogoSlideBoxString ?? false;
      PositionLogoSlide = LogoSlidePositionString ?? '';

      _folderUSBLOGOController.text = LogoFolrderUSBString.toString();
      _folderUSBImageController.text = ImageFolrderUSBString.toString();
    });
  }

  void _navigateToImagesFolder(String basePath) {
    final imagesFolder = Directory('$basePath/');

    if (imagesFolder.existsSync()) {
      showDialog(
        context: context,
        builder: (context) =>
            ImagesListDialog(imagesFolderPath: imagesFolder.path),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Images folder does not exist')),
      );
    }
  }

  void _showPasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('กรอกรหัสผ่าน'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'รหัสผ่าน'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String enteredPassword = passwordController.text;
                if (enteredPassword == _correctPassword) {
                  setState(() {
                    _isVisible = true; // แสดง UI เมื่อรหัสผ่านถูกต้อง
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('รหัสผ่านไม่ถูกต้อง')),
                  );
                }
              },
              child: Text('ยืนยัน'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
          ],
        );
      },
    );
  }
}

class ImagesListDialog extends StatelessWidget {
  final String imagesFolderPath;

  ImagesListDialog({required this.imagesFolderPath});

  @override
  Widget build(BuildContext context) {
    final directory = Directory(imagesFolderPath);
    final imageFiles = directory
        .listSync()
        .where((item) => item is File && _isImageFile(item.path))
        .toList();

    return AlertDialog(
      title: Text('Images in $imagesFolderPath'),
      content: SizedBox(
        width: double.maxFinite, // ให้ Dialog ขยายความกว้างได้เต็มที่
        height: 400, // หรือความสูงที่ต้องการ
        child: ListView.builder(
          itemCount: imageFiles.length,
          itemBuilder: (context, index) {
            final file = imageFiles[index] as File;

            return ListTile(
              leading:
                  Image.file(file, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(file.path.split('/').last),
              onTap: () {
                // Add actions if needed
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  bool _isImageFile(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension);
  }
}
