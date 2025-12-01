import 'dart:async';
import 'dart:io';
import 'package:sharpvendor/core/models/categories_model.dart';
import 'package:sharpvendor/core/models/menu_item_model.dart';
import 'package:sharpvendor/core/services/restaurant/menu/menu_service.dart';
import 'package:sharpvendor/modules/menu/widgets/category_form.dart';
import '../../../core/utils/exports.dart';

class FoodMenuController extends GetxController {
  final menuService = serviceLocator<MenuService>();
  final menuSetupFormKey = GlobalKey<FormState>();
  final categoryFormKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;
  setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  // Menu items list
  List<MenuItemModel> menuItems = [];
  bool isLoadingMenuItems = false;

  setMenuItemsLoadingState(bool val) {
    isLoadingMenuItems = val;
    update();
  }

  // Categories management
  List<CategoryModel> categoryModels = [];
  List<CategoryModel> filteredCategories = [];
  bool isLoadingCategories = false;
  CategoryModel? selectedCategoryModel;
  bool isEditMode = false;

  setCategoriesLoadingState(bool val) {
    isLoadingCategories = val;
    update();
  }

  // Image handling
  String? foodImage;

  // Track original values when editing to detect changes
  MenuItemModel? _originalMenuItem;

  selectFoodImage({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      // File image = compressImageWithLowerQuality(file);
      foodImage = await convertImageToBase64(croppedPhoto.path);
      update();
    }
  }

  // Form Controllers
  TextEditingController menuNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController prepTimeController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController packagingPriceController = TextEditingController();

  // Dropdowns
  CategoryModel? selectedCategory;

  // Dynamic categories list from CategoryModel
  List<CategoryModel> get categories => categoryModels;

  setSelectedCategory(CategoryModel category) {
    selectedCategory = category;
    update();
  }

  // Availability toggle
  int isAvailable = 1;
  toggleAvailability(int value) {
    isAvailable = value;
    update();
  }

  // Available quantity
  int availableQuantity = 1;
  incrementQuantity() {
    availableQuantity++;
    update();
  }

  decrementQuantity() {
    if (availableQuantity > 0) {
      availableQuantity--;
      update();
    }
  }

  setQuantity(int quantity) {
    if (quantity >= 0) {
      availableQuantity = quantity;
      update();
    }
  }

  // Plate size selection
  String selectedPlateSize = "M"; // Default to Medium
  List<String> plateSizes = ["S", "M", "L"];

  setSelectedPlateSize(String size) {
    selectedPlateSize = size;
    update();
  }

  // Show on customer app toggle
  bool showOnCustomerApp = true;
  toggleShowOnCustomerApp(bool value) {
    showOnCustomerApp = value;
    update();
  }

  // Packaging toggle
  bool hasPackaging = false;
  toggleHasPackaging(bool value) {
    hasPackaging = value;
    if (!value) {
      packagingPriceController.clear();
    }
    update();
  }

  // Selected addons
  List<MenuItemModel> selectedAddons = [];

  addAddon(MenuItemModel addon) {
    if (!selectedAddons.any((item) => item.id == addon.id)) {
      selectedAddons.add(addon);
      update();
    }
  }

  removeAddon(MenuItemModel addon) {
    selectedAddons.removeWhere((item) => item.id == addon.id);
    update();
  }

  clearAddons() {
    selectedAddons.clear();
    update();
  }

  bool isAddonSelected(MenuItemModel addon) {
    return selectedAddons.any((item) => item.id == addon.id);
  }

  // Initialize default categories (fallback)
  void initializeDefaultCategories() {
    if (categoryModels.isEmpty) {
      categoryModels = [
        CategoryModel(id: 1, name: 'Rice', description: "Rice dishes"),
        CategoryModel(
          id: 2,
          name: 'Vegetable',
          description: "Vegetable dishes",
        ),
        CategoryModel(id: 3, name: 'Soup', description: "Soup varieties"),
        CategoryModel(id: 4, name: 'Spaghetti', description: "Pasta dishes"),
      ];
      filteredCategories = List.from(categoryModels);
    }
  }

