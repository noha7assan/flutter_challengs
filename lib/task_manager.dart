import 'package:flutter/material.dart';

class Task {
  String title;
  bool isDone;
  Task(this.title, {this.isDone = false});
}

class TaskManagerScreen extends StatefulWidget {
  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  List<Task> tasks = [
    Task('study clean architecture'),
    Task('widgets tour'),
    Task('problem solving'),
    Task('ui ux design'),
  ];

  Task? recentlyDeletedTask;
  int? recentlyDeletedIndex;

  Future<bool> _confirmDismiss(BuildContext context, String task) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete "$task"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showUndoSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (recentlyDeletedTask != null && recentlyDeletedIndex != null) {
              setState(() {
                tasks.insert(recentlyDeletedIndex!, recentlyDeletedTask!);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: task.isDone ? Colors.grey[300] : Colors.white,
        boxShadow: task.isDone
            ? [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ]
            : [],
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        value: task.isDone,
        onChanged: (val) {
          setState(() {
            task.isDone = val ?? false;
          });
        },
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isDone ? Colors.black54 : Colors.black,
          ),
        ),
        secondary: Icon(Icons.drag_handle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, item);
          });
        },
        children: [
          for (int index = 0; index < tasks.length; index++)
            Dismissible(
              key: ValueKey(tasks[index].title),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) =>
                  _confirmDismiss(context, tasks[index].title),
              onDismissed: (_) {
                setState(() {
                  recentlyDeletedTask = tasks[index];
                  recentlyDeletedIndex = index;
                  tasks.removeAt(index);
                });
                _showUndoSnackbar();
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: _buildTaskTile(tasks[index], index),
            ),
        ],
      ),
    );
  }
}
