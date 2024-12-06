import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {

  final Map<String, TextEditingController> controllers = {
    "kg": TextEditingController(),
    "g": TextEditingController(),
    "mg": TextEditingController(),
    "lb": TextEditingController(),
    "oz": TextEditingController(),
    "ton": TextEditingController(),
  };

  // Conversion factors (relative to kilogram)
  final Map<String, double> conversionFactors = {
    "kg": 1,          // Kilogram to kilogram (1 kg = 1 kg)
    "g": 1000,        // 1 kg = 1000 g
    "mg": 1000000,          // 1 kg = 1,000,000 mg
    "lb": 2.20462,      // 1 kg = 2.20462 lb
    "oz": 35.3740,       // 1 kg = 35.274 oz
    "ton": 0.00110231,   // 1 kg = 0.0009842 ton
  };

  // Update all fields based on the given value and field
  void updateValues({String? field, double? value}) {
    if (field != null && value != null) {
      final baseValue = value * conversionFactors[field]!; // Convert to kilograms (kg)
      controllers.forEach((unit, controller) {
        if (unit != field) {
          final convertedValue = conversionFactors[unit]! * baseValue; // Convert from kg to the other units
          controller.text = convertedValue.toStringAsFixed(4); // Update text with 4 decimal places
        }
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weight Conversion"),
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
