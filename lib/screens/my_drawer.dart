import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/blocs/theme/bloc/theme_bloc.dart';

import 'package:flutter_tasks_app/screens/recycle_bin.dart';
import 'package:flutter_tasks_app/screens/tabs_screen.dart';
import 'package:flutter_tasks_app/screens/tasks_screen.dart';

import '../blocs/task/task_bloc.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Drawer(
          child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) => Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Task Drawer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(TabScreen.name),
              leading: Icon(Icons.folder_special),
              title: Text('My Tasks'),
              trailing: Text('${state.pendingList.length}'),
            ),
            Divider(),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(RecycleBin.name),
              leading: Icon(Icons.delete),
              title: Text('Bin'),
              trailing: Text('${state.removedList.length}'),
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Switch(
                  onChanged: (bool value) {
                    setState(() {
                      value = !value;
                    });
                    value
                        ? context.read<ThemeBloc>().add(ThemeLightEvent())
                        : context.read<ThemeBloc>().add(ThemeDarkEvent());
                  },
                  value: state.switchValue,
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
