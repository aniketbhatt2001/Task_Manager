import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_tasks_app/services/db_service.dart';

import '../blocs/task/task_bloc.dart';

class RemovedTask extends StatefulWidget {
  final int index;

  const RemovedTask({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<RemovedTask> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<RemovedTask> {
  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  isDone = widget.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final _removedTask = state.removedList[widget.index];
        final taskBloc = context.read<TaskBloc>();
        bool isDone = _removedTask.isDone ?? false;

        return Container(
            // height: 20,

            child: ListTile(
          title: Text(
            _removedTask.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration:
                    _removedTask.isDone! ? TextDecoration.lineThrough : null),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Container(
            child: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text('Restore'),
                    onTap: () {
                      context
                          .read<TaskBloc>()
                          .add(RestoreTaskEvent(_removedTask));
                    },
                  ),
                  PopupMenuItem(
                    child: Text('Delete Permanetly '),
                    onTap: () {
                      context
                          .read<TaskBloc>()
                          .add(DeletePermanentlyTaskEvent(_removedTask));
                    },
                  )
                ];
              },
            ),
          ),
        ));
      },
    );
  }
}
