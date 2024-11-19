import 'package:flutter/material.dart';
import 'dart:convert';
import '../model/student_model.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentModel student;

  StudentProfileScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? screenWidth * 0.2 : 20, // Adjust padding for larger screens
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05), // Dynamic spacing
              GestureDetector(
                onTap: () {
                  if (student.imageurl != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                                  ),
                                  child: Image.memory(
                                    base64Decode(student.imageurl!),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: student.imageurl != null
                      ? MemoryImage(base64Decode(student.imageurl!)) // Decode from base64
                      : null,
                  child: student.imageurl == null
                      ? Icon(Icons.person, size: 80)
                      : null,
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // Dynamic spacing
              Text(
                student.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Roll No: ${student.rollno}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Department: ${student.department}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Phone Number: ${student.phoneno}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
