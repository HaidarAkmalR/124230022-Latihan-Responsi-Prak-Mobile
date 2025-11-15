
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  const GlassContainer({super.key, required this.child, this.radius = 14, this.padding = const EdgeInsets.all(12)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: child,
        ),
      ),
    );
  }
}
