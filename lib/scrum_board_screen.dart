import 'package:flutter/material.dart';

class ScrumboardScreen extends StatefulWidget {
  @override
  _ScrumboardScreenState createState() => _ScrumboardScreenState();
}

class _ScrumboardScreenState extends State<ScrumboardScreen> {
  // List of all tasks with their names and statuses
  List<Task> allTasks = [
    Task('Task 1', TaskStatus.backlog),
    Task('Task 2', TaskStatus.backlog),
    Task('Task 3', TaskStatus.inProgress),
    Task('Task 4', TaskStatus.done),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrumboard'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Column for the "Backlog" column
            Column(
              children: [
                Text('Backlog'),
                SizedBox(height: 20),
                buildDragTarget(TaskStatus.backlog),
              ],
            ),
            // Column for the "In Progress" column
            Column(
              children: [
                Text('In Progress'),
                SizedBox(height: 20),
                buildDragTarget(TaskStatus.inProgress),
              ],
            ),
            // Column for the "Done" column
            Column(
              children: [
                Text('Done'),
                SizedBox(height: 20),
                buildDragTarget(TaskStatus.done),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for creating draggable tasks
  Widget buildDraggable(Task task) {
    return Draggable(
      data: task,
      feedback: Material(
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(task.name),
        ),
      ),
      childWhenDragging: Container(),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(task.name),
      ),
    );
  }

  // Widget for creating drag targets for different task statuses
  Widget buildDragTarget(TaskStatus targetStatus) {
    return DragTarget<Task>(
      onAccept: (task) {
        // Update the task's status when it's dropped onto a target
        setState(() {
          task.status = targetStatus;
        });
      },
      builder: (context, candidateData, rejectedData) {
        // Filter tasks based on their status
        List<Task> tasksInColumn = allTasks.where((task) => task.status == targetStatus).toList();

        return Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
          child: ListView.builder(
            itemCount: tasksInColumn.length,
            itemBuilder: (context, index) {
              // Build draggable tasks within the column
              return buildDraggable(tasksInColumn[index]);
            },
          ),
        );
      },
    );
  }
}

// Enum for different task statuses
enum TaskStatus {
  backlog,
  inProgress,
  done,
}

// Class representing a task
class Task {
  String name;
  TaskStatus status;

  Task(this.name, this.status);
}
