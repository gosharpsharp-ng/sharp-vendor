class CommissionFormula {
  final String formula;
  final FormulaDetails? formulaDetails;
  final String settingsSource;
  final FormulaParameters? parameters;
  final List<CommissionExample> examples;
  final String? note;

  CommissionFormula({
    required this.formula,
    this.formulaDetails,
    required this.settingsSource,
    this.parameters,
    required this.examples,
    this.note,
  });

  factory CommissionFormula.fromJson(Map<String, dynamic> json) {
    return CommissionFormula(
      formula: json['formula'] ?? '',
      formulaDetails: json['formula_details'] != null
          ? FormulaDetails.fromJson(json['formula_details'])
          : null,
      settingsSource: json['settings_source'] ?? '',
      parameters: json['parameters'] != null
          ? FormulaParameters.fromJson(json['parameters'])
          : null,
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => CommissionExample.fromJson(e))
              .toList() ??
          [],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formula': formula,
      'formula_details': formulaDetails?.toJson(),
      'settings_source': settingsSource,
      'parameters': parameters?.toJson(),
      'examples': examples.map((e) => e.toJson()).toList(),
      'note': note,
    };
  }

  /// Calculate commission for a given menu price
  double calculateCommission(double menuPrice) {
    if (parameters == null) return 0.0;

    // Handle logarithmic commission if base rate and k coefficient exist
    if (parameters!.baseRate != null && parameters!.kCoefficient != null) {
      // Rate = base_rate + (k × ln(price))
      final rate = parameters!.baseRate! +
          (parameters!.kCoefficient! * _ln(menuPrice));
      // Commission = (Menu Price × Rate) / 100
      return (menuPrice * rate) / 100;
    }

    // Fallback: use commission rate if no logarithmic parameters
    return 0.0;
  }

  /// Calculate commission rate for a given menu price
  double calculateCommissionRate(double menuPrice) {
    if (parameters == null) return 0.0;

    if (parameters!.baseRate != null && parameters!.kCoefficient != null) {
      // Rate = base_rate + (k × ln(price))
      return parameters!.baseRate! +
          (parameters!.kCoefficient! * _ln(menuPrice));
    }

    return 0.0;
  }

  /// Natural logarithm helper
  double _ln(double x) {
    if (x <= 0) return 0;
    return _log(x) / _log(2.718281828459045);
  }

  /// Base logarithm helper
  double _log(double x) {
    if (x <= 0) return 0;
    return x.toString().length.toDouble() - 1;
  }
}

class FormulaDetails {
  final String rateCalculation;
  final String commissionCalculation;

  FormulaDetails({
    required this.rateCalculation,
    required this.commissionCalculation,
  });

  factory FormulaDetails.fromJson(Map<String, dynamic> json) {
    return FormulaDetails(
      rateCalculation: json['rate_calculation'] ?? '',
      commissionCalculation: json['commission_calculation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate_calculation': rateCalculation,
      'commission_calculation': commissionCalculation,
    };
  }
}

class FormulaParameters {
  final double? baseRate;
  final double? kCoefficient;

  FormulaParameters({
    this.baseRate,
    this.kCoefficient,
  });

  factory FormulaParameters.fromJson(Map<String, dynamic> json) {
    return FormulaParameters(
      baseRate: json['base_rate']?.toDouble(),
      kCoefficient: json['k_coefficient']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_rate': baseRate,
      'k_coefficient': kCoefficient,
    };
  }
}

class CommissionExample {
  final int menuPrice;
  final double commissionRate;
  final double commissionAmount;

  CommissionExample({
    required this.menuPrice,
    required this.commissionRate,
    required this.commissionAmount,
  });

  factory CommissionExample.fromJson(Map<String, dynamic> json) {
    return CommissionExample(
      menuPrice: json['menu_price'] ?? 0,
      commissionRate: (json['commission_rate'] as num?)?.toDouble() ?? 0.0,
      commissionAmount: (json['commission_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_price': menuPrice,
      'commission_rate': commissionRate,
      'commission_amount': commissionAmount,
    };
  }
}
