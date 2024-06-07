import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Strip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestStripScreen(),
    );
  }
}

class TestStripScreen extends StatefulWidget {
  @override
  _TestStripScreenState createState() => _TestStripScreenState();
}

class _TestStripScreenState extends State<TestStripScreen> {
  final Map<String, List<int>> colorValues = {
    'Total Hardness': [0, 110, 250, 500, 1000],
    'Total Chlorine': [0, 1, 3, 5, 10],
    'Free Chlorine': [0, 1, 3, 5, 10],
    'pH': [6, 7, 8, 9, 10],
    'Total Alkalinity': [0, 40, 80, 120, 160],
    'Cyanuric Acid': [0, 20, 40, 60, 80],
  };

  final Map<String, Color> selectedColors = {
    'Total Hardness': Colors.white,
    'Total Chlorine': Colors.white,
    'Free Chlorine': Colors.white,
    'pH': Colors.white,
    'Total Alkalinity': Colors.white,
    'Cyanuric Acid': Colors.white,
  };

  final Map<String, int> selectedValues = {
    'Total Hardness': 0,
    'Total Chlorine': 0,
    'Free Chlorine': 0,
    'pH': 6,
    'Total Alkalinity': 0,
    'Cyanuric Acid': 0,
  };

  final Map<String, TextEditingController> controllers = {
    'Total Hardness': TextEditingController(),
    'Total Chlorine': TextEditingController(),
    'Free Chlorine': TextEditingController(),
    'pH': TextEditingController(),
    'Total Alkalinity': TextEditingController(),
    'Cyanuric Acid': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    controllers.forEach((key, controller) {
      controller.text = selectedValues[key].toString();
      controller.addListener(() {
        int intValue = int.tryParse(controller.text) ?? 0;
        if (colorValues[key]!.contains(intValue)) {
          setState(() {
            selectedValues[key] = intValue;
            selectedColors[key] = getColor(intValue, colorValues[key]!);
          });
        } else if (controller.text.isEmpty) {
          setState(() {
            selectedValues[key] = 0;
            selectedColors[key] = getColor(0, colorValues[key]!);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Color getColor(int value, List<int> values) {
    int index = values.indexOf(value);
    switch (index) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.red;
      case 4:
        return Colors.pink;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Strip'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (String parameter in colorValues.keys) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$parameter (ppm)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: selectedColors[parameter],
                        ),
                        SizedBox(width: 8),
                        for (int value in colorValues[parameter]!) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedValues[parameter] = value;
                                selectedColors[parameter] =
                                    getColor(value, colorValues[parameter]!);
                                controllers[parameter]!.text = value.toString();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 30,
                              height: 30,
                              color: getColor(value, colorValues[parameter]!),
                              child: Center(
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(width: 8),
                        Container(
                          width: 50,
                          child: TextField(
                            controller: controllers[parameter],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ],
        ),
      ),
    );
  }
}