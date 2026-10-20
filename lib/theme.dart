import 'package:flutter/material.dart';

const ink = Color(0xFF243A35),
    muted = Color(0xFF7C8984),
    green = Color(0xFF4F7B68),
    sage = Color(0xFFEAF1EB),
    blue = Color(0xFFEAF0F9),
    lavender = Color(0xFFF0EBF7),
    peach = Color(0xFFFAEEE4),
    line = Color(0xFFECF0EC);
ThemeData hubTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF8FAF8),
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSeed(
    seedColor: green,
    brightness: Brightness.light,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 34,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: ink,
      letterSpacing: -1.2,
    ),
    headlineSmall: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w600,
      color: ink,
      letterSpacing: -.6,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: ink,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: ink,
    ),
    bodyMedium: TextStyle(fontSize: 13, height: 1.6, color: ink),
    bodySmall: TextStyle(fontSize: 11, height: 1.5, color: muted),
  ),
  dividerColor: line,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF8FAF8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: line),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: green,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ink,
      side: const BorderSide(color: Color(0xFFDCE5DE)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = 24,
    this.color = Colors.white,
  });
  final Widget child;
  final double padding;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: line),
    ),
    child: child,
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill(
    this.label, {
    super.key,
    this.color = sage,
    this.textColor = green,
  });
  final String label;
  final Color color, textColor;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.subtitle, this.action});
  final String title;
  final String? subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    ),
  );
}

void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
