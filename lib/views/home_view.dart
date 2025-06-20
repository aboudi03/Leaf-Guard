import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/result_card.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? _selectedImage;
  String? _result;
  bool _loading = false;
  bool _dialogShown = false; // To track if popup was shown

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _result = null;
      });
      _sendToBackend(_selectedImage!);
    }
  }

  Future<void> _sendToBackend(File imageFile) async {
    setState(() {
      _loading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/leaf/predict'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);
        final prediction = data['Prediction'];
        if (prediction != null) {
          setState(() {
            _result =
                "${prediction['label']} (${prediction['confidence'].toStringAsFixed(1)}%)";
          });
        } else {
          setState(() {
            _result = "No prediction found";
          });
        }
      } else {
        setState(() {
          _result = "Failed to detect disease";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show the dialog only once after the first frame build
    if (!_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Welcome to LeafGuard 🌿'),
            content: const Text(
              'This app currently supports detection for Pepper, Potato, and Tomato leaves only. Thanks for using it!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("LeafGuard 🌿")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered image preview
            if (_selectedImage != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(_selectedImage!, height: 250),
                ),
              )
            else
              const SizedBox(
                height: 250,
                child: Center(
                  child: Text(
                    "No image selected",
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Buttons row with midnight purple styling
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B0087),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B0087),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_loading) const CircularProgressIndicator(),

            if (_result != null && !_loading) ResultCard(result: _result!),

            // Reset button to clear image and result
            if ((_selectedImage != null || _result != null) && !_loading)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B0087),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                      _result = null;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
