import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xlist/pages/test/controller.dart';

class TestPage extends GetView<TestController> {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Page')),
      body: const Center(
        child: Text('Welcome to the Test Page!'),
      ),
    );
  }
}
