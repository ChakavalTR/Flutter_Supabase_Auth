import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:get/get.dart';

class FullScreenPreviewView extends StatefulWidget {
  final String imageUrl;
  const FullScreenPreviewView({super.key, required this.imageUrl});

  @override
  State<FullScreenPreviewView> createState() => _FullScreenPreviewViewState();
}

class _FullScreenPreviewViewState extends State<FullScreenPreviewView> {
  final TransformationController _controller = TransformationController();
  bool isZoomed = false;
  void _toggleZoom() {
    if (isZoomed) {
      _controller.value = Matrix4.identity();
    } else {
      _controller.value = Matrix4.identity()..scale(2.5);
    }
    isZoomed = !isZoomed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onDoubleTap: _toggleZoom,
              child: InteractiveViewer(
                transformationController: _controller,
                minScale: 1.0,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const Icon(
                      Icons.error,
                      color: Colors.redAccent,
                      size: 60,
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: 20,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
