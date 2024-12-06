import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {


  final Map<String, TextEditingController> controllers = {
    "Celsius": TextEditingController(),
    "Fahrenheit": TextEditingController(),
    "Kelvin": TextEditingController(),
    "Rankine": TextEditingController(),
  };

  // Conversion functions
  double celsiusToFahrenheit(double celsius) => celsius * 9 / 5 + 32;
  double celsiusToKelvin(double celsius) => celsius + 273.15;
  double celsiusToRankine(double celsius) => celsius * 9 / 5 + 491.67;

  double fahrenheitToCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;
  double fahrenheitToKelvin(double fahrenheit) => (fahrenheit - 32) * 5 / 9 + 273.15;
  double fahrenheitToRankine(double fahrenheit) => fahrenheit + 459.67;

  double kelvinToCelsius(double kelvin) => kelvin - 273.15;
  double kelvinToFahrenheit(double kelvin) => (kelvin - 273.15) * 9 / 5 + 32;
  double kelvinToRankine(double kelvin) => kelvin * 9 / 5;

  double rankineToCelsius(double rankine) => (rankine - 491.67) * 5 / 9;
  double rankineToFahrenheit(double rankine) => rankine - 459.67;
  double rankineToKelvin(double rankine) => rankine * 5 / 9;


  void updateValues({String? field, double? value}) {
    if (field != null && value != null) {
      double baseValue;
      if (field == "Celsius") {
        baseValue = value;
        controllers["Fahrenheit"]!.text = celsiusToFahrenheit(baseValue).toStringAsFixed(4);
        controllers["Kelvin"]!.text = celsiusToKelvin(baseValue).toStringAsFixed(4);
        controllers["Rankine"]!.text = celsiusToRankine(baseValue).toStringAsFixed(4);
      } else if (field == "Fahrenheit") {
        baseValue = fahrenheitToCelsius(value);
        controllers["Celsius"]!.text = baseValue.toStringAsFixed(4);
        controllers["Kelvin"]!.text = fahrenheitToKelvin(value).toStringAsFixed(4);
        controllers["Rankine"]!.text = fahrenheitToRankine(value).toStringAsFixed(4);
      } else if (field == "Kelvin") {
        baseValue = kelvinToCelsius(value);
        controllers["Celsius"]!.text = baseValue.toStringAsFixed(4);
        controllers["Fahrenheit"]!.text = kelvinToFahrenheit(value).toStringAsFixed(4);
        controllers["Rankine"]!.text = kelvinToRankine(value).toStringAsFixed(4);
      } else if (field == "Rankine") {
        baseValue = rankineToCelsius(value);
        controllers["Celsius"]!.text = baseValue.toStringAsFixed(4);
        controllers["Fahrenheit"]!.text = rankineToFahrenheit(value).toStringAsFixed(4);
        controllers["Kelvin"]!.text = rankineToKelvin(value).toStringAsFixed(4);
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Temperature Conversion"),
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
