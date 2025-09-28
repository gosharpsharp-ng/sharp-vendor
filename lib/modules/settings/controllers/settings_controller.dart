import 'package:sharpvendor/core/utils/exports.dart';

class SettingsController extends GetxController {
  final profileService = serviceLocator<ProfileService>();

  // Initial values for comparison
  String? initialFName;
  String? initialLName;
  String? initialEmail;
  String? initialPhone;
  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  final getStorage = GetStorage();
  UserProfile? userProfile;
  getProfile() async {
    setLoadingState(true);
    APIResponse response = await profileService.getProfile();

    setLoadingState(false);
    if (response.status == "success") {
      userProfile = UserProfile.fromJson(response.data['user']);
      update();
      // Initialize the signaling plugin
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: int.parse(Secret.zegoCloudAppID),
        appSign: Secret.zegoCloudAppSign,
        userID: userProfile!.id.toString(),
        userName: "${userProfile!.fname} ${userProfile!.lname}",
        plugins: [ZegoUIKitSignalingPlugin()],
        notificationConfig: ZegoCallInvitationNotificationConfig(
            androidNotificationConfig: ZegoCallAndroidNotificationConfig(
              showFullScreen: true,
            ),
            iOSNotificationConfig:
                ZegoCallIOSNotificationConfig(appName: "sharpvendor_mobile")),
      );
      setProfileFields();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  bool isProfileEditable = false;
  toggleProfileEditState(bool value) {
    isProfileEditable = value;
    update();
  }

  setProfileFields() {
    // Store initial values
    initialFName = userProfile?.fname ?? "";
    initialLName = userProfile?.lname ?? "";
    initialEmail = userProfile?.email ?? "";
    initialPhone = userProfile?.phone ?? "";

    fNameController.text = initialFName!;
    lNameController.text = initialLName!;
    emailController.text = initialEmail!;
    phoneController.text = initialPhone!;
    update();
  }

  final profileUpdateFormKey = GlobalKey<FormState>();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  updateUserProfile() async {
    if (profileUpdateFormKey.currentState!.validate()) {
      setLoadingState(true);
      Map<String, dynamic> updatedData = {};
      if (fNameController.text != initialFName) {
        updatedData['fname'] = fNameController.text;
      }
      if (lNameController.text != initialLName) {
        updatedData['lname'] = lNameController.text;
      }

      APIResponse response = await profileService.updateProfile(updatedData);

      setLoadingState(false);
      if (response.status == "success") {
        getProfile();
        toggleProfileEditState(false);
        showAnyBottomSheet(
            isControlled: false,
            child: const ProfileUpdateSuccessBottomSheet());
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  bool isUpdatingAvatar = false;
  setLoadingProfileAvatarState(bool val) {
    isUpdatingAvatar = val;
    update();
  }

  final ImagePicker _picker = ImagePicker();
  String? userProfilePicture;
  pickUserProfilePicture({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      // Convert image to base64 string
      userProfilePicture = await convertImageToBase64(croppedPhoto.path);
      update();
      setLoadingProfileAvatarState(true);
      dynamic data = {'avatar': userProfilePicture};
      APIResponse response = await profileService.updateProfile(data);
      if (response.status == "success") {
        getProfile();
        showAnyBottomSheet(
            isControlled: false,
            child: const ProfileUpdateSuccessBottomSheet());
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
    setLoadingProfileAvatarState(false);
  }

  final changePasswordFormKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  bool oldPasswordVisibility = false;

  toggleOldPasswordVisibility() {
    oldPasswordVisibility = !oldPasswordVisibility;
    update();
  }

  bool newPasswordVisibility = false;

  toggleNewPasswordVisibility() {
    newPasswordVisibility = !newPasswordVisibility;
    update();
  }

  bool confirmNewPasswordVisibility = false;

  toggleConfirmNewPasswordVisibility() {
    confirmNewPasswordVisibility = !confirmNewPasswordVisibility;
    update();
  }

  changePassword() async {
    if (changePasswordFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        "old_password": oldPasswordController.text,
        "new_password": newPasswordController.text
      };

      APIResponse response = await profileService.changePassword(data);

      setLoadingState(false);
      showToast(
          message: response.message, isError: response.status != "success");
      if (response.status == "success") {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        update();
      }
    }
  }

  bool _isLoadingNotification = false;
  get isLoadingNotification => _isLoadingNotification;
  setLoadingNotificationState(bool val) {
    _isLoadingNotification = val;
    update();
  }

  List<NotificationModel> notifications = [];
  NotificationModel? selectedNotification;
  setSelectedNotification(NotificationModel nt) {
    selectedNotification = nt;
    update();
  }

  getSingleNotification() async {
    dynamic data = {
      "id": selectedNotification!.id,
    };
    APIResponse response = await profileService.getNotificationById(data);
    selectedNotification = NotificationModel.fromJson(response.data[data]);
    if (response.status == "success") {
      setSelectedNotification(NotificationModel.fromJson(response.data[data]));
    }
  }

  logout() async {
    GetStorage getStorage = GetStorage();
    getStorage.remove('token');
    Get.offAllNamed(Routes.SIGN_IN);
    DeliveryNotificationServiceManager serviceManager =
        DeliveryNotificationServiceManager();
    serviceManager.disposeServices();
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  bool deletePasswordVisibility = false;

  toggleDeletePasswordVisibility() {
    deletePasswordVisibility = !deletePasswordVisibility;
    update();
  }

  bool deletingAccount = false;
  final deleteAccountFormKey = GlobalKey<FormState>();
  TextEditingController deletePasswordController = TextEditingController();
  deleteAccount() async {
    if (deleteAccountFormKey.currentState!.validate()) {
      dynamic data = {"password": deletePasswordController.text};
      APIResponse res = await profileService.deleteAccount(data);
      if (res.status == "success") {
        GetStorage getStorage = GetStorage();
        getStorage.remove('token');
        Get.offAllNamed(Routes.SIGN_IN);
        DeliveryNotificationServiceManager serviceManager =
            DeliveryNotificationServiceManager();
        serviceManager.disposeServices();
        ZegoUIKitPrebuiltCallInvitationService().uninit();
      } else {
        showToast(message: "could not delete your account", isError: true);
      }
    }
  }

  showAccountDeletionDialog() async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: customText("Delete Account",
            fontWeight: FontWeight.bold, fontSize: 18.sp),
        content: customText(
          "Are you sure you want to delete your account? This action is permanent and cannot be undone.",
          textAlign: TextAlign.left,
          overflow: TextOverflow.visible,
          fontSize: 16.sp,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: customText("Cancel",
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      color: AppColors.obscureTextColor),
                ),
              ),
              Expanded(
                child: CustomButton(
                  onPressed: () async {
                    Get.back();
                    Get.toNamed(Routes.DELETE_ACCOUNT_SCREEN); // Close dialog
                  },
                  title: "Delete",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Business Operations Form
  final businessOperationsFormKey = GlobalKey<FormState>();

  // Business Hours Controllers
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();

  // Business Details Controllers
  TextEditingController restaurantNameController = TextEditingController();
  TextEditingController businessPhoneController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  TextEditingController businessDescriptionController = TextEditingController();

  // Operational Settings Controllers
  TextEditingController minOrderAmountController = TextEditingController();
  TextEditingController deliveryFeeController = TextEditingController();
  TextEditingController avgPrepTimeController = TextEditingController();

  // Working Days Management (matching signup structure)
  Map<String, Map<String, String>> dayOperatingHours = {
    'monday': {'openTime': '', 'closeTime': ''},
    'tuesday': {'openTime': '', 'closeTime': ''},
    'wednesday': {'openTime': '', 'closeTime': ''},
    'thursday': {'openTime': '', 'closeTime': ''},
    'friday': {'openTime': '', 'closeTime': ''},
    'saturday': {'openTime': '', 'closeTime': ''},
    'sunday': {'openTime': '', 'closeTime': ''},
  };

  Map<String, bool> selectedDays = {
    'monday': false,
    'tuesday': false,
    'wednesday': false,
    'thursday': false,
    'friday': false,
    'saturday': false,
    'sunday': false,
  };

  // Toggle States
  bool isTakingOrders = true;
  bool autoAcceptOrders = false;

  // Business Hours Time Pickers
  selectOpeningTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      openingTimeController.text = picked.format(context);
      update();
    }
  }

  selectClosingTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      closingTimeController.text = picked.format(context);
      update();
    }
  }

  // Day Selection Management (matching signup structure)
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(Get.context!).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(Get.context!);
      if (isOpeningTime) {
        dayOperatingHours[day]!['openTime'] = formattedTime;
      } else {
        dayOperatingHours[day]!['closeTime'] = formattedTime;
      }
      update();
    }
  }

  // Toggle Methods
  toggleTakingOrders(bool value) {
    isTakingOrders = value;
    update();
  }

  toggleAutoAcceptOrders(bool value) {
    autoAcceptOrders = value;
    update();
  }

  // Update Business Operations
  updateBusinessOperations() async {
    // Check if at least one day is selected
    bool hasSelectedDays = selectedDays.values.any((selected) => selected);
    if (!hasSelectedDays) {
      showToast(message: "Please select at least one operating day", isError: true);
      return;
    }

    // Validate that each selected day has both opening and closing times
    for (String day in selectedDays.keys) {
      if (selectedDays[day]!) {
        String openTime = dayOperatingHours[day]!['openTime'] ?? '';
        String closeTime = dayOperatingHours[day]!['closeTime'] ?? '';
        if (openTime.isEmpty || closeTime.isEmpty) {
          String capitalizedDay = day.substring(0, 1).toUpperCase() + day.substring(1);
          showToast(
            message: "Please set both opening and closing times for $capitalizedDay",
            isError: true,
          );
          return;
        }
      }
    }

    setLoadingState(true);

    try {
      // Create schedule data structure
      List<Map<String, dynamic>> schedule = [];
      selectedDays.forEach((day, isSelected) {
        if (isSelected && dayOperatingHours[day] != null) {
          String openTime = dayOperatingHours[day]!['openTime'] ?? '';
          String closeTime = dayOperatingHours[day]!['closeTime'] ?? '';
          if (openTime.isNotEmpty && closeTime.isNotEmpty) {
            schedule.add({"day": day, "open": openTime, "close": closeTime});
          }
        }
      });

      Map<String, dynamic> businessData = {
        'schedule': schedule,
        'is_taking_orders': isTakingOrders,
        'auto_accept_orders': autoAcceptOrders,
      };

      // TODO: Add API call to update business operations
      // APIResponse response = await profileService.updateBusinessOperations(businessData);
      print('Business data prepared: $businessData'); // Remove when API is implemented

      // Simulate API call for now
      await Future.delayed(const Duration(seconds: 2));

      showToast(message: "Business operations updated successfully", isError: false);
      Get.back();

    } catch (e) {
      showToast(message: "Error updating business operations: ${e.toString()}", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Initialize business operations data
  setBusinessOperationsFields() {
    // Set default times for weekdays
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
    selectedDays['wednesday'] = true;
    selectedDays['thursday'] = true;
    selectedDays['friday'] = true;
    selectedDays['saturday'] = false;
    selectedDays['sunday'] = false;

    update();
  }

  @override
  void onInit() {
    super.onInit();
    // Load profile when the controller is initialized
    getProfile();
    setBusinessOperationsFields();
  }

  @override
  void onClose() {
    // Dispose business operations controllers
    openingTimeController.dispose();
    closingTimeController.dispose();
    restaurantNameController.dispose();
    businessPhoneController.dispose();
    businessAddressController.dispose();
    businessDescriptionController.dispose();
    minOrderAmountController.dispose();
    deliveryFeeController.dispose();
    avgPrepTimeController.dispose();
    super.onClose();
  }
}
