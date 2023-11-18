import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tasks_app/screens/completed_task.dart';

import 'package:flutter_tasks_app/screens/tasks_screen.dart';

import '../blocs/task/task_bloc.dart';
import '../services/db_service.dart';
import '../widgets/add_task.dart';
import 'my_drawer.dart';

class TabScreen extends StatefulWidget {
  static const name = 'tab_screen';
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selceltedPageindex = 0;
  final List<Map<String, dynamic>> _pageDetails = [
    {'name': const PendingTasksScreen(), 'title': "Pending Task "},
    {'name': const CompletedtaskScreen(), 'title': "Completed Task "},
  ];

  void _addTask() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
            value: context.read<TaskBloc>(), child: AddTask());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('tab screen builded');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Tasks'),
        ),
        drawer: const MyDrawer(),
        body: _pageDetails[_selceltedPageindex]['name'],
        bottomNavigationBar: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return BottomNavigationBar(
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                iconSize: 32,
                currentIndex: _selceltedPageindex,
                onTap: (value) {
                  setState(() {
                    if (value == 2) {
                      return;
                    }
                    _selceltedPageindex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Container(
                        child: Stack(
                          children: [
                            const Icon(Icons.list),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${state.pendingList.length} ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                //  margin: EdgeInsets.only(left: 20, bottom: 5),
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            )
                          ],
                        ),
                      ),
                      label: 'Pending Tasks'),
                  BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          const Icon(Icons.done),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${state.completed.length}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              //  margin: EdgeInsets.only(left: 20, bottom: 5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                        ],
                      ),
                      label: 'Completed Tasks '),
                  BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          const Icon(Icons.star),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '${state.completed.length}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              //  margin: EdgeInsets.only(left: 20, bottom: 5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                        ],
                      ),
                      label: 'Favourite Tasks '),
                ]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTask();
          },
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
