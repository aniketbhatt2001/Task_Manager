import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task extends Equatable {
  String title;
  String desc;
  String id;
  String dateTime;
  bool? isDone;
  bool? fav;
  bool? deleted;
  Task(
      {required this.title,
      required this.dateTime,
      required this.desc,
      required this.id,
      this.isDone,
      this.deleted,
      this.fav}) {
    isDone = isDone ?? false;
    deleted = deleted ?? false;
    fav = fav ?? false;
  }

  Task copyWith({
    String? title,
    String? desc,
    bool? isDone,
    bool? deleted,
    bool? isFav,
    String? id,
    String? dateTime,
    bool? fav,
  }) {
    return Task(
        dateTime: dateTime ?? this.dateTime,
        desc: desc ?? this.desc,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
        deleted: deleted ?? this.deleted,
        id: id ?? this.id,
        fav: fav ?? this.fav);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'dateTime': dateTime,
      'desc': desc,
      'isDone': isDone! ? '1' : '0',
      'deleted': deleted! ? '1' : '0',
      'fav': fav! ? '1' : '0'
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      dateTime: map['dateTime'] as String,
      id: map['id'] as String,
      title: map['title'] as String,
      desc: map['desc'] as String,
      isDone: map['isDone'] == '1' ? true : false,
      fav: map['fav'] == '1' ? true : false,
      deleted: map['deleted'] == '1' ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  // TODO: implement props
  List<Object?> get props => [title, isDone, deleted, id, desc, fav, dateTime];
}
