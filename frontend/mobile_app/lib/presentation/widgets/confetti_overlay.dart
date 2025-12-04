import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({
    super.key,
    required this.controller,
    this.child,
  });

  final ConfettiController controller;
  final Widget? child;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: widget.controller,
            blastDirection: pi / 2, // down
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
            shouldLoop: false,
            colors: const [
              Color(0xFFFFB5C5), // Soft Pink
              Color(0xFFA8E6CF), // Mint Green
              Color(0xFFC5A9E0), // Gentle Purple
              Color(0xFFFFD166), // Soft Yellow
            ],
          ),
        ),
      ],
    );
  }
}
