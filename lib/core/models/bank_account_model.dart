class BankAccount {
  final int id;
  final String bankAccountNumber;
  final String bankAccountName;
  final String bankName;
  final String bankCode;
  final String? recipientId;
  final String? accountableType;
  final int? accountableId;
  final String createdAt;
  final String updatedAt;

  BankAccount({
    required this.id,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.bankName,
    required this.bankCode,
    this.recipientId,
    this.accountableType,
    this.accountableId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] ?? 0,
      bankAccountNumber: json['bank_account_number'] ?? '',
      bankAccountName: json['bank_account_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      recipientId: json['recipient_id'],
      accountableType: json['accountable_type'],
      accountableId: json['accountable_id'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_account_number': bankAccountNumber,
      'bank_account_name': bankAccountName,
      'bank_name': bankName,
      'bank_code': bankCode,
      'recipient_id': recipientId,
      'accountable_type': accountableType,
      'accountable_id': accountableId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}