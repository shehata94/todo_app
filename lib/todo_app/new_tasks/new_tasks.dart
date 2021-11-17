
import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';


class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index) =>  taskList(tasks[index]),
        separatorBuilder: (context,index) => separator(),
        itemCount: tasks.length);
  }
}
