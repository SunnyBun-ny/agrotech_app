import 'dart:io';
import 'package:agrotech_app/screens/home_screen/components/icon_button.dart';
import 'package:agrotech_app/screens/result_screen/result_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/api_service.dart';
import '../../main.dart';
import '../../model/prediction.dart';
import 'components/camera_screen.dart';

typedef NavigateToResultScreen = void Function(
    Map<String, dynamic> predictionResult);

class HomeScreen extends StatefulWidget {
  static const route = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum ButtonState {
  uploadingPhoto,
  processingPhoto,
  scanningPhoto,
  defaultState,
  disabledState
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  late CameraController _controllerCamera;
  late ApiService _apiService;
  File? _pickedFile;
  ButtonState _buttonState = ButtonState.defaultState;

  @override
  void initState() {
    super.initState();
    _controllerCamera = CameraController(cameras[0], ResolutionPreset.medium);
    _controllerCamera.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _apiService = ApiService();
  }

  @override
  void dispose() {
    _controllerCamera.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AgroTech',
          style: TextStyle(fontFamily: 'MuseoModerno'),
        ),
        // titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      // leading: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Image.asset('assets/images/logo-primary.png'),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a Crop image to',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    'Scan for Disease',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomIconButton(
                        label: 'Camera',
                        icon: Icons.camera,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CameraScreen(
                                    controller: _controllerCamera,
                                    onImageClicked: onImageClicked,
                                  )));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: CustomIconButton(
                        label: 'Gallery',
                        icon: Icons.filter,
                        onPressed: _pickFile,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: _pickedFile == null
                      ? const Text('No Image selected')
                      : Image.file(
                          _pickedFile!,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                  disabledColor: Colors.grey[100],
                  disabledTextColor: Colors.grey[400],
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.green[400],
                  textColor: Colors.grey[100],
                  onPressed: _pickedFile != null
                      ? () {
                          _predictImage((predictionResult) {
                            Navigator.pushNamed(
                              context,
                              ResultScreen
                                  .route, // Route name for the next screen
                              arguments:
                                  predictionResult, // Pass prediction data as arguments
                            );
                          });
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          _getButtonText(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buttonState == ButtonState.defaultState
                          ? const Icon(Icons.arrow_forward)
                          : const Icon(Icons.splitscreen),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String _getButtonText() {
    switch (_buttonState) {
      case ButtonState.uploadingPhoto:
        return 'Uploading Photo';
      case ButtonState.processingPhoto:
        return 'Processing Photo';
      case ButtonState.scanningPhoto:
        return 'Scanning for Disease';
      case ButtonState.defaultState:
        return 'Scan for Disease';
      case ButtonState.disabledState:
        return 'Disabled';
    }
  }

  Future<void> _pickFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _pickedFile = File(pickedFile.path);
      }
    });
  }

  void onImageClicked() {
    try {
      _controllerCamera.takePicture().then((image) {
        setState(() {
          _pickedFile = File(image.path);
        });
        Navigator.of(context).pop();
      });
      // Do something with the captured image
    } catch (e) {
      print(e);
    }
  }

  Future<void> _predictImage(
      NavigateToResultScreen navigateToResultScreen) async {
    if (_pickedFile == null) {
      print('No file Found');
      return;
    }
    // Set the button state to indicate uploading photo
    setState(() {
      _buttonState = ButtonState.scanningPhoto;
    });

    Map<String, dynamic> result = await _apiService.predictImage(_pickedFile!);

    if (result.containsKey('prediction')) {
      Prediction prediction = result['prediction'] as Prediction;
      navigateToResultScreen({'prediction': prediction, 'image': _pickedFile});
    } else if (result.containsKey('error')) {
      String error = result['error'] as String;
      print('Error: $error');
    }
    setState(() {
      _buttonState = ButtonState.defaultState;
    });
  }
}
