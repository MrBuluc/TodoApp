import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';

import '../models/task_model.dart';
import 'task_list_item.dart';

class TaskListViewBuilder extends StatefulWidget {
  List<Task> allTasks;
  TaskListViewBuilder({Key? key, required this.allTasks}) : super(key: key);

  @override
  State<TaskListViewBuilder> createState() => _TaskListViewBuilderState();
}

class _TaskListViewBuilderState extends State<TaskListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Task task = widget.allTasks[index];
        return Dismissible(
          key: Key(task.id),
          child: TaskItem(
            task: task,
          ),
          onDismissed: (direction) async {
            widget.allTasks.removeAt(index);
            await locator<LocalStorage>().deleteTask(task: task);
            setState(() {});
          },
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text("remove_task").tr()
            ],
          ),
        );
      },
      itemCount: widget.allTasks.length,
    );
  }
}
