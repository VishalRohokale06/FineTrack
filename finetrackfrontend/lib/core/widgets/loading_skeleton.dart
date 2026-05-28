import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';

class LoadingSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const LoadingSkeleton({
    super.key,
    required this.height,
    required this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.border,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
