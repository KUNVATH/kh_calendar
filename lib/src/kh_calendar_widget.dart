import 'package:flutter/material.dart';

/// A customizable Khmer calendar widget with full Khmer language support
class KhmerCalendar extends StatefulWidget {
  /// Creates a Khmer calendar widget
  const KhmerCalendar({
    super.key,
    this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.primaryColor = Colors.blue,
    this.selectedTextColor = Colors.white,
    this.todayTextColor,
    this.normalTextColor = Colors.black87,
  });

  /// Callback function called when a date is selected
  final Function(DateTime)? onDateSelected;

  /// Initial date to display and select
  final DateTime? initialDate;

  /// The earliest date the user is permitted to select
  final DateTime? firstDate;

  /// The latest date the user is permitted to select
  final DateTime? lastDate;

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
    '០',
    '១',
    '២',
    '៣',
    '៤',
    '៥',
    '៦',
    '៧',
    '៨',
    '៩'
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

  bool _isDateInRange(DateTime date) {
    if (widget.firstDate != null && date.isBefore(widget.firstDate!)) {
      return false;
    }
    if (widget.lastDate != null && date.isAfter(widget.lastDate!)) {
      return false;
    }
    return true;
  }

  bool _canNavigateToPreviousMonth() {
    if (widget.firstDate == null) return true;
    final previousMonth = DateTime(currentDate.year, currentDate.month - 1);
    final firstDayOfPreviousMonth = DateTime(previousMonth.year, previousMonth.month, 1);
    return !firstDayOfPreviousMonth.isBefore(widget.firstDate!);
  }

  bool _canNavigateToNextMonth() {
    if (widget.lastDate == null) return true;
    final nextMonth = DateTime(currentDate.year, currentDate.month + 1);
    final lastDayOfNextMonth = DateTime(nextMonth.year, nextMonth.month + 1, 0);
    return !lastDayOfNextMonth.isAfter(widget.lastDate!);
  }

  Color get _primaryColor => widget.primaryColor;
  Color get _selectedTextColor => widget.selectedTextColor;
  Color get _todayTextColor => widget.todayTextColor ?? widget.primaryColor;
  Color get _normalTextColor => widget.normalTextColor;

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            onPressed: _canNavigateToPreviousMonth() ? _previousMonth : null,
            icon: Icon(
              Icons.chevron_left,
              color: _canNavigateToPreviousMonth() ? Colors.white : Colors.white.withValues(alpha: 0.5),
              size: 28,
            ),
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
            onPressed: _canNavigateToNextMonth() ? _nextMonth : null,
            icon: Icon(
              Icons.chevron_right,
              color: _canNavigateToNextMonth() ? Colors.white : Colors.white.withValues(alpha: 0.5),
              size: 28,
            ),
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
      final isInRange = _isDateInRange(date);

      days.add(
        GestureDetector(
          onTap: isInRange
              ? () {
                  setState(() {
                    selectedDate = date;
                  });
                  // Call the callback if provided
                  widget.onDateSelected?.call(date);
                }
              : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? _primaryColor
                  : isToday && isInRange
                      ? _primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected && isInRange
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
                      : isToday && isInRange
                          ? _todayTextColor
                          : isInRange
                              ? _normalTextColor
                              : Colors.grey[400],
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
      height: MediaQuery.of(context).size.height/2,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
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
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   child: Text(
          //     'កាលបរិច្ឆេទដែលបានជ្រើសរើស៖ ${convertToKhmerNumber(selectedDate.day)} ${khmerMonths[selectedDate.month - 1]} ${convertToKhmerNumber(selectedDate.year)}',
          //     style: TextStyle(
          //       fontSize: 16,
          //       color: Colors.grey[700],
          //       fontWeight: FontWeight.w500,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
        ],
      ),
    );
  }
}