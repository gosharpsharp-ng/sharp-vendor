import 'package:sharpvendor/core/utils/exports.dart';

class RestaurantBankService extends CoreService {
  Future<RestaurantBankService> init() async => this;

  // Get list of banks
  Future<APIResponse> getBankList() async {
    return await fetch("/banks/list");
  }

  // Verify bank account details
  Future<APIResponse> verifyBankAccount(dynamic data) async {
    return await send("/banks/verify-account", data);
  }

  // Update restaurant bank account
  Future<APIResponse> updateRestaurantBankAccount(dynamic data) async {
    return await send("/restaurants/bank-account", data);
  }

  // Get restaurant bank account details
  Future<APIResponse> getRestaurantBankAccount() async {
    return await fetch("/restaurants/bank-account");
  }
}