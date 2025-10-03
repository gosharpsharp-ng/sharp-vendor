import '../exports.dart';

class StatsContainer extends StatelessWidget {
  final String value;
  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final Color textColor;
  const StatsContainer({
    super.key,
    this.value = "56",
    this.title = "Completed Orders",
    this.textColor = AppColors.amberColor,
    this.backgroundColor = AppColors.lightOrangeColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onPressed();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
        margin: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              value,
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 36.sp,
            ),
            SizedBox(height: 8.sp),
            Row(
              children: [
                Expanded(
                  child: customText(
                    title,
                    overflow: TextOverflow.visible,
                    color: textColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),

                // Icon(Icons.chevron_right, color: textColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
