import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../models/task_model.dart';

class DBService {
  DBService._();

  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    print('retriving db...');
    _database = await initDatabase();

    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    final absolutePath = join(path, 'tasks_database.db');
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.

      absolutePath,
      // When the database is first created, create a table to store tasks.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, isDone TEXT , deleted TEXT , desc TEXT, dateTime TEXT )',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    ('getDbPath $absolutePath');

    return database;
  }

  // Define a function that inserts tasks into the database
  static Future<void> insertTask(Task task) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Task into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same task is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    (db);
  }

// A method that retrieves all the tasks from the tasks table.
  static Future<List<Task>> tasks() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Tasks.
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(maps.length, (i) {
      return Task(
        dateTime: maps[i]['dateTime'] as String,
        id: maps[i]['id'] as String,
        title: maps[i]['title'] as String,
        desc: maps[i]['desc'] as String,
        isDone: maps[i]['isDone'] == '1' ? true : false,
        deleted: maps[i]['deleted'] == '1' ? true : false,
      );
    });
  }

  static Future<void> updateTask(Task task) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Task.

    await db.update(
      'tasks',
      task.toMap(),
      // Ensure that the Task has a matching id.
      where: 'id = ?',
      // Pass the Task's id as a whereArg to prevent SQL injection.
      whereArgs: [task.id],
    );
  }

  // static Future<Task?> fetchTask(Task task) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> result = await db.query(
  //     'tasks', // Replace with the actual table name
  //     where: 'id = ?',
  //     whereArgs: [task.id],
  //   );
  //   if (result.isNotEmpty) {
  //     // The task information is available in the result list.
  //     Map<String, dynamic> taskInfo = result.first;

  //     // Access specific information, for example, the task's name:
  //     String taskName = taskInfo['title'];
  //     // Use the fetched information as needed.
  //     ('Task Name: $taskName');
  //     return Task.fromMap(taskInfo);
  //   } else {
  //     // Task with the specified ID not found.
  //     ('Task not found.');
  //   }
  // }

  static Future<void> deleteTask(String id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'tasks',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
