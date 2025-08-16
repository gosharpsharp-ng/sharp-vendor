import 'dart:async';

import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignUpController extends GetxController {
  late Timer _otpResendTimer;
  int resendOTPAfter = 120;
  String remainingTime = "";

  void _startOtpResendTimer() {
    resendOTPAfter = 120;
    const oneSec = Duration(seconds: 1);
    _otpResendTimer = Timer.periodic(oneSec, (Timer timer) {
      update();
      if (resendOTPAfter > 0) {
        resendOTPAfter--;
        remainingTime = getFormattedResendOTPTime(resendOTPAfter);
        update();
      } else {
        update();
        _otpResendTimer.cancel();
        update();
      }
    });
  }

  final authService = serviceLocator<AuthenticationService>();
  final signUpFormKey = GlobalKey<FormState>();
  final businessInfoFormKey = GlobalKey<FormState>();
  final businessOpsFormKey = GlobalKey<FormState>();
  final businessBankAccountFormKey = GlobalKey<FormState>();
  final signOTPFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  bool isResendingOtp = false;
  setIsResendingOTPState(bool val) {
    isResendingOtp = val;
    update();
  }

  bool signUpPasswordVisibility = false;

  togglePasswordVisibility() {
    signUpPasswordVisibility = !signUpPasswordVisibility;
    update();
  }

  bool signUpConfirmPasswordVisibility = false;

  toggleConfirmPasswordVisibility() {
    signUpConfirmPasswordVisibility = !signUpConfirmPasswordVisibility;
    update();
  }

  TextEditingController otpController = TextEditingController();
  verifyOtp() async {
    if (signOTPFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'otp': otpController.text,
        'email': emailController.text,
        // 'phone': filledPhoneNumber?.completeNumber??"",
      };
      APIResponse response = await authService.verifyEmailOtp(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        Get.offAllNamed(Routes.SIGN_IN);
      }
    }
  }

  sendOtp() async {
    setIsResendingOTPState(true);
    dynamic data = {
      'login': emailController.text,
    };
    APIResponse response = await authService.sendOtp(data);
    showToast(message: response.message, isError: response.status != "success");
    setIsResendingOTPState(false);
    if (response.status == "success") {
      _startOtpResendTimer();
    }
  }

  setPhoneNumber(val) {
    phoneNumberController.text = val;
    update();
  }

  PhoneNumber? filledPhoneNumber;
  setFilledPhoneNumber(PhoneNumber num) {
    filledPhoneNumber = num;
    update();
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  signUp() async {
    if (signUpFormKey.currentState!.validate() &&
        phoneNumberController.text.isNotEmpty) {
      setLoadingState(true);
      dynamic data = {
        'fname': firstNameController.text,
        'lname': lastNameController.text,
        'email': emailController.text,
        'phone': filledPhoneNumber?.completeNumber ?? '',
        'as_rider': false,
        'password': passwordController.text,
      };
      APIResponse response = await authService.signup(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        _startOtpResendTimer();
        Get.offAndToNamed(Routes.SIGNUP_OTP_SCREEN);
      }
    }
  }
  // Business Information Entry
  final ImagePicker _picker = ImagePicker();
  String? parcelImage;
  selectParcelImage({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      parcelImage = await convertImageToBase64(croppedPhoto.path);
      update();
    }
  }


  // Bank Details Entry
  List<BankModel> originalBanks = [];
  List<BankModel> filteredBanks = [];
  TextEditingController banksFilterController = TextEditingController();
  filterBanks(String query) {
    if (originalBanks.isNotEmpty && query.isNotEmpty) {
      filteredBanks = originalBanks
          .where((element) =>
      (element.name.toLowerCase().contains(query.toLowerCase()) ||
          element.name.toLowerCase().contains(query.toLowerCase()) ||
          element.name.toLowerCase().contains(query.toLowerCase())))
          .toList();
    } else {
      filteredBanks = originalBanks;
    }
    update();
  }

  bool isLoadingBanks = false;
  getBankList() async {
    isLoadingBanks = true;
    update();
    APIResponse response = await walletService.getBankList();
    isLoadingBanks = false;
    update();
    if (response.status == "success") {
      originalBanks =
          (response.data as List).map((bk) => BankModel.fromJson(bk)).toList();
      filteredBanks = originalBanks;
      update();
    }
  }

  final walletService = serviceLocator<WalletsService>();
  BankModel? selectedBank;
  setSelectedBank(BankModel bank) async {
    selectedBank = bank;
    bankNameController.setText(bank.name);
    update();
    if (accountNumberController.text.length == 10) {
      await verifyPayoutBank();
    }
  }
  TextEditingController resolvedBankAccountName = TextEditingController();
  clearImputedBankFields() {
    resolvedBankAccountName.clear();
    bankNameController.clear();
    accountNumberController.clear();
    selectedBank = null;
    update();
  }


  final payoutAccountFormKey = GlobalKey<FormState>();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  bool verifyingAccountNumber = false;
  verifyPayoutBank() async {
    if (selectedBank != null) {
      verifyingAccountNumber = true;
      update();
      dynamic data = {
        'account_number': accountNumberController.text,
        'bank_code': selectedBank!.code,
      };
      print(data.toString());
      APIResponse response = await walletService.verifyPayoutBank(data);
      verifyingAccountNumber = false;
      update();
      if (response.status == "success") {
        resolvedBankAccountName.text = response.data['account_name'];
        update();
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }
}
