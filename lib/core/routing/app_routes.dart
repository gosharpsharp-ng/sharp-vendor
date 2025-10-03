// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const SIGN_IN = '/sign_in';
  static const SIGNUP_SCREEN = '/signup_screen';
  static const BUSINESS_INFO_ENTRY_SCREEN = '/business_info_entry_screen';
  static const BANK_INFO_ENTRY_SCREEN = '/bank_info_entry_screen';
  static const BUSINESS_OPERATIONS_ENTRY_SCREEN = '/business_operations_entry_screen';
  static const SIGNUP_OTP_SCREEN = '/signup_otp_screen';
  static const SIGNUP_SUCCESS_SCREEN = '/signup_success_screen';
  static const RESET_PASSWORD_EMAIL_ENTRY_SCREEN = '/reset_password_email_entry_screen';
  static const RESET_PASSWORD_NEW_PASSWORD_SCREEN = '/reset_password_new_password_screen';
  static const RESET_PASSWORD_OTP_SCREEN = '/reset_password_otp_screen';
  static const RESET_PASSWORD_SUCCESS_SCREEN = '/reset_password_success_screen';
  static const DASHBOARD = '/dashboard';
  static const ONBOARDING_BUSINESS_OPERATIONS = '/onboarding_business_operations';
  static const ONBOARDING_BANK_INFORMATION = '/onboarding_bank_information';
  static const APP_NAVIGATION = '/app_navigation';

  static const DELIVERIES_HOME = '/deliveries_home';
  static const DELIVERY_DETAILS = '/delivery_details';
  static const PROCESSED_DELIVERY_SUMMARY_SCREEN = '/processed_delivery_details';
  static const DELIVERY_TRACKING_SCREEN = '/delivery_tracking_screen';
  static const DELIVERY_INVOICE_DETAILS = '/delivery_invoice_details';
  static const INITIATE_DELIVERY_SCREEN = '/initiate_delivery_screen';
  static const DELIVERY_SUCCESS_SCREEN = '/delivery_success_screen';
  static const DELIVERY_ITEM_INPUT_SCREEN = '/delivery_item_input_screen';
  static const DELIVERY_PAYMENT_OPTIONS_SCREEN = '/delivery_payment_options_screen';
  static const RIDE_SELECTION_SCREEN = '/ride_selection_screen';
  static const DELIVERY_SUMMARY_SCREEN = '/delivery_summary_screen';

  static const NOTIFICATIONS_HOME = '/notifications_home';
  static const NOTIFICATIONS_DETAILS = '/notifications_details';

  static const SETTINGS_HOME_SCREEN = '/settings_home_screen';
  static const REVIEWS_SCREEN = '/reviews_screen';
  static const ORDER_TRANSACTIONS_SCREEN = '/order_transactions_screen';
  static const ANALYTICS_SCREEN = '/analytics_screen';
  static const PROFILE_SETTINGS_SCREEN = '/profile_settings_screen';
  static const DELETE_ACCOUNT_SCREEN = '/delete_account_screen';
  static const EDIT_PROFILE_SCREEN = '/edit_profile_screen';
  static const BUSINESS_OPERATIONS_SCREEN = '/business_operations_screen';
  static const CHANGE_PASSWORD_SCREEN = '/change_password_screen';
  static const NEW_PASSWORD_ENTRY_SCREEN = '/new_password_entry_screen';
  static const FAQS_SCREEN = '/faqs_screen';

  static const WALLETS_HOME_SCREEN = '/wallets_home_screen';
  static const FUND_WALLET_SCREEN = '/fund_wallet_screen';
  static const TRANSACTIONS_SCREEN = '/transactions_screen';
  static const TRANSACTION_DETAILS_SCREEN = '/transaction_details_screen';

  // Payouts
  static const PAYOUT_REQUEST_SCREEN = '/payout_request_screen';
  static const PAYOUT_HISTORY_SCREEN = '/payout_history_screen';
  static const PAYOUT_DETAILS_SCREEN = '/payout_details_screen';

  static const RATINGS_AND_REVIEWS_HOME = '/ratings_and_reviews_home';
  static const SELECT_LOCATION_SCREEN = '/select_location_screen';


//   Menu
  static const ADD_MENU_SCREEN = '/add_menu_screen';
  static const EDIT_MENU_SCREEN = '/edit_menu_screen';
  static const MENU_DETAILS_SCREEN = '/menu_details_screen';
  static const MENU_HOME_SCREEN = '/menu_home_screen';
  static const CATEGORIES_MANAGEMENT_SCREEN = '/categories_management_screen';

  // Orders
  static const ORDERS_HOME_SCREEN = '/orders_home_screen';
  static const ORDER_DETAILS_SCREEN = '/order_details_screen';

  // Restaurant Management
  static const RESTAURANT_DETAILS_SCREEN = '/restaurant_details_screen';
  static const RESTAURANT_EDIT_BASIC_INFO = '/restaurant/edit-basic-info';
  static const RESTAURANT_EDIT_LOCATION = '/restaurant/edit-location';
  static const RESTAURANT_BUSINESS_HOURS = '/restaurant/business-hours';
  static const RESTAURANT_BUSINESS_SETTINGS = '/restaurant/business-settings';
}
