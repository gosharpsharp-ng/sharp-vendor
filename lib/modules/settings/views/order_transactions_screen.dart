import '../../../core/utils/exports.dart';

class OrderTransactionsScreen extends StatelessWidget {
  const OrderTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: "Order Transactions",centerTitle: true),
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 25.h,horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h,),
              TransactionItemWidget(),
              TransactionItemWidget(),
              TransactionItemWidget(),
              TransactionItemWidget(),
              TransactionItemWidget(),
              TransactionItemWidget(),
            ],
          ),
        ),
      ),
    );
  }


}

class TransactionItemWidget extends StatelessWidget {
  const TransactionItemWidget({super.key});

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 35.h,
                width: 45.w,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/imgs/menu_1.png"),fit: BoxFit.contain),
                  borderRadius: BorderRadius.circular(8.r)
                ),
              ),
              SizedBox(width: 8.w,),
              customText("Halley Aminu",fontWeight: FontWeight.w500,color:AppColors.blackColor,fontSize: 15.sp),
            ],
          ),
          SizedBox(height: 5.h,),
          TransactionDetailItem(),
          TransactionDetailItem(title: "Customer",value: "Halley Aminu",),
          TransactionDetailItem(title: "Delivery Type",value: "Pick up",),
          TransactionDetailItem(title: "Status",value: "Delivered",),
          TransactionDetailItem(title: "Date",value: "17 March, 2025",),
             ],
      ),
    );
  }
}

class TransactionDetailItem extends StatelessWidget {
  final String title;
  final String value;
  const TransactionDetailItem({super.key, this.title="Order ID", this.value="Order_OXLR2Z271"});

  @override
  Widget build(BuildContext context) {
    return    Container(
      margin: EdgeInsets.symmetric(horizontal: 5.h,vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(title,fontWeight: FontWeight.w500,color:AppColors.greyColor,fontSize: 13.sp),
          customText(value,fontWeight: FontWeight.w600,color:AppColors.blackColor,fontSize: 13.sp),

        ],
      ),
    );
  }
}

