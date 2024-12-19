import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meedu_demo/fashion_mnist/fashion_mnist_ctrl.dart';
import 'package:signature/signature.dart';

class FashionMnist extends StatefulWidget {
  const FashionMnist({super.key});
  @override
  State<FashionMnist> createState() => _FashionMnistState();
}

class _FashionMnistState extends State<FashionMnist> {
  final controller = Get.find<FashionMnistCtrl>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton.filled(
            onPressed: () {
              controller.signatureController.clear();
            },
            icon: const Icon(
              Icons.replay,
              color: Colors.white,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.solve();
        },
        child: const Icon(Icons.rule_rounded),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Signature(
              controller: controller.signatureController,
              height: Get.width,
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}