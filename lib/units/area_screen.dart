import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AreaScreen extends StatefulWidget {
  const AreaScreen({super.key});

  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  final Map<String, TextEditingController> controllers = {
    "km²": TextEditingController(),
    "m²": TextEditingController(),
    "cm²": TextEditingController(),
    "mm²": TextEditingController(),
    "mile²": TextEditingController(),
    "ft²": TextEditingController(),
    "in²": TextEditingController(),
    "yd²": TextEditingController(),
  };

  // Conversion factors
  final Map<String, double> conversionFactors = {
    "km²": 1e6,
    "m²": 1,
    "cm²": 1e-4,
    "mm²": 1e-6,
    "mile²": 2589988.11,
    "ft²": 0.092903,
    "in²": 0.00064516,
    "yd²": 0.836127,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Area Conversion"),
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
