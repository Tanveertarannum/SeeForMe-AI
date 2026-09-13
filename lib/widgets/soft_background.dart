import 'dart:ui';

import 'package:flutter/material.dart';

class SoftBackground extends StatelessWidget {
  final Widget child;

  const SoftBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF4F8F7),
            Color(0xFFE9F2F2),
            Color(0xFFF7F5F1),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _BlurCircle(
              size: 250,
              color: const Color(0xFFBFDADC),
            ),
          ),

          Positioned(
            top: 290,
            left: -100,
            child: _BlurCircle(
              size: 230,
              color: const Color(0xFFD5E6DF),
            ),
          ),

          Positioned(
            bottom: -110,
            right: -65,
            child: _BlurCircle(
              size: 250,
              color: const Color(0xFFD9E6EE),
            ),
          ),

          child,
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 35,
        sigmaY: 35,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.42),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}