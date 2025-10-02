import 'package:flutter/material.dart';

class PhysicsDragScreen extends StatefulWidget {
  @override
  _PhysicsDragScreenState createState() => _PhysicsDragScreenState();
}

class _PhysicsDragScreenState extends State<PhysicsDragScreen> {
  final List<Color> ballColors = [Colors.red, Colors.green, Colors.blue];
  final Map<Color, bool> matched = {};

  @override
  void initState() {
    super.initState();
    for (var color in ballColors) {
      matched[color] = false;
    }
  }

  Color applyOpacity(Color color, double opacity) {
    return color.withValues(alpha: 127);
  }

  Widget buildDraggableBall(Color color) {
    return Draggable<Color>(
      data: color,
      feedback: CircleAvatar(
        radius: 30,
        backgroundColor: applyOpacity(color, 0.7),
      ),
      childWhenDragging: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[300],
      ),
      child: CircleAvatar(radius: 30, backgroundColor: color),
    );
  }

  Widget buildDropTarget(Color color) {
    return DragTarget<Color>(
      builder: (context, candidateData, rejectedData) {
        bool isActive = candidateData.isNotEmpty;
        return Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: matched[color]!
                ? applyOpacity(color, 0.5)
                : Colors.green[200],
            border: Border.all(color: color, width: 3),
            boxShadow: isActive
                ? [BoxShadow(color: applyOpacity(color, 0.5), blurRadius: 8)]
                : [],
          ),
          child: Center(
            child: matched[color]!
                ? Icon(Icons.check, color: color, size: 30)
                : Text('Drop', style: TextStyle(color: color)),
          ),
        );
      },
      onWillAcceptWithDetails: (details) => true,
      onAccept: (data) {
        setState(() {
          if (data == color) {
            matched[color] = true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Wrong match! Try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Physics Simulation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text(
            //   'Drag the balls into matching containers',
            //   style: TextStyle(fontSize: 18),
            // ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ballColors
                  .map((color) => buildDraggableBall(color))
                  .toList(),
            ),
            SizedBox(height: 300),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ballColors
                  .map((color) => buildDropTarget(color))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
