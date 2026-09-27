class CompassModel {
  final double headingDegrees;
  final bool isAvailable;
  final String? errorMessage;

  const CompassModel({
    this.headingDegrees = 0,
    this.isAvailable = true,
    this.errorMessage,
  });

  CompassModel copyWith({
    double? headingDegrees,
    bool? isAvailable,
    String? errorMessage,
  }) {
    return CompassModel(
      headingDegrees: headingDegrees ?? this.headingDegrees,
      isAvailable: isAvailable ?? this.isAvailable,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  static String cardinalLabel(double degrees) {
    const labels = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) % 360 / 45).floor() % 8;
    return labels[index];
  }
}
