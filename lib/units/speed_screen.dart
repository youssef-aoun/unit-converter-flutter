import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SpeedScreen extends StatefulWidget {
  const SpeedScreen({super.key});

  @override
  State<SpeedScreen> createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {

  final Map<String, TextEditingController> controllers = {
    "km/h": TextEditingController(),
    "mile/h": TextEditingController(),
    "cm/s": TextEditingController(),
    "m/s": TextEditingController(),
    "mm/s": TextEditingController(),
  };

// Conversion factors
  final Map<String, double> conversionFactors = {
    "km/h": 1,
    "mile/h": 1.60934,
    "cm/s": 0.036,
    "m/s": 3.6,
    "mm/s": 0.0036,
  };

  // Update all fields based on the given value and field
  void updateValues({String? field, double? value}) {
    if (field != null && value != null) {
      final baseValue = value * conversionFactors[field]!; // Convert to m²
      controllers.forEach((unit, controller) {
        if (unit != field) {
          final convertedValue = baseValue / conversionFactors[unit]!;
          controller.text = convertedValue.toStringAsFixed(4);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speed Conversion"),foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF492084),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: controllers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key, // Display the unit name (e.g., km², m²)
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF492084),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: entry.value,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter value",
                          hintStyle: const TextStyle(fontSize: 14.0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            final newValue = double.tryParse(text);
                            if (newValue != null) {
                              updateValues(field: entry.key, value: newValue);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
