
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerLoading({super.key, this.height = 220, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
