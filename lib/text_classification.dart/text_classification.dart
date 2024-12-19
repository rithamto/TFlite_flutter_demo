import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meedu_demo/text_classification.dart/text_classification_ctrl.dart';

class TextClassification extends StatefulWidget {
  const TextClassification({super.key});

  @override
  State<TextClassification> createState() => _TextClassificationState();
}

class _TextClassificationState extends State<TextClassification> {
  final controller = Get.find<TextClassificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Input Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.txtCtrler,
              decoration: const InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.solve();
              },
              child: const Text('Submit'),
            ),
            
          ],
        ),
      ),
    );
  }
}