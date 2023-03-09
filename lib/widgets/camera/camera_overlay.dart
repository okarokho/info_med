// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'border_paint.dart';

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Camera({super.key, required this.cameras});
  static XFile? test;
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  // controll camera flash
  bool flash = false;
  // camera controller
  late CameraController controll;
  // initiate the controller
  @override
  void initState() {
    controll = CameraController(widget.cameras[0], ResolutionPreset.max);
    controll.initialize().then((value) {
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  // dispose the controller
  @override
  void dispose() {
    controll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !controll.value.isInitialized
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              // camera screen with phone screen size
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CameraPreview(controll),
              ),
              // drug name container with border
              Center(
                heightFactor: 7,
                child: CustomPaint(
                  foregroundPainter: BorderPainter(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 80,
                      width: 300,
                      color: Colors.white.withOpacity(0.019),
                    ),
                  ),
                ),
              ),
              // camera controll buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // take picture button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FloatingActionButton(
                        onPressed: () async {
                          Camera.test = await controll.takePicture();

                          Navigator.pop(context);
                        },
                        backgroundColor: Colors.red[900]!.withOpacity(0.5),
                        elevation: 0,
                        child: Stack(
                          children: [
                            // border of button
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle),
                            ),
                            // red color of button
                            Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    shape: BoxShape.circle),
                              ),
                            )
                          ],
                        )),
                  ),
                  // flash button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: () {}, child: const Text('')),
                        GestureDetector(
                            onTap: () async {
                              setState(() => flash = !flash);
                              if (flash == true) {
                                await controll.setFlashMode(FlashMode.always);
                              } else {
                                await controll.setFlashMode(FlashMode.off);
                              }
                            },
                            child: flash
                                ? const Icon(
                                    Icons.flash_on_sharp,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.flash_off_sharp,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                        TextButton(onPressed: () {}, child: const Text(''))
                      ],
                    ),
                  )
                ],
              )
            ],
          );
  }
}
