import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF492084), // Using your theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About Us",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "We are two students from Lebanese International University (LIU), currently working on our senior year projects. Here’s a little about us:",
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
              const SizedBox(height: 24.0),
              _buildStudentProfile(
                "Youssef Aoun",
                "I am currently in my final semester at LIU. In Spring 2024, I developed my senior project called AttendIt, an event management system. It was a challenging yet rewarding experience where I applied my skills in system design using React Native, backend development with Spring Boot, and database management with MySQL. I have learned a lot through this project, and I’m excited to take on the next challenge in my career.",
              ),
              const SizedBox(height: 24.0),
              _buildStudentProfile(
                "Adam Ghaddar",
                "I will be starting my final semester and working on my final year project next semester. Throughout our studies, Youssef and I have collaborated on several projects, and I have gained a lot of knowledge and experience. I’m looking forward to tackling the challenges of my final project, and I’m eager to apply my skills to make it a success.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentProfile(String name, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
          style: const TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
      ],
    );
  }
}
