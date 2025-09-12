import 'dart:async';
import 'dart:developer';
import 'dart:io' show File;

import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignUpController extends GetxController {
  Map<String, Map<String, String>> dayOperatingHours = {
    'monday': {'openTime': '', 'closeTime': ''},
    'tuesday': {'openTime': '', 'closeTime': ''},
    'wednesday': {'openTime': '', 'closeTime': ''},
    'thursday': {'openTime': '', 'closeTime': ''},
    'friday': {'openTime': '', 'closeTime': ''},
    'saturday': {'openTime': '', 'closeTime': ''},
    'sunday': {'openTime': '', 'closeTime': ''},
  };

  // Selected Days
  Map<String, bool> selectedDays = {
    'monday': false,
    'tuesday': false,
    'wednesday': false,
    'thursday': false,
    'friday': false,
    'saturday': false,
    'sunday': false,
  };
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

  // ============ BUSINESS OPERATIONS HOURS ============

  // Business Hours Controllers
  TextEditingController weekdayOpenTimeController = TextEditingController();
  TextEditingController weekdayCloseTimeController = TextEditingController();
  TextEditingController weekendOpenTimeController = TextEditingController();
  TextEditingController weekendCloseTimeController = TextEditingController();

  // Initialize default values
  @override
  void onInit() {
    super.onInit();
    // Set default times
    dayOperatingHours['monday'] = {
      'openTime': '08:00 AM',
      'closeTime': '09:00 PM',
    };
    dayOperatingHours['tuesday'] = {
      'openTime': '08:00 AM',
      'closeTime': '09:00 PM',
    };
    dayOperatingHours['wednesday'] = {
      'openTime': '08:00 AM',
      'closeTime': '09:00 PM',
    };
    dayOperatingHours['thursday'] = {
      'openTime': '08:00 AM',
      'closeTime': '09:00 PM',
    };
    dayOperatingHours['friday'] = {
      'openTime': '08:00 AM',
      'closeTime': '09:00 PM',
    };
    dayOperatingHours['saturday'] = {'openTime': '', 'closeTime': ''};
    dayOperatingHours['sunday'] = {'openTime': '', 'closeTime': ''};

    // Set default selected days (Monday to Friday)
    selectedDays['monday'] = true;
    selectedDays['tuesday'] = true;
    selectedDays['wednesday'] = false;
    selectedDays['thursday'] = false;
    selectedDays['friday'] = false;
    selectedDays['saturday'] = true;
    selectedDays['sunday'] = true;
  }

  // Toggle day selection
  void toggleDaySelection(String day) {
    selectedDays[day] = !selectedDays[day]!;

    // If day is deselected, clear its operating hours
    if (!selectedDays[day]!) {
      dayOperatingHours[day] = {'openTime': '', 'closeTime': ''};
    } else {
      // If day is selected and has no times, set default times
      if (dayOperatingHours[day]!['openTime']!.isEmpty ||
          dayOperatingHours[day]!['closeTime']!.isEmpty) {
        dayOperatingHours[day] = {
          'openTime': '08:00 AM',
          'closeTime': '09:00 PM',
        };
      }
    }
    update();
  }

  // Select time for specific day
  Future<void> selectTimeForDay({
    required String day,
    required bool isOpeningTime,
  }) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime = formatTimeOfDay(pickedTime);

      if (isOpeningTime) {
        dayOperatingHours[day]!['openTime'] = formattedTime;
      } else {
        dayOperatingHours[day]!['closeTime'] = formattedTime;
      }
      update();
    }
  }

  // Generate schedule array for API
  List<Map<String, dynamic>> generateScheduleArray() {
    List<Map<String, dynamic>> schedule = [];

    selectedDays.forEach((day, isSelected) {
      if (isSelected && dayOperatingHours[day] != null) {
        String openTime = convertTo24Hour(
          dayOperatingHours[day]!['openTime'] ?? '',
        );
        String closeTime = convertTo24Hour(
          dayOperatingHours[day]!['closeTime'] ?? '',
        );

        if (openTime.isNotEmpty && closeTime.isNotEmpty) {
          schedule.add({"day": day, "open": openTime, "close": closeTime});
        }
      }
    });

    return schedule;
  }
  TextEditingController restaurantAddressController=TextEditingController();
  ItemLocation? restaurantLocation;
  void setRestaurantLocation(ItemLocation point) {
    restaurantLocation = point;
    restaurantAddressController.setText(point.formattedAddress!);
    update();
  }
  // Validate business operations form
  bool validateBusinessOperations() {
    // Check if at least one day is selected
    bool hasSelectedDays = selectedDays.values.any((selected) => selected);
    if (!hasSelectedDays) {
      showToast(
        message: "Please select at least one operating day",
        isError: true,
      );
      return false;
    }

    // Validate that each selected day has both opening and closing times
    for (String day in selectedDays.keys) {
      if (selectedDays[day]!) {
        String openTime = dayOperatingHours[day]!['openTime'] ?? '';
        String closeTime = dayOperatingHours[day]!['closeTime'] ?? '';

        if (openTime.isEmpty || closeTime.isEmpty) {
          String capitalizedDay =
              day.substring(0, 1).toUpperCase() + day.substring(1);
          showToast(
            message:
                "Please set both opening and closing times for $capitalizedDay",
            isError: true,
          );
          return false;
        }

        // Validate that closing time is after opening time
        TimeOfDay openTimeOfDay = parseTimeString(openTime);
        TimeOfDay closeTimeOfDay = parseTimeString(closeTime);

        if (!isValidTimeRange(openTimeOfDay, closeTimeOfDay)) {
          String capitalizedDay =
              day.substring(0, 1).toUpperCase() + day.substring(1);
          showToast(
            message:
                "Closing time must be after opening time for $capitalizedDay",
            isError: true,
          );
          return false;
        }
      }
    }

    return true;
  }

  // Submit business operations and proceed
  void submitBusinessOperations() {
    if (validateBusinessOperations()) {
      // Operations data is valid, proceed to next screen
      // Get.toNamed(Routes.BANK_INFO_ENTRY_SCREEN);

      signUp();
    }
  }

  // Copy times from one day to another (utility method)
  void copyTimesToDay(String fromDay, String toDay) {
    if (dayOperatingHours[fromDay] != null &&
        dayOperatingHours[toDay] != null) {
      dayOperatingHours[toDay]!['openTime'] =
          dayOperatingHours[fromDay]!['openTime'] ?? '';
      dayOperatingHours[toDay]!['closeTime'] =
          dayOperatingHours[fromDay]!['closeTime'] ?? '';
      update();
    }
  }

  // Apply same hours to multiple days (utility method)
  void applySameHoursToSelectedDays(String openTime, String closeTime) {
    selectedDays.forEach((day, isSelected) {
      if (isSelected) {
        dayOperatingHours[day]!['openTime'] = openTime;
        dayOperatingHours[day]!['closeTime'] = closeTime;
      }
    });
    update();
  }
  // ============ END BUSINESS OPERATIONS HOURS ============

  TextEditingController otpController = TextEditingController();
  verifyOtp() async {
    if (signOTPFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {'otp': otpController.text, 'email': emailController.text};
      APIResponse response = await authService.verifyEmailOtp(data);
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      setLoadingState(false);
      if (response.status == "success") {
        Get.offAllNamed(Routes.SIGN_IN);
      }
    }
  }

  sendOtp() async {
    setIsResendingOTPState(true);
    dynamic data = {'login': emailController.text};
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
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController restaurantPhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController restaurantEmailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  signUp() async {
    if (signUpFormKey.currentState!.validate() &&
        phoneNumberController.text.isNotEmpty) {
      setLoadingState(true);

      // Generate the schedule from the business operations data
      List<Map<String, dynamic>> schedule = generateScheduleArray();

      dynamic data = {
        'fname': firstNameController.text,
        'lname': lastNameController.text,
        'email': emailController.text,
        'phone': filledPhoneNumber?.completeNumber ?? '',
        'password': passwordController.text,
        "restaurant_name": restaurantNameController.text,
        "restaurant_phone": restaurantPhoneController.text,
        "restaurant_email": restaurantEmailController.text,
        "restaurant_logo": restaurantLogo,
        "restaurant_banner": restaurantBanner,
        "cuisine_type": "Italian",
        "restaurant_location": {
          "name": restaurantAddressController.text,
          "latitude": "${restaurantLocation?.latitude}",
          "longitude": "${restaurantLocation?.longitude}"
        },
        "schedule": schedule,
      };

      dynamic dataWithoutImages = Map.from(data)
        ..remove("restaurant_logo")
        ..remove("restaurant_banner");
print("******************************************Request****************************************************************");
log(dataWithoutImages.toString());
print("**********************************************************************************************************");
      APIResponse response = await authService.signup(data);
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      setLoadingState(false);
      if (response.status == "success") {
        _startOtpResendTimer();
        Get.offAndToNamed(Routes.SIGNUP_OTP_SCREEN);
      }
    }
  }

  // Business Information Entry
  final ImagePicker _picker = ImagePicker();
  String? restaurantBanner;
  void selectRestaurantBanner({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      final compressed = await ImageCompressionService.compressImage(XFile(croppedPhoto.path));

      restaurantBanner = await convertImageToBase64(compressed.path);
      update();
    }
  }

  String? restaurantLogo;
  void selectRestaurantLogo({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      final compressed = await ImageCompressionService.compressImage(XFile(croppedPhoto.path));
      restaurantLogo = await convertImageToBase64(compressed.path);
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
          .where(
            (element) =>
                (element.name.toLowerCase().contains(query.toLowerCase()) ||
                element.name.toLowerCase().contains(query.toLowerCase()) ||
                element.name.toLowerCase().contains(query.toLowerCase())),
          )
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
      originalBanks = (response.data as List)
          .map((bk) => BankModel.fromJson(bk))
          .toList();
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
          message: response.message,
          isError: response.status != "success",
        );
      }
    }
  }
}
