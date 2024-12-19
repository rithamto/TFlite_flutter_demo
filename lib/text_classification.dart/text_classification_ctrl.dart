import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TextClassificationController extends GetxController {
  late Interpreter interpreter;
  final txtCtrler = TextEditingController();
  var output = List.generate(1, (_) => List.generate(1, (_) => 0.0));
  final result = 0.1.obs;

  @override
  Future<void> onInit() async {
    interpreter = await Interpreter.fromAsset(
      'assets/models/text_classification_model.tflite',
    );
    print(
        "${interpreter.getInputTensor(0).shape} okela ${interpreter.getOutputTensor(0).shape}");
    super.onInit();
  }

  solve() {
    var rawInput = txtCtrler.text.codeUnits.map((e) => e.toDouble()).toList();
    var input = List.generate(1, (_) => List.generate(1, (_) => rawInput[0]));
    interpreter.run(input, output);
    result.value = output[0][0];
    Get.showSnackbar(
      GetSnackBar(
        title: 'Result',
        message: 'The result is: ${output[0][0].toStringAsFixed(0)}',
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
