// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FashionMnistCtrl extends GetxController {
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.green,
    exportBackgroundColor: Colors.black,
  );
  late Interpreter interpreter;

  Uint8List? signatureData;
  final value =
      List.generate(1, (_) => List.generate(35, (_) => Float32List(147)));

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Future<void> onInit() async {
    interpreter = await Interpreter.fromAsset(
      'assets/models/fashion_mnist_model.tflite',
    );
    print(interpreter.getInputTensor(0).shape);
    print(interpreter.getOutputTensor(0).shape);
    super.onInit();
  }

  solve() async {
    signatureData = await signatureController.toPngBytes();
    late img.Image? originalImage;
    originalImage = img.decodeImage(signatureData!);

    img.Image resizedImage =
        img.copyResize(originalImage!, width: 280, height: 60);
    img.Image grayscaleImage = img.grayscale(resizedImage);

    final inputTensor = List.generate(
        1,
        (_) => List.generate(
            28,
            (y) => List.generate(
                28,
                (x) =>
                    img.getLuminance(grayscaleImage.getPixel(x, y)) / 255.0)));

    final outputTensor = List.generate(1, (_) => List.generate(10, (_) => 0.0));

    interpreter.run(inputTensor, outputTensor);
    switch (indexOfMaxValue(outputTensor[0])) {
      case 0:
        Get.showSnackbar(const GetSnackBar(
          title: "T-shirt/top",
          message: "T-shirt/top",
          duration: Duration(seconds: 1),
        ));
        break;
      case 1:
        Get.showSnackbar(const GetSnackBar(
          title: "Trouser",
          message: "Trouser",
          duration: Duration(seconds: 1),
        ));
        break;
      case 2:
        Get.showSnackbar(const GetSnackBar(
          title: "Pullover",
          message: "Pullover",
          duration: Duration(seconds: 1),
        ));
        break;
      case 3:
        Get.showSnackbar(const GetSnackBar(
          title: "Dress",
          message: "Dress",
          duration: Duration(seconds: 1),
        ));
        break;
      case 4:
        Get.showSnackbar(const GetSnackBar(
          title: "Coat",
          message: "Coat",
          duration: Duration(seconds: 1),
        ));
        break;
      case 5:
        Get.showSnackbar(const GetSnackBar(
          title: "Sandal",
          message: "Sandal",
          duration: Duration(seconds: 1),
        ));
        break;
      case 6:
        Get.showSnackbar(const GetSnackBar(
          title: "Shirt",
          message: "Shirt",
          duration: Duration(seconds: 1),
        ));
        break;
      case 7:
        Get.showSnackbar(const GetSnackBar(
          title: "Sneaker",
          message: "Sneaker",
          duration: Duration(seconds: 1),
        ));
        break;
      case 8:
        Get.showSnackbar(const GetSnackBar(
          title: "Bag",
          message: "Bag",
          duration: Duration(seconds: 1),
        ));
        break;
      case 9:
        Get.showSnackbar(const GetSnackBar(
          title: "Ankle boot",
          message: "Ankle boot",
          duration: Duration(seconds: 1),
        ));
        break;
      default:
        Get.showSnackbar(const GetSnackBar(
          title: "Unknow",
          message: "Unknow",
          duration: Duration(seconds: 1),
        ));
    }
  }

  int indexOfMaxValue(List<double> list) {
    if (list.isEmpty) return -1;
    return list.fold(
        0,
        (maxIndex, element) =>
            list[maxIndex] > element ? maxIndex : list.indexOf(element));
  }

// _controller.clear();

// _controller.toPngBytes();

// var exportedPoints = _controller.points;
}
