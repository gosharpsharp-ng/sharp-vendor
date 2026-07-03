class BankModel {
  final String name;
  final String code;

  const BankModel({required this.name, required this.code});

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        name: json['name'] as String,
        code: json['code'] as String,
      );

  Map<String, dynamic> toJson() => {'name': name, 'code': code};
}
