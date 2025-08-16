import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class BusinessOperationsEntryScreen extends GetView<SignUpController> {
  const BusinessOperationsEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (signUpController) {
        return Form(
          key: signUpController.businessOpsFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () {
                Get.back();
              },
              title: "Business Operations",
            ),
            backgroundColor: AppColors.backgroundColor,
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              child:  CustomButton(
                onPressed: () {
                  // signUpController.signUp();
                  Get.toNamed(Routes.BANK_INFO_ENTRY_SCREEN);
                },
                isBusy: signUpController.isLoading,
                title: "Continue",
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 25.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Week Days",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 15.h,),
                    Row(
                      children: [
                        Expanded(
                          child: ClickableCustomRoundedInputField(
                            onPressed: ()async {
                              await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                              );
                            },
                            title: "Opening Time",
                            label: "8:00 AM",
                            showLabel: true,
                            readOnly: true,
                            isRequired: true,
                            hasTitle: true,
                            controller:
                            signUpController.firstNameController,
                            suffixWidget: IconButton(
                              onPressed: ()async {
                                await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                              },
                              icon: SvgPicture.asset(
                                SvgAssets.timeIcon,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: ClickableCustomRoundedInputField(
                            onPressed: ()async {
                              await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                            },
                            title: "Closing Time",
                            label: "9:00 PM",
                            showLabel: true,
                            isRequired: true,
                            hasTitle: true,
                            readOnly: true,
                            controller:
                            signUpController.firstNameController,

                            suffixWidget: IconButton(
                              onPressed: ()async {
                                await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                              },
                              icon: SvgPicture.asset(
                                SvgAssets.timeIcon,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                    SizedBox(height: 12.sp,),
                    customText(
                      "Week Days",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),

                    OpeningDayWidget(day: "Monday",isSelected: true,),
                    OpeningDayWidget(day: "Tuesday",isSelected: true,),
                    OpeningDayWidget(day: "Wednesday",),
                    OpeningDayWidget(day: "Thursday",),
                    OpeningDayWidget(day: "Friday",),
                    SizedBox(height: 15.h,),

                    customText(
                      "Week Ends",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 15.h,),
                    Row(
                      children: [
                        Expanded(
                          child: ClickableCustomRoundedInputField(
                            onPressed: ()async {
                              await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                            },
                            title: "Opening Time",
                            label: "8:00 AM",
                            showLabel: true,
                            readOnly: true,
                            isRequired: true,
                            hasTitle: true,
                            controller:
                            signUpController.firstNameController,
                            suffixWidget: IconButton(
                              onPressed: ()async {
                                await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                              },
                              icon: SvgPicture.asset(
                                SvgAssets.timeIcon,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: ClickableCustomRoundedInputField(
                            onPressed: ()async {
                              await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                            },
                            title: "Closing Time",
                            label: "9:00 PM",
                            showLabel: true,
                            isRequired: true,
                            hasTitle: true,
                            readOnly: true,
                            controller:
                            signUpController.firstNameController,

                            suffixWidget: IconButton(
                              onPressed: ()async {
                                await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                              },
                              icon: SvgPicture.asset(
                                SvgAssets.timeIcon,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    OpeningDayWidget(day: "Saturday",isSelected: true,),
                    OpeningDayWidget(day: "Sunday",isSelected: true,),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class OpeningDayWidget extends StatelessWidget {
  final bool isSelected;
  final String day;
  const OpeningDayWidget({super.key, this.isSelected=false, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 15.h),
      margin: EdgeInsets.symmetric(horizontal: 0.w,vertical: 8.h),
      decoration: BoxDecoration(border: Border.all(color:AppColors.greyColor,width: 0.5),borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(day,fontSize: 15.sp, fontWeight: FontWeight.w600,color: AppColors.blackColor),
       Container(
         // padding: EdgeInsets.all(5.sp),
         decoration: BoxDecoration(
           color:  isSelected?AppColors.primaryColor:AppColors.transparent,
           border: Border.all(width: 1, color: isSelected?AppColors.primaryColor:AppColors.greyColor),
           shape: BoxShape.rectangle,
         ),
         height: 20.sp,
         width: 20.sp,
         child: Center(child:isSelected? Icon(Icons.check,size: 14.sp,color: AppColors.whiteColor,):SizedBox.shrink()),
       )
        ],
      ),
    );
  }
}
