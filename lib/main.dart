import 'package:challenges/anmation_chain.dart';
import 'package:challenges/physic_drag.dart';
import 'package:challenges/task_manager.dart';
import 'package:flutter/material.dart';

void main() => runApp(ChallengesApp());

class ChallengesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Challenges',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<_ChallengeItem> challenges = [
    _ChallengeItem('Task Manager', Icons.check_circle, TaskManagerScreen()),
    _ChallengeItem(
      'Physics Drag & Drop',
      Icons.bubble_chart,
      PhysicsDragScreen(),
    ),
    _ChallengeItem('Anmation Chain', Icons.play_arrow, LoadingDots()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Challenges')),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final item = challenges[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(item.icon, color: Colors.teal),
              title: Text(item.title),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.screen),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChallengeItem {
  final String title;
  final IconData icon;
  final Widget screen;

  _ChallengeItem(this.title, this.icon, this.screen);
}
