import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'units/area_screen.dart';
import 'units/length_screen.dart';
import 'units/speed_screen.dart';
import 'units/volume_screen.dart';
import 'units/weight_screen.dart';
import 'units/temperature_screen.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open the drawer when the menu button is pressed
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      // The drawer widget on the left side
      // The drawer widget on the left side
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Adjusting the DrawerHeader
            const DrawerHeader(
              padding: EdgeInsets.symmetric(vertical: 16.0), // Adjusted padding
              decoration: BoxDecoration(
                color: Color(0xFF492084), // Color for the header
              ),
              child: Center(
                child: Text(
                  'Navigation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold, // Ensuring the font is bold
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                // Handle navigation to About Us page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              onTap: () {
                // Handle navigation to Contact Us page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactUsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildCategoryCard(
              title: "Area",
              icon: Icons.square_foot,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AreaScreen()),
                );
              },
            ),
            _buildCategoryCard(
              title: "Length",
              icon: Icons.straighten,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LengthScreen()),
                );
              },
            ),
            _buildCategoryCard(
              title: "Speed",
              icon: Icons.speed,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpeedScreen()),
                );
              },
            ),
            _buildCategoryCard(
              title: "Volume",
              icon: Icons.view_in_ar,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VolumeScreen()),
                );
              },
            ),
            _buildCategoryCard(
              title: "Weight",
              icon: Icons.scale,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeightScreen()),
                );
              },
            ),
            _buildCategoryCard(
              title: "Temperature",
              icon: Icons.thermostat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TemperatureScreen()),
                );
              },
            ),
            _buildCategoryCard(
              title: "Currencies",
              icon: Icons.monetization_on,
              onTap: () {
                // Placeholder for future functionality
              },
              isComingSoon: true,
            ),
            _buildCategoryCard(
              title: "Cryptocurrencies",
              icon: Icons.currency_bitcoin,
              onTap: () {
                // Placeholder for future functionality
              },
              isComingSoon: true,
            ),
          ],
        ),
      ),
    );
  }

  // A helper function to build a single category card
  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isComingSoon = false, // Optional flag for "Coming soon..."
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            if (isComingSoon) // Show the "Coming soon..." text if the flag is true
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Coming soon...",
                  style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final Function(String) f;
  final String hint;

  const MyTextField({required this.hint, required this.f, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 50.0,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        style: const TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint,
        ),
        onChanged: (text) {
          f(text);
        },
      ),
    );
  }
}
