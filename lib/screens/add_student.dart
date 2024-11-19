import 'dart:convert'; // Import for base64 encoding
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_web/functions/functions.dart';
import 'package:student_management_web/model/student_model.dart';
import 'package:student_management_web/screens/student_list.dart';

class AddStudent extends StatefulWidget {
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final rollnoController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final phonenoController = TextEditingController();
  Uint8List? _selectedImage;

  void _setImage(Uint8List image) {
    setState(() {
      _selectedImage = image;
    });
  }

  Future<Uint8List?> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes(); // Read the image as bytes
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Student"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentInfo()),
              );
            },
            icon: Icon(Icons.supervised_user_circle_rounded, size: 30),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? 600 : double.infinity,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    maxRadius: 70,
                    child: GestureDetector(
                      onTap: () async {
                        Uint8List? pickedImage = await _pickImageFromGallery();
                        if (pickedImage != null) {
                          _setImage(pickedImage);
                        }
                      },
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.memory(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                            )
                          : const Icon(Icons.add_a_photo_rounded, size: 50),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Student Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name is required';
                      }
                      if (value.length < 4) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: rollnoController,
                    decoration: const InputDecoration(
                      labelText: "Roll number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Roll no is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: departmentController,
                    decoration: const InputDecoration(
                      labelText: "Department",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Department is required';
                      }
                      if (value.length < 3) {
                        return 'Department name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phonenoController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number is required';
                      }
                      final phoneRegExp = RegExp(r'^[0-9]{10}$');
                      if (!phoneRegExp.hasMatch(value)) {
                        return 'Invalid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: "Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 45),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.orange,
                              content: Text(
                                "Please select an image",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                          return;
                        }
                        final student = StudentModel(
                          rollno: rollnoController.text,
                          name: nameController.text,
                          department: departmentController.text,
                          phoneno: phonenoController.text,
                          imageurl: base64Encode(_selectedImage!),
                        );
                        await addStudent(student);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Data Added Successfully",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        rollnoController.clear();
                        nameController.clear();
                        departmentController.clear();
                        phonenoController.clear();
                        setState(() {
                          _selectedImage = null;
                        });
                      }
                    },
                    child: Text("Save"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
