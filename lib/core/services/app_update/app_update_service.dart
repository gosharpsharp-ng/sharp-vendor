import 'dart:developer';
import 'dart:io';
import 'package:sharpvendor/core/utils/exports.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  bool _isDialogShowing = false;

  // Store IDs - Update these with your actual store IDs
  static const String _playStoreId = 'com.gosharpsharp.vendor';
  static const String _appStoreId = 'com.gosharpsharp.vendor';

  /// Initialize and check for updates
  Future<void> initialize() async {
    await checkForUpdate();
  }

  /// Check if there's a new version available from Play Store/App Store
  Future<void> checkForUpdate() async {
    try {
      final upgrader = Upgrader(
        storeController: UpgraderStoreController(
          onAndroid: () => UpgraderPlayStore(),
          oniOS: () => UpgraderAppStore(),
        ),
      );

      await upgrader.initialize();

      final currentVersion = upgrader.currentInstalledVersion ?? '';
      final storeVersion = upgrader.currentAppStoreVersion ?? '';

      log('Current app version: $currentVersion');
      log('Store version: $storeVersion');

      if (upgrader.belowMinAppVersion()) {
        // Force update required
        log('Force update required - below minimum version');
        _showUpdateDialog(
          currentVersion: currentVersion,
          latestVersion: storeVersion,
          isForceUpdate: true,
          message: 'This version is no longer supported. Please update to continue using the app.',
          releaseNotes: upgrader.releaseNotes,
        );
      } else if (upgrader.isUpdateAvailable()) {
        // Optional update available
        log('New version available: $storeVersion');
        _showUpdateDialog(
          currentVersion: currentVersion,
          latestVersion: storeVersion,
          isForceUpdate: false,
          message: 'A new version of GoSharpSharp Vendor is available with improvements and bug fixes.',
          releaseNotes: upgrader.releaseNotes,
        );
      } else {
        log('App is up to date');
      }
    } catch (e) {
      log('Error checking for updates: $e');
    }
  }

  /// Show the update dialog
  void _showUpdateDialog({
    required String currentVersion,
    required String latestVersion,
    required bool isForceUpdate,
    required String message,
    String? releaseNotes,
  }) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    Get.dialog(
      PopScope(
        canPop: !isForceUpdate,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App icon
                CircleAvatar(
                  radius: 32.sp,
                  backgroundImage: const AssetImage(PngAssets.goSharpSharpIcon),
                ),
                SizedBox(height: 20.h),

                // Title
                customText(
                  'New update available',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),

                // Version line
                customText(
                  'Version $latestVersion is ready to install.',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                  textAlign: TextAlign.center,
                ),

                // Release notes
                if (releaseNotes != null && releaseNotes.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      "What's new",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      releaseNotes,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                SizedBox(height: 24.h),

                // Primary action
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    child: customText(
                      'Update',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),

                if (!isForceUpdate) ...[
                  SizedBox(height: 4.h),
                  TextButton(
                    onPressed: () {
                      _isDialogShowing = false;
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.greyColor,
                    ),
                    child: customText(
                      'Not now',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: !isForceUpdate,
      barrierColor: Colors.black.withValues(alpha: 0.5),
    ).then((_) {
      if (!isForceUpdate) {
        _isDialogShowing = false;
      }
    });
  }

  /// Open the appropriate app store
  Future<void> _openStore() async {
    final Uri storeUrl;

    if (Platform.isAndroid) {
      storeUrl = Uri.parse('market://details?id=$_playStoreId');
    } else {
      storeUrl = Uri.parse('https://apps.apple.com/app/id$_appStoreId');
    }

    try {
      if (await canLaunchUrl(storeUrl)) {
        await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web URL
        final webUrl = Platform.isAndroid
            ? Uri.parse(
                'https://play.google.com/store/apps/details?id=$_playStoreId')
            : Uri.parse('https://apps.apple.com/app/id$_appStoreId');
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      log('Error opening store: $e');
      showToast(message: 'Could not open store', isError: true);
    }
  }

  /// Manual trigger for testing (can be called from settings)
  void showUpdateDialogForTesting() {
    _showUpdateDialog(
      currentVersion: '1.0.0',
      latestVersion: '2.0.0',
      isForceUpdate: true,
      message:
          'A new version of GoSharpSharp Vendor is available with exciting new features and improvements!',
      releaseNotes:
          '• Improved order management\n• Bug fixes and performance improvements\n• New dashboard analytics',
    );
  }
}
