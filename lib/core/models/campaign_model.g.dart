// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignModel _$CampaignModelFromJson(Map<String, dynamic> json) =>
    CampaignModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      restaurantId: (json['restaurant_id'] as num?)?.toInt(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      status: json['status'] as String?,
      priority: (json['priority'] as num?)?.toInt(),
      paymentMethodCode: json['payment_method_code'] as String?,
      totalCost: json['total_cost'] as String?,
      paymentStatus: json['payment_status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CampaignModelToJson(CampaignModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'restaurant_id': instance.restaurantId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'status': instance.status,
      'priority': instance.priority,
      'payment_method_code': instance.paymentMethodCode,
      'total_cost': instance.totalCost,
      'payment_status': instance.paymentStatus,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CostBreakdown _$CostBreakdownFromJson(Map<String, dynamic> json) =>
    CostBreakdown(
      baseCost: json['base_cost'] as String?,
      durationDays: (json['duration_days'] as num?)?.toInt(),
      priorityMultiplier: json['priority_multiplier'] as String?,
      totalCost: json['total_cost'] as String?,
    );

Map<String, dynamic> _$CostBreakdownToJson(CostBreakdown instance) =>
    <String, dynamic>{
      'base_cost': instance.baseCost,
      'duration_days': instance.durationDays,
      'priority_multiplier': instance.priorityMultiplier,
      'total_cost': instance.totalCost,
    };

CampaignResponse _$CampaignResponseFromJson(Map<String, dynamic> json) =>
    CampaignResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CampaignResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CampaignResponseToJson(CampaignResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

CampaignResponseData _$CampaignResponseDataFromJson(
  Map<String, dynamic> json,
) => CampaignResponseData(
  campaign: json['campaign'] == null
      ? null
      : CampaignModel.fromJson(json['campaign'] as Map<String, dynamic>),
  costBreakdown: json['cost_breakdown'] == null
      ? null
      : CostBreakdown.fromJson(json['cost_breakdown'] as Map<String, dynamic>),
  paymentProcessed: json['payment_processed'] as bool?,
);

Map<String, dynamic> _$CampaignResponseDataToJson(
  CampaignResponseData instance,
) => <String, dynamic>{
  'campaign': instance.campaign,
  'cost_breakdown': instance.costBreakdown,
  'payment_processed': instance.paymentProcessed,
};

CampaignCostEstimate _$CampaignCostEstimateFromJson(
  Map<String, dynamic> json,
) => CampaignCostEstimate(
  durationDays: (json['duration_days'] as num?)?.toInt(),
  basePricePerDay: json['base_price_per_day'] as num?,
  baseCost: json['base_cost'] as num?,
  priority: json['priority'] as String?,
  priorityMultiplier: json['priority_multiplier'] as num?,
  priorityCost: json['priority_cost'] as num?,
  finalCost: json['final_cost'] as num?,
  breakdown: json['breakdown'] == null
      ? null
      : CampaignCostBreakdownDetail.fromJson(
          json['breakdown'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CampaignCostEstimateToJson(
  CampaignCostEstimate instance,
) => <String, dynamic>{
  'duration_days': instance.durationDays,
  'base_price_per_day': instance.basePricePerDay,
  'base_cost': instance.baseCost,
  'priority': instance.priority,
  'priority_multiplier': instance.priorityMultiplier,
  'priority_cost': instance.priorityCost,
  'final_cost': instance.finalCost,
  'breakdown': instance.breakdown,
};

CampaignCostBreakdownDetail _$CampaignCostBreakdownDetailFromJson(
  Map<String, dynamic> json,
) => CampaignCostBreakdownDetail(
  baseCost: json['Base Cost'] as String?,
  priorityMultiplier: json['Priority Multiplier'] as String?,
  totalCost: json['Total Cost'] as num?,
);

Map<String, dynamic> _$CampaignCostBreakdownDetailToJson(
  CampaignCostBreakdownDetail instance,
) => <String, dynamic>{
  'Base Cost': instance.baseCost,
  'Priority Multiplier': instance.priorityMultiplier,
  'Total Cost': instance.totalCost,
};
