import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meedu_demo/fashion_mnist/fashion_mnist.dart';
import 'package:meedu_demo/fashion_mnist/fashion_mnist_ctrl.dart';
import 'package:meedu_demo/text_classification.dart/text_classification.dart';
import 'package:meedu_demo/text_classification.dart/text_classification_ctrl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FashionMnistCtrl());
  Get.put(TextClassificationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(const FashionMnist());
              },
              child: const Text('FashionMnist'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(const TextClassification());
              },
              child: const Text('Text classification'),
            ),
          ],
        ),
      ),
    );
  }
}
