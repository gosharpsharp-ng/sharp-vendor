import 'package:sharpvendor/core/utils/exports.dart';

class OrderDetailSummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;

  const OrderDetailSummaryItem({
    super.key,
    this.title = "",
    this.value = "",
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: AppColors.whiteColor,
      ),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title,
                  color: AppColors.obscureTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(height: 8.h),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontFamily: title == "Amount" || title == "Total"
                      ? GoogleFonts.montserrat().fontFamily!
                      : "Satoshi",
                  fontSize: 14.sp,
                  fontWeight: title == "Amount" || title == "Total"
                      ? FontWeight.w600
                      : FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title,
                  color: AppColors.obscureTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                Flexible(
                  child: customText(
                    value,
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontFamily: title == "Amount" || title == "Total"
                        ? GoogleFonts.montserrat().fontFamily!
                        : "Satoshi",
                    fontWeight: title == "Amount" || title == "Total"
                        ? FontWeight.w600
                        : FontWeight.w500,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
    );
  }
}

class OrderDetailSummaryStatusItem extends StatelessWidget {
  final String title;
  final String value;
  final String status;

  const OrderDetailSummaryStatusItem({
    super.key,
    this.title = "",
    this.value = "",
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: AppColors.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title,
            color: AppColors.obscureTextColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.normal,
          ),
          Container(
            decoration: BoxDecoration(
              color: _getStatusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _getStatusColor().withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getStatusIcon(), color: _getStatusColor(), size: 14.sp),
                SizedBox(width: 6.w),
                customText(
                  value,
                  color: _getStatusColor(),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.amberColor;
      case 'confirmed':
        return Colors.lightGreen;
      case 'preparing':
        return AppColors.blueColor;
      case 'ready':
        return AppColors.primaryColor;
      case 'in_transit':
        return AppColors.blueColor;
      case 'completed':
        return AppColors.forestGreenColor;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.check_circle;
      case 'in_transit':
        return Icons.local_shipping_outlined;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.block;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

class OrderDetailPackageItem extends StatelessWidget {
  final String packageName;
  final int quantity;
  final String price;

  const OrderDetailPackageItem({
    super.key,
    required this.packageName,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  packageName,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 2.h),
                customText(
                  "Quantity: $quantity",
                  color: AppColors.obscureTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          customText(
            price,
            color: AppColors.primaryColor,
            fontSize: 15.sp,
            fontFamily: GoogleFonts.montserrat().fontFamily!,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class OrderDetailMenuItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final int quantity;
  final String price;
  final String? unitPrice;
  final String? description;
  final String? plateSize;
  final String? packagingUnitPrice;

  const OrderDetailMenuItem({
    super.key,
    required this.name,
    this.imageUrl,
    required this.quantity,
    required this.price,
    this.unitPrice,
    this.description,
    this.plateSize,
    this.packagingUnitPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: AppColors.whiteColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu item image
          if (imageUrl != null && imageUrl!.isNotEmpty)
            Container(
              width: 65.w,
              height: 65.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.greyColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.fastfood,
                color: AppColors.greyColor,
                size: 24.sp,
              ),
            ),

          SizedBox(width: 12.w),

          // Menu item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  name,
                  color: AppColors.blackColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                if (description != null && description!.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  customText(
                    description!,
                    color: AppColors.obscureTextColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 4.h),
                Row(
                  children: [
                    // Show unit price if available
                    if (unitPrice != null && unitPrice!.isNotEmpty) ...[
                      customText(
                        unitPrice!,
                        color: AppColors.obscureTextColor,
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.montserrat().fontFamily!,
                        fontWeight: FontWeight.w500,
                      ),
                      customText(
                        " × $quantity",
                        color: AppColors.obscureTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ] else ...[
                      customText(
                        "Qty: $quantity",
                        color: AppColors.obscureTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                    if (plateSize != null && plateSize!.isNotEmpty) ...[
                      customText(
                        " • ",
                        color: AppColors.obscureTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      customText(
                        plateSize!,
                        color: AppColors.obscureTextColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ],
                ),
                // Packaging price on separate line if available
                if (packagingUnitPrice != null &&
                    packagingUnitPrice!.isNotEmpty &&
                    packagingUnitPrice != '₦0.00') ...[
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      customText(
                        "Packaging: ",
                        color: AppColors.obscureTextColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      customText(
                        packagingUnitPrice!,
                        color: AppColors.obscureTextColor,
                        fontSize: 11.sp,
                        fontFamily: GoogleFonts.montserrat().fontFamily!,
                        fontWeight: FontWeight.w500,
                      ),
                      customText(
                        " × $quantity",
                        color: AppColors.obscureTextColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Total Price
          customText(
            price,
            color: AppColors.primaryColor,
            fontSize: 14.sp,
            fontFamily: GoogleFonts.montserrat().fontFamily!,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
