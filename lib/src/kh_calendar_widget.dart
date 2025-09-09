import 'package:flutter/material.dart';

/// A customizable Khmer calendar widget with full Khmer language support
class KhmerCalendar extends StatefulWidget {
  /// Creates a Khmer calendar widget
  const KhmerCalendar({
    Key? key,
    this.onDateSelected,
    this.initialDate,
    this.primaryColor = Colors.blue,
    this.selectedTextColor = Colors.white,
    this.todayTextColor,
    this.normalTextColor = Colors.black87,
  }) : super(key: key);

  /// Callback function called when a date is selected
  final Function(DateTime)? onDateSelected;
  
  /// Initial date to display and select
  final DateTime? initialDate;
  
  /// Primary color for selected date background and header
  final Color primaryColor;
  
  /// Text color for selected date
  final Color selectedTextColor;
  
  /// Text color for today's date
  final Color? todayTextColor;
  
  /// Text color for normal dates
  final Color normalTextColor;

  @override
  State<KhmerCalendar> createState() => _KhmerCalendarState();
}

class _KhmerCalendarState extends State<KhmerCalendar> {
  late DateTime currentDate;
  late DateTime selectedDate;

  // Khmer month names
  final List<String> khmerMonths = [
    'មករា', // January
    'កុម្ភៈ', // February
    'មីនា', // March
    'មេសា', // April
    'ឧសភា', // May
    'មិថុនា', // June
    'កក្កដា', // July
    'សីហា', // August
    'កញ្ញា', // September
    'តុលា', // October
    'វិច្ឆិកា', // November
    'ធ្នូ', // December
  ];

  // Khmer day names (short form)
  final List<String> khmerDays = [
    'អា', // Sunday
    'ច', // Monday
    'អ', // Tuesday
    'ព', // Wednesday
    'ព្រ', // Thursday
    'សុ', // Friday
    'ស', // Saturday
  ];

  // Khmer numerals
  final List<String> khmerNumbers = [
    '០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'
  ];

  @override
  void initState() {
    super.initState();
    currentDate = widget.initialDate ?? DateTime.now();
    selectedDate = widget.initialDate ?? DateTime.now();
  }

  String convertToKhmerNumber(int number) {
    return number
        .toString()
        .split('')
        .map((digit) => khmerNumbers[int.parse(digit)])
        .join();
  }

  Color get _primaryColor => widget.primaryColor;
  Color get _selectedTextColor => widget.selectedTextColor;
  Color get _todayTextColor => widget.todayTextColor ?? widget.primaryColor;
  Color get _normalTextColor => widget.normalTextColor;

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          Text(
            '${khmerMonths[currentDate.month - 1]} ${convertToKhmerNumber(currentDate.year)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeekHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Row(
        children: khmerDays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final days = <Widget>[];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstDayWeekday; i++) {
      days.add(const SizedBox());
    }

    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(currentDate.year, currentDate.month, day);
      final isSelected = date.day == selectedDate.day &&
          date.month == selectedDate.month &&
          date.year == selectedDate.year;
      final isToday = date.day == DateTime.now().day &&
          date.month == DateTime.now().month &&
          date.year == DateTime.now().year;

      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
            // Call the callback if provided
            widget.onDateSelected?.call(date);
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? _primaryColor
                  : isToday
                      ? _primaryColor.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: _primaryColor, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                convertToKhmerNumber(day),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? _selectedTextColor
                      : isToday
                          ? _todayTextColor
                          : _normalTextColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: days,
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildDaysOfWeekHeader(),
          _buildCalendarGrid(),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'កាលបរិច្ឆេទដែលបានជ្រើសរើស៖ ${convertToKhmerNumber(selectedDate.day)} ${khmerMonths[selectedDate.month - 1]} ${convertToKhmerNumber(selectedDate.year)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}