import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/onboarding/widgets/onbaording_content.dart'
    show contents;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    show AnimatedSmoothIndicator, ExpandingDotsEffect;

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double buttonWidth = isTablet
        ?MediaQuery.of(context).size.width * 0.80
        : MediaQuery.of(context).size.width * 0.88;
    final double buttonHeight = isTablet ? 100 : 80;
    final double titleFontSize = isTablet ? 20.sp : 22.sp;
    final double descFontSize = isTablet ? 13.sp : 14.sp;

    return GetBuilder<OnboardingController>(
      builder: (onboardingController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: flatAppBar(
            bgColor: AppColors.backgroundColor,
            navigationColor: AppColors.backgroundColor,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(PngAssets.lightWatermark),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: PageView.builder(
                    controller: onboardingController.pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: contents.length,
                    onPageChanged: (int index) {
                      onboardingController.nextIndex(index);
                    },
                    itemBuilder: (_, i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(contents[i].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.sp),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 48.0 : 14.sp,
                                vertical: 4.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    customText(
                                      contents[i].title,
                                      textAlign: TextAlign.center,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.visible,
                                    ),
                                    SizedBox(height: 5.sp),
                                    customText(
                                      contents[i].desc,
                                      textAlign: TextAlign.center,
                                      fontSize: descFontSize,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSmoothIndicator(
                        activeIndex: onboardingController.currentPageIndex,
                        count: 3,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppColors.primaryColor,
                          dotColor: AppColors.obscureTextColor,
                          dotWidth: 8.sp,
                          dotHeight: 8.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        borderRadius: 16.r,
                        onPressed: () {
                          if (onboardingController.currentPageIndex !=
                              contents.length - 1) {
                            onboardingController.autoNextIndex();
                          } else {
                            Get.toNamed(Routes.SIGN_IN);
                          }
                        },
                        width: buttonWidth,
                        height: buttonHeight,
                        fontWeight: FontWeight.w600,
                        title:
                            onboardingController.currentPageIndex !=
                                contents.length - 1
                            ? "Next"
                            : "Continue",
                        backgroundColor: AppColors.primaryColor,
                      ),
                      SizedBox(height: 8.sp),
                      Visibility(
                        visible:
                            onboardingController.currentPageIndex !=
                            contents.length - 1,
                        replacement: SizedBox(height: 19.sp),
                        child: InkWell(
                          onTap: () {
                            onboardingController.moveToLastIndex();
                          },
                          child: customText(
                            "Skip",
                            textAlign: TextAlign.center,
                            fontSize: 13.sp,
                            color: AppColors.primaryColor,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
