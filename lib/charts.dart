import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

class LearningChart extends StatelessWidget {
  const LearningChart({super.key, required this.month});
  final bool month;
  @override
  Widget build(BuildContext context) => Semantics(
    label: month
        ? 'Progres empat minggu: 48, 62, 74, 82 persen'
        : 'Progres Senin sampai Minggu: 42, 55, 48, 69, 65, 84, 82 persen',
    child: SizedBox(
      height: 206,
      width: double.infinity,
      child: CustomPaint(painter: _LearningPainter(month)),
    ),
  );
}

class _LearningPainter extends CustomPainter {
  _LearningPainter(this.month);
  final bool month;
  void label(Canvas canvas, String text, Offset at) {
    final p = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          color: muted,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    p.paint(canvas, at);
  }

  @override
  void paint(Canvas c, Size s) {
    const left = 32.0, top = 8.0;
    final w = s.width - 42, h = s.height - 40;
    for (var i = 0; i < 5; i++) {
      final y = top + h * i / 4;
      c.drawLine(
        Offset(left, y),
        Offset(left + w, y),
        Paint()
          ..color = line
          ..strokeWidth = 1,
      );
      label(c, '${100 - i * 25}', Offset(0, y - 6));
    }
    final values = month
        ? [48.0, 62.0, 74.0, 82.0]
        : [42.0, 55.0, 48.0, 69.0, 65.0, 84.0, 82.0];
    final labels = month
        ? ['Minggu 1', 'Minggu 2', 'Minggu 3', 'Minggu 4']
        : ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(
          left + i * w / (values.length - 1),
          top + h * (1 - values[i] / 100),
        ),
    ];
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i], mid = (a.dx + b.dx) / 2;
      path.cubicTo(mid, a.dy, mid, b.dy, b.dx, b.dy);
    }
    final fill = Path.from(path)
      ..lineTo(left + w, top + h)
      ..lineTo(left, top + h)
      ..close();
    c.drawPath(
      fill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x885FA787), Color(0x035FA787)],
        ).createShader(Rect.fromLTWH(left, top, w, h)),
    );
    c.drawPath(
      path,
      Paint()
        ..color = green
        ..strokeWidth = 2.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    for (var i = 0; i < points.length; i++) {
      c.drawCircle(points[i], 3, Paint()..color = Colors.white);
      c.drawCircle(points[i], 2, Paint()..color = green);
      label(
        c,
        labels[i],
        Offset(points[i].dx - (i == points.length - 1 ? 24 : 10), top + h + 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LearningPainter old) => old.month != month;
}

class RingChart extends StatelessWidget {
  const RingChart({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: '68 persen tuntas, 24 persen berjalan, 8 persen belum mulai',
    child: SizedBox(
      width: 146,
      height: 146,
      child: CustomPaint(
        painter: _RingPainter(),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '68%',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: ink,
                ),
              ),
              Text(
                'sudah tuntas',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final r = Rect.fromLTWH(10, 10, s.width - 20, s.height - 20);
    var start = -math.pi / 2;
    final values = [.68, .24, .08],
        colors = [
          const Color(0xFF8EB39B),
          const Color(0xFFB9C9E4),
          const Color(0xFFE4DDEE),
        ];
    for (var i = 0; i < 3; i++) {
      final sweep = 2 * math.pi * values[i] - .06;
      c.drawArc(
        r,
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round,
      );
      start += 2 * math.pi * values[i];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
