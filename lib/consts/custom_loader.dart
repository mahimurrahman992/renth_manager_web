import 'dart:math';
import 'consts.dart';

class LoaderService extends GetxService {
  static LoaderService get to => Get.find<LoaderService>();

  final RxBool _isLoading = false.obs;
  final RxDouble _progress = 0.0.obs;
  final Rx<Color> _color = Colors.blue.obs;
  final RxDouble _size = 50.0.obs;

  AnimationController? _animationController;

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(
      vsync: Get.find<LoaderController>(),
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
      _progress.value = _animationController!.value;
    });
  }

  @override
  void onClose() {
    _animationController?.dispose();
    super.onClose();
  }

  void showLoader({
    Color color = Colors.blue,
    double size = 50.0,
  }) {
    _color.value = color;
    _size.value = size;

    if (!_isLoading.value) {
      _isLoading.value = true;
      _animationController?.repeat();

      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CustomLoaderWidget(
              progress: _progress,
              color: _color,
              size: _size,
            ),
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.3),
      );
    }
  }

  void hideLoader() {
    if (_isLoading.value) {
      _isLoading.value = false;
      _animationController?.stop();
      Get.back();
    }
  }
}

class LoaderController extends GetxController with GetSingleTickerProviderStateMixin {}

class CustomLoaderWidget extends StatelessWidget {
  final RxDouble progress;
  final Rx<Color> color;
  final RxDouble size;

  const CustomLoaderWidget({
    super.key,
    required this.progress,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SizedBox(
        width: size.value,
        height: size.value,
        child: CustomPaint(
          painter: _CircleLoaderPainter(
            progress: progress.value,
            color: color.value,
          ),
        ),
      ),
    );
  }
}

class _CircleLoaderPainter extends CustomPainter {
  final double progress;
  final Color color;
  static const int dotCount = 8;
  static const double dotRadius = 4.0;
  static const double radius = 15.0;

  _CircleLoaderPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dotCount; i++) {
      final angle = 2 * pi * (i / dotCount) + (2 * pi * progress);
      final opacity = (cos(angle) + 1) / 2;
      paint.color = color.withValues(alpha: opacity);

      final dotCenter = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      canvas.drawCircle(dotCenter, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}