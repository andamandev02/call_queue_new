import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:call_queue_new/Tabs/setting.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _controller = TextEditingController();

  int? sizesqueue;
  String displayNumber = '000';

  int digit = 3;
  Timer? _timer;
  Color _textColor = Colors.white;

  Color selectedBackgroundColor = Colors.black;
  Color selectedTextColor = Colors.white;
  Color selectedTextBlinkColor = Colors.yellow;

  bool ImageSlide = false;
  String? PositionImageSlide;

  bool LogoSlide = false;
  String? PositionLogoSlide;

  // logo ดึงจากไฟล์
  List<File> logoList = [];

  // ปรับหน้าจอแนวตั้ง
  bool CountRow = false;

  String? _errorLoadingImage;

  List<List<String?>> selectedFoldersModeSoundsList = [[]];

  @override
  void initState() {
    super.initState();
    _requestExternalStoragePermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadDigitFromHive();
      _loadBackgroundColorFromHive();
      _loadImageSlide();
      _loadModeSounds();
    });
  }

  void _loadDigitFromHive() async {
    var box = await Hive.openBox('Digit');
    setState(() {
      digit = box.get('Digit', defaultValue: 3);

      sizesqueue = box.get(
        'SizeQueue',
      );

      // displayNumber.padLeft(digit, '0');
      int intValue = int.parse(displayNumber);
      if (intValue.toString().length > digit) {
        displayNumber = intValue.toString().substring(0, digit);
      } else {
        displayNumber = intValue.toString().padLeft(digit, '0');
      }
    });
  }

  void _loadImageSlide() async {
    var ImageSlideBox = await Hive.openBox('ImageSlideBoxChecked');
    var ImageSlidePositionBox = await Hive.openBox('ImageSlidePosition');

    var LogoSlideBox = await Hive.openBox('LogoSlideBoxChecked');
    var LogoSlidePositionBox = await Hive.openBox('LogoSlidePosition');
    var LogoFolderUSBBox = await Hive.openBox('LogoFolderUSB');

    setState(() {
      bool? ImageSlideString = ImageSlideBox.get('ImageSlideBoxChecked');
      String ImageSlidePositionString = ImageSlideBox.get('ImageSlidePosition');
      ImageSlide = ImageSlideString!;
      PositionImageSlide = ImageSlidePositionString;

      bool? LogoSlideString = LogoSlideBox.get('LogoSlideBoxChecked');
      String LogoSlidePositionString = LogoSlideBox.get('LogoSlidePosition');
      String LogoFolderUSBString = LogoSlideBox.get('LogoFolderUSB');
      LogoSlide = LogoSlideString!;
      PositionLogoSlide = LogoSlidePositionString;

      // if (LogoSlide) {
      //   loadLogoFromDrive(LogoFolderUSBString);
      // }
    });
    // await box.close();
  }

  Future<void> loadLogoFromDrive(String LogoFolderUSBString) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await _requestExternalStoragePermission();
    }
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw 'External storage directory not found';
    }
    String usbPath = LogoFolderUSBString;
    if (usbPath == null) {
      throw 'USB path is null';
    }
    Directory usbDir = Directory(usbPath);
    if (!usbDir.existsSync()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const duration = Duration(seconds: 2);
          Timer(duration, () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Text(
              'USB directory does not exist : $usbPath',
              style: const TextStyle(fontSize: 50),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
      throw 'USB directory does not exist';
    }

    List<FileSystemEntity> files = usbDir.listSync();

    if (files.isEmpty) {
      throw 'No files found in USB directory';
    }
    List<File> logoFiles = files.whereType<File>().toList();
    if (logoFiles.isEmpty) {
      throw 'No image files found in USB directory';
    }
    setState(() {
      logoList = logoFiles;
    });
  }

  Future<void> _requestExternalStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
    } else {
      setState(() {
        _errorLoadingImage = 'Permission denied for storage';
      });
    }
  }

  void _loadModeSounds() async {
    var modeSoundsBox = await Hive.openBox('ModeSounds');
    setState(() {
      List<dynamic> modeSoundsBoxList =
          modeSoundsBox.get('ModeSounds', defaultValue: []);
    });
    // await modeSoundsBox.close();
  }

  void _loadBackgroundColorFromHive() async {
    var backgroundcolorBox = await Hive.openBox('BackgroundColor');
    String? BackgroundcolorString = backgroundcolorBox.get('BackgroundColor');
    if (BackgroundcolorString != null) {
      setState(() {
        selectedBackgroundColor =
            Color(int.parse(BackgroundcolorString.substring(1), radix: 16));
      });
      // await backgroundcolorBox.close();
    }

    var TextcolorBox = await Hive.openBox('TextColor');
    String? TextcolorString = TextcolorBox.get('TextColor');
    if (TextcolorString != null) {
      setState(() {
        selectedTextColor =
            Color(int.parse(TextcolorString.substring(1), radix: 16));
      });
      // await TextcolorBox.close();
    }

    var TextBlinkcolorBox = await Hive.openBox('TextBlinkColor');
    String? TextBlinkcolorString = TextBlinkcolorBox.get('TextBlinkColor');
    if (TextBlinkcolorString != null) {
      setState(() {
        selectedTextBlinkColor =
            Color(int.parse(TextBlinkcolorString.substring(1), radix: 16));
      });
      // await TextBlinkcolorBox.close();
    }
  }

  void _handleSubmitted(String value) async {
    if (value == '//') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingScreen()),
      );
    } else {
      var box = await Hive.openBox('Digit');
      setState(() {
        digit = box.get('Digit', defaultValue: 3);
        int intValue = int.parse(value);
        if (intValue.toString().length > digit) {
          displayNumber = intValue.toString().substring(0, digit);
          PlaySound(displayNumber);
        } else {
          displayNumber = intValue.toString().padLeft(digit, '0');
          PlaySound(displayNumber);
        }
      });
      _focusNode.requestFocus();
    }
    _controller.clear();
  }

  void PlaySound(String value) async {
    try {
      final player = AudioPlayer();
      _timer?.cancel();
      var ModeSoundsBox = await Hive.openBox('ModeSounds');
      var DataModeSounds = ModeSoundsBox.values.toList();
      var mainList = DataModeSounds.firstWhere((item) => item is List);
      var filteredData = mainList
          .asMap()
          .entries
          .where((entry) => entry.value['selected'] == true)
          .map((entry) => {
                'index': entry.key,
                'value': entry.value,
              })
          .toList();
      final trimmedString = value.toString();
      final numberString = trimmedString.replaceAll(RegExp('^0+'), '');
      try {
        _startBlinking();
        Future<void> playNumberSound(String number, String lang) async {
          for (int i = 0; i < number.length; i++) {
            await player.play(AssetSource('sounds/$lang/${number[i]}.mp3'));
            if (i + 1 < number.length && number[i] == number[i + 1]) {
              await player.onPlayerStateChanged.firstWhere(
                (state) => state == PlayerState.completed,
                orElse: () => PlayerState.completed,
              );
            } else {
              await Future.delayed(const Duration(milliseconds: 650));
            }
          }
        }

        for (var item in filteredData) {
          if (item['index'] == 0) {
            var folders = item['value']['folders'];
            for (var folder in folders) {
              await player
                  .play(AssetSource('sounds/${folder}/queuenumber.mp3'));
              await Future.delayed(const Duration(milliseconds: 1200));
              await playNumberSound(numberString, '${folder}');
            }
          }
        }
      } catch (e) {
        print("Error playing sound: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error playing sound: $e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } finally {
        _timer?.cancel();
      }
    } catch (e) {
      print("Error opening Hive box: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error opening Hive box: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _startBlinking() {
    _timer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      setState(() {
        selectedTextColor = selectedTextColor == selectedTextColor
            ? selectedTextBlinkColor
            : selectedTextColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseFontSize = screenSize.height * 0.05;
    final double fontSize = baseFontSize * (sizesqueue ?? 1.0);

    return GestureDetector(
      onTap: () {
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      },
      child: Scaffold(
        backgroundColor: selectedBackgroundColor,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ImageSlide && PositionImageSlide == "ซ้าย")
              _buildSideContainer(fontSize),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.all(5.0), // Add padding for spacing
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Opacity(
                              opacity: 1,
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.text,
                                focusNode: _focusNode,
                                decoration: const InputDecoration(
                                  labelText: 'Enter number',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: _handleSubmitted,
                              ),
                            ),
                            if (LogoSlide)
                              SizedBox(
                                height: screenSize.height * 0.3,
                                child: Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: logoList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          logoList[index],
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.center,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: selectedBackgroundColor,
                      child: Center(
                        child: Text(
                          displayNumber,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: selectedTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (ImageSlide && PositionImageSlide == "ขวา")
              _buildSideContainer(fontSize),
          ],
        ),
      ),
    );
  }

// Helper method to build the side containers
  Widget _buildSideContainer(double fontSize) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.red,
        child: Center(
          child: Text(
            displayNumber,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: selectedTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
