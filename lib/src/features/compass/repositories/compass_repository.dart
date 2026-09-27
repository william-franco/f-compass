import 'package:f_compass/src/common/constants/value_constant.dart';
import 'package:flutter/services.dart';

abstract interface class CompassRepository {
  Future<bool> isAvailable();
  Future<void> startListening();
  Future<void> stopListening();
  void setHeadingUpdateListener(Future<void> Function(double heading) callback);
}

class CompassRepositoryImpl implements CompassRepository {
  static final _channel = MethodChannel(ValueConstant.pathChannel);

  @override
  Future<bool> isAvailable() async {
    return await _channel.invokeMethod<bool>('isAvailable') ?? false;
  }

  @override
  Future<void> startListening() async {
    await _channel.invokeMethod('startListening');
  }

  @override
  Future<void> stopListening() async {
    await _channel.invokeMethod('stopListening');
  }

  @override
  void setHeadingUpdateListener(Future<void> Function(double heading) callback) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'updateHeading') {
        final value = call.arguments;
        if (value is num) {
          await callback(value.toDouble());
        }
      }
    });
  }
}
