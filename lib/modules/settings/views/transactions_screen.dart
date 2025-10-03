import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/utils/widgets/pagination_button.dart';

import 'widgets/transaction_item.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Transactions",
        ),
        // bottomNavigationBar: Container(
        //   padding: EdgeInsets.symmetric(vertical: 5.sp),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       PaginationButton(
        //           isForward: false,
        //           isActive: settingsController.currentTransactionsPage > 1,
        //           onPressed: () {
        //             settingsController.previousTransactionsPage();
        //           }),
        //       customText("${settingsController.currentTransactionsPage}",
        //           color: AppColors.primaryColor, fontWeight: FontWeight.w600),
        //       customText(" of ",
        //           color: AppColors.primaryColor, fontWeight: FontWeight.w600),
        //       customText("${settingsController.totalTransactionsPages}",
        //           color: AppColors.primaryColor, fontWeight: FontWeight.w600),
        //       PaginationButton(
        //           isForward: true,
        //           isActive: (settingsController.currentTransactionsPage <
        //               settingsController.totalTransactionsPages),
        //           onPressed: () {
        //             settingsController.nextTransactionsPage();
        //           }),
        //     ],
        //   ),
        // ),
        backgroundColor: AppColors.backgroundColor,
        body: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: AppColors.whiteColor,
          onRefresh: () async {
            settingsController.getTransactions();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: Visibility(
              visible: settingsController.transactions.isNotEmpty,
              replacement: Visibility(
                visible: settingsController.isLoading &&
                    settingsController.transactions.isEmpty,
                replacement: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: customText("No transactions yet"),
                    ),
                  ],
                ),
                child: Center(
                  child: customText("Loading...."),
                ),
              ),
              child: SingleChildScrollView(
                controller: settingsController.transactionsScrollController,
                child: Column(
                  children: [
                    ...List.generate(
                      settingsController.transactions.length,
                      (i) => TransactionItem(
                        onTap: () {
                          settingsController.setSelectedTransaction(
                              settingsController.transactions[i]);
                          Get.toNamed(Routes.TRANSACTION_DETAILS_SCREEN);
                        },
                        transaction: settingsController.transactions[i],
                      ),
                    ),
                    Visibility(
                      visible: settingsController.fetchingTransactions &&
                          settingsController.transactions.isNotEmpty,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customText("Loading more...",
                              color: AppColors.blueColor),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: settingsController.transactions ==
                          settingsController.totalTransactions,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customText("No more data to load",
                              color: AppColors.blueColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
