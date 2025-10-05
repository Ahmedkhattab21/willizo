import 'package:flutter/material.dart';
import 'package:willizo/core/utils/styles.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String accent;
  final Color color;
  const SectionTitle({super.key, required this.title, required this.accent, required this.color});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyles.font28PrimaryColorW400,
        children: [
          TextSpan(
            text: "$title ",
            style: const TextStyle(color: Colors.white70),
          ),
          TextSpan(
            text: accent,
            style:  TextStyle(color:color),
          ),
        ],
      ),
    );
  }
}
