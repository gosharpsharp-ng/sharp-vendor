class BankVerificationModel {
  final String accountNumber;
  final String accountName;
  final int bankId;

  BankVerificationModel({
    required this.accountNumber,
    required this.accountName,
    required this.bankId,
  });

  factory BankVerificationModel.fromJson(Map<String, dynamic> json) {
    return BankVerificationModel(
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
      bankId: json['bank_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_id': bankId,
    };
  }
}