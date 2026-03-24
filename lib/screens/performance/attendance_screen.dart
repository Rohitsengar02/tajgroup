import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../responsive.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _currentDate = DateTime.now();
  final DateTime _todayDate = DateTime.now();
  List<dynamic> attendanceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  String get _formattedDate {
    return DateFormat('yyyy-MM-dd').format(_currentDate);
  }
  
  String get _todayFormattedDate {
    return DateFormat('yyyy-MM-dd').format(_todayDate);
  }

  bool get _isToday => _formattedDate == _todayFormattedDate;
  bool get _isFuture => _currentDate.isAfter(DateTime(_todayDate.year, _todayDate.month, _todayDate.day));

  Future<void> _fetchAttendance() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/attendance/daily?date=$_formattedDate'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            attendanceList = data;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load attendance');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: errorColor),
        );
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _updateStatus(String memberId, String status) async {
    if (!_isToday) return;

    // Optimistic UI Update
    setState(() {
      final index = attendanceList.indexWhere((m) => m['memberId'] == memberId);
      if (index != -1) {
        attendanceList[index]['status'] = status;
      }
    });

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/attendance/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'memberId': memberId,
          'date': _formattedDate,
          'status': status,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Server rejected update');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("Cloud Error: Couldn't sync status. Try again.", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
        _fetchAttendance(); // Revert back to server state on error
      }
    }
  }

  void _setDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
    _fetchAttendance();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentDate) {
      _setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: defaultPadding),
            _AttendanceStats(attendanceList: attendanceList),
            const SizedBox(height: defaultPadding * 1.5),
            
            // Interactive Horizontal Calendar Slider
            _CalendarSlider(
              currentDate: _currentDate,
              todayDate: _todayDate,
              onDateSelected: _setDate,
              onOpenPicker: () => _pickDate(context),
            ),
            
            const SizedBox(height: defaultPadding * 1.5),
            
            isLoading
                ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
                : Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Team Attendance - ${DateFormat('dd MMM yyyy').format(_currentDate)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                             if (!_isToday)
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                 decoration: BoxDecoration(color: _isFuture ? const Color(0xFFF59E0B).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                 child: Text(_isFuture ? "Upcoming - Locked" : "Past - Locked", style: TextStyle(fontSize: 12, color: _isFuture ? const Color(0xFFF59E0B) : textSecondaryColor, fontWeight: FontWeight.bold)),
                               )
                           ],
                         ),
                        const SizedBox(height: 24),
                        attendanceList.isEmpty
                            ? const Padding(padding: EdgeInsets.all(20), child: Text("No records found.", style: TextStyle(color: textSecondaryColor)))
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: attendanceList.length,
                                separatorBuilder: (context, index) => const Divider(height: 32),
                                itemBuilder: (context, index) {
                                  final record = attendanceList[index];
                                  final name = record['name'] ?? "Unknown";
                                  final territory = record['territory'] ?? "Unassigned";
                                  final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";

                                  return _AttendanceRow(
                                    memberId: record['memberId']?.toString() ?? "",
                                    name: name,
                                    territory: territory,
                                    status: record['status'] ?? "Absent",
                                    initial: initial,
                                    isReadOnly: !_isToday, 
                                    onStatusChanged: (newStatus) => _updateStatus(record['memberId']?.toString() ?? "", newStatus),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _CalendarSlider extends StatelessWidget {
  final DateTime currentDate;
  final DateTime todayDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onOpenPicker;

  const _CalendarSlider({
    required this.currentDate, 
    required this.todayDate, 
    required this.onDateSelected,
    required this.onOpenPicker,
  });

  @override
  Widget build(BuildContext context) {
    // Generate an array of 7 days around the currently selected date.
    List<DateTime> days = [];
    for (int i = -3; i <= 3; i++) {
      days.add(currentDate.add(Duration(days: i)));
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onOpenPicker,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Text(DateFormat('MMMM yyyy').format(currentDate), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_today_rounded, size: 18, color: primaryColor),
                  ],
                ),
              ),
              Row(
                children: [
                  _NavButton(icon: Icons.chevron_left_rounded, onPress: () => onDateSelected(currentDate.subtract(const Duration(days: 7)))),
                  const SizedBox(width: 8),
                  _NavButton(icon: Icons.chevron_right_rounded, onPress: () => onDateSelected(currentDate.add(const Duration(days: 7)))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: days.map((day) {
                bool isSelected = day.year == currentDate.year && day.month == currentDate.month && day.day == currentDate.day;
                bool isToday = day.year == todayDate.year && day.month == todayDate.month && day.day == todayDate.day;
                bool isPast = day.isBefore(DateTime(todayDate.year, todayDate.month, todayDate.day));
                bool isFuture = day.isAfter(DateTime(todayDate.year, todayDate.month, todayDate.day));

                String status = isToday ? "current" : (isPast ? "past" : "future");

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onDateSelected(day),
                    child: _CalendarDay(
                      day: DateFormat('E').format(day), // Mon, Tue...
                      date: DateFormat('d').format(day), // 13, 14...
                      rate: isToday ? "Today" : (isFuture ? "Locked" : "View"), 
                      status: status,
                      isSelected: isSelected,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPress;
  const _NavButton({required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onPress,
        icon: Icon(icon, size: 20, color: textPrimaryColor),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _CalendarDay extends StatefulWidget {
  final String day, date, rate, status;
  final bool isSelected;
  const _CalendarDay({required this.day, required this.date, required this.rate, required this.status, required this.isSelected});

  @override
  State<_CalendarDay> createState() => _CalendarDayState();
}

class _CalendarDayState extends State<_CalendarDay> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color subTextColor;

    if (widget.isSelected) {
      bgColor = const Color(0xFF6366F1);
      textColor = Colors.white;
      subTextColor = Colors.white70;
    } else if (widget.status == "past") {
      bgColor = const Color(0xFF22C55E).withValues(alpha: 0.1);
      textColor = textPrimaryColor;
      subTextColor = const Color(0xFF22C55E);
    } else {
      bgColor = const Color(0xFFF8FAFC);
      textColor = textPrimaryColor;
      subTextColor = textSecondaryColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 110,
        decoration: BoxDecoration(
          color: _isHovered && !widget.isSelected ? bgColor.withValues(alpha: 0.5) : bgColor,
          borderRadius: BorderRadius.circular(16),
          border: widget.isSelected ? null : Border.all(color: _isHovered ? primaryColor.withValues(alpha: 0.3) : Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: subTextColor)),
            const SizedBox(height: 8),
            Text(widget.date, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textColor)),
            const SizedBox(height: 8),
            Text(widget.rate, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor)),
          ],
        ),
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final String memberId, name, territory, status, initial;
  final bool isReadOnly;
  final Function(String) onStatusChanged;

  const _AttendanceRow({
    required this.memberId,
    required this.name,
    required this.territory,
    required this.status,
    required this.initial,
    required this.isReadOnly,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Determine explicitly what row block color to show
    Color statusColor;
    if (status == "Present") {
      statusColor = const Color(0xFF22C55E);
    } else if (status == "Absent") {
      statusColor = const Color(0xFFEF4444);
    } else {
      statusColor = const Color(0xFFF59E0B);
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
          child: Text(initial, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimaryColor)),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 12, color: textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(territory, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: Responsive.isMobile(context) ? 4 : 5,
          child: Align(
            alignment: Alignment.centerRight,
            child: isReadOnly 
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.end,
                  children: [
                    _buildSelectionOption("Absent", const Color(0xFFEF4444)),
                    _buildSelectionOption("Present", const Color(0xFF22C55E)),
                    _buildSelectionOption("On Leave", const Color(0xFFF59E0B)),
                  ],
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionOption(String optionText, Color optionColor) {
    bool isSelected = status == optionText;
    
    return InkWell(
      onTap: () {
        if (!isSelected) {
          onStatusChanged(optionText);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? optionColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? optionColor : Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Text(
          optionText == "On Leave" ? "Leave" : optionText, // Shortened for space
          style: TextStyle(
            color: isSelected ? Colors.white : textSecondaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attendance Management",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Track daily presence and time logs of your field team",
          style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _AttendanceStats extends StatelessWidget {
  final List<dynamic> attendanceList;
  const _AttendanceStats({required this.attendanceList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;
      
      int total = attendanceList.length;
      int present = attendanceList.where((a) => a['status'] == 'Present').length;
      int absent = attendanceList.where((a) => a['status'] == 'Absent').length;
      int onLeave = attendanceList.where((a) => a['status'] == 'On Leave').length;
      
      String rate = total > 0 ? "${((present / total) * 100).toStringAsFixed(0)}%" : "0%";

      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: 2.2,
        children: [
          _buildGradientStatCard("Present", "$present", Icons.check_circle_outline_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
          _buildGradientStatCard("Absent", "$absent", Icons.cancel_outlined, [const Color(0xFFEF4444), const Color(0xFFF87171)]),
          _buildGradientStatCard("On Leave", "$onLeave", Icons.calendar_month_outlined, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
          _buildGradientStatCard("Attendance Rate", rate, Icons.groups_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
        ],
      );
    });
  }

  Widget _buildGradientStatCard(String title, String value, IconData icon, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
