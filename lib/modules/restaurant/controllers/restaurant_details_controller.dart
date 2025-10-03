import 'package:sharpvendor/core/utils/exports.dart';
import 'dart:io';

import '../../../core/models/restaurant_model.dart';

class RestaurantDetailsController extends GetxController {
  final ProfileService _profileService = serviceLocator<ProfileService>();
  final SettingsController _settingsController = Get.find<SettingsController>();

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
  RestaurantModel? get restaurant => _settingsController.userProfile?.restaurant;
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
      businessRegNumberController.text = restaurant!.businessRegistrationNumber ?? '';
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

  // Convert File to base64
  Future<String?> _fileToBase64(File file) async {
    try {
      List<int> imageBytes = await file.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      debugPrint("Error converting file to base64: $e");
      return null;
    }
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
        if (updateData.containsKey('restaurant_banner') || updateData.containsKey('restaurant_logo')) {
          bannerImage = null;
          logoImage = null;
          bannerImageBase64 = null;
          logoImageBase64 = null;
        }

        await refreshRestaurantData();
        if (shouldNavigateBack) Get.back();
        showToast(message: successMessage ?? "Restaurant updated successfully", isError: false);
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Error updating restaurant: ${e.toString()}", isError: true);
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
      if (descriptionController.text.trim() != (restaurant!.description ?? '')) {
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
        'commission_rate': double.tryParse(commissionRateController.text) ?? 0.0,
        'business_registration_number': businessRegNumberController.text,
        'tax_identification_number': taxIdController.text,
      }
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
      }
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
      'restaurant': {
        'is_active': !restaurant!.isActive,
      }
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
        bannerImage = File(pickedFile.path);

        // Immediately convert to base64
        bannerImageBase64 = await _fileToBase64(bannerImage!);
        if (bannerImageBase64 != null) {
          showToast(message: "Banner image selected successfully", isError: false);
        }

        update();
      }
    } catch (e) {
      showToast(message: "Error selecting banner image: ${e.toString()}", isError: true);
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
        logoImage = File(pickedFile.path);

        // Immediately convert to base64
        logoImageBase64 = await _fileToBase64(logoImage!);
        if (logoImageBase64 != null) {
          showToast(message: "Logo image selected successfully", isError: false);
        }

        update();
      }
    } catch (e) {
      showToast(message: "Error selecting logo image: ${e.toString()}", isError: true);
    }
  }

  // Set editing location helper
  void setEditingLocation() {
    editingLocation = restaurant?.location;
    update();
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
    final dayNames = ['', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
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
    final dayNames = ['', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
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
    super.onClose();
  }
}