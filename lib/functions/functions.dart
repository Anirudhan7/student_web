import 'package:hive/hive.dart';
import 'package:student_management_web/model/student_model.dart';

Future<void> addStudent(StudentModel student) async {
  final box = Hive.box<StudentModel>('students');
  await box.add(student);
}

Future<List<StudentModel>> getAllStudents() async {
  final box = Hive.box<StudentModel>('students');
  return box.values.toList();
}

Future<void> deleteStudent(int index) async {
  final box = Hive.box<StudentModel>('students');
  await box.deleteAt(index);
}

Future<void> updateStudent(int index, StudentModel updatedStudent) async {
  final box = Hive.box<StudentModel>('students');
  await box.putAt(index, updatedStudent);
}