import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({Key? key}) : super(key: key);

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _scaleAnimations;
  late final List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scaleAnimations = List.generate(3, (i) {
      final start = i * 0.2;
      final end = start + 0.6;
      return Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    _opacityAnimations = List.generate(3, (i) {
      final start = i * 0.2;
      final end = start + 0.6;
      return Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _opacityAnimations[index].value,
        child: Transform.scale(
          scale: _scaleAnimations[index].value,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: CircleAvatar(radius: 6, backgroundColor: Colors.blue),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, _buildDot),
        ),
      ),
    );
  }
}
