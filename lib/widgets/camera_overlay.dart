// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
   const Camera({super.key, required this.cameras});
static XFile? test;
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  bool flash = false;
  
  late CameraController controll;

  @override
  void initState() {
    controll = CameraController(widget.cameras[0], ResolutionPreset.max);
    controll.initialize().then((value) {
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

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
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CameraPreview(controll),
              ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle),
                            ),
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
                                ? const Icon(Icons.flash_on_sharp,color: Colors.white,size: 40,)
                                : const Icon(Icons.flash_off_sharp,color: Colors.white,size:40,)),
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

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide + 5, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide + 5)
      ..moveTo(0, sh - cornerSide - 5)
      ..quadraticBezierTo(0, sh, cornerSide + 5, sh)
      ..moveTo(sw - cornerSide - 5, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide - 5)
      ..moveTo(sw, cornerSide + 5)
      ..quadraticBezierTo(sw, 0, sw - cornerSide - 5, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
