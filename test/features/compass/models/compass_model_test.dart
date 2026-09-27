import 'package:f_compass/src/features/compass/models/compass_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cardinalLabel returns N at 0 degrees', () {
    expect(CompassModel.cardinalLabel(0), 'N');
  });

  test('cardinalLabel returns E near 90 degrees', () {
    expect(CompassModel.cardinalLabel(90), 'E');
  });
}
