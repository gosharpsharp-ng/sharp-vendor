import 'package:sharpvendor/core/services/restaurant/menu/menu_service.dart';
import 'package:sharpvendor/core/services/restaurant/orders/orders_service.dart';
import 'package:sharpvendor/core/services/restaurant/transactions/transactions_service.dart';
import 'package:sharpvendor/core/services/support/support_service.dart';
import 'package:sharpvendor/core/utils/exports.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthenticationService>(
    () => AuthenticationService(),
  );
  serviceLocator.registerLazySingleton<ProfileService>(() => ProfileService());
  serviceLocator.registerLazySingleton<DeliveryService>(
    () => DeliveryService(),
  ); serviceLocator.registerLazySingleton<SupportService>(
    () => SupportService(),
  );
  serviceLocator.registerLazySingleton<WalletsService>(() => WalletsService());
  serviceLocator.registerLazySingleton<MenuService>(() => MenuService());
  serviceLocator.registerLazySingleton<OrdersService>(() => OrdersService());
  serviceLocator.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  serviceLocator.registerLazySingleton<TransactionsService>(
    () => TransactionsService(),
  );

  // serviceLocator.registerLazySingleton<User>(() => UserImpl());
}
