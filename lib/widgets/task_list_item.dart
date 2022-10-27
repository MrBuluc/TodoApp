import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController nameCnt = TextEditingController();
  late LocalStorage localStorage;

  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    nameCnt.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10)
          ]),
      child: ListTile(
        leading: GestureDetector(
          child: Container(
              decoration: BoxDecoration(
                  color: widget.task.isCompleted ? Colors.green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: .8)),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              )),
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            localStorage.updateTask(task: widget.task);
            setState(() {});
          },
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                controller: nameCnt,
                decoration: const InputDecoration(border: InputBorder.none),
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  if (value.length > 3) {
                    widget.task.name = value;
                    localStorage.updateTask(task: widget.task);
                  }
                },
              ),
        trailing: Text(
          DateFormat("hh:mm a").format(widget.task.createdAt),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
