import 'package:f_compass/src/common/state_management/state_management.dart';
import 'package:f_compass/src/features/compass/models/compass_model.dart';
import 'package:f_compass/src/features/compass/repositories/compass_repository.dart';
import 'package:flutter/foundation.dart';

typedef _ViewModel = StateManagement<CompassModel>;

abstract interface class CompassViewModel extends _ViewModel {
  Future<void> initialize();
  Future<void> stopListening();
  Future<void> updateHeading(double heading);
}

class CompassViewModelImpl extends _ViewModel implements CompassViewModel {
  final CompassRepository compassRepository;

  CompassViewModelImpl({required this.compassRepository});

  @override
  CompassModel build() => const CompassModel();

  @override
  Future<void> initialize() async {
    compassRepository.setHeadingUpdateListener(updateHeading);
    final available = await compassRepository.isAvailable();
    if (!available) {
      _emit(
        state.copyWith(
          isAvailable: false,
          errorMessage: 'Compass sensor not available on this device.',
        ),
      );
      return;
    }
    try {
      await compassRepository.startListening();
      _emit(state.copyWith(isAvailable: true, errorMessage: null));
    } catch (error) {
      debugPrint('$error');
      _emit(
        state.copyWith(
          isAvailable: false,
          errorMessage: 'Could not start compass: $error',
        ),
      );
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await compassRepository.stopListening();
    } catch (error) {
      debugPrint('$error');
    }
  }

  @override
  Future<void> updateHeading(double heading) async {
    if (state.headingDegrees != heading) {
      _emit(state.copyWith(headingDegrees: heading, isAvailable: true));
    }
  }

  void _emit(CompassModel newState) {
    emitState(newState);
    debugPrint('CompassViewModel: ${state.headingDegrees}°');
  }
}
