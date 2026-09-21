import 'dart:convert';
import 'dart:typed_data';

import 'package:nearby_connections/nearby_connections.dart';

class NearbyMessagingService {
  NearbyMessagingService._();

  static final NearbyMessagingService instance =
      NearbyMessagingService._();

  static const String serviceId = 'com.alwazir.chat.nearby';

  final Nearby _nearby = Nearby();

  final Map<String, String> _connectedDevices = {};

  Map<String, String> get connectedDevices =>
      Map.unmodifiable(_connectedDevices);

  Future<bool> startAdvertising({
    required String userName,
    required void Function(
      String deviceId,
      String deviceName,
    ) onDeviceConnected,
    required void Function(
      String deviceId,
    ) onDeviceDisconnected,
    required void Function(
      String deviceId,
      String message,
    ) onMessageReceived,
  }) async {
    try {
      await _nearby.stopAdvertising();
    } catch (_) {}

    try {
      final started = await _nearby.startAdvertising(
        userName,
        Strategy.P2P_CLUSTER,
        serviceId: serviceId,
        onConnectionInitiated: (deviceId, connectionInfo) {
          _nearby.acceptConnection(
            deviceId,
            onPayLoadRecieved: (deviceId, payload) {
              _handlePayload(
                deviceId,
                payload,
                onMessageReceived,
              );
            },
          );
        },
        onConnectionResult: (deviceId, status) {
          if (status == Status.CONNECTED) {
            _connectedDevices[deviceId] = deviceId;

            onDeviceConnected(
              deviceId,
              deviceId,
            );
          }
        },
        onDisconnected: (deviceId) {
          _connectedDevices.remove(deviceId);
          onDeviceDisconnected(deviceId);
        },
      );

      return started;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startDiscovery({
    required String userName,
    required void Function(
      String deviceId,
      String deviceName,
    ) onDeviceFound,
    required void Function(
      String deviceId,
      String message,
    ) onMessageReceived,
  }) async {
    try {
      await _nearby.stopDiscovery();
    } catch (_) {}

    try {
      final started = await _nearby.startDiscovery(
        userName,
        Strategy.P2P_CLUSTER,
        serviceId: serviceId,
        onEndpointFound: (
          String deviceId,
          String deviceName,
          String foundServiceId,
        ) {
          onDeviceFound(
            deviceId,
            deviceName,
          );
        },
        onEndpointLost: (String? deviceId) {},
      );

      return started;
    } catch (_) {
      return false;
    }
  }

  Future<bool> connectToDevice({
    required String deviceId,
    required void Function(
      String deviceId,
      String message,
    ) onMessageReceived,
  }) async {
    try {
      final result = await _nearby.requestConnection(
        'الفهد',
        deviceId,
        onConnectionInitiated: (deviceId, connectionInfo) {
          _nearby.acceptConnection(
            deviceId,
            onPayLoadRecieved: (deviceId, payload) {
              _handlePayload(
                deviceId,
                payload,
                onMessageReceived,
              );
            },
          );
        },
        onConnectionResult: (deviceId, status) {
          if (status == Status.CONNECTED) {
            _connectedDevices[deviceId] = deviceId;
          }
        },
        onDisconnected: (deviceId) {
          _connectedDevices.remove(deviceId);
        },
      );

      return result;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendMessage({
    required String deviceId,
    required String message,
  }) async {
    try {
      final data = Uint8List.fromList(
        utf8.encode(message),
      );

      await _nearby.sendBytesPayload(
        deviceId,
        data,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  void _handlePayload(
    String deviceId,
    Payload payload,
    void Function(
      String deviceId,
      String message,
    ) onMessageReceived,
  ) {
    if (payload.type != PayloadType.BYTES) {
      return;
    }

    final bytes = payload.bytes;

    if (bytes == null) {
      return;
    }

    try {
      final message = utf8.decode(bytes);

      onMessageReceived(
        deviceId,
        message,
      );
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _nearby.stopAdvertising();
    } catch (_) {}

    try {
      await _nearby.stopDiscovery();
    } catch (_) {}

    try {
      await _nearby.stopAllEndpoints();
    } catch (_) {}

    _connectedDevices.clear();
  }
}
