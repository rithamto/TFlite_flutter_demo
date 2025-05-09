// ignore_for_file: depend_on_referenced_packages, unused_local_variable

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FaceAgingController extends GetxController {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  // Observable variables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> processedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    loadModel();
    super.onInit();
  }

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/models/face_aging_model.tflite');
      _isModelLoaded = true;
      print(_interpreter?.getInputTensor(0).shape.toString() ?? "okela");
      print(_interpreter?.getOutputTensor(0).shape.toString() ?? "okela");
    } catch (e) {
      print('Error loading model: $e');
      _isModelLoaded = false;
      errorMessage.value = 'Failed to load model: $e';
    }
  }

  Future<void> pickAndProcessImage() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        isLoading.value = false;
        return;
      }

      selectedImage.value = File(image.path);
      final processed = await processImage(selectedImage.value!);

      if (processed != null) {
        processedImage.value = processed;
      } else {
        errorMessage.value = 'Failed to process image';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<File?> processImage(File inputImage) async {
    if (!_isModelLoaded) {
      await loadModel();
    }

    if (_interpreter == null) {
      throw Exception('Model not loaded');
    }

    try {
      // Read and preprocess the image
      final imageBytes = await inputImage.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image to match model input size (64x64)
      final resizedImage = img.copyResize(image, width: 64, height: 64);

      // Convert image to float32 array and normalize
      var inputArray = List.generate(
        1,
        (_) => List.generate(
          64,
          (_) => List.generate(
            64,
            (_) => List<double>.filled(3, 0),
          ),
        ),
      );

      // Process each pixel
      for (var y = 0; y < resizedImage.height; y++) {
        for (var x = 0; x < resizedImage.width; x++) {
          final pixel = resizedImage.getPixel(x, y);
          final r = pixel.r;
          final g = pixel.g;
          final b = pixel.b;

          inputArray[0][y][x][0] = r / 255.0;
          inputArray[0][y][x][1] = g / 255.0;
          inputArray[0][y][x][2] = b / 255.0;
        }
      }

      // Prepare output tensor with correct shape [1, 1]
      var outputBuffer = List.generate(1, (_) => List<double>.filled(1, 0));

      // Run inference
      _interpreter!.run(inputArray, outputBuffer);

      // Get the age prediction
      final predictedAge = outputBuffer[0][0];
      print('Predicted age: $predictedAge');

      // Create a new image with the same size as input
      var outputImage = img.Image(width: 64, height: 64);
      
      // Apply aging effect based on predicted age
      for (var y = 0; y < resizedImage.height; y++) {
        for (var x = 0; x < resizedImage.width; x++) {
          final pixel = resizedImage.getPixel(x, y);
          var r = pixel.r;
          var g = pixel.g;
          var b = pixel.b;

          // Apply aging effect (example: increase contrast and add some yellow tint)
          r = (r * 1.2).clamp(0, 255).toInt();
          g = (g * 1.1).clamp(0, 255).toInt();
          b = (b * 0.9).clamp(0, 255).toInt();

          outputImage.setPixel(x, y, img.ColorFloat16.rgb(r, g, b));
        }
      }

      // Save processed image
      final processedImageBytes = img.encodeJpg(outputImage);
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/processed_face.jpg');
      await tempFile.writeAsBytes(processedImageBytes);

      return tempFile;
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }

  @override
  void onClose() {
    _interpreter?.close();
    super.onClose();
  }
}
