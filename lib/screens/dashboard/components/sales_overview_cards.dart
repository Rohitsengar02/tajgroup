import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../responsive.dart';

class SalesOverviewCards extends StatelessWidget {
  const SalesOverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sales Report Overview",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Total Sales in a Week",
          style: TextStyle(
            fontSize: 12,
            color: textSecondaryColor,
          ),
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: _buildGrid(context, crossAxisCount: 1, childAspectRatio: 2.2),
          tablet: _buildGrid(context, crossAxisCount: 3, childAspectRatio: 1.1),
          desktop: _buildGrid(context, crossAxisCount: 3, childAspectRatio: 1.5),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, {required int crossAxisCount, required double childAspectRatio}) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: childAspectRatio,
      children: const [
        OverviewCard(
          title: "Sales Revenue",
          value: "45K",
          percentage: "57%",
          barColor: primaryColor,
          avatars: ["https://i.pravatar.cc/100?img=1", "https://i.pravatar.cc/100?img=2", "https://i.pravatar.cc/100?img=3"],
          extraCount: "+4",
        ),
        OverviewCard(
          title: "Today Received",
          value: "\$25K",
          percentage: "33%",
          barColor: Color(0xFFF97316),
          avatars: ["https://i.pravatar.cc/100?img=4", "https://i.pravatar.cc/100?img=5"],
          extraCount: "+2",
        ),
        OverviewCard(
          title: "Sales Total",
          value: "23K",
          percentage: "83%",
          barColor: Color(0xFFEF4444),
          avatars: ["https://i.pravatar.cc/100?img=6", "https://i.pravatar.cc/100?img=7", "https://i.pravatar.cc/100?img=8"],
          extraCount: "+3",
          percentageColor: errorColor,
        ),
      ],
    );
  }
}

class OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final Color barColor;
  final List<String> avatars;
  final String extraCount;
  final Color? percentageColor;

  const OverviewCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.barColor,
    required this.avatars,
    required this.extraCount,
    this.percentageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: barColor.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
             color: barColor.withValues(alpha: 0.05),
             blurRadius: 10,
             offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textPrimaryColor,
                ),
              ),
              const Icon(Icons.more_vert, size: 18, color: textSecondaryColor),
            ],
          ),
          SizedBox(
            height: 30,
            child: Stack(
              children: [
                for (int i = 0; i < avatars.length; i++)
                  Positioned(
                    left: i * 20.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(avatars[i]),
                      ),
                    ),
                  ),
                Positioned(
                  left: avatars.length * 20.0,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        extraCount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 20,
                color: textSecondaryColor.withValues(alpha: 0.3),
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: double.parse(percentage.replaceAll('%', '')) / 100,
              backgroundColor: barColor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
