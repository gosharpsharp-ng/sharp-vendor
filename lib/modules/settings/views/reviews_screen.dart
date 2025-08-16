import '../../../core/utils/exports.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: "Reviews",centerTitle: true),
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 25.h,horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customText("4.8",fontWeight: FontWeight.w700,color:AppColors.blackColor,fontSize: 36.sp),
                  Container(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: customText("/325",fontWeight: FontWeight.w500,color:AppColors.greyColor,fontSize: 13.sp)),

                ],
              ),
               customText("325 Reviews",fontWeight: FontWeight.w500,color:AppColors.greyColor,fontSize: 15.sp),
            SizedBox(height: 20.h,),
              ReviewBox(),
              ReviewBox(),
              ReviewBox(),
              ReviewBox(),
              ReviewBox(),
              ReviewBox(),
            ],
          ),
        ),
      ),
    );
  }


}

class ReviewBox extends StatelessWidget {
  const ReviewBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 0.w),
      padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
            color:AppColors.whiteColor.withAlpha(125)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 15.r,backgroundColor: AppColors.transparent,
                    child: Image.network("https://avatar.iran.liara.run/public/13"),),
                    SizedBox(width: 8.w,),
                    customText("Halley Aminuf",fontWeight: FontWeight.w500,color:AppColors.blackColor,fontSize: 15.sp),
                  ],
                ),
              ),
              customText("32 minutes ago",fontSize: 10.sp,color: AppColors.greyColor),
            ],
          ),
          SizedBox(height: 5.h,),
          Row(
            children: [
              customText("4.5",fontWeight: FontWeight.w500,color:AppColors.blackColor,fontSize: 15.sp),

              SizedBox(width: 8.w,),
              RatingBarIndicator(
                rating:3.5,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12.sp,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          SizedBox(height: 12.h,),
          customText("This Food so tasty & delicious. Breakfast so fast Delivered in my place. ",fontSize: 13.sp,color: AppColors.greyColor,overflow: TextOverflow.visible),
        ],
      ),
    );
  }
}
