import 'package:flutter/material.dart';
import 'package:aug_crv/camera_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: SafeArea(
        child: Center(
            child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CameraPage()));
          },
          child: const Text("Take a Picture"),
        )),
      ),
    );
  }
}
