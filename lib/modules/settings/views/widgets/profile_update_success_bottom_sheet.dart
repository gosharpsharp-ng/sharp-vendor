import 'package:sharpvendor/core/utils/exports.dart';

class ProfileUpdateSuccessBottomSheet extends StatefulWidget {
  const ProfileUpdateSuccessBottomSheet({super.key});

  @override
  State<ProfileUpdateSuccessBottomSheet> createState() =>
      _ProfileUpdateSuccessBottomSheetState();
}

class _ProfileUpdateSuccessBottomSheetState
    extends State<ProfileUpdateSuccessBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _contentController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Icon animation controller
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Content animation controller
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Icon animations
    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    // Content animations
    _contentSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    // Start animations
    _iconController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.whiteColor,
            AppColors.backgroundColor.withValues(alpha: 0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 20.sp),
            child: Column(
              children: [
                // Animated success icon with circular background
                AnimatedBuilder(
                  animation: _iconController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _iconScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _iconRotationAnimation.value * 0.1,
                        child: Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withValues(alpha: 0.8),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              SvgAssets.successIcon,
                              height: 40.h,
                              width: 40.w,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                // Animated content
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _contentSlideAnimation.value),
                      child: Opacity(
                        opacity: _contentFadeAnimation.value,
                        child: Column(
                          children: [
                            // Title with gradient text effect
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor.withValues(alpha: 0.8),
                                ],
                              ).createShader(bounds),
                              child: customText(
                                "Profile Updated Successfully!",
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Subtitle with better styling
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: customText(
                                "Your profile has been updated successfully with the new information you provided.",
                                overflow: TextOverflow.visible,
                                color: AppColors.blackColor.withValues(
                                  alpha: 0.7,
                                ),
                                textAlign: TextAlign.center,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),

                            SizedBox(height: 32.h),

                            // Enhanced button with subtle animation
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.95, end: 1.0),
                              duration: const Duration(milliseconds: 200),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primaryColor,
                                          AppColors.primaryColor.withValues(
                                            alpha: 0.8,
                                          ),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryColor
                                              .withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        onTap: () {
                                          // Add subtle haptic feedback
                                          HapticFeedback.lightImpact();
                                          Get.back();
                                        },
                                        child: Container(
                                          width: 1.sw,
                                          height: 52.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                customText(
                                                  "Continue",
                                                  color: AppColors.whiteColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                SizedBox(width: 8.w),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: AppColors.whiteColor,
                                                  size: 20.sp,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
