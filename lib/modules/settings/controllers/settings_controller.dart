import 'dart:io';
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
      userProfile = UserProfile.fromJson(response.data);
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
  File? userProfilePicture;
  pickUserProfilePicture({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      userProfilePicture = File(croppedPhoto.path);
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

  @override
  void onInit() {
    super.onInit();
    // Load profile when the controller is initialized
    // getProfile();
  }
}
