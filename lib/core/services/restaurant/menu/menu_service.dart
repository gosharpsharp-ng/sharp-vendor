import 'package:sharpvendor/core/utils/exports.dart';

class MenuService extends CoreService {
  Future<MenuService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/me");
  }

  Future<APIResponse> createMenu(dynamic data) async {
    return await send("/restaurants/menus", data);
  }

  Future<APIResponse> updateMenu(dynamic data, int id) async {
    dynamic data2=data;
    return await update("/restaurants/menus/$id", data);
  }

  Future<APIResponse> getMenuCategories(dynamic data) async {
    return await fetch(
      "/restaurants/menu-categories?page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getMenuCategoryById(dynamic data) async {
    return await fetch("/restaurants/menu-categories/${data['id']}");
  }

  Future<APIResponse> getAllMenu(dynamic data) async {
    return await fetch(
      "/restaurants/menus?fresh=${data['fresh']}&${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getMenuById(dynamic data) async {
    return await fetch("/restaurants/menus/${data['id']}");
  }
}
