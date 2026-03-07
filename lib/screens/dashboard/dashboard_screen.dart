import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

import 'components/welcome_header.dart';
import 'components/kpi_cards.dart';
import 'components/charts_section.dart';
import 'components/sales_map.dart';
import 'components/team_performance.dart';
import 'components/field_activity_panel.dart';
import 'components/routes_summary.dart';
import 'components/network_overview.dart';
import 'components/mobile_quick_actions.dart';
import 'components/ai_insights.dart';
import 'components/notifications_panel.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  final Function(int) onIndexChanged;
  const DashboardScreen({super.key, required this.openDrawer, required this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            WelcomeHeader(openDrawer: openDrawer),
            const SizedBox(height: defaultPadding),
            
            const KpiCards(),
            const SizedBox(height: defaultPadding),

            if (Responsive.isMobile(context)) MobileQuickActions(onIndexChanged: onIndexChanged),
            if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),

            // Top Row (Charts and Map)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                         BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sales Chart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                        const SizedBox(height: 16),
                        const SizedBox(height: 300, child: SalesBarChart()),
                      ],
                    ),
                  ),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 3,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: SalesMap(),
                    ),
                  ),
              ],
            ),
             if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
             if (Responsive.isMobile(context)) 
               const AspectRatio(
                 aspectRatio: 1, 
                 child: SalesMap(),
               ),

            const SizedBox(height: defaultPadding),

            // Second Row (Customer Orders and Team Perf)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 5,
                  child: TeamPerformance(),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                   Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Customer Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                          const SizedBox(height: 16),
                          const SizedBox(height: 300, child: OrdersLineChart()),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
            if (Responsive.isMobile(context))
              Container(
                 padding: const EdgeInsets.all(defaultPadding),
                 decoration: BoxDecoration(
                   color: surfaceColor,
                   borderRadius: BorderRadius.circular(16),
                   boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                       const Text("Customer Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                       const SizedBox(height: 16),
                       const SizedBox(height: 300, child: OrdersLineChart()),
                   ],
                 ),
              ),



            // Third Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 5,
                  child: FieldActivityPanel(),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 3,
                    child: RoutesSummary(),
                  ),
              ],
            ),
             if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
             if (Responsive.isMobile(context)) const RoutesSummary(),

            const SizedBox(height: defaultPadding),

            // Fourth Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 3,
                  child: AiInsightsPanel(),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                   const Expanded(
                    flex: 3,
                    child: NetworkOverview(),
                  ),
                 if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                 if (!Responsive.isMobile(context))
                   const Expanded(
                    flex: 3,
                     child: NotificationsPanel(),
                  ),
              ],
            ),
             if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
             if (Responsive.isMobile(context)) const NetworkOverview(),
             if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
             if (Responsive.isMobile(context)) const NotificationsPanel(),

            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}
