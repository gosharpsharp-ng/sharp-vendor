import 'package:sharpvendor/core/utils/exports.dart';
import 'dart:io';

import '../../../core/models/restaurant_model.dart';

class RestaurantDetailsController extends GetxController {
  final ProfileService _profileService = serviceLocator<ProfileService>();
  final SettingsController _settingsController = Get.find<SettingsController>();
  final WalletsService _walletsService = serviceLocator<WalletsService>();

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  void setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  void setUpdatingState(bool val) {
    _isUpdating = val;
    update();
  }

  // Restaurant data
  RestaurantModel? get restaurant =>
      _settingsController.userProfile?.restaurant;
  UserProfile? get userProfile => _settingsController.userProfile;

  // Form controllers for basic info editing
  final basicInfoFormKey = GlobalKey<FormState>();
  late TextEditingController restaurantNameController;
  late TextEditingController descriptionController;
  late TextEditingController cuisineTypeController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // Form controllers for business settings
  final businessSettingsFormKey = GlobalKey<FormState>();
  late TextEditingController commissionRateController;
  late TextEditingController businessRegNumberController;
  late TextEditingController taxIdController;

  // Location editing
  RestaurantLocation? editingLocation;

  // Image selection
  final ImagePicker _picker = ImagePicker();
  File? bannerImage;
  File? logoImage;
  String? bannerImageBase64;
  String? logoImageBase64;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    restaurantNameController = TextEditingController();
    descriptionController = TextEditingController();
    cuisineTypeController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    commissionRateController = TextEditingController();
    businessRegNumberController = TextEditingController();
    taxIdController = TextEditingController();

    // Bank account controllers
    bankNameController = TextEditingController();
    accountNumberController = TextEditingController();
    accountNameController = TextEditingController();
    banksSearchController = TextEditingController();

