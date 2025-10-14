import 'package:sharpvendor/core/utils/exports.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BankSelectionBottomSheet extends StatelessWidget {
  const BankSelectionBottomSheet({super.key, required this.onBankSelected});
  final Function(BankModel) onBankSelected;

  @override
  Widget build(BuildContext context) {
    // Try to get RestaurantDetailsController first, fallback to SignUpController
    final restaurantController = Get.isRegistered<RestaurantDetailsController>()
        ? Get.find<RestaurantDetailsController>()
        : null;
    final signUpController = Get.isRegistered<SignUpController>()
        ? Get.find<SignUpController>()
        : null;

    // Wrap with appropriate GetBuilder for reactivity
    if (restaurantController != null) {
      return GetBuilder<RestaurantDetailsController>(
        builder: (controller) => _buildContent(
          context: context,
          isLoading: controller.isLoading,
          banks: controller.banks,
          searchController: controller.banksSearchController,
          onSearch: (val) => controller.searchBanks(val),
          onReload: () => controller.getBankList(),
        ),
      );
    } else if (signUpController != null) {
      return GetBuilder<SignUpController>(
        builder: (controller) => _buildContent(
          context: context,
          isLoading: controller.isLoadingBanks,
          banks: controller.filteredBanks,
          searchController: controller.banksFilterController,
          onSearch: (val) => controller.filterBanks(val),
          onReload: () => controller.getBankList(),
        ),
      );
    }

    // Fallback if no controller found
    return Container(
      height: 440.h,
      child: Center(
        child: customText("Unable to load bank list"),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required bool isLoading,
    required List<BankModel> banks,
    required TextEditingController searchController,
    required Function(String) onSearch,
    required VoidCallback onReload,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 20.sp, bottom: 12.sp, left: 14.sp, right: 14.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0.sp),
          topRight: Radius.circular(10.0.sp),
        ),
      ),
      height: 440.h,
      child: Column(
        children: [
          // Search field
          CustomOutlinedRoundedInputField(
            labelColor: AppColors.blackColor,
            cursorColor: AppColors.blackColor,
            label: "Search",
            controller: searchController,
            prefixWidget: const Icon(
              Icons.search,
              color: AppColors.blackColor,
            ),
            onChanged: (val) {
              onSearch(val.toString());
            },
          ),
          SizedBox(height: 10.h),

          // Bank list
          Expanded(
            child: Builder(builder: (context) {
              // Show skeleton loader when loading
              if (isLoading) {
                return _buildSkeletonLoader();
              }

              // Show empty/error state
              if (banks.isEmpty) {
                return _buildEmptyState(onReload: onReload);
              }

              // Show bank list
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: banks.map((bank) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onBankSelected(bank);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.sp),
                        child: Row(
                          children: [
                            Container(
                              width: 40.sp,
                              height: 40.sp,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.account_balance,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: customText(
                                bank.name,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.greyColor,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.sp),
            child: Row(
              children: [
                Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Bone.text(
                    words: 2,
                    fontSize: 16.sp,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({required VoidCallback onReload}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.sp,
            height: 80.sp,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_outlined,
              size: 40.sp,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 16.h),
          customText(
            "No banks found",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          customText(
            "Unable to load bank list",
            fontSize: 14.sp,
            color: AppColors.greyColor,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: onReload,
            icon: Icon(
              Icons.refresh,
              color: AppColors.whiteColor,
              size: 18.sp,
            ),
            label: customText(
              "Retry",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}