import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Drag'),
        ),
        body: const Drag(),
      ),
    );
  }
}

class Drag extends StatefulWidget {
  const Drag({
    Key? key,
  }) : super(key: key);

  @override
  State<Drag> createState() => _DragState();
}

class _DragState extends State<Drag> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _animation;
  var _alignment = Alignment.center;
  late Size size;
  double xDown = 0, yDown = 0;
  double xCenter = 0, yCenter = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.addListener(() {
      setState(() {
        _alignment = _animation.value;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _alignment,
      child: GestureDetector(
        onPanDown: (details) {
          xCenter = details.globalPosition.dx;
          yCenter = details.globalPosition.dy;
          _animationController.stop();
        },
        onPanUpdate: (details) {
          var x = (details.delta.dx) / (size.width / 2);
          var y = (details.delta.dy) / (size.height / 2);
          setState(() {
            _alignment += Alignment(x, y);
          });
        },
        onPanEnd: (details) {
          _animation = Tween<Alignment>(
            begin: _alignment,
            end: Alignment.center,
          ).animate(_animationController);

          var simulation = SpringSimulation(
            const SpringDescription(mass: 30, stiffness: 1, damping: 1),
            0,
            1,
            10,
          );
          _animationController.animateWith(simulation);
        },
        child: const Card(
          child: FlutterLogo(
            size: 90,
          ),
        ),
      ),
    );
  }
}
