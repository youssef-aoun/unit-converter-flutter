import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class VolumeScreen extends StatefulWidget {
  const VolumeScreen({super.key});

  @override
  State<VolumeScreen> createState() => _VolumeScreenState();
}

class _VolumeScreenState extends State<VolumeScreen> {

  final Map<String, TextEditingController> controllers = {
    "m³": TextEditingController(),
    "L": TextEditingController(),
    "cm³": TextEditingController(),
    "mm³": TextEditingController(),
    "yd³": TextEditingController(),
    "ft³": TextEditingController(),
    "in³": TextEditingController(),
    "tbsp": TextEditingController(),
  };

  // Conversion factors (relative to cubic meter)
  final Map<String, double> conversionFactors = {
    "m³": 1.0,
    "L": 1000.0,
    "cm³": 1e-6,
    "mm³": 1e-9,
    "yd³": 1.30795,
    "ft³": 35.3147,
    "in³": 61023.7,
    "tbsp": 0.067628,
  };

  // Update all fields based on the given value and field
  void updateValues({String? field, double? value}) {
    if (field != null && value != null) {
      final baseValue = value * conversionFactors[field]!; // Convert to cubic meter
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
        title: const Text("Volume Conversion"),
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
