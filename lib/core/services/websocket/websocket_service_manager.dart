import 'dart:developer';

import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';

import '../../utils/exports.dart';

class WebSocketServiceManager extends GetxService {
  static WebSocketServiceManager get instance => Get.find();
  bool _isServicesInitialized = false;

  bool get isServicesInitialized => _isServicesInitialized;

  Future<void> initializeServices() async {
    if (_isServicesInitialized) {
      log('Services already initialized');
      return;
    }

    try {
      // Check and dispose existing services
      if (Get.isRegistered<SocketService>()) {
        await Get.delete<SocketService>();
      }

      // Initialize services
      await Get.putAsync(() => SocketService().init());
      final socketService = Get.find<SocketService>();

      // Get vendor ID and set it - socket will auto-join when connected
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        final vendorId = settingsController.userProfile?.restaurant?.id;

        if (vendorId != null) {
          // Set the vendor ID so socket will join on connect
          socketService.setRestaurantId(vendorId);
          log('✓ Vendor ID set: $vendorId (will join room when socket connects)');

          // Set up listener for new orders
          if (Get.isRegistered<OrdersController>()) {
            final ordersController = Get.find<OrdersController>();
            socketService.listenForNewOrders((orderData) {
              ordersController.handleNewOrderNotification(orderData);
            });
            log('✓ Listener setup for vendor:new-order events');
          } else {
            log('⚠️ OrdersController not registered - will listen when it initializes');
          }
        } else {
          log('⚠️ Vendor ID not found in user profile');
        }
      } else {
        log('⚠️ SettingsController not registered');
      }

      _isServicesInitialized = true;
      log('✓ Services initialization complete - waiting for socket connection...');
    } catch (e) {
      log('Error initializing services: $e');
      _isServicesInitialized = false;
      rethrow;
    }
  }

  Future<void> disposeServices() async {
    if (Get.isRegistered<SocketService>()) {
      final socketService = Get.find<SocketService>();
      socketService.socket.disconnect();
      await Get.delete<SocketService>();
    }

    _isServicesInitialized = false;
    log('Services disposed successfully');
  }
}

/// Backward compatibility alias
typedef DeliveryNotificationServiceManager = WebSocketServiceManager;
