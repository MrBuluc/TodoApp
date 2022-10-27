import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_view_builder.dart';

import '../helper/translation_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> allTasks;
  late LocalStorage localStorage;

  @override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
    allTasks = <Task>[];
    getAllTaskFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
            child: const Text(
              "title",
              style: TextStyle(color: Colors.black),
            ).tr(),
            onTap: () {
              _showAddTaskBottomSheet();
            },
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearchPage();
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddTaskBottomSheet();
              },
            )
          ],
        ),
        body: allTasks.isNotEmpty
            ? TaskListViewBuilder(allTasks: allTasks)
            : Center(
                child: const Text("empty_task_list").tr(),
              ));
  }

  getAllTaskFromDB() async {
    allTasks = await localStorage.getAllTask();
    setState(() {});
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          MediaQueryData mediaQueryData = MediaQuery.of(context);
          return Container(
            padding: EdgeInsets.only(bottom: mediaQueryData.viewInsets.bottom),
            width: mediaQueryData.size.width,
            child: ListTile(
              title: TextField(
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    hintText: "add_task".tr(), border: InputBorder.none),
                autofocus: true,
                onSubmitted: (value) {
                  Navigator.pop(context);
                  if (value.length > 3) {
                    DatePicker.showTimePicker(context,
                        locale: TranslationHelper.getDeviceLanguage(context),
                        showSecondsColumn: false, onConfirm: (time) async {
                      Task newTask = Task.create(name: value, createdAt: time);
                      allTasks.insert(0, newTask);
                      await localStorage.addTask(task: newTask);
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          );
        });
  }

  showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: allTasks));
    getAllTaskFromDB();
  }
}
