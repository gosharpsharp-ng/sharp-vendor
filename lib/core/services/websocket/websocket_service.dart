import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../utils/exports.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find();

  late IO.Socket socket;
  final isConnected = false.obs;
  int? _currentRestaurantId;
  Function(Map<String, dynamic>)? _onNewOrderCallback;

  Future<SocketService> init() async {
    _initializeSocket();
    _setupSocketListeners();
    return this;
  }

  void _initializeSocket() {
    socket = IO.io(
      'https://socket.gosharpsharp.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(3000)
          .build(),
    );
    socket.connect();
  }

  void _setupSocketListeners() {
    // Setup catch-all listener to see ALL events
    socket.onAny((event, data) {
      log('📨 Socket Event Received: $event');
      log('📨 Event Data: ${data.toString()}');
    });

    socket
      ..onConnect((_) {
        log('🟢 Socket Connected to http://socket.gosharpsharp.com');
        log('🟢 Socket ID: ${socket.id}');
        isConnected.value = true;
        // Rejoin restaurant room if restaurantId was set
        if (_currentRestaurantId != null) {
          joinRestaurantRoom(_currentRestaurantId!);
          // Re-setup listener after joining room
          if (_onNewOrderCallback != null) {
            _setupNewOrderListener();
          }
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
          // Re-setup listener after joining room
          if (_onNewOrderCallback != null) {
            _setupNewOrderListener();
          }
        }
        joinRidersTrackingRoom();
      })
      ..onError((error) => log('❌ Socket Error: $error'))
      ..onConnectError((error) => log('❌ Socket Connect Error: $error'));
  }

  // ==================== RESTAURANT ROOM ====================

  /// Set restaurant ID (will auto-join when socket connects)
  void setRestaurantId(int restaurantId) {
    _currentRestaurantId = restaurantId;
    // If already connected, join immediately
    if (isConnected.value) {
      joinRestaurantRoom(restaurantId);
    }
  }

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
    _onNewOrderCallback = onNewOrder;
    // If already connected, setup listener immediately
    if (isConnected.value) {
      _setupNewOrderListener();
    }
  }

  /// Internal method to setup the new order listener
  void _setupNewOrderListener() {
    // Remove any existing listener first
    socket.off('restaurant:new-order');

    log('📡 Setting up listener for restaurant:new-order event...');
    log('📡 Socket connected: ${socket.connected}');
    log('📡 Socket ID: ${socket.id}');
    log('📡 Callback registered: ${_onNewOrderCallback != null}');

    // Setup new listener
    socket.on('restaurant:new-order', (data) {
      log(
        '🔔 ==================== NEW ORDER EVENT RECEIVED ====================',
      );
      log('🔔 Raw data type: ${data.runtimeType}');
      log('🔔 Raw data: ${data.toString()}');

      if (data is Map<String, dynamic>) {
        log('✅ Data is Map<String, dynamic>');
        if (_onNewOrderCallback != null) {
          log('✅ Calling callback with order data');
          _onNewOrderCallback!(data);
        } else {
          log('❌ No callback registered!');
        }
      } else {
        log('❌ Data is not Map<String, dynamic>, it is: ${data.runtimeType}');
        // Try to convert if it's a different type
        try {
          if (data is Map) {
            Map<String, dynamic> convertedData = Map<String, dynamic>.from(
              data,
            );
            log('✅ Converted to Map<String, dynamic>');
            if (_onNewOrderCallback != null) {
              _onNewOrderCallback!(convertedData);
            }
          }
        } catch (e) {
          log('❌ Error converting data: $e');
        }
      }
      log(
        '🔔 ================================================================',
      );
    });
    log('✅ Listener attached to restaurant:new-order event');
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

  void listenForParcelLocationUpdate({
    required String roomId,
    required Function(dynamic) onLocationUpdate,
  }) {
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

  void leaveTrackingRoom({
    required String trackingId,
    required String msg,
  }) async {
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
