import 'package:hive/hive.dart';

part 'notes_model.g.dart'; // 👈 VERY IMPORTANT

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  int Color;


  NotesModel({
    required this.title,
    required this.description,
    required this.Color,
  });
}
