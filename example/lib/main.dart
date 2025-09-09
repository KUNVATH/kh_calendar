import 'package:flutter/material.dart';
import 'package:kh_calendar/kh_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khmer Calendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ExamplePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  DateTime? selectedDate;
  Color currentColor = Colors.blue;
  
  final List<Color> colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ប្រតិទិនខ្មែរ - Khmer Calendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: currentColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khmer Calendar Widget Demo',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: currentColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This example demonstrates the KhmerCalendar widget with full Khmer language support including numerals, month names, and day names.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Color customization
            Text(
              'Customize Colors:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colorOptions.length,
                itemBuilder: (context, index) {
                  final color = colorOptions[index];
                  final isSelected = color == currentColor;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentColor = color;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected 
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Main calendar widget
            KhmerCalendar(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                
                // Show a snackbar when date is selected
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Selected: ${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: currentColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              primaryColor: currentColor,
              selectedTextColor: Colors.white,
              todayTextColor: currentColor,
              normalTextColor: Colors.black87,
            ),
            
            const SizedBox(height: 20),
            
            // Selected date display
            if (selectedDate != null)
              Card(
                color: currentColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Date Information:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: currentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDateInfo('Date', '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                      _buildDateInfo('Day of Week', _getDayOfWeek(selectedDate!.weekday)),
                      _buildDateInfo('Month', _getMonthName(selectedDate!.month)),
                      _buildDateInfo('Year', '${selectedDate!.year}'),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Usage example code
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usage Example:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '''KhmerCalendar(
  onDateSelected: (DateTime date) {
    print('Selected: \$date');
  },
  primaryColor: Colors.blue,
  selectedTextColor: Colors.white,
  todayTextColor: Colors.blue,
  normalTextColor: Colors.black87,
)''',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDateInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  String _getDayOfWeek(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 
      'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}