import 'package:ds250/presentation/home_screen/widgets/task_list.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  final String? data;
  const TaskListScreen({super.key, this.data});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context, "refresh"),
        ),
        title: Text('Lista de tarefas'),
      ),
      body: Column(
        children: [
          Expanded(child: TaskList(onCompleted: onTaskCompleted, data: widget.data,))
        ],
      ),
    );
  }

  void onTaskCompleted() {
    print("Tarefa concluída!");
    // fetchdata();
    setState(() {});
  }
}
