import 'package:hive/hive.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
class StudentModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final dynamic rollno;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String department;

  @HiveField(4)
  final dynamic phoneno;

  @HiveField(5)
  final String? imageurl;

  StudentModel({
    this.id,
    required this.rollno,
    required this.name,
    required this.department,
    required this.phoneno,
    this.imageurl,
  });
}