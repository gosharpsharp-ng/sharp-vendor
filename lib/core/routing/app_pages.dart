// ignore_for_file: constant_identifier_names

import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/menu/bindings/menu_bindings.dart';
import 'package:sharpvendor/modules/menu/views/add_menu_screen.dart';
import 'package:sharpvendor/modules/menu/views/category_management_screen.dart';
import 'package:sharpvendor/modules/menu/views/edit_menu_screen.dart';
import 'package:sharpvendor/modules/menu/views/menu_details_screen.dart';
import 'package:sharpvendor/modules/menu/views/menu_home_screen.dart';
import 'package:sharpvendor/modules/orders/bindings/orders_bindings.dart';
import 'package:sharpvendor/modules/orders/views/order_details_screen.dart';
import 'package:sharpvendor/modules/orders/views/orders_home_screen.dart';
import 'package:sharpvendor/modules/settings/views/analytics_screen.dart';
import 'package:sharpvendor/modules/settings/views/business_operations_screen.dart';
import 'package:sharpvendor/modules/settings/views/order_transactions_screen.dart';
import 'package:sharpvendor/modules/settings/views/reviews_screen.dart';
import 'package:sharpvendor/modules/signup/views/bank_info_entry_screen.dart';
import 'package:sharpvendor/modules/signup/views/business_information_entry_screen.dart';
import 'package:sharpvendor/modules/signup/views/business_operations_entry_screen.dart';
import 'package:sharpvendor/modules/support/bindings/support_bindings.dart';
import 'package:sharpvendor/modules/support/views/faq_screen.dart';
import 'package:sharpvendor/modules/restaurant/bindings/restaurant_bindings.dart';
import 'package:sharpvendor/modules/restaurant/views/restaurant_details_screen.dart';
import 'package:sharpvendor/modules/restaurant/views/edit_basic_info_screen.dart';
import 'package:sharpvendor/modules/restaurant/views/edit_location_screen.dart';
import 'package:sharpvendor/modules/restaurant/views/business_hours_screen.dart';
import 'package:sharpvendor/modules/restaurant/views/business_settings_screen.dart';
import 'package:sharpvendor/modules/payouts/bindings/payout_bindings.dart';
import 'package:sharpvendor/modules/payouts/views/payout_request_screen.dart';
import 'package:sharpvendor/modules/payouts/views/payout_history_screen.dart';
import 'package:sharpvendor/modules/payouts/views/payout_details_screen.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingBindings(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: Routes.SIGNUP_SCREEN,
      page: () => const SignUpScreen(),
      binding: SignUpBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.BUSINESS_INFO_ENTRY_SCREEN,
      page: () => const BusinessInformationEntryScreen(),
      binding: SignUpBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.BUSINESS_OPERATIONS_ENTRY_SCREEN,
      page: () => const BusinessOperationsEntryScreen(),
      binding: SignUpBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.BANK_INFO_ENTRY_SCREEN,
      page: () => const BankInfoEntryScreen(),
      binding: SignUpBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.SIGNUP_OTP_SCREEN,
      page: () => SignUpOtpScreen(),
      binding: SignUpBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_EMAIL_ENTRY_SCREEN,
      page: () => const ResetPasswordEmailEntry(),
      binding: PasswordResetBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_OTP_SCREEN,
      page: () => ResetPasswordOtpScreen(),
      binding: PasswordResetBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_NEW_PASSWORD_SCREEN,
      page: () => const NewPasswordScreen(),
      binding: PasswordResetBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    GetPage(
      name: Routes.APP_NAVIGATION,
      page: () => AppNavigationScreen(),
      binding: AppNavigationBinding(),
      transition: Transition.noTransition, // Keep dashboard instant
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBindings(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: Routes.NOTIFICATIONS_HOME,
      page: () => const NotificationsHomeScreen(),
      binding: NotificationsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS_DETAILS,
      page: () => const NotificationDetailsScreen(),
      binding: NotificationsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    GetPage(
      name: Routes.DELIVERIES_HOME,
      page: () => const DeliveriesHomeScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.PROCESSED_DELIVERY_SUMMARY_SCREEN,
      page: () => const ProcessedDeliverySummaryScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.DELIVERY_INVOICE_DETAILS,
      page: () => const DeliveryInvoiceDetailsScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.DELIVERY_SUCCESS_SCREEN,
      page: () => const DeliverySuccessScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.DELIVERY_TRACKING_SCREEN,
      page: () => const DeliveryTrackingScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.INITIATE_DELIVERY_SCREEN,
      page: () => const InitiateDeliveryScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.DELIVERY_ITEM_INPUT_SCREEN,
      page: () => const DeliveryItemInputScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RIDE_SELECTION_SCREEN,
      page: () => const RideSelectionScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.DELIVERY_PAYMENT_OPTIONS_SCREEN,
      page: () => const DeliveryPaymentOptionsScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.DELIVERY_SUMMARY_SCREEN,
      page: () => const DeliverySummaryScreen(),
      binding: DeliveriesBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    GetPage(
      name: Routes.SETTINGS_HOME_SCREEN,
      page: () => const SettingsHomeScreen(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.ORDER_TRANSACTIONS_SCREEN,
      page: () => const OrderTransactionsScreen(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.REVIEWS_SCREEN,
      page: () => const ReviewsScreen(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    GetPage(
      name: Routes.ANALYTICS_SCREEN,
      page: () => const AnalyticsScreen(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.DELETE_ACCOUNT_SCREEN,
      page: () => const DeleteAccountPasswordScreen(),
      binding: SettingsBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD_SCREEN,
      page: () => const ChangePasswordScreen(),
      binding: SettingsBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.FAQS_SCREEN,
      page: () => const FaqScreen(),
      binding: SupportBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreen(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.BUSINESS_OPERATIONS_SCREEN,
      page: () => const BusinessOperationsScreen(),
      binding: SettingsBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),



    GetPage(
      name: Routes.SELECT_LOCATION_SCREEN,
      page: () => const SelectLocation(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // Menu
    GetPage(
      name: Routes.MENU_HOME_SCREEN,
      page: () => const MenuHomeScreen(),
      binding: MenuBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.ADD_MENU_SCREEN,
      page: () => const AddMenuScreen(),
      binding: MenuBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.MENU_DETAILS_SCREEN,
      page: () => const MenuDetailsScreen(),
      binding: MenuBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.EDIT_MENU_SCREEN,
      page: () => const EditMenuScreen(),
      binding: MenuBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.CATEGORIES_MANAGEMENT_SCREEN,
      page: () => CategoryManagementScreen(),
      binding: MenuBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.ORDERS_HOME_SCREEN,
      page: () => OrdersHomeScreen(),
      binding: OrdersBindings(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.ORDER_DETAILS_SCREEN,
      page: () => OrderDetailsScreen(),
      binding: OrdersBindings(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // Restaurant Management
    GetPage(
      name: Routes.RESTAURANT_DETAILS_SCREEN,
      page: () => const RestaurantDetailsScreen(),
      binding: RestaurantBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RESTAURANT_EDIT_BASIC_INFO,
      page: () => const EditBasicInfoScreen(),
      binding: RestaurantBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RESTAURANT_EDIT_LOCATION,
      page: () => const EditLocationScreen(),
      binding: RestaurantBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RESTAURANT_BUSINESS_HOURS,
      page: () => const BusinessHoursScreen(),
      binding: RestaurantBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.RESTAURANT_BUSINESS_SETTINGS,
      page: () => const BusinessSettingsScreen(),
      binding: RestaurantBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // Payouts
    GetPage(
      name: Routes.PAYOUT_REQUEST_SCREEN,
      page: () => const PayoutRequestScreen(),
      binding: PayoutBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.PAYOUT_HISTORY_SCREEN,
      page: () => const PayoutHistoryScreen(),
      binding: PayoutBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.PAYOUT_DETAILS_SCREEN,
      page: () => const PayoutDetailsScreen(),
      binding: PayoutBindings(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
