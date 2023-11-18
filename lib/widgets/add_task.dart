import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../blocs/task/task_bloc.dart';

class AddTask extends StatefulWidget {
  AddTask({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final titleClr = TextEditingController();

  final descClr = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Add Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    label: Text('Title'),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                controller: titleClr,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(
                    label: Text('Description'),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
                controller: descClr,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        if (titleClr.text.trim().isEmpty ||
                            descClr.text.trim().isEmpty) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                              content: Text('Enter Title and Decription')));
                          return;
                        }
                        var now = DateTime.now();

                        // Format the date-time as a string in "MM-dd" format
                        var formattedDate = DateFormat('MMMM dd').format(now);
                        final task = Task(
                            dateTime: formattedDate,
                            desc: descClr.text,
                            title: titleClr.text.trim(),
                            id: const Uuid().v1());
                        ctx.read<TaskBloc>().add(AddTaskEvent(task));
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Add')),
                ],
              ),
            )
          ],
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      ),
    );
    ;
  }
}
