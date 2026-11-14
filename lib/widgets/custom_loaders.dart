import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Global app loader service
/// Manages all loading dialogs and indicators across the app

class LoaderService extends GetxService {
  bool _isLoaderShown = false;

  /// Show global loading dialog
  void showLoader({String? message}) {
    if (_isLoaderShown) return; // Prevent multiple dialogs

    _isLoaderShown = true;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF00A8A8),
                  strokeWidth: 3,
                ),
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  /// Hide global loading dialog
  void hideLoader() {
    if (_isLoaderShown) {
      Get.back();
      _isLoaderShown = false;
    }
  }

  /// Check if loader is shown
  bool get isLoaderShown => _isLoaderShown;
}

/// Custom circular progress indicator
class CustomProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CustomProgressIndicator({
    Key? key,
    this.size = 50,
    this.color = const Color(0xFF00A8A8),
    this.strokeWidth = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

/// Shimmer loading skeleton
class ShimmerLoading extends StatefulWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerLoading({
    Key? key,
    this.height = 20,
    this.width,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFFE0E0E0),
                const Color(0xFFF5F5F5),
                const Color(0xFFE0E0E0),
              ],
              stops: [
                _controller.value - 0.1,
                _controller.value,
                _controller.value + 0.1,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer list item skeleton
class ShimmerListItem extends StatelessWidget {
  final int lineCount;
  final EdgeInsets padding;

  const ShimmerListItem({
    Key? key,
    this.lineCount = 3,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          lineCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ShimmerLoading(
              height: index == 0 ? 24 : 16,
              width: index == lineCount - 1 ? 150 : null,
            ),
          ),
        ),
      ),
    );
  }
}
