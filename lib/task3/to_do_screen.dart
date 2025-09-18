import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoTask {
  String title;
  bool isDone;

  TodoTask({required this.title,this.isDone = false});
  Map<String,dynamic> toJson() => {
    "title" : title,
    "isDone":isDone
  };

  factory TodoTask.fromJson(Map<String,dynamic>json) => TodoTask(
      title:json["title"],
  isDone: json["isDone"]);
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _controller = TextEditingController();
  List<TodoTask> _tasks = [];

  @override
  void initState() {

    super.initState();
    _loadTasks();

  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString("tasks");
    if(tasksString != null){
      final List decoded = jsonDecode(tasksString);
      setState(() {
        _tasks = decoded.map((e) => TodoTask.fromJson(
            e)).toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_tasks.map((e) => e.toJson()).toList());
    await prefs.setString("tasks",encoded);

  }

  void _addTask(String title){
    if(title.trim().isEmpty) return;
    setState(() {
      _tasks.add(TodoTask(title: title));
      _controller.clear();

    });
    _saveTasks();
  }

  void _toggleTask(int index){
    setState(() {
      _tasks[index].isDone =!_tasks[index].isDone;

    });
    _saveTasks();
  }

  void _deleteTask(int index){
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple,
        title: Text('To Do App',
        style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: TextField(controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter Task",
                border: OutlineInputBorder(),

              ),),
              ),
              const SizedBox(width: 8,),
              ElevatedButton(onPressed: ()=> _addTask(_controller.text),
                  child: Text("Add")),


            ],
          ),),Expanded(child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context,index){
                final task = _tasks[index];
                return Dismissible(
                  key:ValueKey(task.title + index.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_)=> _deleteTask(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20
                    ),
                    child: Icon(Icons.delete,color: Colors.white,),
                  ),
                  child:ListTile(
                    leading: Checkbox(
                      value:task.isDone,
                      onChanged: (_)=> _toggleTask(index),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                          decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none
                      ),
                    ),  ),
                );
              },
          ),
          ),
        ],
      ),
    );
  }
}
