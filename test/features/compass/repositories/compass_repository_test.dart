import 'package:f_compass/src/common/constants/value_constant.dart';
import 'package:f_compass/src/features/compass/repositories/compass_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CompassRepository', () {
    late CompassRepository repository;
    late MethodChannel channel;

    void setChannelHandler(Future<dynamic> Function(MethodCall call) handler) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannel(ValueConstant.pathChannel),
            handler,
          );
    }

    setUp(() {
      channel = MethodChannel(ValueConstant.pathChannel);
      repository = CompassRepositoryImpl();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    group('isAvailable', () {
      test('returns channel result', () async {
        setChannelHandler((call) async {
          expect(call.method, 'isAvailable');
          return true;
        });
        expect(await repository.isAvailable(), isTrue);
      });

      test('returns false when channel returns null', () async {
        setChannelHandler((_) async => null);
        expect(await repository.isAvailable(), isFalse);
      });
    });

    group('startListening', () {
      test('invokes startListening on channel', () async {
        String? method;
        setChannelHandler((call) async {
          method = call.method;
          return null;
        });
        await repository.startListening();
        expect(method, 'startListening');
      });
    });

    group('stopListening', () {
      test('invokes stopListening on channel', () async {
        String? method;
        setChannelHandler((call) async {
          method = call.method;
          return null;
        });
        await repository.stopListening();
        expect(method, 'stopListening');
      });
    });

    group('setHeadingUpdateListener', () {
      test('invokes callback on updateHeading', () async {
        double? received;
        repository.setHeadingUpdateListener((heading) async {
          received = heading;
        });

        await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage(
              ValueConstant.pathChannel,
              const StandardMethodCodec().encodeMethodCall(
                const MethodCall('updateHeading', 127.5),
              ),
              (_) {},
            );

        expect(received, 127.5);
      });
    });
  });
}
