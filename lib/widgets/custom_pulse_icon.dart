import 'package:flutter/material.dart';

class CustomPulseIcon extends StatefulWidget {
  const CustomPulseIcon({Key? key}) : super(key: key);

  @override
  _CustomPulseIconState createState() =>
      _CustomPulseIconState();
}

class _CustomPulseIconState
    extends State<CustomPulseIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeats the animation in reverse

    // Define a tween animation for scaling
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.yellow,
            backgroundImage: const AssetImage('assets/images/NUShield.png'),
          ),
        );
      },
    );
  }
}
