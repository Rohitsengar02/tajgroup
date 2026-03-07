import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

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
            const _AttendanceStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _WeeklyView(),
            const SizedBox(height: defaultPadding * 1.5),
            const _TodaysAttendanceList(),
            const SizedBox(height: defaultPadding * 2),
          ],
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
  const _AttendanceStats();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: 2.2,
        children: [
          _buildGradientStatCard("Present Today", "38", Icons.check_circle_outline_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
          _buildGradientStatCard("Absent", "2", Icons.cancel_outlined, [const Color(0xFFEF4444), const Color(0xFFF87171)]),
          _buildGradientStatCard("On Leave", "2", Icons.calendar_month_outlined, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
          _buildGradientStatCard("Attendance Rate", "90%", Icons.groups_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
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

class _WeeklyView extends StatelessWidget {
  const _WeeklyView();

  @override
  Widget build(BuildContext context) {
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
              const Text("This Week", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              Row(
                children: [
                  _CalendarNavButton(icon: Icons.chevron_left_rounded, onPress: () {}),
                  const SizedBox(width: 8),
                  _CalendarNavButton(icon: Icons.chevron_right_rounded, onPress: () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _CalendarDay(day: "Mon", date: "13", rate: "90%", status: "past"),
                SizedBox(width: 12),
                _CalendarDay(day: "Tue", date: "14", rate: "91%", status: "past"),
                SizedBox(width: 12),
                _CalendarDay(day: "Wed", date: "15", rate: "Active", status: "current"),
                SizedBox(width: 12),
                _CalendarDay(day: "Thu", date: "16", rate: "-", status: "future"),
                SizedBox(width: 12),
                _CalendarDay(day: "Fri", date: "17", rate: "-", status: "future"),
                SizedBox(width: 12),
                _CalendarDay(day: "Sat", date: "18", rate: "-", status: "future"),
                SizedBox(width: 12),
                _CalendarDay(day: "Sun", date: "19", rate: "-", status: "future"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPress;
  const _CalendarNavButton({required this.icon, required this.onPress});

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
  const _CalendarDay({required this.day, required this.date, required this.rate, required this.status});

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

    if (widget.status == "current") {
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
        width: 110,
        height: 120,
        decoration: BoxDecoration(
          color: _isHovered ? (widget.status == "current" ? bgColor : bgColor.withValues(alpha: 0.2)) : bgColor,
          borderRadius: BorderRadius.circular(16),
          border: widget.status == "current" ? null : Border.all(color: _isHovered ? primaryColor.withValues(alpha: 0.3) : Colors.transparent),
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

class _TodaysAttendanceList extends StatelessWidget {
  const _TodaysAttendanceList();

  @override
  Widget build(BuildContext context) {
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
          const Text("Today's Attendance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 24),
          const _AttendanceRow(name: "Rajesh Kumar", territory: "Downtown", checkIn: "9:05 AM", checkOut: "6:15 PM", hours: "9h 10m", status: "Present", initial: "RK"),
          const Divider(height: 32),
          const _AttendanceRow(name: "Priya Sharma", territory: "Market Area", checkIn: "8:55 AM", checkOut: "5:30 PM", hours: "8h 35m", status: "Present", initial: "PS"),
          const Divider(height: 32),
          const _AttendanceRow(name: "Amit Patel", territory: "Industrial", checkIn: "-", checkOut: "-", hours: "-", status: "Absent", initial: "AP"),
          const Divider(height: 32),
          const _AttendanceRow(name: "Neha Singh", territory: "Residential", checkIn: "9:15 AM", checkOut: "Ongoing", hours: "7h 20m", status: "Present", initial: "NS"),
          const Divider(height: 32),
          const _AttendanceRow(name: "Vikram Gupta", territory: "Commercial", checkIn: "8:45 AM", checkOut: "6:00 PM", hours: "9h 15m", status: "On Leave", initial: "VG"),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final String name, territory, checkIn, checkOut, hours, status, initial;

  const _AttendanceRow({
    required this.name,
    required this.territory,
    required this.checkIn,
    required this.checkOut,
    required this.hours,
    required this.status,
    required this.initial,
  });

  @override
  Widget build(BuildContext context) {
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
          flex: 3,
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
        if (!Responsive.isMobile(context)) ...[
          _buildInfoColumn("Check In", checkIn),
          _buildInfoColumn("Check Out", checkOut),
          _buildInfoColumn("Hours", hours),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimaryColor)),
        ],
      ),
    );
  }
}
