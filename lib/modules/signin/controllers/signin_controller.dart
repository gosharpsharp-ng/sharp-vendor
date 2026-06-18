import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:sharpvendor/core/services/push_notification_service.dart';
import 'package:sharpvendor/core/services/analytics_service.dart' as firebase_analytics;

class SignInController extends GetxController {
  final authService = serviceLocator<AuthenticationService>();
  final signInFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  bool signInPasswordVisibility = false;

  togglePasswordVisibility() {
    signInPasswordVisibility = !signInPasswordVisibility;
    update();
  }

  bool signInWithEmail = true;

  toggleSignInWithEmail() {
    signInWithEmail = !signInWithEmail;
    loginController.clear();
    update();
  }

  TextEditingController loginController = TextEditingController();

  setPhoneNumber(val) {
    loginController.text = val;
    update();
  }

  PhoneNumber? filledPhoneNumber;
  setFilledPhoneNumber(PhoneNumber num) {
    filledPhoneNumber = num;
    update();
  }

  String? loginErrorMessage;

  TextEditingController passwordController = TextEditingController();
  signIn() async {
    loginErrorMessage = null;
    update();

    if (signInFormKey.currentState!.validate()) {
      setLoadingState(true);
      try {
        dynamic data = {
          'login': loginController.text,
          'password': passwordController.text,
        };
        APIResponse response = await authService.login(data);

        if (response.status.toLowerCase() == "success") {
          print(
            "*****************************************************************************",
          );
          print(response.data['auth_token']);
          print(
            "******************************************************************************",
          );

          loginController.clear();
          passwordController.clear();
          filledPhoneNumber = null;
          update();
          final getStorage = GetStorage();
          getStorage.write("token", response.data['auth_token']);

          // Register device token for push notifications
          await PushNotificationService().registerTokenIfAvailable();

          // Track user login in Firebase Analytics
          final userProfile = response.data['user'];
          if (userProfile != null && userProfile['id'] != null) {
            await firebase_analytics.AnalyticsService().setUserId(userProfile['id'].toString());
            await firebase_analytics.AnalyticsService().setUserProperty('user_type', 'vendor');
          }

          // Initialize DeliveryNotificationServiceManager first
          Get.put(DeliveryNotificationServiceManager());

          // Then initialize other controllers
          Get.put(SettingsController());
          Get.put(DeliveriesController());
          Get.toNamed(Routes.APP_NAVIGATION);
        } else {
          loginErrorMessage = response.message;
          update();
        }
      } catch (e) {
        print("Error during sign in: $e");
        loginErrorMessage = "An unexpected error occurred. Please try again.";
        update();
      } finally {
        // Always reset loading state, even if an error occurs
        setLoadingState(false);
      }
    }
  }
}
