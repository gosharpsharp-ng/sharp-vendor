import 'dart:developer';

import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/orders/views/orders_home_screen.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '../../menu/views/menu_home_screen.dart' show MenuHomeScreen;

class AppNavigationController extends GetxController {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  socket_io.Socket? socket;
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  int currentScreenIndex = 0;
  changeScreenIndex(selectedIndex) {
    currentScreenIndex = selectedIndex;

    // Trigger refresh when navigating to Menu or Orders tabs
    if (selectedIndex == 1) {
      // Menu tab - refresh menu items
      try {
        final menuController = Get.find<FoodMenuController>();
        menuController.getMenuItems();
      } catch (e) {
        debugPrint('Menu controller not found: $e');
      }
    } else if (selectedIndex == 2) {
      // Orders tab - refresh orders
      try {
        final ordersController = Get.find<OrdersController>();
        ordersController.getOrders();
      } catch (e) {
        debugPrint('Orders controller not found: $e');
      }
    }

    update();
  }

  List<Widget> screens = [
    const DashboardScreen(),
    const MenuHomeScreen(),
    const OrdersHomeScreen(),
    const SettingsHomeScreen(),
  ];
  @override
  void onInit() {
    // _handleLocationPermission();
    super.onInit();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationPermissionDialog();
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast(isError: true, message: 'Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast(
        isError: true,
        message:
            'Location permissions are permanently denied. Please grant permissions from app settings.',
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
