import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SelfSmart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(camera: camera),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CameraDescription camera;

  const MyHomePage({super.key, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Future<void> sendImage(String blobUrl) async {
  //   // Convert the Blob URL to a File object (for web).
  //   html.Blob blob =
  //       html.Url.createObjectUrlFromBlob(blobUrl as html.Blob) as html.Blob;
  //   var reader = html.FileReader();
  //   reader.readAsArrayBuffer(blob);
  //   await reader.onLoad.first;

  //   var file = File.fromRawPath(reader.result
  //       as Uint8List); // For mobile, this will vary depending on how the image is captured.

  //   var uri = Uri.parse('http://192.168.4.86:50600/upload');
  //   var request = http.MultipartRequest('POST', uri)
  //     ..files.add(await http.MultipartFile.fromPath('image', file.path));

  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     print('Image sent successfully');
  //   } else {
  //     print('Image failed to send');
  //   }
  // }

  Future<void> sendImage(Uint8List imageBytes) async {
    var uri = Uri.parse('http://192.168.4.86:50600/upload');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes,
          filename: 'upload.png'));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image sent successfully');
    } else {
      print('Image failed to send');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060A27),
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();
                      // image has the image captured
                      // await sendImage(File(image.path));
                      print('Picture taken: ${image.path}');
                    } catch (e) {
                      print(e);
                    }
                  },
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.camera_alt),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ()),
                    // );
                  },
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.book),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Now in your main flutter file, where you want to access, add this code in the function you want to get your output by python script.

// var data = await getData('http://localhost:50600/);
// var decodedData = jsonDecode(data);
// print(decodedData['query']);