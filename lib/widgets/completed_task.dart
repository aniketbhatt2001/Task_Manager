// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
// import 'package:flutter_tasks_app/services/app_router.dart';
// import 'package:flutter_tasks_app/services/db_service.dart';
// import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';

// import '../blocs/task/task_bloc.dart';

// class CompletedTask extends StatefulWidget {
//   final int index;

//   const CompletedTask({
//     Key? key,
//     required this.index,
//   }) : super(key: key);

//   @override
//   State<CompletedTask> createState() => _CompletedTaskState();
// }

// class _CompletedTaskState extends State<CompletedTask> {
//   bool isDone = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //  isDone = widget.isDone;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TaskBloc, TaskState>(
//       builder: (context, state) {
//         final _task = state.completed[widget.index];
//         final taskBloc = context.read<TaskBloc>();
//         bool isDone = _task.isDone ?? false;
//         // var dateTime = DateTime.fromMillisecondsSinceEpoch(
//         //     extractTimestampFromUuid(_task.id));
//         // var formattedDate = DateFormat('MM-dd').format(dateTime);
//         //(dateTime.toString());
//         //  (_task.id);

//         return Dismissible(
//           direction: DismissDirection.horizontal,
//           background: Container(color: Colors.red.shade300),
//           onDismissed: (direction) {
//             taskBloc.add(DeleteTaskEvent(_task));
//           },
//           key: UniqueKey(),
//           child: Container(
//               child: ExpandedTile(
//             trailing: const Icon(
//               Icons.chevron_right,
//               color: Colors.black,
//             ),
//             theme: ExpandedTileThemeData(
//               headerColor: Colors.grey.shade50,
//               headerRadius: 12.0,
//               headerPadding: EdgeInsets.all(12.0),
//               contentPadding: EdgeInsets.all(24.0),
//               contentRadius: 12.0,
//             ),
//             contentseparator: 0,
//             title: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _task.title,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             decoration: _task.isDone!
//                                 ? TextDecoration.lineThrough
//                                 : null),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         _task.dateTime,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 12,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 10,
//                   child: Checkbox(
//                     activeColor: Colors.black,
//                     // checkColor: Colors.black,
//                     //   side: BorderSide(color: Colors.black, width: 2),
//                     value: isDone,
//                     onChanged: (value) {
//                       taskBloc.add(
//                           UpdateTaskEvent(_task.copyWith(isDone: !isDone)));
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     'Title :',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Text(
//                   _task.title,
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     'Description :',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   _task.desc,
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ],
//             ),
//             controller: ExpandedTileController(),
//           )),
//         );
//       },
//     );
//   }
// }
