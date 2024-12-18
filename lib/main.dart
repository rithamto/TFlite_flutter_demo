import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meedu_demo/main_controller.dart';
import 'package:signature/signature.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MainController());
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
  final controller = Get.find<MainController>();

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