    _populateControllers();
  }

  void _populateControllers() {
    if (restaurant != null) {
      restaurantNameController.text = restaurant!.name;
      descriptionController.text = restaurant!.description ?? '';
      cuisineTypeController.text = restaurant!.cuisineType;
      emailController.text = restaurant!.email;
      phoneController.text = restaurant!.phone;
      commissionRateController.text = restaurant!.commissionRate.toString();
      businessRegNumberController.text =
          restaurant!.businessRegistrationNumber ?? '';
      taxIdController.text = restaurant!.taxIdentificationNumber ?? '';
      editingLocation = restaurant!.location;
    }
  }

  // Refresh restaurant data
  Future<void> refreshRestaurantData() async {
    await _settingsController.getProfile();
    _populateControllers();

    // Clear any pending image changes
    bannerImage = null;
    logoImage = null;
    bannerImageBase64 = null;
    logoImageBase64 = null;
  }


  // Generic method to update restaurant profile using the same endpoint as user profile
  Future<void> _updateRestaurantProfile(
    Map<String, dynamic> updateData, {
    String? successMessage,
    bool shouldNavigateBack = true,
  }) async {
    setUpdatingState(true);
    try {
      final response = await _profileService.updateProfile(updateData);

      if (response.status == "success") {
        // Clear selected images after successful upload if images were included
        if (updateData.containsKey('restaurant_banner') ||
            updateData.containsKey('restaurant_logo')) {
          bannerImage = null;
          logoImage = null;
          bannerImageBase64 = null;
          logoImageBase64 = null;
        }

        await refreshRestaurantData();
        if (shouldNavigateBack) Get.back();
        showToast(
          message: successMessage ?? "Restaurant updated successfully",
          isError: false,
        );
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(
        message: "Error updating restaurant: ${e.toString()}",
        isError: true,
      );
    } finally {
      setUpdatingState(false);
    }
  } // Generic method to update restaurant profile using the same endpoint as user profile

  Future<void> _updateBankAccount(
    Map<String, dynamic> updateData, {
    String? successMessage,
    bool shouldNavigateBack = true,
  }) async {
    setUpdatingState(true);
    try {
      final response = await _profileService.updateBankAccount(updateData);

      if (response.status == "success") {
        await refreshRestaurantData();
        if (shouldNavigateBack) Get.back();
        selectedBank = null;
        accountNumberController.clear();
        accountNameController.clear();
        showToast(
          message: successMessage ?? "Bank details updated successfully",
          isError: false,
        );
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(
        message: "Error updating bank account: ${e.toString()}",
        isError: true,
      );
    } finally {
      setUpdatingState(false);
    }
  }

  // Update basic restaurant information
  Future<void> updateBasicInfo() async {
    if (!basicInfoFormKey.currentState!.validate()) return;

    // Only include changed fields
    Map<String, dynamic> updateData = {};

    // Check for text field changes
    if (restaurant != null) {
      if (restaurantNameController.text.trim() != restaurant!.name) {
        updateData['restaurant_name'] = restaurantNameController.text.trim();
      }
      if (descriptionController.text.trim() !=
          (restaurant!.description ?? '')) {
        updateData['description'] = descriptionController.text.trim();
      }
      if (cuisineTypeController.text.trim() != restaurant!.cuisineType) {
        updateData['cuisine_type'] = cuisineTypeController.text.trim();
      }
      if (emailController.text.trim() != restaurant!.email) {
        updateData['restaurant_email'] = emailController.text.trim();
      }
      if (phoneController.text.trim() != restaurant!.phone) {
        updateData['restaurant_phone'] = phoneController.text.trim();
      }
    }

    // Add base64 images directly to updateData if available
    if (bannerImageBase64 != null) {
      updateData['restaurant_banner'] = bannerImageBase64!;
    }
    if (logoImageBase64 != null) {
      updateData['restaurant_logo'] = logoImageBase64!;
    }

    // Check if there are any changes to update
    if (updateData.isEmpty) {
      showToast(message: "No changes to update", isError: false);
      return;
    }

    await _updateRestaurantProfile(
      updateData,
      successMessage: "Restaurant information updated successfully",
    );
  }

  // Update business settings
  Future<void> updateBusinessSettings() async {
    if (!businessSettingsFormKey.currentState!.validate()) return;

    final updateData = {
      'restaurant': {
        'commission_rate':
            double.tryParse(commissionRateController.text) ?? 0.0,
        'business_registration_number': businessRegNumberController.text,
        'tax_identification_number': taxIdController.text,
      },
    };

    await _updateRestaurantProfile(
      updateData,
      successMessage: "Business settings updated successfully",
    );
  }

  // Update restaurant location
  Future<void> updateLocation(RestaurantLocation location) async {
    final updateData = {
      'restaurant_location': {
        'name': location.name,
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
      },
    };

    await _updateRestaurantProfile(
      updateData,
      successMessage: "Restaurant location updated successfully",
    );
  }

  // Toggle restaurant active status
  Future<void> toggleRestaurantStatus() async {
    if (restaurant == null) return;

    final updateData = {
      'restaurant': {'is_active': !restaurant!.isActive},
    };

    final status = !restaurant!.isActive ? "activated" : "deactivated";
    await _updateRestaurantProfile(
      updateData,
      successMessage: "Restaurant $status successfully",
      shouldNavigateBack: false,
    );
  }

  // Image selection methods
  Future<void> selectBannerImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 400,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final croppedPhoto = await cropImage(pickedFile);
        bannerImage = File(croppedPhoto.path);

        // Immediately convert to base64
        bannerImageBase64 = await convertImageToBase64(croppedPhoto.path);
        showToast(
          message: "Banner image selected successfully",
          isError: false,
        );

        update();
      }
    } catch (e) {
      showToast(
        message: "Error selecting banner image: ${e.toString()}",
        isError: true,
      );
    }
  }

  Future<void> selectLogoImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final croppedPhoto = await cropImage(pickedFile);
        logoImage = File(croppedPhoto.path);

        // Immediately convert to base64
        logoImageBase64 = await convertImageToBase64(croppedPhoto.path);
        showToast(
          message: "Logo image selected successfully",
          isError: false,
        );

        update();
      }
    } catch (e) {
      showToast(
        message: "Error selecting logo image: ${e.toString()}",
        isError: true,
      );
    }
  }

  // Set editing location helper
  void setEditingLocation() {
    editingLocation = restaurant?.location;
    update();
  }

  // Business Hours Management
  Map<String, bool> selectedDays = {
    'monday': false,
    'tuesday': false,
    'wednesday': false,
    'thursday': false,
    'friday': false,
    'saturday': false,
    'sunday': false,
  };

  Map<String, Map<String, String>> dayOperatingHours = {
    'monday': {'openTime': '', 'closeTime': ''},
    'tuesday': {'openTime': '', 'closeTime': ''},
    'wednesday': {'openTime': '', 'closeTime': ''},
    'thursday': {'openTime': '', 'closeTime': ''},
    'friday': {'openTime': '', 'closeTime': ''},
    'saturday': {'openTime': '', 'closeTime': ''},
    'sunday': {'openTime': '', 'closeTime': ''},
  };

  // Initialize business hours from existing restaurant data
  void initializeBusinessHours() {
    if (restaurant?.schedules.isEmpty ?? true) {
      selectedDays.forEach((key, value) {
        selectedDays[key] = false;
        dayOperatingHours[key] = {'openTime': '', 'closeTime': ''};
      });
    } else {
      for (var schedule in restaurant!.schedules) {
        String day = schedule.dayOfWeek.toLowerCase();
        selectedDays[day] = true;
        dayOperatingHours[day] = {
          'openTime': schedule.formattedOpenTime,
          'closeTime': schedule.formattedCloseTime,
        };
      }
    }
    update();
  }

  // Toggle day selection
  void toggleDaySelection(String day) {
    selectedDays[day] = !selectedDays[day]!;
    if (!selectedDays[day]!) {
      dayOperatingHours[day] = {'openTime': '', 'closeTime': ''};
    } else {
      if (dayOperatingHours[day]!['openTime']!.isEmpty) {
        dayOperatingHours[day] = {
          'openTime': '09:00 AM',
          'closeTime': '09:00 PM',
        };
      }
    }
    update();
  }

  // Select time for specific day
  Future<void> selectTimeForDay({
    required BuildContext context,
    required String day,
    required bool isOpeningTime,
  }) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && context.mounted) {
      String formattedTime = pickedTime.format(context);
      if (isOpeningTime) {
        dayOperatingHours[day]!['openTime'] = formattedTime;
      } else {
        dayOperatingHours[day]!['closeTime'] = formattedTime;
      }
      update();
    }
  }

  // Convert 12-hour time format to 24-hour format (e.g., "09:00 AM" -> "09:00")
  String _convertTo24HourFormat(String time12h) {
    try {
      // Remove extra spaces
      time12h = time12h.trim();

      // Split time and period (AM/PM)
      final parts = time12h.split(' ');
      if (parts.length != 2) return time12h; // Already in 24h format

      final timePart = parts[0];
      final period = parts[1].toUpperCase();

      final timeParts = timePart.split(':');
      int hour = int.parse(timeParts[0]);
      final minute = timeParts[1];

      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return '${hour.toString().padLeft(2, '0')}:$minute';
    } catch (e) {
      debugPrint("Error converting time format: $e");
      return time12h;
    }
  }

  // Update business hours
  Future<void> updateBusinessHours() async {
    bool hasSelectedDays = selectedDays.values.any((selected) => selected);
    if (!hasSelectedDays) {
      showToast(
        message: "Please select at least one operating day",
        isError: true,
      );
      return;
    }

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
          return;
        }
      }
    }

    setUpdatingState(true);

    try {
      List<Map<String, dynamic>> schedules = [];
      selectedDays.forEach((day, isSelected) {
        if (isSelected && dayOperatingHours[day] != null) {
          String openTime = dayOperatingHours[day]!['openTime'] ?? '';
          String closeTime = dayOperatingHours[day]!['closeTime'] ?? '';
          if (openTime.isNotEmpty && closeTime.isNotEmpty) {
            schedules.add({
              "day": day,
              "open": _convertTo24HourFormat(openTime),
              "close": _convertTo24HourFormat(closeTime),
            });
          }
        }
      });

      final updateData = {'schedules': schedules};

      await _updateRestaurantProfile(
        updateData,
        successMessage: "Business hours updated successfully",
      );
    } catch (e) {
      showToast(
        message: "Error updating business hours: ${e.toString()}",
        isError: true,
      );
    } finally {
      setUpdatingState(false);
    }
  }

  // Bank Account Management
  final bankAccountFormKey = GlobalKey<FormState>();
  late TextEditingController bankNameController;
  late TextEditingController accountNumberController;
  late TextEditingController accountNameController;
  late TextEditingController banksSearchController;

  bool _isVerifyingAccount = false;
  bool get isVerifyingAccount => _isVerifyingAccount;

  void setVerifyingAccountState(bool val) {
    _isVerifyingAccount = val;
    update();
  }

  // Bank list
  List<BankModel> banks = [];
  List<BankModel> originalBanks = [];
  BankModel? selectedBank;

  // Get list of banks
  Future<void> getBankList() async {
    if (banks.isNotEmpty) return; // Already loaded

    setLoadingState(true);
    try {
      final response = await _walletsService.getBankList();
      if (response.status == "success") {
        banks = (response.data['banks'] as List)
            .map((bank) => BankModel.fromJson(bank))
            .toList();
        originalBanks = List.from(banks);
        update();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Error loading banks: ${e.toString()}", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Set selected bank
  void setSelectedBank(BankModel bank) {
    selectedBank = bank;
    bankNameController.text = bank.name;
    // Clear account name when bank changes
    accountNameController.clear();
    update();
  }

  // Search banks
  void searchBanks(String query) {
    if (query.isEmpty) {
      banks = List.from(originalBanks);
    } else {
      banks = originalBanks
          .where(
            (bank) => bank.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    update();
  }

  // Verify bank account when account number reaches 10 digits
  Future<void> verifyBankAccount() async {
    if (selectedBank == null) {
      showToast(message: "Please select a bank first", isError: true);
      return;
    }

    if (accountNumberController.text.length != 10) {
      return;
    }

    setVerifyingAccountState(true);

    try {
      final data = {
        'account_number': accountNumberController.text,
        'bank_code': selectedBank!.code,
      };
      customDebugPrint(data.toString());
      final response = await _walletsService.verifyPayoutBank(data);

      if (response.status == "success") {
        accountNameController.text =
            response.data['account_details']['account_name'];
        showToast(message: "Account verified successfully", isError: false);
        update();
      } else {
        accountNameController.clear();
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      accountNameController.clear();
      showToast(
        message: "Error verifying account: ${e.toString()}",
        isError: true,
      );
    } finally {
      setVerifyingAccountState(false);
    }
  }

  // Update bank account
  Future<void> updateBankAccount() async {
    if (!bankAccountFormKey.currentState!.validate()) return;

    if (selectedBank == null) {
      showToast(message: "Please select a bank", isError: true);
      return;
    }

    if (accountNameController.text.isEmpty) {
      showToast(
        message: "Please verify your account number first",
        isError: true,
      );
      return;
    }

    setUpdatingState(true);

    try {
      final updateData = {
        'bank_name': selectedBank!.name,
        'bank_code': selectedBank!.code,
        'bank_account_number': accountNumberController.text,
        'bank_account_name': accountNameController.text,
      };

      await _updateBankAccount(
        updateData,
        successMessage: "Bank account updated successfully",
      );
    } catch (e) {
      showToast(
        message: "Error updating bank account: ${e.toString()}",
        isError: true,
      );
    } finally {
      setUpdatingState(false);
    }
  }

  // Initialize bank account form
  void initializeBankAccountForm() {
    bankNameController = TextEditingController();
    accountNumberController = TextEditingController();
    accountNameController = TextEditingController();

    // Load existing bank account data if available
    if (restaurant?.bankAccount != null) {
      bankNameController.text = restaurant!.bankAccount!.bankName;
      accountNumberController.text = restaurant!.bankAccount!.bankAccountNumber;
      accountNameController.text = restaurant!.bankAccount!.bankAccountName;

      // Try to find and set the selected bank
      if (banks.isNotEmpty) {
        selectedBank = banks.firstWhereOrNull(
          (bank) => bank.name == restaurant!.bankAccount!.bankName,
        );
      }
    }
  }

  // Helper methods
  String getStatusText() {
    if (restaurant == null) return "Unknown";
    return restaurant!.isActive ? "Active" : "Inactive";
  }

  Color getStatusColor() {
    if (restaurant == null) return AppColors.greyColor;
    return restaurant!.isActive ? AppColors.greenColor : Colors.red;
  }

  String getFormattedBalance() {
    if (restaurant?.wallet == null) return formatToCurrency(0);
    return formatToCurrency(restaurant!.wallet!.balanceDouble);
  }

  String getFormattedBonusBalance() {
    if (restaurant?.wallet == null) return formatToCurrency(0);
    return formatToCurrency(restaurant!.wallet!.bonusBalanceDouble);
  }

  String getTodayOperatingHours() {
    if (restaurant?.schedules.isEmpty ?? true) return "No schedule set";

    final today = DateTime.now().weekday;
    final dayNames = [
      '',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final todayName = dayNames[today];

    final todaySchedule = restaurant!.schedules.firstWhereOrNull(
      (schedule) => schedule.dayOfWeek.toLowerCase() == todayName,
    );

    if (todaySchedule != null) {
      return todaySchedule.timeRange;
    }

    return "Closed today";
  }

  bool isOpenNow() {
    if (restaurant?.schedules.isEmpty ?? true) return false;

    final now = DateTime.now();
    final today = now.weekday;
    final dayNames = [
      '',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final todayName = dayNames[today];

    final todaySchedule = restaurant!.schedules.firstWhereOrNull(
      (schedule) => schedule.dayOfWeek.toLowerCase() == todayName,
    );

    if (todaySchedule == null) return false;

    final currentTime = TimeOfDay.fromDateTime(now);
    final openTime = TimeOfDay.fromDateTime(todaySchedule.openTime);
    final closeTime = TimeOfDay.fromDateTime(todaySchedule.closeTime);

    return _isTimeInRange(currentTime, openTime, closeTime);
  }

  bool _isTimeInRange(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (endMinutes > startMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Handle overnight hours
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }

  @override
  void onClose() {
    restaurantNameController.dispose();
    descriptionController.dispose();
    cuisineTypeController.dispose();
    emailController.dispose();
    phoneController.dispose();
    commissionRateController.dispose();
    businessRegNumberController.dispose();
    taxIdController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    accountNameController.dispose();
    banksSearchController.dispose();
    super.onClose();
  }
}
