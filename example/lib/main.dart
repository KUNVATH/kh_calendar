import 'package:flutter/material.dart';
import 'package:kh_calendar/kh_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  DateTime? selectedDate;
  DateTime? selectedDateFromDialog;
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
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                            color: color.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 24)
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
              firstDate: DateTime.now(),
              lastDate: DateTime(2025, 12, 31),
              primaryColor: currentColor,
              selectedTextColor: Colors.white,
              todayTextColor: currentColor,
              normalTextColor: Colors.black87,
            ),

            const SizedBox(height: 20),

            // Selected date display
            if (selectedDate != null)
              Card(
                color: currentColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Date Information:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: currentColor,
                                ),
                      ),
                      const SizedBox(height: 8),
                      _buildDateInfo('Date',
                          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                      _buildDateInfo(
                          'Day of Week', _getDayOfWeek(selectedDate!.weekday)),
                      _buildDateInfo(
                          'Month', _getMonthName(selectedDate!.month)),
                      _buildDateInfo('Year', '${selectedDate!.year}'),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),
                  
            // Dialog with title and date range
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!context.mounted) return;
                  
                  DateTime? date = await KhmerCalendarDialog.show(
                    context: context,
                    title: 'ជ្រើសរើសកាលបរិច្ឆេទ',
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    primaryColor: Colors.purple,
                    confirmText: 'យល់ព្រម',
                    cancelText: 'បោះបង់',
                  );
                  if (date != null && context.mounted) {
                    setState(() {
                      selectedDateFromDialog = date;
                    });
                    // Show a snackbar when date is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Selected with range: ${date.toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: currentColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Show Dialog with Title & Range'),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Custom styled dialog
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!context.mounted) return;
                  
                  DateTime? date = await KhmerCalendarDialog.show(
                    context: context,
                    title: 'Select Your Birthday',
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1950, 1, 1),
                    lastDate: DateTime.now(),
                    primaryColor: Colors.pink,
                    selectedTextColor: Colors.white,
                    todayTextColor: Colors.pink,
                    confirmText: 'Choose',
                    cancelText: 'Cancel',
                  );
                  if (date != null && context.mounted) {
                    setState(() {
                      selectedDateFromDialog = date;
                    });
                    // Show a snackbar when date is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Birthday selected: ${date.toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: currentColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Show Custom Styled Dialog'),
              ),
            ),
            
            // Display selected date from dialog
            if (selectedDateFromDialog != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Selected from Dialog:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${selectedDateFromDialog!.day}/${selectedDateFromDialog!.month}/${selectedDateFromDialog!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 20),

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
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}