import 'dart:developer';

import 'package:sharpvendor/core/services/delivery/delivery_notification.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';

import '../../utils/exports.dart';

class DeliveryNotificationServiceManager extends GetxService {
  static DeliveryNotificationServiceManager get instance => Get.find();
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

      if (Get.isRegistered<DeliveryNotificationService>()) {
        await Get.delete<DeliveryNotificationService>();
      }

      // Initialize services
      await Get.putAsync(() => SocketService().init());
      final socketService = Get.find<SocketService>();

      // Get restaurant ID and set it - socket will auto-join when connected
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        final restaurantId = settingsController.userProfile?.restaurant?.id;

        if (restaurantId != null) {
          // Set the restaurant ID so socket will join on connect
          socketService.setRestaurantId(restaurantId);
          log('✓ Restaurant ID set: $restaurantId (will join room when socket connects)');

          // Set up listener for new orders
          if (Get.isRegistered<OrdersController>()) {
            final ordersController = Get.find<OrdersController>();
            socketService.listenForNewOrders((orderData) {
              ordersController.handleNewOrderNotification(orderData);
            });
            log('✓ Listener setup for restaurant:new-order events');
          } else {
            log('⚠️ OrdersController not registered - will listen when it initializes');
          }
        } else {
          log('⚠️ Restaurant ID not found in user profile');
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
