import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meedu_demo/face_aging/face_aging_ctrl.dart';

class FaceAging extends StatelessWidget {
  const FaceAging({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FaceAgingController());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Aging'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selected Image
            Obx(() => controller.selectedImage.value != null
                ? Expanded(
                    flex: 2,
                    child: Image.file(
                      controller.selectedImage.value!,
                      fit: BoxFit.contain,
                    ),
                  )
                : const Expanded(
                    flex: 2,
                    child: Center(
                      child: Text('No image selected'),
                    ),
                  )),
            
            const SizedBox(height: 16),
            
            // Processed Image
            Obx(() => controller.processedImage.value != null
                ? Expanded(
                    flex: 2,
                    child: Image.file(
                      controller.processedImage.value!,
                      fit: BoxFit.contain,
                    ),
                  )
                : const Expanded(
                    flex: 2,
                    child: Center(
                      child: Text('Processed image will appear here'),
                    ),
                  )),
            
            const SizedBox(height: 16),
            
            // Error Message
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink()),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.pickAndProcessImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select Image'),
                ),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}