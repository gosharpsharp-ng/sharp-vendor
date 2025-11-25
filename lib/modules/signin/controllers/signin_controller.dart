import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

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

  TextEditingController passwordController = TextEditingController();
  signIn() async {
    if (signInFormKey.currentState!.validate()) {
      setLoadingState(true);
      try {
        dynamic data = {
          'login':  loginController.text,
          'password': passwordController.text,
        };
        APIResponse response = await authService.login(data);

        if (response.status.toLowerCase() == "success") {
          print("*****************************************************************************");
          print(response.data['auth_token']);
          print("******************************************************************************");

          loginController.clear();
          passwordController.clear();
          filledPhoneNumber=null;
          update();
          final getStorage = GetStorage();
          getStorage.write("token", response.data['auth_token']);

          // Initialize DeliveryNotificationServiceManager first
          Get.put(DeliveryNotificationServiceManager());

          // Then initialize other controllers
          Get.put(SettingsController());
          Get.put(DeliveriesController());
          Get.toNamed(Routes.APP_NAVIGATION);
        }
      } catch (e) {
        print("Error during sign in: $e");
        showToast(
            message: "An unexpected error occurred. Please try again.",
            isError: true);
      } finally {
        // Always reset loading state, even if an error occurs
        setLoadingState(false);
      }
    }
  }
}
