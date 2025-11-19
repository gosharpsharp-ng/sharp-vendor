import 'package:sharpvendor/core/utils/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (settingsController) {
        WebViewController webViewController = createWebViewController(
          successCallback: () {
            Get.back();
          },
        );
        return Scaffold(
          appBar: defaultAppBar(
            implyLeading: false,
            bgColor: AppColors.backgroundColor,
            title: "Settings",
            centerTitle: true,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SectionBox(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   backgroundColor: AppColors.whiteColor,
                  //   children: [
                  //     Visibility(
                  //       visible: settingsController.userProfile?.avatar != null,
                  //       replacement: Visibility(
                  //         visible:
                  //             settingsController.userProfilePicture != null,
                  //         replacement: CircleAvatar(
                  //           radius: 55.r,
                  //           backgroundColor: AppColors.redColor,
                  //           child: customText(
                  //             "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                  //             fontSize: 24.sp,
                  //           ),
                  //         ),
                  //         child: settingsController.userProfilePicture != null
                  //             ? CircleAvatar(
                  //                 backgroundImage: FileImage(
                  //                   settingsController.userProfilePicture!,
                  //                 ),
                  //                 radius: 55.r,
                  //               )
                  //             : CircleAvatar(
                  //                 backgroundImage: const AssetImage(
                  //                   PngAssets.avatarIcon,
                  //                 ),
                  //                 radius: 55.r,
                  //               ),
                  //       ),
                  //       child: CircleAvatar(
                  //         backgroundImage: NetworkImage(
                  //           settingsController.userProfile?.avatar ?? '',
                  //         ),
                  //         radius: 55.r,
                  //       ),
                  //     ),
                  //     SizedBox(height: 5.h),
                  //     customText(
                  //       "${settingsController.userProfile?.fname ?? ""} ${settingsController.userProfile?.lname ?? ""}",
                  //       color: AppColors.blackColor,
                  //       fontSize: 25.sp,
                  //       fontWeight: FontWeight.w600,
                  //       overflow: TextOverflow.visible,
                  //     ),
                  //     SizedBox(height: 5.h),
                  //     customText(
                  //       settingsController.userProfile?.email ?? "",
                  //       color: AppColors.obscureTextColor,
                  //       fontSize: 15.sp,
                  //       fontWeight: FontWeight.w500,
                  //       overflow: TextOverflow.visible,
                  //     ),
                  //   ],
                  // ),
                  // User Profile Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Profile Picture
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.whiteColor,
                              width: 3.w,
                            ),
                          ),
                          child:
                              settingsController.userProfile?.avatarUrl !=
                                      null &&
                                  settingsController
                                      .userProfile!
                                      .avatarUrl!
                                      .isNotEmpty
                              ? CircleAvatar(
                                  radius: 30.r,
                                  backgroundImage: CachedNetworkImageProvider(
                                    settingsController.userProfile!.avatarUrl!,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 35.r,
                                  backgroundColor: AppColors.whiteColor,
                                  child: customText(
                                    "${settingsController.userProfile?.fname.isNotEmpty == true ? settingsController.userProfile!.fname[0].toUpperCase() : ''}${settingsController.userProfile?.lname.isNotEmpty == true ? settingsController.userProfile!.lname[0].toUpperCase() : ''}",
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                        ),
                        SizedBox(width: 16.w),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "${settingsController.userProfile?.fname ?? ''} ${settingsController.userProfile?.lname ?? ''}",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                settingsController.userProfile?.email ?? '',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.whiteColor.withOpacity(0.9),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              customText(
                                settingsController
                                        .userProfile
                                        ?.restaurant
                                        ?.name ??
                                    '',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.whiteColor.withOpacity(0.8),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Edit Profile Icon
                        InkWell(
                          onTap: () {
                            settingsController.setProfileFields();
                            settingsController.toggleProfileEditState(false);
                            Get.toNamed(Routes.EDIT_PROFILE_SCREEN);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SvgPicture.asset(
                              SvgAssets.editIcon,
                              height: 20.sp,
                              width: 20.sp,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SectionBox(
                    children: [
                      // SettingsItem(
                      //   onPressed: () {
                      //     settingsController.setProfileFields();
                      //     settingsController.toggleProfileEditState(false);
                      //     Get.toNamed(Routes.EDIT_PROFILE_SCREEN);
                      //   },
                      //   title: "Personal Information",
                      // ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.RESTAURANT_DETAILS_SCREEN);
                        },
                        title: "Business Details",
                        icon: SvgAssets.operationsIcon,
                        isLast: false,
                      ),
                      // SettingsItem(
                      //   onPressed: () {
                      //     settingsController.setProfileFields();
                      //     settingsController.toggleProfileEditState(false);
                      //     Get.toNamed(Routes.EDIT_PROFILE_SCREEN);
                      //   },
                      //   iconColor: AppColors.primaryColor,
                      //   title: "My Address",
                      //   icon: SvgAssets.locationIcon,
                      // ),
                      // SettingsItem(
                      //   onPressed: () {
                      //     settingsController.setProfileFields();
                      //     settingsController.toggleProfileEditState(false);
                      //     Get.toNamed(Routes.EDIT_PROFILE_SCREEN);
                      //   },
                      //   title: "Menu management",
                      //   icon: SvgAssets.menuIcon,
                      // ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.WALLETS_HOME_SCREEN);
                        },
                        title: "GoWallet",
                        icon: SvgAssets.walletIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.ANALYTICS_SCREEN);
                        },
                        title: "Analytics",
                        icon: SvgAssets.analyticsIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.CAMPAIGNS_HOME_SCREEN);
                        },
                        title: "Campaigns",
                        icon: SvgAssets.campaignIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.RESTAURANT_DISCOUNTS_SCREEN);
                        },
                        title: "Manage Discounts",
                        icon: SvgAssets.discountIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.ORDER_TRANSACTIONS_SCREEN);
                        },
                        title: "Order Transactions",
                        icon: SvgAssets.ordersIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.PAYOUT_HISTORY_SCREEN);
                        },
                        title: "Payout History",
                        icon: SvgAssets.walletIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.NOTIFICATIONS_HOME);
                        },
                        title: "Notifications",
                        icon: SvgAssets.notificationIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.REVIEWS_SCREEN);
                        },
                        title: "Ratings",
                        icon: SvgAssets.ratingIcon,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.CHANGE_PASSWORD_SCREEN);
                        },
                        title: "Change Password",
                        icon: SvgAssets.passwordChangeIcon,
                        isLast: false,
                      ),

                      // SettingsItem(
                      //   onPressed: () {},
                      //   title: "Disputes",
                      //   icon: SvgAssets.supportIcon,
                      // ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.FAQS_SCREEN);
                        },
                        title: "FAQS",
                        icon: SvgAssets.faqsIcon,
                        isLast: false,
                      ),

                      // SettingsItem(
                      //   onPressed: () {
                      //     showWebViewDialog(
                      //       context,
                      //       controller: webViewController,
                      //       onDialogClosed: () {
                      //         Get.back();
                      //       },
                      //       title: "Help and Support",
                      //       url: "https://sharpvendor.com/contact",
                      //     );
                      //   },
                      //   title: "Help and Support",
                      //   icon: SvgAssets.supportIcon,
                      // ),

                      // SettingsItem(
                      //   onPressed: () {
                      //     showWebViewDialog(
                      //       context,
                      //       controller: webViewController,
                      //       onDialogClosed: () {
                      //         Get.back();
                      //       },
                      //       title: "Privacy Policy",
                      //       url: "https://sharpvendor.com/privacy",
                      //     );
                      //   },
                      //   title: "Privacy Policy",
                      //   icon: SvgAssets.profileIcon,
                      // ),
                      // SettingsItem(
                      //   onPressed: () {},
                      //   title: "Language",
                      //   icon: SvgAssets.languageIcon,
                      // ),
                      // SettingsItem(
                      //   onPressed: () {},
                      //   title: "Security",
                      //   icon: SvgAssets.securityIcon,
                      // ),
                      SettingsItem(
                        onPressed: () {
                          settingsController.logout();
                        },
                        title: "Logout",
                        icon: SvgAssets.logoutIcon,
                        // isLogout: true,
                        isLast: false,
                      ),
                      SettingsItem(
                        onPressed: () {
                          settingsController.deletePasswordController.clear();
                          settingsController.showAccountDeletionDialog();
                        },
                        title: "Delete Account",
                        icon: SvgAssets.deleteIcon,
                        // isLogout: true,
                        isLast: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
