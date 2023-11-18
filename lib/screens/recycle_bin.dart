import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/screens/my_drawer.dart';
import 'package:flutter_tasks_app/screens/tabs_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_tasks_app/models/task_model.dart';

import '../blocs/task/task_bloc.dart';
import '../widgets/add_task.dart';
import '../widgets/removed_task.dart';
import '../widgets/pending_task.dart';

class RecycleBin extends StatefulWidget {
  static const name = 'recycle_bin';
  const RecycleBin({Key? key}) : super(key: key);

  @override
  State<RecycleBin> createState() => _RecycleBinState();
}

class _RecycleBinState extends State<RecycleBin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TaskBloc>().add(FetchTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(TabScreen.name);
        return false;
      },
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: const Text('Recycle Bin '),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            
            if (state is TaskLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Chip(
                    label: Text(
                      '${state.removedList.length} Tasks ',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.removedList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RemovedTask(
                          index: index,
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
    ;
  }
}
