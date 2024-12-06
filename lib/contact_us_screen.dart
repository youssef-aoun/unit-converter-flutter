import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  // Function to launch a URL (email, GitHub, LinkedIn)
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to copy phone number to clipboard
  Future<void> _copyToClipboard(String phoneNumber) async {
    await Clipboard.setData(ClipboardData(text: phoneNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied phone number to clipboard: $phoneNumber'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        foregroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        backgroundColor: const Color(0xFF492084), // Theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Connect with Us",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF492084),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Reach out to us through any of the following methods:",
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              _buildContactInfo(
                "Youssef Aoun",
                "y.aoun@outlook.com",
                "https://github.com/youssef-aoun",
                "https://www.linkedin.com/in/youssef-aoun-/",
                "+961 76 861 644",
              ),
              const SizedBox(height: 24.0),
              const Divider(
                color: Colors.black26,
                thickness: 1.5,
              ),
              const SizedBox(height: 24.0),
              _buildContactInfo(
                "Adam Ghaddar",
                "aghaddar72@gmail.com",
                "https://github.com/aghaddar",
                "https://www.linkedin.com/in/adam-ghaddar-436403285?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app",
                "+961 3 987 654",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String name, String email, String github, String linkedin, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF492084),
          ),
        ),
        const SizedBox(height: 8.0),
        _buildIconBox(
          label: "Phone",
          icon: Icons.phone,
          content: phone,
          url: "",
          isPhoneNumber: true,
        ),
        const SizedBox(height: 16.0),
        _buildIconBox(
          label: "Email me at",
          icon: Icons.email,
          content: email,
          url: "mailto:$email",
        ),
        const SizedBox(height: 16.0),
        _buildIconBox(
          label: "GitHub",
          icon: Icons.code,
          content: "Explore our code repositories.",
          url: github,
        ),
        const SizedBox(height: 16.0),
        _buildIconBox(
          label: "LinkedIn",
          icon: Icons.linked_camera,
          content: "Connect with us professionally.",
          url: linkedin,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  // Helper widget to build each icon box with effects
  Widget _buildIconBox({
    required String label,
    required IconData icon,
    required String content,
    required String url,
    bool isPhoneNumber = false,
  }) {
    return GestureDetector(
      onTap: isPhoneNumber ? () => _copyToClipboard(content) : () => _launchURL(url),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center( // Center the card in the available space
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400), // Set a fixed max width for all cards
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(icon, size: 40.0, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 8.0),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF492084),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
