import 'package:sharpvendor/core/services/push_notification_service.dart';
import 'package:sharpvendor/core/services/vendor/discounts/discount_service.dart';
import 'package:sharpvendor/core/services/vendor/inventory/inventory_service.dart';
import 'package:sharpvendor/core/services/vendor/orders/orders_service.dart';
import 'package:sharpvendor/core/services/vendor/transactions/transactions_service.dart';
import 'package:sharpvendor/core/services/vendor/bank/vendor_bank_service.dart';
import 'package:sharpvendor/core/services/support/support_service.dart';
import 'package:sharpvendor/core/utils/exports.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(),
  );
  serviceLocator.registerLazySingleton<AuthenticationService>(
    () => AuthenticationService(),
  );
  serviceLocator.registerLazySingleton<ProfileService>(() => ProfileService());
  serviceLocator.registerLazySingleton<SupportService>(
    () => SupportService(),
  );
  serviceLocator.registerLazySingleton<WalletsService>(() => WalletsService());

  // Vendor services (generic for all vendor types)
  serviceLocator.registerLazySingleton<InventoryService>(() => InventoryService());
  serviceLocator.registerLazySingleton<VendorDiscountService>(() => VendorDiscountService());
  serviceLocator.registerLazySingleton<VendorOrdersService>(() => VendorOrdersService());
  serviceLocator.registerLazySingleton<VendorAnalyticsService>(() => VendorAnalyticsService());
  serviceLocator.registerLazySingleton<VendorTransactionsService>(
    () => VendorTransactionsService(),
  );
  serviceLocator.registerLazySingleton<VendorBankService>(() => VendorBankService());
  serviceLocator.registerLazySingleton<CampaignService>(
    () => CampaignService(),
  );

  // Backward compatibility aliases (these use the same instances as above)
  // MenuService is now an alias for InventoryService
  // DiscountService is now an alias for VendorDiscountService
  // OrdersService is now an alias for VendorOrdersService
  // AnalyticsService is now an alias for VendorAnalyticsService
  // TransactionsService is now an alias for VendorTransactionsService
}
