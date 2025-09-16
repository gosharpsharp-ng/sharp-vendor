import 'dart:async';
import 'package:sharpvendor/core/models/categories_model.dart';
import 'package:sharpvendor/core/models/menu_item_model.dart';
import 'package:sharpvendor/modules/menu/widgets/category_form.dart';
import '../../../core/utils/exports.dart';

class FoodMenuController extends GetxController {
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
  selectFoodImage({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      foodImage = await convertImageToBase64(croppedPhoto.path);
      update();
    }
  }

  // Form Controllers
  TextEditingController menuNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  // Dropdowns
  String? selectedCategory;
  String? selectedFoodDuration;

  // Dynamic categories list from CategoryModel
  List<String> get categories => categoryModels.map((cat) => cat.name).toList();

  List<String> foodDurations = [
    '5-10 minutes',
    '10-15 minutes',
    '15-20 minutes',
    '20-30 minutes',
    '30+ minutes',
  ];

  setSelectedCategory(String category) {
    selectedCategory = category;
    update();
  }

  setSelectedFoodDuration(String duration) {
    selectedFoodDuration = duration;
    update();
  }

  // Availability toggle
  bool isAvailable = true;
  toggleAvailability(bool value) {
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

  // Initialize default categories
  void initializeDefaultCategories() {
    categoryModels = [
      CategoryModel(id: '1', name: 'Rice', description: "Nice one"),
      CategoryModel(id: '2', name: 'Vegetable', description: "Nice one"),
      CategoryModel(id: '3', name: 'Soup', description: "Nice one"),
      CategoryModel(id: '4', name: 'Spaghetti', description: "Nice one"),
    ];
    filteredCategories = List.from(categoryModels);
  }

  // Get categories from API
  getCategories() async {
    setCategoriesLoadingState(true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // For now, use initialized categories
      filteredCategories = List.from(categoryModels);
    } catch (e) {
      showToast(message: "Error loading categories", isError: true);
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
        // TODO: Replace with actual API call
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
                description: "Nice one"
            );
          }
          showToast(message: "Category updated successfully", isError: false);
        } else {
          // Add new category
          final newCategory = CategoryModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: categoryNameController.text,
            description: "Nice one",
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
        // TODO: Replace with actual API call
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

  // Save menu item
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

      if (selectedFoodDuration == null) {
        showToast(message: "Please select food duration", isError: true);
        return;
      }

      setLoadingState(true);

      dynamic data = {
        'name': menuNameController.text,
        'description': descriptionController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'category': selectedCategory,
        'food_duration': selectedFoodDuration,
        'is_available': isAvailable,
        'available_quantity': availableQuantity,
        'image': foodImage,
      };

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      showToast(message: "Menu item added successfully", isError: false);
      setLoadingState(false);

      // Clear form
      clearForm();
      Get.back();
    }
  }

  clearForm() {
    menuNameController.clear();
    descriptionController.clear();
    priceController.clear();
    selectedCategory = null;
    selectedFoodDuration = null;
    foodImage = null;
    isAvailable = true;
    availableQuantity = 1;
    update();
  }

  // Get menu items
  getMenuItems() async {
    setMenuItemsLoadingState(true);

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    // Sample data - replace with actual API response
    menuItems = [
      MenuItemModel(
        id: "1",
        name: "Assorted vegetable soup",
        category: "Soup",
        price: 3000.00,
        duration: "15-20 minutes",
        image: "assets/imgs/menu_2.png",
        isAvailable: true,
        availableQuantity: 10,
        description: "Delicious assorted vegetable soup",
      ),
      MenuItemModel(
        id: "2",
        name: "Efo riro",
        category: "Vegetable",
        price: 3000.00,
        duration: "15-20 minutes",
        image: "assets/imgs/menu_1.png",
        isAvailable: true,
        availableQuantity: 5,
        description: "Traditional Nigerian spinach stew",
      ),
      MenuItemModel(
        id: "3",
        name: "Bitter leaf soup",
        category: "Soup",
        price: 3000.00,
        duration: "15-20 minutes",
        image: "assets/imgs/menu_3.png",
        isAvailable: true,
        availableQuantity: 8,
        description: "Nutritious bitter leaf soup",
      ),
    ];

    setMenuItemsLoadingState(false);
  }

  // Current menu item being viewed
  MenuItemModel? currentMenuItem;

  setCurrentMenuItem(MenuItemModel item) {
    currentMenuItem = item;
    update();
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

  // Update menu item availability
  updateMenuItemAvailability(String itemId, bool isAvailable) async {
    setLoadingState(true);

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    // Update in local list
    int index = menuItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      menuItems[index] = MenuItemModel(
        id: menuItems[index].id,
        name: menuItems[index].name,
        category: menuItems[index].category,
        price: menuItems[index].price,
        duration: menuItems[index].duration,
        image: menuItems[index].image,
        isAvailable: isAvailable,
        availableQuantity: menuItems[index].availableQuantity,
        description: menuItems[index].description,
      );

      // Update current menu item if it's the same
      if (currentMenuItem?.id == itemId) {
        currentMenuItem = menuItems[index];
      }
    }

    showToast(
      message: "Menu item ${isAvailable ? 'enabled' : 'disabled'} successfully",
      isError: false,
    );
    setLoadingState(false);
  }

  deleteMenuItem(String itemId) async {
    setLoadingState(true);

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    menuItems.removeWhere((item) => item.id == itemId);
    showToast(message: "Menu item deleted successfully", isError: false);
    setLoadingState(false);
  }

  // Edit menu item
  editMenuItem(MenuItemModel item) {
    // Populate form with existing data
    menuNameController.text = item.name;
    descriptionController.text = item.description ?? "";
    priceController.text = item.price.toString();
    selectedCategory = item.category;
    selectedFoodDuration = item.duration;
    isAvailable = item.isAvailable;
    availableQuantity = item.availableQuantity;
    foodImage = item.image;
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
  }

  @override
  void onClose() {
    menuNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    categoryNameController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
