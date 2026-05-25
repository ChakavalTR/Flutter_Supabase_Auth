import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/config/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmerWidget extends StatelessWidget {
  const ProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderShimmer,
          const SizedBox(height: 10),
          _shimmerBox(width: 220, height: 26, radius: 8),
          const SizedBox(height: 10),
          _shimmerBox(width: 180, height: 18, radius: 8),
          const SizedBox(height: 10),
          _shimmerBox(width: 80, height: 30, radius: 10),
          const SizedBox(height: 12),
          _shimmerTile,
          _shimmerTile,
          _shimmerTile,
          _shimmerTile,
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 70, right: 70),
            child: _shimmerBox(width: double.infinity, height: 34, radius: 10),
          ),
          const SizedBox(height: 70),
          _shimmerBox(width: 100, height: 16, radius: 5),
        ],
      ),
    );
  }

  //! Build Header Shimmer Widget
  Widget get _buildHeaderShimmer {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! Build Shimmer Tile Widget
  Widget get _shimmerTile {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.lightBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Row(
        children: [
          _shimmerBox(width: 55, height: 60, radius: 10),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _shimmerBox(width: 90, height: 16, radius: 8),
              const SizedBox(height: 8),
              _shimmerBox(width: 140, height: 14, radius: 8),
            ],
          ),
        ],
      ),
    );
  }

  //! Build Shimmer Box Widget
  Widget _shimmerBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
