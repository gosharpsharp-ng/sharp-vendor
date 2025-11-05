import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../utils/exports.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find();

  late IO.Socket socket;
  final isConnected = false.obs;
  int? _currentRestaurantId;

  Future<SocketService> init() async {
    _initializeSocket();
    _setupSocketListeners();
    return this;
  }

  void _initializeSocket() {
    socket = IO.io(
        'http://socket.gosharpsharp.com/',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(3000)
            .build());
    socket.connect();
  }

  void _setupSocketListeners() {
    socket
      ..onConnect((_) {
        log('🟢 Socket Connected to http://socket.gosharpsharp.com/');
        isConnected.value = true;
        // Rejoin restaurant room if restaurantId was set
        if (_currentRestaurantId != null) {
          joinRestaurantRoom(_currentRestaurantId!);
        }
        joinRidersTrackingRoom();
      })
      ..onDisconnect((_) {
        log('🔴 Socket Disconnected');
        isConnected.value = false;
      })
      ..onReconnect((_) {
        log('🟡 Socket Reconnected');
        isConnected.value = true;
        // Rejoin restaurant room on reconnection
        if (_currentRestaurantId != null) {
          joinRestaurantRoom(_currentRestaurantId!);
        }
        joinRidersTrackingRoom();
      })
      ..onError((error) => log('❌ Socket Error: $error'))
      ..onConnectError((error) => log('❌ Socket Connect Error: $error'));
  }

  // ==================== RESTAURANT ROOM ====================

  /// Join restaurant room to receive new orders
  /// Emits to: "restaurant:join" with payload { "restaurantId": restaurantId }
  void joinRestaurantRoom(int restaurantId) {
    if (isConnected.value) {
      _currentRestaurantId = restaurantId;
      socket.emit('restaurant:join', {'restaurantId': restaurantId});
      log('🍽️ Joined restaurant room with restaurantId: $restaurantId');
    } else {
      log('⚠️ Cannot join restaurant room - socket not connected');
    }
  }

  /// Listen for new incoming orders
  /// Event: "restaurant:new-order"
  /// Data: {orderId, orderNumber, userId, status, total, currency, items, packages, createdAt}
  void listenForNewOrders(Function(Map<String, dynamic>) onNewOrder) {
    socket.on('restaurant:new-order', (data) {
      log('🔔 New order received: ${data.toString()}');
      if (data is Map<String, dynamic>) {
        onNewOrder(data);
      }
    });
  }

  /// Stop listening for new orders
  void stopListeningForNewOrders() {
    socket.off('restaurant:new-order');
    log('🔇 Stopped listening for new orders');
  }

  /// Leave restaurant room
  void leaveRestaurantRoom() {
    if (_currentRestaurantId != null && isConnected.value) {
      log('👋 Left restaurant room for restaurantId: $_currentRestaurantId');
      _currentRestaurantId = null;
    }
  }

  // ==================== LEGACY METHODS (kept for backward compatibility) ====================

  void listenForParcelLocationUpdate(
      {required String roomId, required Function(dynamic) onLocationUpdate}) {
    socket.on(roomId, onLocationUpdate);
  }

  joinTrackingRoom({required String trackingId, required String msg}) async {
    if (isConnected.value) {
      socket.emit(msg, trackingId);
    }
  }

  joinRidersTrackingRoom() async {
    if (isConnected.value) {
      socket.emit("get_riders", "riders");
    }
  }

  void listenForAvailableRiders({required Function(dynamic) onRiderOnline}) {
    socket.on("riders_list", onRiderOnline);
  }

  void leaveTrackingRoom(
      {required String trackingId, required String msg}) async {
    if (isConnected.value) {
      socket.emit(msg, trackingId);
    }
  }

  // ==================== CLEANUP ====================

  @override
  void onClose() {
    // Clean up restaurant room
    leaveRestaurantRoom();

    // Stop all listeners
    stopListeningForNewOrders();

    // Dispose socket
    socket.dispose();
    super.onClose();
  }
}
