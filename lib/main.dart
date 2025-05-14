import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moon Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<BoxShadow> noShadow = const [];
  final List<BoxShadow> glowShadow = const [
    BoxShadow(color: Colors.white, blurRadius: 10.0),
    BoxShadow(color: Colors.white, blurRadius: 80.0, spreadRadius: 2.0),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E272E),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final val = _controller.value;
            double translateX;
            double scale;
            List<BoxShadow>? currentBoxShadow;

            if (val < 0.5) {
              final t = val * 2;
              translateX = lerpDouble(50.0, 0.0, t)!;
              scale = lerpDouble(0.9, 1.02, t)!;
              currentBoxShadow = BoxShadow.lerpList(noShadow, glowShadow, t);
            } else {
              final t = (val - 0.5) * 2;
              translateX = lerpDouble(0.0, -50.0, t)!;
              scale = lerpDouble(1.02, 0.9, t)!;
              currentBoxShadow = BoxShadow.lerpList(glowShadow, noShadow, t);
            }

            Widget animatedWhiteMoon = Transform.translate(
              offset: Offset(translateX, 0),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: currentBoxShadow,
                  ),
                ),
              ),
            );

            return Stack(
              alignment: Alignment.center,
              children: [
                animatedWhiteMoon,
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E272E),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(125),
                    child: Image.asset("assets/images/kish.jpeg",fit: BoxFit.fill,),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
