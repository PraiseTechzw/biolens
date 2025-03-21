import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:afro_dip/utils/app_theme.dart';

class AdvancedAnalysisOverlay extends StatefulWidget {
  final String message;
  final String subMessage;

  const AdvancedAnalysisOverlay({
    super.key,
    this.message = 'Analyzing Image...',
    this.subMessage = 'Our AI is identifying the fly species',
  });

  @override
  State<AdvancedAnalysisOverlay> createState() => _AdvancedAnalysisOverlayState();
}

class _AdvancedAnalysisOverlayState extends State<AdvancedAnalysisOverlay> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;
  
  final List<WaveData> _waves = [];
  final int _waveCount = 5;
  final _random = math.Random();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize wave data
    for (int i = 0; i < _waveCount; i++) {
      _waves.add(WaveData(
        amplitude: 5 + _random.nextDouble() * 10,
        frequency: 0.5 + _random.nextDouble() * 1.5,
        speed: 0.02 + _random.nextDouble() * 0.05,
        phase: _random.nextDouble() * 2 * math.pi,
        color: AppTheme.primaryGreen.withOpacity(0.1 + (i / _waveCount) * 0.5),
      ));
    }
    
    // Wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    
    // Scan line animation controller
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_scanController);
    
    _waveController.addListener(() {
      setState(() {
        // Update wave phases
        for (var wave in _waves) {
          wave.phase += wave.speed;
          if (wave.phase > 2 * math.pi) {
            wave.phase -= 2 * math.pi;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Stack(
        children: [
          // Waveform visualization
          Positioned.fill(
            child: CustomPaint(
              painter: WaveformPainter(
                waves: _waves,
                scanPosition: _scanAnimation.value,
                scanColor: isDarkMode ? AppTheme.secondaryGreen : AppTheme.primaryGreen,
              ),
            ),
          ),
          
          // Data points visualization
          Positioned.fill(
            child: CustomPaint(
              painter: DataPointsPainter(
                animationValue: _waveController.value,
                isDarkMode: isDarkMode,
              ),
            ),
          ),
          
          // Analysis text and progress
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hexagonal progress indicator
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: HexagonalProgressPainter(
                      progress: _waveController.value,
                      color: isDarkMode ? AppTheme.secondaryGreen : AppTheme.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Analysis text
                Text(
                  widget.message,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                // Processing percentage
                const SizedBox(height: 16),
                Text(
                  '${(_waveController.value * 100).toInt()}% Complete',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                
                // Analysis points
                const SizedBox(height: 24),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      _buildAnalysisPoint('Analyzing wing venation pattern...'),
                      _buildAnalysisPoint('Measuring body proportions...'),
                      _buildAnalysisPoint('Identifying proboscis structure...'),
                      _buildAnalysisPoint('Matching against species database...'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Technical data visualization on the sides
          Positioned(
            left: 16,
            top: 100,
            bottom: 100,
            width: 40,
            child: CustomPaint(
              painter: TechnicalDataPainter(
                animationValue: _waveController.value,
                direction: 'vertical',
                color: isDarkMode ? AppTheme.secondaryGreen : AppTheme.primaryGreen,
              ),
            ),
          ),
          
          Positioned(
            right: 16,
            top: 100,
            bottom: 100,
            width: 40,
            child: CustomPaint(
              painter: TechnicalDataPainter(
                animationValue: 1 - _waveController.value,
                direction: 'vertical',
                color: isDarkMode ? AppTheme.secondaryGreen : AppTheme.primaryGreen,
              ),
            ),
          ),
          
          Positioned(
            left: 70,
            right: 70,
            bottom: 40,
            height: 30,
            child: CustomPaint(
              painter: TechnicalDataPainter(
                animationValue: _waveController.value,
                direction: 'horizontal',
                color: isDarkMode ? AppTheme.secondaryGreen : AppTheme.primaryGreen,
              ),
            ),
          ),
          
          // Fly silhouette analysis
          Positioned(
            right: 70,
            top: 70,
            child: SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(
                painter: FlyAnalysisPainter(
                  progress: _waveController.value,
                  color: isDarkMode ? AppTheme.secondaryGreen : AppTheme.primaryGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_right,
            color: Colors.white70,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveData {
  final double amplitude;
  final double frequency;
  final double speed;
  double phase;
  final Color color;
  
  WaveData({
    required this.amplitude,
    required this.frequency,
    required this.speed,
    required this.phase,
    required this.color,
  });
}

class WaveformPainter extends CustomPainter {
  final List<WaveData> waves;
  final double scanPosition;
  final Color scanColor;
  
  WaveformPainter({
    required this.waves,
    required this.scanPosition,
    required this.scanColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final width = size.width;
    
    // Draw each wave
    for (var wave in waves) {
      final path = Path();
      final paint = Paint()
        ..color = wave.color
        ..style = PaintingStyle.fill;
      
      path.moveTo(0, centerY);
      
      for (double x = 0; x <= width; x++) {
        final normalizedX = x / width;
        final y = centerY + wave.amplitude * math.sin(normalizedX * wave.frequency * 2 * math.pi + wave.phase);
        path.lineTo(x, y);
      }
      
      path.lineTo(width, centerY);
      path.lineTo(0, centerY);
      path.close();
      
      canvas.drawPath(path, paint);
    }
    
    // Draw scan line
    final scanY = size.height * scanPosition;
    final scanPaint = Paint()
      ..color = scanColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      scanPaint,
    );
    
    // Draw scan glow
    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          scanColor.withOpacity(0.0),
          scanColor.withOpacity(0.5),
          scanColor.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, scanY - 10, size.width, 20));
    
    canvas.drawRect(
      Rect.fromLTWH(0, scanY - 10, size.width, 20),
      glowPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}

class DataPointsPainter extends CustomPainter {
  final double animationValue;
  final bool isDarkMode;
  final int pointCount = 100;
  final math.Random random = math.Random();
  
  DataPointsPainter({
    required this.animationValue,
    required this.isDarkMode,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()
      ..color = isDarkMode 
          ? AppTheme.secondaryGreen.withOpacity(0.6)
          : AppTheme.primaryGreen.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    // Generate and draw random data points that move up and down
    for (int i = 0; i < pointCount; i++) {
      final seed = i * 1000; // Consistent seed for each point
      final pointRandom = math.Random(seed);
      
      final x = pointRandom.nextDouble() * size.width;
      
      // Base y position
      final baseY = pointRandom.nextDouble() * size.height;
      
      // Movement amplitude
      final amplitude = 20.0 + pointRandom.nextDouble() * 40.0;
      
      // Phase offset for varied movement
      final phaseOffset = pointRandom.nextDouble() * 2 * math.pi;
      
      // Calculate current y with sinusoidal movement
      final y = baseY + amplitude * math.sin(animationValue * 2 * math.pi + phaseOffset);
      
      // Point size varies with animation
      final pointSize = 1.0 + pointRandom.nextDouble() * 3.0 * 
          (0.5 + 0.5 * math.sin(animationValue * 2 * math.pi + phaseOffset));
      
      canvas.drawCircle(Offset(x, y), pointSize, pointPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant DataPointsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class HexagonalProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  HexagonalProgressPainter({
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    
    // Draw hexagon background
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final hexagonPath = _createHexagonPath(center, radius);
    canvas.drawPath(hexagonPath, bgPaint);
    
    // Draw progress
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    final progressPath = Path();
    const startAngle = -math.pi / 2; // Start from top
    
    for (int i = 0; i < 6; i++) {
      final angle1 = startAngle + i * math.pi / 3;
      final angle2 = startAngle + (i + 1) * math.pi / 3;
      
      final point1 = Offset(
        center.dx + radius * math.cos(angle1),
        center.dy + radius * math.sin(angle1),
      );
      
      final point2 = Offset(
        center.dx + radius * math.cos(angle2),
        center.dy + radius * math.sin(angle2),
      );
      
      if (i == 0) {
        progressPath.moveTo(point1.dx, point1.dy);
      }
      
      final segmentProgress = math.min(1.0, math.max(0.0, progress * 6 - i));
      if (segmentProgress > 0) {
        final endPoint = Offset(
          point1.dx + (point2.dx - point1.dx) * segmentProgress,
          point1.dy + (point2.dy - point1.dy) * segmentProgress,
        );
        
        progressPath.lineTo(endPoint.dx, endPoint.dy);
      }
    }
    
    canvas.drawPath(progressPath, progressPaint);
    
    // Draw inner content
    final innerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Draw a pulsing circle in the center
    final pulseSize = 0.5 + 0.2 * math.sin(progress * 2 * math.pi);
    canvas.drawCircle(center, radius * 0.2 * pulseSize, innerPaint);
    
    // Draw percentage text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }
  
  Path _createHexagonPath(Offset center, double radius) {
    final path = Path();
    const startAngle = -math.pi / 2; // Start from top
    
    for (int i = 0; i < 6; i++) {
      final angle = startAngle + i * math.pi / 3;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    
    path.close();
    return path;
  }
  
  @override
  bool shouldRepaint(covariant HexagonalProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class TechnicalDataPainter extends CustomPainter {
  final double animationValue;
  final String direction;
  final Color color;
  final math.Random random = math.Random();
  
  TechnicalDataPainter({
    required this.animationValue,
    required this.direction,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    if (direction == 'vertical') {
      // Draw background line
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        linePaint,
      );
      
      // Draw data bars
      const barCount = 20;
      final barSpacing = size.height / barCount;
      
      for (int i = 0; i < barCount; i++) {
        // Use a seeded random for consistent bar heights
        final barRandom = math.Random(i * 1000);
        
        // Base width percentage
        final baseWidth = 0.3 + barRandom.nextDouble() * 0.7;
        
        // Animation modifier
        final animOffset = math.sin(animationValue * 2 * math.pi + i * 0.3);
        final widthModifier = 0.7 + 0.3 * animOffset;
        
        final barWidth = size.width * baseWidth * widthModifier;
        final barHeight = barSpacing * 0.7;
        
        canvas.drawRect(
          Rect.fromLTWH(
            (size.width - barWidth) / 2,
            i * barSpacing + (barSpacing - barHeight) / 2,
            barWidth,
            barHeight,
          ),
          barPaint,
        );
      }
    } else {
      // Draw background line
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        linePaint,
      );
      
      // Draw data bars
      const barCount = 15;
      final barSpacing = size.width / barCount;
      
      for (int i = 0; i < barCount; i++) {
        // Use a seeded random for consistent bar heights
        final barRandom = math.Random(i * 1000);
        
        // Base height percentage
        final baseHeight = 0.3 + barRandom.nextDouble() * 0.7;
        
        // Animation modifier
        final animOffset = math.sin(animationValue * 2 * math.pi + i * 0.3);
        final heightModifier = 0.7 + 0.3 * animOffset;
        
        final barHeight = size.height * baseHeight * heightModifier;
        final barWidth = barSpacing * 0.7;
        
        canvas.drawRect(
          Rect.fromLTWH(
            i * barSpacing + (barSpacing - barWidth) / 2,
            (size.height - barHeight) / 2,
            barWidth,
            barHeight,
          ),
          barPaint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant TechnicalDataPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class FlyAnalysisPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  FlyAnalysisPainter({
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw fly body outline with animation
    final bodyPath = Path();
    final bodyLength = radius * (0.8 + 0.2 * math.sin(progress * 2 * math.pi));
    final bodyWidth = radius * 0.5;
    
    bodyPath.moveTo(center.dx - bodyLength / 2, center.dy);
    bodyPath.quadraticBezierTo(
      center.dx - bodyLength / 2, center.dy - bodyWidth / 2,
      center.dx, center.dy - bodyWidth / 2,
    );
    bodyPath.quadraticBezierTo(
      center.dx + bodyLength / 2, center.dy - bodyWidth / 2,
      center.dx + bodyLength / 2, center.dy,
    );
    bodyPath.quadraticBezierTo(
      center.dx + bodyLength / 2, center.dy + bodyWidth / 2,
      center.dx, center.dy + bodyWidth / 2,
    );
    bodyPath.quadraticBezierTo(
      center.dx - bodyLength / 2, center.dy + bodyWidth / 2,
      center.dx - bodyLength / 2, center.dy,
    );
    
    // Only draw part of the path based on progress
    final pathMetrics = bodyPath.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0,
      pathMetrics.length * progress,
    );
    
    canvas.drawPath(extractPath, paint);
    
    // Draw wings if progress is far enough
    if (progress > 0.5) {
      final wingProgress = (progress - 0.5) * 2; // Scale from 0 to 1
      
      // Left wing
      final leftWingPath = Path();
      leftWingPath.moveTo(center.dx - radius * 0.2, center.dy - radius * 0.1);
      leftWingPath.quadraticBezierTo(
        center.dx - radius * 0.6, center.dy - radius * 0.4,
        center.dx - radius * 0.7, center.dy,
      );
      leftWingPath.quadraticBezierTo(
        center.dx - radius * 0.6, center.dy + radius * 0.2,
        center.dx - radius * 0.2, center.dy + radius * 0.1,
      );
      
      // Right wing
      final rightWingPath = Path();
      rightWingPath.moveTo(center.dx + radius * 0.2, center.dy - radius * 0.1);
      rightWingPath.quadraticBezierTo(
        center.dx + radius * 0.6, center.dy - radius * 0.4,
        center.dx + radius * 0.7, center.dy,
      );
      rightWingPath.quadraticBezierTo(
        center.dx + radius * 0.6, center.dy + radius * 0.2,
        center.dx + radius * 0.2, center.dy + radius * 0.1,
      );
      
      // Draw wings with partial progress
      final leftWingMetrics = leftWingPath.computeMetrics().first;
      final extractLeftWing = leftWingMetrics.extractPath(
        0,
        leftWingMetrics.length * wingProgress,
      );
      
      final rightWingMetrics = rightWingPath.computeMetrics().first;
      final extractRightWing = rightWingMetrics.extractPath(
        0,
        rightWingMetrics.length * wingProgress,
      );
      
      final wingPaint = Paint()
        ..color = color.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      
      canvas.drawPath(extractLeftWing, wingPaint);
      canvas.drawPath(extractRightWing, wingPaint);
    }
    
    // Draw measurement points and lines
    if (progress > 0.8) {
      final pointPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      // Draw points at key locations
      canvas.drawCircle(Offset(center.dx, center.dy - bodyWidth / 2), 2, pointPaint);
      canvas.drawCircle(Offset(center.dx + bodyLength / 2, center.dy), 2, pointPaint);
      canvas.drawCircle(Offset(center.dx - bodyLength / 2, center.dy), 2, pointPaint);
      
      // Draw measurement lines
      final measurePaint = Paint()
        ..color = color.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(
        Offset(center.dx - bodyLength / 2, center.dy + radius * 0.4),
        Offset(center.dx + bodyLength / 2, center.dy + radius * 0.4),
        measurePaint,
      );
      
      canvas.drawLine(
        Offset(center.dx - bodyLength / 2, center.dy + radius * 0.35),
        Offset(center.dx - bodyLength / 2, center.dy + radius * 0.45),
        measurePaint,
      );
      
      canvas.drawLine(
        Offset(center.dx + bodyLength / 2, center.dy + radius * 0.35),
        Offset(center.dx + bodyLength / 2, center.dy + radius * 0.45),
        measurePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant FlyAnalysisPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

