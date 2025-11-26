import 'package:sharpvendor/core/utils/exports.dart';

class CampaignsController extends GetxController {
  final campaignService = serviceLocator<CampaignService>();

  // Loading states
  bool _isLoading = false;
  get isLoading => _isLoading;

  bool _isFetchingCampaigns = false;
  get isFetchingCampaigns => _isFetchingCampaigns;

  bool _isCreatingCampaign = false;
  get isCreatingCampaign => _isCreatingCampaign;

  bool _isUpdatingCampaign = false;
  get isUpdatingCampaign => _isUpdatingCampaign;

  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  // Campaign lists
  List<CampaignModel> allCampaigns = [];
  CampaignModel? selectedCampaign;

  // Campaign form fields
  final TextEditingController campaignNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  final GlobalKey<FormState> createCampaignFormKey = GlobalKey<FormState>();

  String selectedPaymentMethod = 'wallet';
  String selectedStatus = 'draft';
  int selectedPriority = 1;

  // Cost breakdown
  CostBreakdown? costBreakdown;

  // Cost estimation
  CampaignCostEstimate? costEstimate;
  bool _isEstimatingCost = false;
  get isEstimatingCost => _isEstimatingCost;

  @override
  void onInit() {
    super.onInit();
    getCampaigns();
    // Initialize status controller with default value
    statusController.text = 'Draft';
  }

  @override
  void onClose() {
    campaignNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    priorityController.dispose();
    statusController.dispose();
    super.onClose();
  }

  // Set selected campaign
  setSelectedCampaign(CampaignModel campaign) {
    selectedCampaign = campaign;
    update();
  }

  // Get all campaigns
  getCampaigns() async {
    _isFetchingCampaigns = true;
    update();

    APIResponse response = await campaignService.getCampaigns();
    _isFetchingCampaigns = false;

    if (response.status == "success") {
      allCampaigns = (response.data['campaigns'] as List)
          .map((campaign) => CampaignModel.fromJson(campaign))
          .toList();
      update();
    } else {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
    }
  }

  // Get campaign by ID
  getCampaignById(int campaignId) async {
    setLoadingState(true);

    APIResponse response = await campaignService.getCampaignById(campaignId);
    setLoadingState(false);

    if (response.status == "success") {
      selectedCampaign = CampaignModel.fromJson(response.data['campaign']);
      update();
    } else {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
    }
  }

  // Create new campaign
  createCampaign() async {
    if (!createCampaignFormKey.currentState!.validate()) {
      return;
    }

    _isCreatingCampaign = true;
    update();

    dynamic data = {
      "name": campaignNameController.text,
      "start_date": startDateController.text,
      "end_date": endDateController.text,
      "payment_method_code": selectedPaymentMethod,
      "status": selectedStatus,
      "priority": selectedPriority,
    };

    APIResponse response = await campaignService.createCampaign(data);
    _isCreatingCampaign = false;
    update();

    if (response.status == "success") {
      showToast(
        message: response.message,
        isError: false,
      );

      // Parse the response data
      final campaignData = response.data['campaign'];
      final costBreakdownData = response.data['cost_breakdown'];

      selectedCampaign = CampaignModel.fromJson(campaignData);
      costBreakdown = CostBreakdown.fromJson(costBreakdownData);

      // Refresh campaigns list
      getCampaigns();

      // Clear form
      clearCampaignForm();

      update();

      // Navigate back to campaigns screen
      Get.back();
    } else {
      showToast(
        message: response.message,
        isError: true,
      );
    }
  }

  // Update campaign status (pause, cancel)
  updateCampaignStatus(int campaignId, String status) async {
    _isUpdatingCampaign = true;
    update();

    APIResponse response = await campaignService.updateCampaignStatus(campaignId, status);
    _isUpdatingCampaign = false;

    if (response.status == "success") {
      showToast(
        message: response.message,
        isError: false,
      );

      // Update the campaign in the list
      final updatedCampaign = CampaignModel.fromJson(response.data['campaign']);
      final index = allCampaigns.indexWhere((c) => c.id == campaignId);
      if (index != -1) {
        allCampaigns[index] = updatedCampaign;
      }

      // Update selected campaign if it's the one being updated
      if (selectedCampaign?.id == campaignId) {
        selectedCampaign = updatedCampaign;
      }

      update();
    } else {
      showToast(
        message: response.message,
        isError: true,
      );
    }
  }

  // Delete campaign
  deleteCampaign(int campaignId) async {
    setLoadingState(true);

    APIResponse response = await campaignService.deleteCampaign(campaignId);
    setLoadingState(false);

    if (response.status == "success") {
      showToast(
        message: response.message,
        isError: false,
      );

      // Remove campaign from list
      allCampaigns.removeWhere((c) => c.id == campaignId);

      // Clear selected campaign if it was deleted
      if (selectedCampaign?.id == campaignId) {
        selectedCampaign = null;
      }

      update();

      // Navigate back
      Get.back();
    } else {
      showToast(
        message: response.message,
        isError: true,
      );
    }
  }

  // Set payment method
  setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    update();
  }

  // Set status
  setStatus(String status) {
    selectedStatus = status;
    statusController.text = status == 'draft' ? 'Draft' : 'Active';
    update();
  }

  // Set priority
  setPriority(int priority) {
    selectedPriority = priority;
    update();
    // Trigger cost estimation when priority changes
    _triggerCostEstimation();
  }

  // Estimate campaign cost
  estimateCampaignCost() async {
    // Only estimate if both dates are set
    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      costEstimate = null;
      update();
      return;
    }

    _isEstimatingCost = true;
    update();

    // Extract date part only (YYYY-MM-DD) from the datetime string
    String startDate = startDateController.text.split(' ')[0];
    String endDate = endDateController.text.split(' ')[0];

    APIResponse response = await campaignService.estimateCampaignCost(
      startDate: startDate,
      endDate: endDate,
      priority: selectedPriority,
    );

    _isEstimatingCost = false;

    if (response.status == "success") {
      costEstimate = CampaignCostEstimate.fromJson(response.data);
    } else {
      costEstimate = null;
    }
    update();
  }

  // Trigger cost estimation when dates or priority change
  _triggerCostEstimation() {
    if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
      estimateCampaignCost();
    }
  }

  // Called when start date is set
  onStartDateChanged() {
    _triggerCostEstimation();
  }

  // Called when end date is set
  onEndDateChanged() {
    _triggerCostEstimation();
  }

  // Clear campaign form
  clearCampaignForm() {
    campaignNameController.clear();
    startDateController.clear();
    endDateController.clear();
    priorityController.clear();
    statusController.text = 'Draft';
    selectedPaymentMethod = 'wallet';
    selectedStatus = 'draft';
    selectedPriority = 1;
    costBreakdown = null;
    costEstimate = null;
    update();
  }
}
