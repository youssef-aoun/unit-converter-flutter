import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LengthScreen extends StatefulWidget {
  const LengthScreen({super.key});

  @override
  State<LengthScreen> createState() => _LengthScreenState();
}

class _LengthScreenState extends State<LengthScreen> {
  final Map<String, TextEditingController> controllers = {
    "km": TextEditingController(),
    "m": TextEditingController(),
    "cm": TextEditingController(),
    "mm": TextEditingController(),
    "mile": TextEditingController(),
    "ft": TextEditingController(),
    "in": TextEditingController(),
    "yd": TextEditingController(),
  };

  final Map<String, double> conversionFactors = {
    "km": 1000.0,
    "m": 1.0,
    "cm": 0.01,
    "mm": 0.001,
    "mile": 1609.34,
    "ft": 0.3048,
    "in": 0.0254,
    "yd": 0.9144,
  };

  void updateValues({String? field, double? value}) {
    if (field != null && value != null) {
      final baseValue = value * conversionFactors[field]!; // Convert to meters
      controllers.forEach((unit, controller) {
        if (unit != field) {
          final convertedValue = baseValue / conversionFactors[unit]!;
          controller.text = convertedValue.toStringAsFixed(4);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Length Conversion"),
        foregroundColor: const Color(0xFFFFFFFF),
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
