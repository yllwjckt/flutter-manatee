import 'package:flutter/material.dart';

void main() => runApp(const DraggableExampleApp());

class DraggableExampleApp extends StatelessWidget {
  const DraggableExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Manatee')),
        body: const DraggableExample(),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class DraggableExample extends StatefulWidget {
  const DraggableExample({super.key});

  @override
  State<DraggableExample> createState() => _DraggableExampleState();
}

class _DraggableExampleState extends State<DraggableExample> {
  int hungerMeter = 0;
  int happyMeter = 0;

  void increaseMeter(int meterType, int? value) {
    setState(() {
      if (meterType == 1) {
        hungerMeter += value ?? 0;
        hungerMeter = hungerMeter.clamp(0, 100);
      } else if (meterType == 2) {
        happyMeter += value ?? 0;
        happyMeter = happyMeter.clamp(0, 100);
      }
    });
  }

  Widget buildMeterWidget(int hungerValue, int happyValue) {
    String assetPath;

    // Logic for hunger and happy meter
    if (hungerValue == 0 && happyValue == 0) {
      assetPath = 'assets/images/Manatee.png';
    } else if (hungerValue > 0 && hungerValue < 50) {
      assetPath = 'assets/images/Manatee_Hungry.png';
    } else if (hungerValue == 0 && happyValue > 0 && happyValue < 50) {
      assetPath = 'assets/images/Manatee_Crying.png';
    } else if (hungerValue > 50 &&
        hungerValue < 75 &&
        happyValue > 50 &&
        happyValue < 75) {
      assetPath = 'assets/images/Manatee.png';
    } else if (hungerValue > 75 &&
        hungerValue < 100 &&
        happyValue > 75 &&
        happyValue < 100) {
      assetPath = 'assets/images/Manatee_Happy.png';
    } else if (hungerValue == 100 && happyValue == 100) {
      assetPath = 'assets/images/Manatee_Hearts.png';
    } else {
      // Default case (unchanged hungerValue and increasing happyValue)
      assetPath = 'assets/images/Manatee.png';
    }

    return Column(
      children: [
        FloatingManatee(assetPath: assetPath),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          DragTarget<Map<String, int>>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return Container(
                width: 300,
                child: Center(
                  child: Column(
                    children: [
                      buildMeterWidget(hungerMeter, happyMeter),
                    ],
                  ),
                ),
              );
            },
            onAccept: (Map<String, int> data) {
              int meterType = data['meterType']!;
              int value = data['value']!;

              if (meterType == 1 || meterType == 2) {
                increaseMeter(meterType, value);
              }
            },
          ),
          Column(
            children: [
              Container(
                width: 250,
                child: LinearProgressIndicator(
                  value: hungerMeter / 100,
                  backgroundColor: Colors.green,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
                  minHeight: 14,
                ),
              ),
              // Text for Hunger meter
              Text('Manatee\'s hunger meter: $hungerMeter%'),

              Container(
                width: 250,
                child: LinearProgressIndicator(
                  value: happyMeter / 100,
                  backgroundColor: Colors.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  minHeight: 14,
                ),
              ),
              // Text for Hunger meter
              Text('Manatee\'s happy meter: $happyMeter%'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Draggable Leaf
              Draggable<Map<String, int>>(
                // Data is the value this Draggable stores.
                data: {'meterType': 1, 'value': 5},
                feedback: Container(
                  height: 150,
                  width: 150,
                  child: const Center(
                    child: Image(image: AssetImage('assets/images/Leaf.png')),
                  ),
                ),
                childWhenDragging: Container(
                  height: 100,
                  width: 100,
                  child: const Center(
                    child: Image(image: AssetImage('assets/images/Leaf.png')),
                  ),
                ),
                child: Container(
                  height: 100,
                  width: 100,
                  child: const Center(
                    child: Image(image: AssetImage('assets/images/Leaf.png')),
                  ),
                ),
              ),
              // Draggable Gamegal
              Draggable<Map<String, int>>(
                // Data is the value this Draggable stores.
                data: {'meterType': 2, 'value': 5},
                feedback: Container(
                  height: 150,
                  width: 150,
                  child: const Center(
                    child:
                        Image(image: AssetImage('assets/images/Gamegal.png')),
                  ),
                ),
                childWhenDragging: Container(
                  height: 100,
                  width: 100,
                  child: const Center(
                    child:
                        Image(image: AssetImage('assets/images/Gamegal.png')),
                  ),
                ),
                child: Container(
                  height: 100,
                  width: 100,
                  child: const Center(
                    child:
                        Image(image: AssetImage('assets/images/Gamegal.png')),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FloatingManatee extends StatefulWidget {
  final String assetPath;

  const FloatingManatee({required this.assetPath});

  @override
  _FloatingManateeState createState() => _FloatingManateeState();
}

class _FloatingManateeState extends State<FloatingManatee>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 20.0),
          child: child,
        );
      },
      child: Container(
        child: Image(image: AssetImage(widget.assetPath)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}