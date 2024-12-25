import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoCurrencyScreen extends StatefulWidget {
  const CryptoCurrencyScreen({super.key});

  @override
  State<CryptoCurrencyScreen> createState() => _CryptoCurrencyScreenState();
}

class _CryptoCurrencyScreenState extends State<CryptoCurrencyScreen> {
  final Map<String, TextEditingController> controllers = {
    "BNB": TextEditingController(),
    "BTC": TextEditingController(),
    "DOGE": TextEditingController(),
    "ETH": TextEditingController(),
    "USDT": TextEditingController(),
    "XRP": TextEditingController(),
  };

  // This map will store live exchange rates fetched from an API
  Map<String, double> conversionRates = {
    "BNB": 1.0,
    "BTC": 0.85,
    "DOGE": 0.75,
    "ETH": 110.0,
    "USDT": 1.4,
    "XRP": 2,
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
      final response = await http.get(Uri.parse('localhost/unit_converter/crypto_currency_converter.php'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['rates'] != null) {
          setState(() {
            conversionRates = Map<String, double>.from(data['rates']);

            // Fix the USDT conversion rate (set it to 1.0)
            conversionRates['USDT'] = 1.0; // Make USDT behave as 1 USD

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
      // Check if the updated field is "USDT"
      if (field == "USDT") {
        controllers.forEach((currency, controller) {
          if (currency != field) {
            final convertedValue = value * conversionRates[currency]!; // Convert directly from USDT to other currencies
            controller.text = convertedValue.toStringAsFixed(4);
          }
        });
      } else {
        // If the updated field is not "USDT", treat it as a different base currency
        final baseRate = conversionRates[field]!;

        controllers.forEach((currency, controller) {
          if (currency != field) {
            // Convert from the base currency (e.g., BTC) to USDT first
            final usdtValue = value * baseRate;
            // Then convert from USDT to the target currency
            final convertedValue = usdtValue / conversionRates[currency]!;
            controller.text = convertedValue.toStringAsFixed(4);
          }
        });
      }
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
