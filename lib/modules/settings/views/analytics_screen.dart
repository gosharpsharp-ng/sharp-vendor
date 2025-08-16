import 'package:flutter/material.dart';
import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/utils/widgets/stats_container.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: "Analytics",centerTitle: true),
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatsContainer(
                      onPressed: () {},
                      backgroundColor:
                      AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      title: "Menus",
                      value: "56",
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: StatsContainer(
                      onPressed: () {},
                      backgroundColor:
                      AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      title: "Categories",
                      value: "16",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child:StatsContainer(
                      onPressed: () {},
                      backgroundColor:
                      AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      title: "Pending Orders",
                      value: "23",
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: StatsContainer(
                      onPressed: () {},
                      backgroundColor:
                      AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      title: "Cancelled Orders",
                      value: "18",
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: StatsContainer(
                      onPressed: () {},
                      backgroundColor:
                      AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      title: "Completed Orders",
                      value: "256",
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child:StatsContainer(
                      onPressed: () {},
                      backgroundColor:
                      AppColors.whiteColor,
                      textColor: AppColors.blackColor,
                      title: "Customer reviews",
                      value: "4.8",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35.h),
              SizedBox(
                width: 1.sw,
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      "Sales Summary",
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      color: AppColors.blackColor,
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1.sp,
                          ),
                          borderRadius: BorderRadius.circular(
                            8.r,
                          ),
                        ),
                        child: Row(
                          children: [
                            customText(
                              "This Week",
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(width: 5.w),
                            SvgPicture.asset(
                              SvgAssets.downChevronIcon,
                              height: 16.sp,
                              width: 16.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              AreaChartWidget(chartData: usageData),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }
}
