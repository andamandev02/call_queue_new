import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SettingImportSoundTab extends StatefulWidget {
  @override
  _SettingImportSoundTabState createState() => _SettingImportSoundTabState();
}

class _SettingImportSoundTabState extends State<SettingImportSoundTab> {
  String? importedFilePath;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _importFile() async {
    // เลือกไฟล์เสียง
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // สร้างโฟลเดอร์ใหม่ใน local storage
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String newFolderPath = p.join(appDocDir.path, 'call_queue_new', 'import');
      Directory newDir = Directory(newFolderPath);

      print(newDir);

      if (!(await newDir.exists())) {
        await newDir.create(recursive: true); // สร้างโฟลเดอร์ถ้ายังไม่มี
      }

      // Copy ไฟล์ไปยังโฟลเดอร์ที่สร้าง
      String newFilePath = p.join(newFolderPath, p.basename(file.path));
      await file.copy(newFilePath);

      setState(() {
        importedFilePath =
            newFilePath; // เก็บ path ของไฟล์ที่ import มาใช้ในแอป
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (importedFilePath != null)
              Text('Imported File: $importedFilePath'),
            ElevatedButton(
              onPressed: _importFile,
              child: Text('Import File'),
            ),
          ],
        ),
      ),
    );
  }
}
