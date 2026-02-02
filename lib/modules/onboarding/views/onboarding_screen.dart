import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/onboarding/widgets/onbaording_content.dart'
    show contents;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    show AnimatedSmoothIndicator, ExpandingDotsEffect;

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                              padding: EdgeInsets.symmetric(
                                vertical: 0.sp,
                                horizontal: 0.sp,
                              ),
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
                          ),
                          SizedBox(height: 5.sp),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.sp,
                                vertical: 8.h,
                              ),
                              child: Column(
                                children: [
                                  customText(
                                    contents[i].title,
                                    textAlign: TextAlign.center,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.visible,
                                  ),
                                  SizedBox(height: 5.sp),
                                  customText(
                                    contents[i].desc,
                                    textAlign: TextAlign.center,
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 5.h),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      SizedBox(
                        child: AnimatedSmoothIndicator(
                          activeIndex: onboardingController.currentPageIndex,
                          count: 3,
                          effect: ExpandingDotsEffect(
                            activeDotColor: AppColors.primaryColor,
                            dotColor: AppColors.obscureTextColor,
                            dotWidth: 8.sp,
                            dotHeight: 8.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h),
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
                        width: 1.sw * 0.88,
                        height: 40.h,
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
                            fontSize: 16.sp,
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
