import 'package:intl/intl.dart';
import 'package:sharpvendor/core/models/discount_model.dart';
import 'package:sharpvendor/core/services/restaurant/menu/discount_service.dart';
import 'package:sharpvendor/core/utils/exports.dart';

class DiscountController extends GetxController {
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

  // Current menu ID
  int? currentMenuId;

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

  /// Get all discounts for a menu item
  Future<void> getDiscountsForMenuItem(int menuId, {int page = 1}) async {
    currentMenuId = menuId;
    setDiscountsLoadingState(true);

    try {
      final response = await discountService.getMenuDiscounts(menuId, page: page);

      if (response.status == "success" && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        // Handle the nested structure
        final discountsData = responseData['discounts'];

        if (discountsData != null) {
          final List<dynamic> discountsList = discountsData['data'] ?? [];

          discounts = discountsList
              .map((json) => DiscountModel.fromJson(json))
              .toList();

          currentPage = discountsData['current_page'] ?? 1;
          totalPages = discountsData['last_page'] ?? 1;
          hasMorePages = currentPage < totalPages;
        }
      } else {
        if (response.message.isNotEmpty) {
          showToast(message: response.message, isError: true);
        }
      }
    } catch (e) {
      showToast(message: "Error loading discounts", isError: true);
      customDebugPrint("Error in getDiscountsForMenuItem: $e");
    } finally {
      setDiscountsLoadingState(false);
    }
  }

  /// Load more discounts (pagination)
  Future<void> loadMoreDiscounts() async {
    if (currentMenuId == null || !hasMorePages || isLoadingDiscounts) return;

    await getDiscountsForMenuItem(currentMenuId!, page: currentPage + 1);
  }

  /// Initialize form for creating a new discount
  void initializeCreateForm(int menuId) {
    currentMenuId = menuId;
    isEditMode = false;
    editingDiscount = null;
    clearForm();
  }

  /// Initialize form for editing an existing discount
  void initializeEditForm(DiscountModel discount) {
    isEditMode = true;
    editingDiscount = discount;
    currentMenuId = discount.discountableId;

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

  /// Create a new discount
  Future<void> createDiscount() async {
    if (!validateForm()) return;
    if (currentMenuId == null) {
      showToast(message: "Menu ID is missing", isError: true);
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
        'badge_text': badgeTextController.text.trim().isNotEmpty
            ? badgeTextController.text.trim()
            : null,
        'show_on_listing': showOnListing,
      };

      final response = await discountService.createDiscount(currentMenuId!, payload);

      if (response.status == "success") {
        clearForm();
        Get.back();
        // Show success message after navigating back so it's visible on the previous screen
        if (Get.context != null) {
          ModernSnackBar.showSuccess(
            Get.context!,
            message: response.message.isNotEmpty ? response.message : "Discount created successfully",
          );
        }
        // Refresh the discounts list
        await getDiscountsForMenuItem(currentMenuId!);
      } else {
        if (Get.context != null) {
          ModernSnackBar.showError(
            Get.context!,
            message: response.message.isNotEmpty ? response.message : "Failed to create discount",
          );
        }
      }
    } catch (e) {
      if (Get.context != null) {
        ModernSnackBar.showError(Get.context!, message: "Error creating discount");
      }
      customDebugPrint("Error in createDiscount: $e");
    } finally {
      setLoadingState(false);
    }
  }

  /// Update an existing discount
  Future<void> updateDiscount() async {
    if (!validateForm()) return;
    if (currentMenuId == null || editingDiscount == null) {
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
        'badge_text': badgeTextController.text.trim().isNotEmpty
            ? badgeTextController.text.trim()
            : null,
        'show_on_listing': showOnListing,
      };

      final response = await discountService.updateDiscount(
        currentMenuId!,
        editingDiscount!.id,
        payload,
      );

      if (response.status == "success") {
        clearForm();
        Get.back();
        // Show success message after navigating back so it's visible on the previous screen
        if (Get.context != null) {
          ModernSnackBar.showSuccess(
            Get.context!,
            message: response.message.isNotEmpty ? response.message : "Discount updated successfully",
          );
        }
        // Refresh the discounts list
        await getDiscountsForMenuItem(currentMenuId!);
      } else {
        if (Get.context != null) {
          ModernSnackBar.showError(
            Get.context!,
            message: response.message.isNotEmpty ? response.message : "Failed to update discount",
          );
        }
      }
    } catch (e) {
      if (Get.context != null) {
        ModernSnackBar.showError(Get.context!, message: "Error updating discount");
      }
      customDebugPrint("Error in updateDiscount: $e");
    } finally {
      setLoadingState(false);
    }
  }

  /// Delete a discount
  Future<void> deleteDiscount(int menuId, int discountId) async {
    setLoadingState(true);

    try {
      final response = await discountService.deleteDiscount(menuId, discountId);

      if (response.status == "success") {
        Get.back();
        // Show success message after navigating back so it's visible on the previous screen
        if (Get.context != null) {
          ModernSnackBar.showSuccess(
            Get.context!,
            message: response.message.isNotEmpty ? response.message : "Discount deleted successfully",
          );
        }
        // Refresh the discounts list
        await getDiscountsForMenuItem(menuId);
      } else {
        if (Get.context != null) {
          ModernSnackBar.showError(
            Get.context!,
            message: response.message.isNotEmpty ? response.message : "Failed to delete discount",
          );
        }
      }
    } catch (e) {
      if (Get.context != null) {
        ModernSnackBar.showError(Get.context!, message: "Error deleting discount");
      }
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
