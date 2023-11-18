import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_tasks_app/services/app_router.dart';
import 'package:flutter_tasks_app/services/db_service.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../blocs/task/task_bloc.dart';

enum TaskType { completed, pending, favs }

class MyTask extends StatefulWidget {
  final int index;
  final TaskType taskType;
  const MyTask({Key? key, required this.index, required this.taskType})
      : super(key: key);

  @override
  State<MyTask> createState() => _TaskState();
}

class _TaskState extends State<MyTask> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final _task = widget.taskType == TaskType.completed
            ? state.completed[widget.index]
            : widget.taskType == TaskType.pending
                ? state.pendingList[widget.index]
                : state.favList[widget.index];
        final taskBloc = context.read<TaskBloc>();
        bool isDone = _task.isDone ?? false;
        bool _isFav = _task.fav ?? false;
        String originalDateTimeString = _task.dateTime;

        // Parse the original date-time string
        String formattedDate =
            DateFormat('MMMMd').format(DateTime.parse(originalDateTimeString));

        // Format the date in MM-dd format

        return Dismissible(
          direction: DismissDirection.horizontal,
          background: Container(color: Colors.red.shade300),
          onDismissed: (direction) {
            taskBloc.add(DeleteTaskEvent(_task));
          },
          key: UniqueKey(),
          child: ExpandedTile(
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.black,
            ),
            theme: ExpandedTileThemeData(
              headerColor: Colors.grey.shade50,
              headerRadius: 12.0,
              headerPadding: const EdgeInsets.all(12.0),
              contentPadding: const EdgeInsets.all(24.0),
              contentRadius: 12.0,
            ),
            contentseparator: 0,
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _task.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration:
                                isDone ? TextDecoration.lineThrough : null),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      taskBloc
                          .add(UpdateTaskEvent(_task.copyWith(fav: !_isFav)));
                    },
                    icon: Icon(
                      _isFav ? Icons.star : Icons.star_outline,
                      color: Colors.black,
                    )),
                Container(
                  height: 10,
                  child: Checkbox(
                    activeColor: Colors.black,
                    value: isDone,
                    onChanged: (value) {
                      taskBloc.add(
                          UpdateTaskEvent(_task.copyWith(isDone: !isDone)));
                    },
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Title :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _task.title,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Description :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  _task.desc,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            controller: ExpandedTileController(),
          ),
        );
      },
    );
  }
}
