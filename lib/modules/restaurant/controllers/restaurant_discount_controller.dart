import 'package:intl/intl.dart';
import 'package:sharpvendor/core/models/discount_model.dart';
import 'package:sharpvendor/core/services/restaurant/menu/discount_service.dart';
import 'package:sharpvendor/core/utils/exports.dart';

class RestaurantDiscountController extends GetxController {
  final DiscountService discountService = serviceLocator<DiscountService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  void setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  bool isLoadingDiscounts = false;
  void setDiscountsLoadingState(bool val) {
    isLoadingDiscounts = val;
    update();
  }

  // Discounts list
  List<DiscountModel> discounts = [];
  int currentPage = 1;
  int totalPages = 1;
  bool hasMorePages = false;

  // Form controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController badgeTextController = TextEditingController();

  // Form values
  String selectedType = 'percentage';
  bool isActive = true;
  bool showOnListing = true;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  // Edit mode
  bool isEditMode = false;
  DiscountModel? editingDiscount;

  void setDiscountType(String type) {
    selectedType = type;
    update();
  }

  void toggleActive(bool value) {
    isActive = value;
    update();
  }

  void toggleShowOnListing(bool value) {
    showOnListing = value;
    update();
  }

  /// Format date for display
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format date and time for display
  String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Set start date
  void setStartDate(DateTime date) {
    selectedStartDate = date;
    startDateController.text = formatDate(date);
    update();
  }

  /// Set end date
  void setEndDate(DateTime date) {
    selectedEndDate = date;
    endDateController.text = formatDate(date);
    update();
  }

  /// Get all discounts for the restaurant
  Future<void> getRestaurantDiscounts({int page = 1}) async {
    setDiscountsLoadingState(true);

    try {
      final response = await discountService.getRestaurantDiscounts(page: page);

      if (response.status == "success" && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> discountsList = responseData['data'] ?? [];

        discounts = discountsList
            .map((json) => DiscountModel.fromJson(json))
            .toList();

        currentPage = responseData['current_page'] ?? 1;
        totalPages = responseData['last_page'] ?? 1;
        hasMorePages = currentPage < totalPages;
      } else {
        if (response.message.isNotEmpty) {
          showToast(message: response.message, isError: true);
        }
      }
    } catch (e) {
      showToast(message: "Error loading discounts", isError: true);
      customDebugPrint("Error in getRestaurantDiscounts: $e");
    } finally {
      setDiscountsLoadingState(false);
    }
  }

  /// Load more discounts (pagination)
  Future<void> loadMoreDiscounts() async {
    if (!hasMorePages || isLoadingDiscounts) return;

    await getRestaurantDiscounts(page: currentPage + 1);
  }

  /// Initialize form for creating a new discount
  void initializeCreateForm() {
    isEditMode = false;
    editingDiscount = null;
    clearForm();
  }

  /// Initialize form for editing an existing discount
  void initializeEditForm(DiscountModel discount) {
    isEditMode = true;
    editingDiscount = discount;

    nameController.text = discount.name;
    valueController.text = discount.value.toString();
    selectedType = discount.type;
    isActive = discount.isActive;
    showOnListing = discount.showOnListing;
    badgeTextController.text = discount.badgeText ?? '';

    selectedStartDate = discount.startDate;
    startDateController.text = formatDate(discount.startDate);

    selectedEndDate = discount.endDate;
    endDateController.text = formatDate(discount.endDate);

    update();
  }

  /// Validate form before submission
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (selectedStartDate == null) {
      showToast(message: "Please select a start date", isError: true);
      return false;
    }

    if (selectedEndDate == null) {
      showToast(message: "Please select an end date", isError: true);
      return false;
    }

    if (selectedEndDate!.isBefore(selectedStartDate!)) {
      showToast(message: "End date must be after start date", isError: true);
      return false;
    }

    return true;
  }

  /// Create a new restaurant discount
  Future<void> createDiscount() async {
    if (!validateForm()) return;

    setLoadingState(true);

    try {
      final payload = {
        'name': nameController.text.trim(),
        'type': selectedType,
        'value': double.parse(valueController.text.trim()),
        'start_date': formatDate(selectedStartDate!),
        'end_date': formatDate(selectedEndDate!),
        'is_active': isActive,
      };

      // Add optional badge_text if provided
      if (badgeTextController.text.trim().isNotEmpty) {
        payload['badge_text'] = badgeTextController.text.trim();
      }

      final response = await discountService.createRestaurantDiscount(payload);

      if (response.status == "success") {
        showToast(message: response.message.isNotEmpty ? response.message : "Discount created successfully");
        clearForm();
        Get.back();
        // Refresh the discounts list
        await getRestaurantDiscounts();
      } else {
        showToast(message: response.message.isNotEmpty ? response.message : "Failed to create discount", isError: true);
      }
    } catch (e) {
      showToast(message: "Error creating discount", isError: true);
      customDebugPrint("Error in createDiscount: $e");
    } finally {
      setLoadingState(false);
    }
  }

  /// Update an existing restaurant discount
  Future<void> updateDiscount() async {
    if (!validateForm()) return;
    if (editingDiscount == null) {
      showToast(message: "Discount information is missing", isError: true);
      return;
    }

    setLoadingState(true);

    try {
      final payload = {
        'name': nameController.text.trim(),
        'type': selectedType,
        'value': double.parse(valueController.text.trim()),
        'start_date': formatDate(selectedStartDate!),
        'end_date': formatDate(selectedEndDate!),
        'is_active': isActive,
      };

      // Add optional badge_text if provided
      if (badgeTextController.text.trim().isNotEmpty) {
        payload['badge_text'] = badgeTextController.text.trim();
      }

      final response = await discountService.updateRestaurantDiscount(
        editingDiscount!.id,
        payload,
      );

      if (response.status == "success") {
        showToast(message: response.message.isNotEmpty ? response.message : "Discount updated successfully");
        clearForm();
        Get.back();
        // Refresh the discounts list
        await getRestaurantDiscounts();
      } else {
        showToast(message: response.message.isNotEmpty ? response.message : "Failed to update discount", isError: true);
      }
    } catch (e) {
      showToast(message: "Error updating discount", isError: true);
      customDebugPrint("Error in updateDiscount: $e");
    } finally {
      setLoadingState(false);
    }
  }

  /// Delete a restaurant discount
  Future<void> deleteDiscount(int discountId) async {
    setLoadingState(true);

    try {
      final response = await discountService.deleteRestaurantDiscount(discountId);

      if (response.status == "success") {
        showToast(message: response.message.isNotEmpty ? response.message : "Discount deleted successfully");
        // Refresh the discounts list
        await getRestaurantDiscounts();
      } else {
        showToast(message: response.message.isNotEmpty ? response.message : "Failed to delete discount", isError: true);
      }
    } catch (e) {
      showToast(message: "Error deleting discount", isError: true);
      customDebugPrint("Error in deleteDiscount: $e");
    } finally {
      setLoadingState(false);
    }
  }

  /// Clear form
  void clearForm() {
    nameController.clear();
    valueController.clear();
    startDateController.clear();
    endDateController.clear();
    badgeTextController.clear();
    selectedType = 'percentage';
    isActive = true;
    showOnListing = true;
    selectedStartDate = null;
    selectedEndDate = null;
    isEditMode = false;
    editingDiscount = null;
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    valueController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    badgeTextController.dispose();
    super.onClose();
  }
}
