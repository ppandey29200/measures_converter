import 'package:flutter/material.dart';

void main() {
  runApp(MeasuresConverter());
}

/// The main application widget.
class MeasuresConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConversionHomePage(),
    );
  }
}

/// The home page of the conversion app.
class ConversionHomePage extends StatefulWidget {
  @override
  _ConversionHomePageState createState() => _ConversionHomePageState();
}

class _ConversionHomePageState extends State<ConversionHomePage> {
  String _selectedFromUnit = 'Meters';
  String _selectedToUnit = 'Feet';
  double _inputValue = 0.0;
  double _convertedValue = 0.0;
  bool _showOutput = false;
  bool _showWarning = false;

  /// Conversion rates between different units.
  final Map<String, double> _conversionRates = {
    'Meters to Feet': 3.28084,
    'Feet to Meters': 0.3048,
    'Miles to Meters': 1609.34,
    'Meters to Miles': 0.000621371,
    'Miles to Feet': 5280.0,
    'Feet to Miles': 0.000189394,
    'Kilograms to Pounds': 2.20462,
    'Pounds to Kilograms': 0.453592,
  };

  /// Returns the list of units to convert to based on the selected from unit.
  List<String> _getToUnits(String fromUnit) {
    if (fromUnit == 'Meters' || fromUnit == 'Feet' || fromUnit == 'Miles') {
      return ['Meters', 'Feet', 'Miles'].where((unit) => unit != fromUnit).toList();
    } else if (fromUnit == 'Kilograms' || fromUnit == 'Pounds') {
      return ['Kilograms', 'Pounds'].where((unit) => unit != fromUnit).toList();
    } else {
      return [];
    }
  }

  /// Converts the input value based on the selected units.
  void _convert() {
    if (_selectedFromUnit == _selectedToUnit) {
      setState(() {
        _convertedValue = _inputValue;
      });
    } else {
      String conversionKey = '$_selectedFromUnit to $_selectedToUnit';
      double conversionRate = _conversionRates[conversionKey] ?? 1.0;
      setState(() {
        _convertedValue = _inputValue * conversionRate;
      });
    }
    setState(() {
      _showOutput = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Measures Converter',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text('Value', style: TextStyle(fontSize: 16.0))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Slightly thicker border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0), // Slightly thicker border
                  ),
                ),
                style: TextStyle(color: Colors.blue),
                onChanged: (String value) {
                  setState(() {
                    _inputValue = double.tryParse(value) ?? 0.0;
                    _showWarning = double.tryParse(value) == null && value.isNotEmpty;
                    _showOutput = false;
                  });
                },
              ),
            ),
            if (_showWarning)
              Center(
                child: Text(
                  'Invalid Input',
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
              ),
            SizedBox(height: 8.0),
            Center(child: Text('From', style: TextStyle(fontSize: 16.0))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0), // Remove space between hover color and border bottom
                    ),
                    isEmpty: _selectedFromUnit == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFromUnit,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFromUnit = newValue!;
                            _selectedToUnit = _getToUnits(_selectedFromUnit).first;
                            _showOutput = false;
                          });
                        },
                        items: <String>['Meters', 'Feet', 'Miles', 'Kilograms', 'Pounds'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              color: Colors.transparent, // Remove active background color
                              child: Text(value, style: TextStyle(color: Colors.blue)),
                            ),
                          );
                        }).toList(),
                        style: TextStyle(color: Colors.blue),
                        dropdownColor: Colors.white, // Set hover color to white
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.0),
            Center(child: Text('To', style: TextStyle(fontSize: 16.0))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0), // Remove space between hover color and border bottom
                    ),
                    isEmpty: _selectedToUnit == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedToUnit,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedToUnit = newValue!;
                            _showOutput = false;
                          });
                        },
                        items: _getToUnits(_selectedFromUnit).map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              color: Colors.transparent, // Remove active background color
                              child: Text(value, style: TextStyle(color: Colors.blue)),
                            ),
                          );
                        }).toList(),
                        style: TextStyle(color: Colors.blue),
                        dropdownColor: Colors.white, // Set hover color to white
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _convert,
                child: Text(
                  'Convert',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                  foregroundColor: Colors.blue, // Text color
                  minimumSize: Size(150, 40), // Button size
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Equal spacing
                ),
              ),
            ),
            SizedBox(height: 16.0),
            if (_showOutput)
              Center(
                child: Text(
                  '$_inputValue $_selectedFromUnit are ${_convertedValue.toStringAsFixed(3)} $_selectedToUnit',
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}