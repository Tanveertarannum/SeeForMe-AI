class DetectionResult {
  final String object;
  final double confidence;
  final String position;
  final double? distance;

  DetectionResult({
    required this.object,
    required this.confidence,
    required this.position,
    this.distance,
  });

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      object: json['object'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
      position: json['position'] ?? 'Unknown',
      distance: json['distance']?.toDouble(),
    );
  }
}