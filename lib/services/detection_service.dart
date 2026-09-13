import '../models/detection_result.dart';

class DetectionService {
  Future<List<DetectionResult>> getDummyDetections() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      DetectionResult(
        object: 'Person',
        confidence: 0.92,
        position: 'Center',
        distance: 2.4,
      ),
      DetectionResult(
        object: 'Door',
        confidence: 0.88,
        position: 'Left',
        distance: 3.0,
      ),
      DetectionResult(
        object: 'Obstacle',
        confidence: 0.84,
        position: 'Right',
        distance: 1.2,
      ),
    ];
  }
}