  // Get categories from API
  getCategories() async {
    setCategoriesLoadingState(true);

    try {
      final response = await menuService.getMenuCategories({
        'page': 1,
        'per_page': 100, // Get all categories
      });

      if (response.status == "success" && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> categoriesData = responseData['data'] ?? [];

        categoryModels = categoriesData
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        if (categoryModels.isEmpty) {
          // Use defaults if no categories from API
          initializeDefaultCategories();
        } else {
          filteredCategories = List.from(categoryModels);
        }
      } else {
        // Fallback to default categories
        initializeDefaultCategories();
        if (response.message != null && response.message!.isNotEmpty) {
          showToast(message: response.message!, isError: true);
        }
      }
    } catch (e) {
      // Fallback to default categories
      initializeDefaultCategories();
      showToast(
        message: "Error loading categories: ${e.toString()}",
        isError: true,
      );
    } finally {
      setCategoriesLoadingState(false);
    }
  }

  // Filter categories based on search
  void filterCategories(String query) {
    if (query.isEmpty) {
      filteredCategories = List.from(categoryModels);
    } else {
      filteredCategories = categoryModels
          .where(
            (category) =>
                category.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    update();
  }

  // Show add category modal
  void showAddCategoryModal(BuildContext context) {
    isEditMode = false;
    selectedCategoryModel = null;
    categoryNameController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const CategoryForm(),
      ),
    );
  }

