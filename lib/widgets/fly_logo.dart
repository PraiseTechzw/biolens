import 'package:flutter/material.dart';
import 'package:afro_dip/utils/app_theme.dart';

class FlyLogo extends StatefulWidget {
  final double size;
  final Color? color;
  final bool animate;

  const FlyLogo({
    super.key,
    this.size = 100,
    this.color,
    this.animate = true,
  });

  @override
  State<FlyLogo> createState() => _FlyLogoState();
}

class _FlyLogoState extends State<FlyLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _wingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (!widget.animate) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = widget.color ?? 
      (isDarkMode ? AppTheme.secondaryGreen : AppTheme.primaryGreen);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: FlyPainter(
          wingAngle: _wingAnimation.value,
          color: color,
        ),
      ),
    );
  }
}

class FlyPainter extends CustomPainter {
  final double wingAngle;
  final Color color;

  FlyPainter({
    required this.wingAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;
    
    // Paint for the fly body
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Paint for the wings
    final wingPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    // Paint for the outline
    final outlinePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Draw the fly body (oval shape)
    final bodyRect = Rect.fromCenter(
      center: center,
      width: radius * 1.8,
      height: radius * 2.5,
    );
    canvas.drawOval(bodyRect, bodyPaint);
    
    // Draw the head (circle)
    final headCenter = Offset(center.dx, center.dy - radius * 0.9);
    canvas.drawCircle(headCenter, radius * 0.6, bodyPaint);
    
    // Draw the eyes
    final eyePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final leftEyeCenter = Offset(headCenter.dx - radius * 0.3, headCenter.dy - radius * 0.1);
    final rightEyeCenter = Offset(headCenter.dx + radius * 0.3, headCenter.dy - radius * 0.1);
    canvas.drawCircle(leftEyeCenter, radius * 0.15, eyePaint);
    canvas.drawCircle(rightEyeCenter, radius * 0.15, eyePaint);
    
    // Draw the wings with animation
    // Left wing
    final leftWingPath = Path();
    final leftWingBase = Offset(center.dx - radius * 0.5, center.dy - radius * 0.2);
    leftWingPath.moveTo(leftWingBase.dx, leftWingBase.dy);
    
    // Wing animation - adjust the control points based on wingAngle
    final wingExtension = radius * (1.0 + wingAngle * 0.3);
    final wingHeight = radius * (0.8 - wingAngle * 0.4);
    
    leftWingPath.quadraticBezierTo(
      leftWingBase.dx - wingExtension, 
      leftWingBase.dy - wingHeight,
      leftWingBase.dx - wingExtension * 0.8, 
      leftWingBase.dy + radius * 0.3,
    );
    leftWingPath.quadraticBezierTo(
      leftWingBase.dx - radius * 0.3, 
      leftWingBase.dy + radius * 0.5,
      leftWingBase.dx, 
      leftWingBase.dy,
    );
    canvas.drawPath(leftWingPath, wingPaint);
    canvas.drawPath(leftWingPath, outlinePaint);
    
    // Right wing
    final rightWingPath = Path();
    final rightWingBase = Offset(center.dx + radius * 0.5, center.dy - radius * 0.2);
    rightWingPath.moveTo(rightWingBase.dx, rightWingBase.dy);
    
    rightWingPath.quadraticBezierTo(
      rightWingBase.dx + wingExtension, 
      rightWingBase.dy - wingHeight,
      rightWingBase.dx + wingExtension * 0.8, 
      rightWingBase.dy + radius * 0.3,
    );
    rightWingPath.quadraticBezierTo(
      rightWingBase.dx + radius * 0.3, 
      rightWingBase.dy + radius * 0.5,
      rightWingBase.dx, 
      rightWingBase.dy,
    );
    canvas.drawPath(rightWingPath, wingPaint);
    canvas.drawPath(rightWingPath, outlinePaint);
    
    // Draw legs
    final legPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Left legs
    for (int i = 0; i < 3; i++) {
      final startY = center.dy - radius * 0.3 + i * radius * 0.5;
      final legPath = Path();
      legPath.moveTo(center.dx - radius * 0.5, startY);
      legPath.quadraticBezierTo(
        center.dx - radius * 1.2, 
        startY + radius * 0.3,
        center.dx - radius * 1.0, 
        startY + radius * 0.6,
      );
      canvas.drawPath(legPath, legPaint);
    }
    
    // Right legs
    for (int i = 0; i < 3; i++) {
      final startY = center.dy - radius * 0.3 + i * radius * 0.5;
      final legPath = Path();
      legPath.moveTo(center.dx + radius * 0.5, startY);
      legPath.quadraticBezierTo(
        center.dx + radius * 1.2, 
        startY + radius * 0.3,
        center.dx + radius * 1.0, 
        startY + radius * 0.6,
      );
      canvas.drawPath(legPath, legPaint);
    }
    
    // Draw antennae
    final antennaPath1 = Path();
    antennaPath1.moveTo(headCenter.dx - radius * 0.2, headCenter.dy - radius * 0.2);
    antennaPath1.quadraticBezierTo(
      headCenter.dx - radius * 0.5, 
      headCenter.dy - radius * 0.8,
      headCenter.dx - radius * 0.4, 
      headCenter.dy - radius * 1.0,
    );
    canvas.drawPath(antennaPath1, legPaint);
    
    final antennaPath2 = Path();
    antennaPath2.moveTo(headCenter.dx + radius * 0.2, headCenter.dy - radius * 0.2);
    antennaPath2.quadraticBezierTo(
      headCenter.dx + radius * 0.5, 
      headCenter.dy - radius * 0.8,
      headCenter.dx + radius * 0.4, 
      headCenter.dy - radius * 1.0,
    );
    canvas.drawPath(antennaPath2, legPaint);
  }

  @override
  bool shouldRepaint(covariant FlyPainter oldDelegate) {
    return oldDelegate.wingAngle != wingAngle || oldDelegate.color != color;
  }
}

