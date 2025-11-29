import 'package:sharpvendor/core/models/discount_model.dart';
import 'package:sharpvendor/core/utils/widgets/skeleton_loaders.dart';
import 'package:sharpvendor/modules/restaurant/controllers/restaurant_discount_controller.dart';
import '../../../core/utils/exports.dart';

class RestaurantDiscountsScreen extends StatelessWidget {
  const RestaurantDiscountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDiscountController>(
      init: RestaurantDiscountController(),
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.find<RestaurantDiscountController>().getRestaurantDiscounts();
        });
      },
      builder: (controller) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Restaurant Discounts",
            centerTitle: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              controller.initializeCreateForm();
              Get.toNamed(Routes.ADD_RESTAURANT_DISCOUNT_SCREEN);
            },
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.add, color: AppColors.whiteColor),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            height: 1.sh,
            width: 1.sw,
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.getRestaurantDiscounts();
              },
              child: controller.isLoadingDiscounts
                  ? SkeletonLoaders.discountCard(count: 4)
                  : controller.discounts.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 150.h),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.discount_outlined,
                                size: 100.sp,
                                color: AppColors.greyColor.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              customText(
                                "No restaurant discounts yet",
                                color: AppColors.blackColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 8.h),
                              customText(
                                "Create discounts that apply to your entire restaurant",
                                color: AppColors.greyColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      itemCount: controller.discounts.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final discount = controller.discounts[index];
                        return _DiscountCard(
                          discount: discount,
                          onTap: () {
                            // Navigate to edit screen
                            controller.initializeEditForm(discount);
                            Get.toNamed(
                              Routes.EDIT_RESTAURANT_DISCOUNT_SCREEN,
                              arguments: discount,
                            );
                          },
                          onDelete: () {
                            _showDeleteDialog(context, controller, discount);
                          },
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    RestaurantDiscountController controller,
    DiscountModel discount,
  ) {
    Get.defaultDialog(
      title: "Delete Discount",
      titleStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.blackColor,
      ),
      content: Column(
        children: [
          customText(
            "Are you sure you want to delete '${discount.name}'?",
            fontSize: 14.sp,
            color: AppColors.blackColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  title: "Cancel",
                  backgroundColor: AppColors.greyColor,
                  fontColor: AppColors.whiteColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  onPressed: () async {
                    Get.back();
                    await controller.deleteDiscount(discount.id);
                  },
                  title: "Delete",
                  backgroundColor: AppColors.redColor,
                  fontColor: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiscountCard extends StatelessWidget {
  final DiscountModel discount;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DiscountCard({
    required this.discount,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: customText(
                                discount.name,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: discount.type == 'percentage'
                                ? AppColors.primaryColor.withValues(alpha: 0.1)
                                : AppColors.secondaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: customText(
                            discount.displayValue,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: discount.type == 'percentage'
                                ? AppColors.primaryColor
                                : AppColors.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.blackColor,
                      size: 20.sp,
                    ),
                    onSelected: (value) {
                      if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              SvgAssets.deleteIcon,
                              height: 18.sp,
                              width: 18.sp,
                              color: AppColors.redColor,
                            ),
                            SizedBox(width: 8.w),
                            customText(
                              'Delete',
                              fontSize: 14.sp,
                              color: AppColors.redColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Divider(
                height: 1.h,
                color: AppColors.greyColor.withValues(alpha: 0.2),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: SvgPicture.asset(
                      SvgAssets.calendarIcon,
                      height: 14.sp,
                      width: 14.sp,
                      colorFilter: ColorFilter.mode(
                        AppColors.greyColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: customText(
                      "${_formatDate(discount.startDate)} - ${_formatDate(discount.endDate)}",
                      fontSize: 13.sp,
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    discount.isCurrentlyActive
                        ? Icons.check_circle
                        : discount.isExpired
                        ? Icons.cancel
                        : Icons.schedule,
                    size: 14.sp,
                    color: discount.isCurrentlyActive
                        ? AppColors.greenColor
                        : discount.isExpired
                        ? AppColors.redColor
                        : AppColors.secondaryColor,
                  ),
                  SizedBox(width: 6.w),
                  customText(
                    discount.isCurrentlyActive
                        ? "Active"
                        : discount.isExpired
                        ? "Expired"
                        : "Not Started",
                    fontSize: 13.sp,
                    color: discount.isCurrentlyActive
                        ? AppColors.greenColor
                        : discount.isExpired
                        ? AppColors.redColor
                        : AppColors.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  const Spacer(),
                  if (discount.badgeText != null &&
                      discount.badgeText!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: customText(
                        discount.badgeText!,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                ],
              ),
              if (!discount.isActive) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.visibility_off,
                      size: 14.sp,
                      color: AppColors.redColor,
                    ),
                    SizedBox(width: 6.w),
                    customText(
                      "Inactive",
                      fontSize: 13.sp,
                      color: AppColors.redColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