  // Show edit category modal
  void showEditCategoryModal(BuildContext context, CategoryModel category) {
    isEditMode = true;
    selectedCategoryModel = category;
    categoryNameController.text = category.name;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const CategoryForm(),
      ),
    );
  }

  // Show delete confirmation dialog
  void showDeleteConfirmationDialog(
    BuildContext context,
    CategoryModel category,
  ) {
    selectedCategoryModel = category;

    showDialog(
      context: context,
      builder: (context) => const CategoryDeleteDialog(),
    );
  }

  // Save category (add or edit)
  saveCategory() async {
    if (categoryFormKey.currentState!.validate()) {
      setLoadingState(true);

      try {
        // TODO: Implement category save API call when available
        await Future.delayed(const Duration(seconds: 1));

        if (isEditMode && selectedCategoryModel != null) {
          // Update existing category
          int index = categoryModels.indexWhere(
            (cat) => cat.id == selectedCategoryModel!.id,
          );
          if (index != -1) {
            categoryModels[index] = CategoryModel(
              id: selectedCategoryModel!.id,
              name: categoryNameController.text,
              description: "Updated category",
            );
          }
          showToast(message: "Category updated successfully", isError: false);
        } else {
          // Add new category
          final newCategory = CategoryModel(
            id: int.parse(DateTime.now().millisecondsSinceEpoch.toString()),
            name: categoryNameController.text,
            description: "New category",
          );
          categoryModels.add(newCategory);
          showToast(message: "Category added successfully", isError: false);
        }

        filterCategories(searchController.text);
        Get.back();
        clearCategoryForm();
      } catch (e) {
        showToast(message: "Error saving category", isError: true);
      } finally {
        setLoadingState(false);
      }
    }
  }

  // Delete category
  deleteCategory() async {
    if (selectedCategoryModel != null) {
      setLoadingState(true);

      try {
        // TODO: Implement category delete API call when available
        await Future.delayed(const Duration(seconds: 1));

        categoryModels.removeWhere(
          (cat) => cat.id == selectedCategoryModel!.id,
        );
        filterCategories(searchController.text);

        showToast(message: "Category deleted successfully", isError: false);
        Get.back();
      } catch (e) {
        showToast(message: "Error deleting category", isError: true);
      } finally {
        setLoadingState(false);
      }
    }
  }

  // Clear category form
  void clearCategoryForm() {
    categoryNameController.clear();
    selectedCategoryModel = null;
    isEditMode = false;
  }

  // Helper method to get prep time from controller
  int _getPrepTime() {
    return int.tryParse(prepTimeController.text) ?? 15;
  }

  // Save menu item -
  saveMenuItem() async {
    if (menuSetupFormKey.currentState!.validate()) {
      if (foodImage == null) {
        showToast(message: "Please select a food image", isError: true);
        return;
      }

      if (selectedCategory == null) {
        showToast(message: "Please select a category", isError: true);
        return;
      }

      setLoadingState(true);

      try {

        // Get prep time from controller
        int prepTimeMinutes = _getPrepTime();

        // Strip currency formatting from price
        String cleanedPrice = priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
        double priceValue = double.tryParse(cleanedPrice) ?? 0.0;

        // Prepare data in the required format
        final Map<String, dynamic> menuData = {
          "name": menuNameController.text.trim(),
          "description": descriptionController.text.trim(),
          "plate_size": selectedPlateSize,
          "price": priceValue,
          "prep_time_minutes": prepTimeMinutes,
          "category_id": selectedCategory!.id,
          "images": [foodImage], // Array of base64 images
          "addons": selectedAddons.map((addon) => addon.id).toList(), // Array of addon IDs
          "is_available": isAvailable == 1,
        };

        // Add packaging_price only if hasPackaging is true
        if (hasPackaging && packagingPriceController.text.isNotEmpty) {
          String cleanedPackagingPrice = packagingPriceController.text.replaceAll(RegExp(r'[^\d.]'), '');
          menuData["packaging_price"] = double.tryParse(cleanedPackagingPrice) ?? 0.0;
        }

        // Call the API
        final APIResponse response = await menuService.createMenu(menuData);

        if (response.status == "success") {
          // Clear form
          clearForm();

          // Navigate back first
          Get.back();

          // Show toast after navigation
          showToast(message: "Menu item added successfully", isError: false);

          // Refresh menu items in the background
          getMenuItems();
        } else {
          showToast(
            message: response.message ?? "Failed to add menu item",
            isError: true,
          );
        }
      } catch (e) {
        showToast(
          message: "Error adding menu item: ${e.toString()}",
          isError: true,
        );
      } finally {
        setLoadingState(false);
      }
    }
  }

  // Update menu item -
  updateMenuItem() async {
    if (menuSetupFormKey.currentState!.validate()) {
      if (foodImage == null) {
        showToast(message: "Please select a food image", isError: true);
        return;
      }

      if (selectedCategory == null) {
        showToast(message: "Please select a category", isError: true);
        return;
      }

      if (currentMenuItem == null) {
        showToast(message: "No menu item selected for update", isError: true);
        return;
      }

      if (_originalMenuItem == null) {
        showToast(message: "Original menu item data not found", isError: true);
        return;
      }

      setLoadingState(true);

      try {
        // Get prep time from controller
        int prepTimeMinutes = _getPrepTime();

        // Build menuData with only changed fields
        final Map<String, dynamic> menuData = {};

        // Check each field and only add if changed
        String newName = menuNameController.text.trim();
        if (newName != _originalMenuItem!.name) {
          menuData["name"] = newName;
        }

        String newDescription = descriptionController.text.trim();
        if (newDescription != (_originalMenuItem!.description ?? "")) {
          menuData["description"] = newDescription;
        }

        if (selectedPlateSize != (_originalMenuItem!.plateSize ?? "M")) {
          menuData["plate_size"] = selectedPlateSize;
        }

        // Strip currency formatting from price
        String cleanedPriceText = priceController.text.replaceAll(RegExp(r'[^\d.]'), '');
        double newPrice = double.tryParse(cleanedPriceText) ?? 0.0;
        if (newPrice != _originalMenuItem!.price) {
          menuData["price"] = newPrice;
        }

        // Compare prep time (extract from original duration)
        String originalDurationStr = _originalMenuItem!.duration;
        int originalPrepTime = 15; // default
        RegExp numberRegex = RegExp(r'\d+');
        Match? match = numberRegex.firstMatch(originalDurationStr);
        if (match != null) {
          originalPrepTime = int.tryParse(match.group(0) ?? "15") ?? 15;
        }

        if (prepTimeMinutes != originalPrepTime) {
          menuData["prep_time_minutes"] = prepTimeMinutes;
        }

        if (selectedCategory!.id != _originalMenuItem!.category.id) {
          menuData["category_id"] = selectedCategory!.id;
        }

        // Check if addons changed
        List<int> newAddonIds = selectedAddons.map((addon) => addon.id).toList();
        List<int> originalAddonIds = _originalMenuItem!.addons.map((addon) => addon.id).toList();

        // Sort for comparison
        newAddonIds.sort();
        originalAddonIds.sort();

        if (newAddonIds.toString() != originalAddonIds.toString()) {
          menuData["addons"] = newAddonIds;
        }

        // Check if packaging price changed - strip currency formatting
        double? newPackagingPrice;
        if (hasPackaging && packagingPriceController.text.isNotEmpty) {
          String cleanedPackagingPrice = packagingPriceController.text.replaceAll(RegExp(r'[^\d.]'), '');
          newPackagingPrice = double.tryParse(cleanedPackagingPrice);
        }

        double? originalPackagingPrice = _originalMenuItem!.packagingPrice;

        // Compare packaging prices (handle null cases)
        if (newPackagingPrice != originalPackagingPrice) {
          if (newPackagingPrice != null && newPackagingPrice > 0) {
            menuData["packaging_price"] = newPackagingPrice;
          } else {
            // If packaging was removed or set to null/0, send null to clear it
            menuData["packaging_price"] = null;
          }
        }

        // Check if availability changed
        if (isAvailable != _originalMenuItem!.isAvailable) {
          menuData["is_available"] = isAvailable == 1;
        }

        // Only include images if a new image was selected (base64 format)
        // If foodImage is a URL (from existing item), don't send it
        bool imageChanged = false;
        if (foodImage != null && foodImage!.startsWith('data:image')) {
          menuData["images"] = [foodImage]; // Array of base64 images
          imageChanged = true;
        }

        // Check if anything changed
        if (menuData.isEmpty) {
          showToast(message: "No changes detected", isError: false);
          setLoadingState(false);
          return;
        }

        // Print detailed logging
        print('\n' + '=' * 60);
        print('UPDATE MENU REQUEST');
        print('=' * 60);
        print('Menu ID: ${currentMenuItem!.id}');
        print('Menu Name: ${currentMenuItem!.name}');
        print('\nChanged Fields:');

        menuData.forEach((key, value) {
          if (key == 'images') {
            // For images, show format info instead of full base64 string
            if (value is List && value.isNotEmpty) {
              String imageData = value[0] as String;
              String mimeType = 'unknown';
              int dataLength = imageData.length;

              // Extract MIME type from data URI
              if (imageData.startsWith('data:image/')) {
                int semicolonIndex = imageData.indexOf(';');
                if (semicolonIndex > 0) {
                  mimeType = imageData.substring(5, semicolonIndex); // Extract after "data:"
                }
              }

              print('  - $key: [1 image]');
              print('    • Format: $mimeType');
              print('    • Data URI length: $dataLength characters');
              print('    • Preview: ${imageData.substring(0, 50)}...');
            }
          } else {
            print('  - $key: $value');
          }
        });

        print('\nImage Status:');
        print('  • Image changed: $imageChanged');
        print('  • Current foodImage type: ${foodImage!.startsWith('data:image') ? 'Base64 Data URI' : 'URL'}');

        print('=' * 60 + '\n');

        // Call the API
        final APIResponse response = await menuService.updateMenu(menuData, currentMenuItem!.id,);

        if (response.status == "success") {
          // Clear form
          clearForm();

          // Navigate back first
          Get.back();

          // Show toast after navigation
          showToast(message: "Menu item updated successfully", isError: false);

          // Refresh menu items in the background
          getMenuItems();
        } else {
          showToast(
            message: response.message ?? "Failed to update menu item",
            isError: true,
          );
        }
      } catch (e) {
        showToast(
          message: "Error updating menu item: ${e.toString()}",
          isError: true,
        );
      } finally {
        setLoadingState(false);
      }
    }
  }

  void clearForm() {
    menuNameController.clear();
    descriptionController.clear();
    priceController.clear();
    prepTimeController.clear();
    packagingPriceController.clear();
    selectedCategory = null;
    foodImage = null;
    isAvailable = 1;
    availableQuantity = 1;
    selectedPlateSize = "M";
    showOnCustomerApp = true;
    hasPackaging = false;
    currentMenuItem = null; // Reset current menu item
    _originalMenuItem = null; // Reset original menu item
    selectedAddons.clear(); // Clear addons
    update();
  }

  // Get menu items - UPDATED WITH API INTEGRATION
  getMenuItems() async {
    setMenuItemsLoadingState(true);

    try {
      final response = await menuService.getAllMenu({
        'fresh': true,
        'page': 'page=1',
        'per_page': 50,
      });

      if (response.status == "success" && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> menuData = responseData['data'] ?? [];

        menuItems = menuData.map((json) => MenuItemModel.fromJson(json)).toList();

      } else {
        if (response.message != null && response.message!.isNotEmpty) {
          showToast(message: response.message!, isError: true);
        }
      }
    } catch (e) {
      // Keep existing sample data as fallback

      showToast(
        message: "Error loading menu items: ${e.toString()}",
        isError: true,
      );
    } finally {
      setMenuItemsLoadingState(false);
    }
  }

  // Current menu item being viewed
  MenuItemModel? currentMenuItem;

  setCurrentMenuItem(MenuItemModel item) {
    currentMenuItem = item;
    update();
  }

  // Update menu item availability - TODO: Add API integration
  updateMenuItemAvailability(int itemId, bool isAvailable) async {
    setLoadingState(true);

    try {
      // TODO: Replace with actual API call using updateMenu method
      await Future.delayed(const Duration(seconds: 1));

      // Update in local list
      int index = menuItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        menuItems[index] = MenuItemModel(
          id: menuItems[index].id,
          name: menuItems[index].name,
          restaurant: menuItems[index].restaurant,
          category: menuItems[index].category,
          price: menuItems[index].price,
          duration: menuItems[index].duration,
          image: menuItems[index].image,
          isAvailable: 1,
          availableQuantity: menuItems[index].availableQuantity,
          description: menuItems[index].description,
          plateSize: menuItems[index].plateSize,
          showOnCustomerApp: menuItems[index].showOnCustomerApp,
          files: menuItems[index].files,
          packagingPrice: menuItems[index].packagingPrice,
        );

        // Update current menu item if it's the same
        if (currentMenuItem?.id == itemId) {
          currentMenuItem = menuItems[index];
        }
      }

      showToast(
        message:
            "Menu item ${isAvailable ? 'enabled' : 'disabled'} successfully",
        isError: false,
      );
    } catch (e) {
      showToast(
        message: "Error updating menu item: ${e.toString()}",
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  deleteMenuItem(int itemId) async {
    setLoadingState(true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      menuItems.removeWhere((item) => item.id == itemId);
      showToast(message: "Menu item deleted successfully", isError: false);
      Get.back();
    } catch (e) {
      showToast(
        message: "Error deleting menu item: ${e.toString()}",
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Edit menu item
  editMenuItem(MenuItemModel item) {
    // Set the current menu item for updating
    currentMenuItem = item;

    // Store original item for comparison during update
    _originalMenuItem = item;

    // Populate form with existing data
    menuNameController.text = item.name;
    descriptionController.text = item.description ?? "";
    priceController.text = item.price.toString();

    // Fix prep time parsing - handle different duration formats
    String durationStr = item.duration;
    String prepTimeValue = "";

    // Try to extract numbers from duration string
    RegExp numberRegex = RegExp(r'\d+');
    Match? match = numberRegex.firstMatch(durationStr);
    if (match != null) {
      prepTimeValue = match.group(0) ?? "";
    }

    // If no numbers found, try parsing as direct number
    if (prepTimeValue.isEmpty) {
      int? parsedDuration = int.tryParse(durationStr);
      if (parsedDuration != null) {
        prepTimeValue = parsedDuration.toString();
      }
    }

    prepTimeController.text = prepTimeValue.isNotEmpty ? prepTimeValue : "15"; // Default to 15 if parsing fails

    selectedCategory = item.category;
    isAvailable = item.isAvailable;
    availableQuantity = item.availableQuantity;

    // Fix image handling - get image from files array
    if (item.files.isNotEmpty) {
      // Get the first image file from the files array
      final imageFile = item.files.firstWhere(
        (file) => file.mimeType.startsWith('image/'),
        orElse: () => item.files.first, // Fallback to first file if no image found
      );
      foodImage = imageFile.url;
    } else if (item.image.isNotEmpty) {
      // Fallback to the direct image field if no files
      foodImage = item.image;
    } else {
      // If no image, set to null to show placeholder
      foodImage = null;
    }

    selectedPlateSize = item.plateSize ?? "M";
    showOnCustomerApp = item.showOnCustomerApp ?? true;
    selectedAddons = List.from(item.addons); // Populate addons

    // Populate packaging fields
    if (item.packagingPrice != null && item.packagingPrice! > 0) {
      hasPackaging = true;
      packagingPriceController.text = item.packagingPrice.toString();
    } else {
      hasPackaging = false;
      packagingPriceController.clear();
    }

    update();

    Get.toNamed(Routes.EDIT_MENU_SCREEN);
  }

  @override
  void onInit() {
    super.onInit();
    initializeDefaultCategories();
    getCategories();
    getMenuItems();

    // Setup search listener
    searchController.addListener(() {
      filterCategories(searchController.text);
    });

    // Setup price listener to update commission calculator
    priceController.addListener(() {
      update(); // Trigger rebuild to show updated commission
    });
  }

  @override
  void onClose() {
    // Remove listeners before disposal
    searchController.removeListener(() {
      filterCategories(searchController.text);
    });
    priceController.removeListener(() {
      update();
    });

    // Dispose controllers
    menuNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    prepTimeController.dispose();
    categoryNameController.dispose();
    searchController.dispose();
    packagingPriceController.dispose();
    super.onClose();
  }
}
