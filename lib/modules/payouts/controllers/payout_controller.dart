import 'package:sharpvendor/core/utils/exports.dart';
import '../models/payout_request_model.dart';
import '../services/payout_service.dart';

class PayoutController extends GetxController {
  final PayoutService _payoutService = PayoutService();
  final WalletsService _walletsService = serviceLocator<WalletsService>();

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmittingRequest = false;
  bool get isSubmittingRequest => _isSubmittingRequest;

  bool _fetchingPayouts = false;
  bool get fetchingPayouts => _fetchingPayouts;

  void setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  void setSubmittingState(bool val) {
    _isSubmittingRequest = val;
    update();
  }

  // Pagination for payout history
  final ScrollController payoutHistoryScrollController = ScrollController();
  int payoutPageSize = 15;
  int totalPayouts = 0;
  int currentPayoutPage = 1;
  List<PayoutRequest> payoutRequests = [];

  // Current selected payout
  PayoutRequest? selectedPayoutRequest;

  // Form data for creating payout requests
  final GlobalKey<FormState> payoutRequestFormKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  String selectedPaymentMethod = 'bank';
  List<String> paymentMethods = ['bank', 'mobile_money'];

  // Wallet balance and limits
  double availableBalance = 0.0;
  double minimumPayoutAmount = 1000.0;
  double maximumPayoutAmount = 1000000.0;

  @override
  void onInit() {
    super.onInit();
    _payoutService.init();
    payoutHistoryScrollController.addListener(_payoutHistoryScrollListener);
    getPayoutHistory();
    getWalletBalance();
    getPayoutLimits();
  }

  @override
  void onClose() {
    payoutHistoryScrollController.dispose();
    amountController.dispose();
    super.onClose();
  }

  // Scroll listener for pagination
  void _payoutHistoryScrollListener() {
    if (payoutHistoryScrollController.position.pixels >=
        payoutHistoryScrollController.position.maxScrollExtent - 100) {
      getPayoutHistory(isLoadMore: true);
    }
  }

  // Set selected payout request
  void setSelectedPayoutRequest(PayoutRequest payout) {
    selectedPayoutRequest = payout;
    update();
  }

  // Set payment method
  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    update();
  }

  // Get wallet balance
  Future<void> getWalletBalance() async {
    try {
      final response = await _walletsService.getWalletBalance();
      if (response.status == "success" && response.data != null) {
        final balanceData = response.data;
        // Assuming the wallet balance API returns available balance
        availableBalance = double.tryParse(balanceData['available_balance']?.toString() ?? '0') ?? 0.0;
        update();
      }
    } catch (e) {
      debugPrint("Error getting wallet balance: $e");
    }
  }

  // Get payout limits
  Future<void> getPayoutLimits() async {
    try {
      final response = await _payoutService.getPayoutLimits();
      if (response.status == "success" && response.data != null) {
        final limits = response.data;
        minimumPayoutAmount = double.tryParse(limits['minimum_amount']?.toString() ?? '1000') ?? 1000.0;
        maximumPayoutAmount = double.tryParse(limits['maximum_amount']?.toString() ?? '1000000') ?? 1000000.0;
        update();
      }
    } catch (e) {
      debugPrint("Error getting payout limits: $e");
    }
  }

  // Get payout history with pagination
  Future<void> getPayoutHistory({bool isLoadMore = false, String? status}) async {
    if (_fetchingPayouts || (isLoadMore && payoutRequests.length >= totalPayouts)) return;

    _fetchingPayouts = true;
    update();

    if (!isLoadMore) {
      payoutRequests.clear();
      currentPayoutPage = 1;
    }

    try {
      final response = await _payoutService.getPayoutHistory(
        page: currentPayoutPage,
        perPage: payoutPageSize,
        status: status,
      );

      _fetchingPayouts = false;

      if (response.status == "success" && response.data != null) {
        List<PayoutRequest> newPayouts = (response.data['data'] as List)
            .map((payout) => PayoutRequest.fromJson(payout))
            .toList();

        if (isLoadMore) {
          payoutRequests.addAll(newPayouts);
        } else {
          payoutRequests = newPayouts;
        }

        totalPayouts = response.data['total'] ?? 0;
        currentPayoutPage++;
        update();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      _fetchingPayouts = false;
      showToast(message: "Error loading payout history: ${e.toString()}", isError: true);
      update();
    }
  }

  // Submit payout request
  Future<void> submitPayoutRequest() async {
    if (!payoutRequestFormKey.currentState!.validate()) return;

    final amount = double.tryParse(amountController.text) ?? 0.0;

    // Validate amount
    if (amount < minimumPayoutAmount) {
      showToast(message: "Minimum payout amount is ${formatToCurrency(minimumPayoutAmount)}", isError: true);
      return;
    }

    if (amount > maximumPayoutAmount) {
      showToast(message: "Maximum payout amount is ${formatToCurrency(maximumPayoutAmount)}", isError: true);
      return;
    }

    if (amount > availableBalance) {
      showToast(message: "Insufficient balance", isError: true);
      return;
    }

    setSubmittingState(true);

    try {
      final requestData = PayoutRequestData(
        amount: amount,
        paymentMethod: selectedPaymentMethod,
      );

      final response = await _payoutService.createPayoutRequest(requestData.toJson());

      if (response.status == "success") {
        showToast(message: "Payout request submitted successfully", isError: false);

        // Clear form
        amountController.clear();
        selectedPaymentMethod = 'bank';

        // Refresh data
        getPayoutHistory();
        getWalletBalance();

        // Navigate back
        Get.back();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Error submitting payout request: ${e.toString()}", isError: true);
    } finally {
      setSubmittingState(false);
    }
  }

  // Get payout request details
  Future<void> getPayoutRequestDetails(int payoutId) async {
    setLoadingState(true);

    try {
      final response = await _payoutService.getPayoutRequestDetails(payoutId);

      if (response.status == "success" && response.data != null) {
        selectedPayoutRequest = PayoutRequest.fromJson(response.data);
        update();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Error loading payout details: ${e.toString()}", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Cancel payout request
  Future<void> cancelPayoutRequest(int payoutId) async {
    setLoadingState(true);

    try {
      final response = await _payoutService.cancelPayoutRequest(payoutId);

      if (response.status == "success") {
        showToast(message: "Payout request cancelled successfully", isError: false);

        // Refresh data
        getPayoutHistory();
        getWalletBalance();

        // Update selected payout if it's the same one
        if (selectedPayoutRequest?.id == payoutId) {
          await getPayoutRequestDetails(payoutId);
        }
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Error cancelling payout request: ${e.toString()}", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      getPayoutHistory(),
      getWalletBalance(),
      getPayoutLimits(),
    ]);
  }

  // Validate amount input
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }

    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }

    if (amount < minimumPayoutAmount) {
      return 'Minimum amount is ${formatToCurrency(minimumPayoutAmount)}';
    }

    if (amount > maximumPayoutAmount) {
      return 'Maximum amount is ${formatToCurrency(maximumPayoutAmount)}';
    }

    if (amount > availableBalance) {
      return 'Insufficient balance';
    }

    return null;
  }

  // Clear form
  void clearForm() {
    amountController.clear();
    selectedPaymentMethod = 'bank';
    update();
  }

  // Get payout status color
  Color getPayoutStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.amberColor;
      case 'approved':
        return AppColors.blueColor;
      case 'processed':
        return AppColors.primaryColor;
      case 'completed':
        return AppColors.forestGreenColor;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }
}