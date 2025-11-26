import 'package:json_annotation/json_annotation.dart';

part 'campaign_model.g.dart';

@JsonSerializable()
class CampaignModel {
  final int? id;
  final String? name;
  @JsonKey(name: 'restaurant_id')
  final int? restaurantId;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final String? status;
  final int? priority;
  @JsonKey(name: 'payment_method_code')
  final String? paymentMethodCode;
  @JsonKey(name: 'total_cost')
  final String? totalCost;
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  CampaignModel({
    this.id,
    this.name,
    this.restaurantId,
    this.startDate,
    this.endDate,
    this.status,
    this.priority,
    this.paymentMethodCode,
    this.totalCost,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignModelFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignModelToJson(this);

  CampaignModel copyWith({
    int? id,
    String? name,
    int? restaurantId,
    String? startDate,
    String? endDate,
    String? status,
    int? priority,
    String? paymentMethodCode,
    String? totalCost,
    String? paymentStatus,
    String? createdAt,
    String? updatedAt,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      name: name ?? this.name,
      restaurantId: restaurantId ?? this.restaurantId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      paymentMethodCode: paymentMethodCode ?? this.paymentMethodCode,
      totalCost: totalCost ?? this.totalCost,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class CostBreakdown {
  @JsonKey(name: 'base_cost')
  final String? baseCost;
  @JsonKey(name: 'duration_days')
  final int? durationDays;
  @JsonKey(name: 'priority_multiplier')
  final String? priorityMultiplier;
  @JsonKey(name: 'total_cost')
  final String? totalCost;

  CostBreakdown({
    this.baseCost,
    this.durationDays,
    this.priorityMultiplier,
    this.totalCost,
  });

  factory CostBreakdown.fromJson(Map<String, dynamic> json) =>
      _$CostBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$CostBreakdownToJson(this);
}

@JsonSerializable()
class CampaignResponse {
  final String? status;
  final String? message;
  final CampaignResponseData? data;

  CampaignResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> json) =>
      _$CampaignResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignResponseToJson(this);
}

@JsonSerializable()
class CampaignResponseData {
  final CampaignModel? campaign;
  @JsonKey(name: 'cost_breakdown')
  final CostBreakdown? costBreakdown;
  @JsonKey(name: 'payment_processed')
  final bool? paymentProcessed;

  CampaignResponseData({
    this.campaign,
    this.costBreakdown,
    this.paymentProcessed,
  });

  factory CampaignResponseData.fromJson(Map<String, dynamic> json) =>
      _$CampaignResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignResponseDataToJson(this);
}

@JsonSerializable()
class CampaignCostEstimate {
  @JsonKey(name: 'duration_days')
  final int? durationDays;
  @JsonKey(name: 'base_price_per_day')
  final num? basePricePerDay;
  @JsonKey(name: 'base_cost')
  final num? baseCost;
  final String? priority;
  @JsonKey(name: 'priority_multiplier')
  final num? priorityMultiplier;
  @JsonKey(name: 'priority_cost')
  final num? priorityCost;
  @JsonKey(name: 'final_cost')
  final num? finalCost;
  final CampaignCostBreakdownDetail? breakdown;

  CampaignCostEstimate({
    this.durationDays,
    this.basePricePerDay,
    this.baseCost,
    this.priority,
    this.priorityMultiplier,
    this.priorityCost,
    this.finalCost,
    this.breakdown,
  });

  factory CampaignCostEstimate.fromJson(Map<String, dynamic> json) =>
      _$CampaignCostEstimateFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignCostEstimateToJson(this);
}

@JsonSerializable()
class CampaignCostBreakdownDetail {
  @JsonKey(name: 'Base Cost')
  final String? baseCost;
  @JsonKey(name: 'Priority Multiplier')
  final String? priorityMultiplier;
  @JsonKey(name: 'Total Cost')
  final num? totalCost;

  CampaignCostBreakdownDetail({
    this.baseCost,
    this.priorityMultiplier,
    this.totalCost,
  });

  factory CampaignCostBreakdownDetail.fromJson(Map<String, dynamic> json) =>
      _$CampaignCostBreakdownDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignCostBreakdownDetailToJson(this);
}
