import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_web/functions/functions.dart';
import 'package:student_management_web/model/student_model.dart';
import 'package:student_management_web/screens/profile_page.dart';
import 'dart:convert';

class StudentInfo extends StatefulWidget {
  const StudentInfo({Key? key}) : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  late List<StudentModel> _studentsData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<StudentModel> students = await getAllStudents();
    setState(() {
      _studentsData = students;
    });
  }

  Future<void> _searchData() async {
    List<StudentModel> students = await getAllStudents();
    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _studentsData = students;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student.name);
    final TextEditingController rollnoController =
        TextEditingController(text: student.rollno.toString());
    final TextEditingController departmentController =
        TextEditingController(text: student.department);
    final TextEditingController phonenoController =
        TextEditingController(text: student.phoneno.toString());

    Uint8List? selectedImage;

    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedImage = await _pickImageFromGallery();
                  if (pickedImage != null) {
                    setState(() {
                      selectedImage = pickedImage;
                    });
                  }
                },
                child: CircleAvatar(
                  backgroundImage: selectedImage != null
                      ? MemoryImage(selectedImage!)
                      : student.imageurl != null
                          ? MemoryImage(base64Decode(
                              student.imageurl!)) // Decode from base64
                          : null,
                  child: selectedImage == null && student.imageurl == null
                      ? Icon(Icons.person)
                      : null,
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: InputDecoration(labelText: "Phone No"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                  index,
                  StudentModel(
                    id: student.id,
                    rollno: rollnoController.text,
                    name: nameController.text,
                    department: departmentController.text,
                    phoneno: phonenoController.text,
                    imageurl: selectedImage != null
                        ? base64Encode(selectedImage!)
                        : student.imageurl,
                  ));
              Navigator.of(context).pop();
              _fetchStudentsData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Changes Saved Successfully"),
                ),
              );
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes(); // Read the image as bytes
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Information"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  _searchData();
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: "Search by Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _studentsData.isEmpty
          ? Center(child: Text("No students available."))
          : ListView.separated(
              itemBuilder: (context, index) {
                final student = _studentsData[index];
                final imageUrl = student.imageurl;

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentProfileScreen(student: student),
                      ),
                    );
                  },
                  leading: GestureDetector(
                    onTap: () {
                      if (imageUrl != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.memory(base64Decode(
                                      imageUrl)), // Decode from base64
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage: imageUrl != null
                          ? MemoryImage(base64Decode(imageUrl))
                          : null,
                      child: imageUrl == null ? Icon(Icons.person) : null,
                    ),
                  ),
                  title: Text(student.name),
                  subtitle: Text(student.department),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(index);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext) => AlertDialog(
                              title: Text("Delete Student"),
                              content: Text("Are you sure you want to delete?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await deleteStudent(index);
                                    _fetchStudentsData();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content:
                                                Text("Deleted Successfully")));
                                  },
                                  child: Text("Ok"),
                                )
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: _studentsData.length,
            ),
    );
  }
}
