import 'package:flutter/material.dart';
import '../../../responsive.dart';
import '../../../constants.dart';

class Header extends StatelessWidget {
  final VoidCallback openDrawer;
  const Header({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
             icon: const Icon(Icons.menu),
             onPressed: openDrawer,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined, color: primaryColor),
            onPressed: () {},
          ),
          if (!Responsive.isMobile(context))
            IconButton(
              icon: const Icon(Icons.message_outlined, color: textSecondaryColor),
              onPressed: () {},
            ),
          const SizedBox(width: defaultPadding / 2),
          const CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
            radius: 18,
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(
                "John Doe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search here...",
        hintStyle: const TextStyle(color: textSecondaryColor),
        fillColor: surfaceColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2, vertical: defaultPadding / 3),
            decoration: BoxDecoration(
              gradient: primaryGradient,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
