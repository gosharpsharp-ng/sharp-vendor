import 'dart:async';

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
    // No days pre-selected - user must choose
    // Default times are set when a day is selected (8am - 9pm)
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

  TextEditingController restaurantAddressController = TextEditingController();
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
          "longitude": "${restaurantLocation?.longitude}",
        },
        "schedule": schedule,
      };

      // Log registration data - create a copy with truncated base64 for logging
      Map<String, dynamic> dataForLogging = Map.from(data);

      // Truncate base64 strings for logging
      if (restaurantLogo != null) {
        dataForLogging['restaurant_logo'] =
            '${restaurantLogo!.substring(0, restaurantLogo!.length > 100 ? 100 : restaurantLogo!.length)}... [Total: ${restaurantLogo!.length} chars]';
      }
      if (restaurantBanner != null) {
        dataForLogging['restaurant_banner'] =
            '${restaurantBanner!.substring(0, restaurantBanner!.length > 100 ? 100 : restaurantBanner!.length)}... [Total: ${restaurantBanner!.length} chars]';
      }

      // Save complete request body as JSON to file
      print('\n' + '=' * 60);
      print('SIGNUP REQUEST - SAVING JSON BODY TO FILE');
      print('=' * 60);

      // Convert to JSON string
      try {
        // Also create a readable summary file
        Map<String, dynamic> summary = Map.from(data);
        if (summary.containsKey('restaurant_logo') &&
            summary['restaurant_logo'] != null) {
          String logo = summary['restaurant_logo'].toString();
          if (logo.startsWith('data:image')) {
            String mimeType = logo.substring(5, logo.indexOf(';'));
            summary['restaurant_logo'] =
                '[Base64 Image - $mimeType - ${logo.length} chars]';
          }
        }
        if (summary.containsKey('restaurant_banner') &&
            summary['restaurant_banner'] != null) {
          String banner = summary['restaurant_banner'].toString();
          if (banner.startsWith('data:image')) {
            String mimeType = banner.substring(5, banner.indexOf(';'));
            summary['restaurant_banner'] =
                '[Base64 Image - $mimeType - ${banner.length} chars]';
          }
        }
        if (summary.containsKey('password')) {
          summary['password'] = '***hidden***';
        }
      } catch (e) {
        print('Error saving JSON to file: $e');
        print('Data object: $data');
      }

      print('=' * 60 + '\n');

      APIResponse response = await authService.signup(data);

      // Print full response details
      print('\n' + '=' * 60);
      print('SIGNUP API RESPONSE');
      print('=' * 60);
      print('Status: ${response.status}');
      print('Message: ${response.message}');

      // Check if response data contains validation errors
      if (response.data is Map) {
        Map<String, dynamic> responseMap =
            response.data as Map<String, dynamic>;

        // Check for validation errors
        if (responseMap.containsKey('errors') &&
            responseMap['errors'] != null) {
          print('\nValidation Errors:');
          Map<String, dynamic> errors =
              responseMap['errors'] as Map<String, dynamic>;
          errors.forEach((field, messages) {
            print('  • $field:');
            if (messages is List) {
              for (var message in messages) {
                print('    - $message');
              }
            } else {
              print('    - $messages');
            }
          });
        }

        // Print timestamp if available
        if (responseMap.containsKey('timestamp')) {
          print('\nTimestamp: ${responseMap['timestamp']}');
        }
      }

      print('\nFull Response Data:');
      print(response.data.toString());
      print('=' * 60 + '\n');

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
      restaurantBanner = await convertImageToBase64(croppedPhoto.path);
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
      restaurantLogo = await convertImageToBase64(croppedPhoto.path);
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
      originalBanks = (response.data['banks'] as List)
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
        resolvedBankAccountName.text =
            response.data['account_details']['account_name'];
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
