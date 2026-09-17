import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/detection_result.dart';
import '../theme/app_theme.dart';

class LiveDetectionScreen extends StatefulWidget {
  const LiveDetectionScreen({super.key});

  @override
  State<LiveDetectionScreen> createState() => _LiveDetectionScreenState();
}

class _LiveDetectionScreenState extends State<LiveDetectionScreen> {
  // FastAPI backend
  static const String backendUrl = 'http://127.0.0.1:8000';

  List<DetectionResult> detections = [];

  bool isScanning = false;
  bool isLoading = false;

  String? analysisMessage;
  String? recommendedDirection;

  Future<void> startDetection() async {
    setState(() {
      isScanning = true;
      isLoading = true;
      detections = [];
      analysisMessage = null;
      recommendedDirection = null;
    });

    try {
      // Temporary test request.
      // Real camera image will be connected next.
      final response = await http.get(
        Uri.parse('$backendUrl/vision/test'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          isLoading = false;
          analysisMessage = data['message'] ?? 'Vision API is working.';
        });

        // Browser voice
        await speakText(analysisMessage!);
      } else {
        throw Exception('Vision API returned ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to connect to backend.\n$e',
          ),
        ),
      );
    }
  }

  Future<void> speakText(String text) async {
    // Browser speech will be connected here.
    // For now this confirms that the backend response reached Flutter.
    debugPrint('VOICE: $text');
  }

  void stopDetection() {
    setState(() {
      isScanning = false;
      isLoading = false;
      detections = [];
      analysisMessage = null;
      recommendedDirection = null;
    });
  }

  String getObjectIcon(String object) {
    switch (object.toLowerCase()) {
      case 'person':
        return '🚶';
      case 'door':
        return '🚪';
      case 'stairs':
        return '🪜';
      case 'obstacle':
        return '⚠️';
      case 'chair':
        return '🪑';
      default:
        return '🔎';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Live Detection',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCameraPreview(),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detected Objects',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isScanning) _buildScanningIndicator(),
                ],
              ),

              const SizedBox(height: 14),

              if (isLoading)
                _buildLoadingCard()
              else if (analysisMessage != null)
                _buildAnalysisCard()
              else if (!isScanning)
                _buildEmptyState()
              else if (detections.isEmpty)
                _buildNoDetection()
              else
                ...detections.map(
                  (detection) => _buildDetectionCard(detection),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed:
                      isScanning ? stopDetection : startDetection,
                  icon: Icon(
                    isScanning
                        ? Icons.stop_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    isScanning
                        ? 'Stop Detection'
                        : 'Start Detection',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isScanning ? AppTheme.danger : AppTheme.teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: AppTheme.deepTeal,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.deepTeal,
                    AppTheme.teal,
                  ],
                ),
              ),
            ),

            const Center(
              child: Icon(
                Icons.camera_alt_outlined,
                size: 70,
                color: Colors.white70,
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isScanning
                            ? Colors.greenAccent
                            : Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      isScanning
                          ? 'AI CONNECTED'
                          : 'CAMERA READY',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.mist,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'AI Active',
        style: TextStyle(
          color: AppTheme.deepTeal,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 48,
            color: AppTheme.teal,
          ),
          const SizedBox(height: 12),
          const Text(
            'Backend Connected',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            analysisMessage ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.muted,
              fontSize: 14,
            ),
          ),
          if (recommendedDirection != null) ...[
            const SizedBox(height: 10),
            Text(
              'Direction: $recommendedDirection',
              style: TextStyle(
                color: AppTheme.teal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetectionCard(DetectionResult detection) {
    final distanceText = detection.distance != null
        ? '${detection.distance!.toStringAsFixed(1)} m away'
        : 'Distance unavailable';

    final confidence =
        '${(detection.confidence * 100).round()}% confidence';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.mist,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              getObjectIcon(detection.object),
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detection.object,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${detection.position} • $distanceText',
                  style: TextStyle(
                    color: AppTheme.muted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  confidence,
                  style: TextStyle(
                    color: AppTheme.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.muted,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 15),
          Text(
            'Connecting to AI backend...',
            style: TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return _infoCard(
      Icons.camera_alt_outlined,
      'Ready to scan',
      'Start detection to connect with the SeeForMe AI backend.',
    );
  }

  Widget _buildNoDetection() {
    return _infoCard(
      Icons.search_off_rounded,
      'Nothing detected',
      'Try pointing the camera in another direction.',
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: AppTheme.teal,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.muted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}