import '../utils/helpers.dart';

class RestaurantWallet {
  final int id;
  final String balance;
  final String bonusBalance;
  final int currencyId;
  final String walletableType;
  final int walletableId;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  RestaurantWallet({
    required this.id,
    required this.balance,
    required this.bonusBalance,
    required this.currencyId,
    required this.walletableType,
    required this.walletableId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantWallet.fromJson(Map<String, dynamic> json) {
    return RestaurantWallet(
      id: json['id'] ?? 0,
      balance: json['balance'] ?? '0.00',
      bonusBalance: json['bonus_balance'] ?? '0.00',
      currencyId: json['currency_id'] ?? 1,
      walletableType: json['walletable_type'] ?? '',
      walletableId: json['walletable_id'] ?? 0,
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'bonus_balance': bonusBalance,
      'currency_id': currencyId,
      'walletable_type': walletableType,
      'walletable_id': walletableId,
      'deleted_at': deletedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convenience getters
  double get balanceDouble => double.tryParse(balance) ?? 0.0;
  double get bonusBalanceDouble => double.tryParse(bonusBalance) ?? 0.0;
  double get totalBalance => balanceDouble + bonusBalanceDouble;

  // Formatted balance with currency symbol using proper formatting
  String get formattedBalance => formatToCurrency(balanceDouble);
}
