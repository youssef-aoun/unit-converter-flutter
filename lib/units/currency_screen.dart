import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final Map<String, TextEditingController> controllers = {
    "AUD": TextEditingController(),
    "CAD": TextEditingController(),
    "CHF": TextEditingController(),
    "CNY": TextEditingController(),
    "EUR": TextEditingController(),
    "GBP": TextEditingController(),
    "JPY": TextEditingController(),
    "INR": TextEditingController(),
    "LBP": TextEditingController(),
    "RUB": TextEditingController(),
    "USD": TextEditingController(),
  };

  // This map will store live exchange rates fetched from an API
  Map<String, double> conversionRates = {
    "USD": 1.0,
    "EUR": 0.85,
    "GBP": 0.75,
    "JPY": 110.0,
    "AUD": 1.4,
    "CAD": 1.25,
    "CHF": 0.92,
    "CNY": 6.5,
    "INR": 74.0,
    "LBP": 15000.0,
    "RUB": 73.0,
  };

  @override
  void initState() {
    super.initState();
    fetchConversionRates(); // Fetch live rates when the screen loads
  }

  Future<void> fetchConversionRates() async {
    try {
      // Replace this URL with your PHP backend URL
      // Set your IP:port/code to your backend
      final response = await http.get(Uri.parse('localhost/unit_converter/currency_converter.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['rates'] != null) {
          setState(() {
            // Convert the rates to a Map<String, double>
            conversionRates = Map<String, double>.fromIterable(
              data['rates'].entries,
              key: (entry) => entry.key as String,
              value: (entry) => (entry.value is int ? (entry.value as int).toDouble() : entry.value) as double,
            );

            // Ensure all specified currencies are included
            controllers.keys.forEach((currency) {
              if (!conversionRates.containsKey(currency)) {
                conversionRates[currency] = 0.0; // Default to 0 if not in API
              }
            });
          });
        } else {
          throw Exception('No rates found in API response');
        }
      } else {
        throw Exception('Failed to fetch exchange rates');
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
    }
  }


  void updateValues({String? field, double? value}) {
    if (field != null && value != null) {
      final baseValue = value / conversionRates[field]!; // Convert to USD (or base currency)
      controllers.forEach((currency, controller) {
        if (currency != field) {
          final convertedValue = baseValue * conversionRates[currency]!;
          controller.text = convertedValue.toStringAsFixed(4);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Conversion"),
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
                        entry.key, // Display the currency code (e.g., USD, EUR)
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
