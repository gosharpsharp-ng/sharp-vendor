import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/utils/exports.dart';

class CampaignService extends CoreService {
  Future<CampaignService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  // Get all campaigns for the vendor
  Future<APIResponse> getCampaigns() async {
    return await fetch("/$_endpoint/campaigns");
  }

  // Create a new campaign
  Future<APIResponse> createCampaign(dynamic data) async {
    return await send("/$_endpoint/campaigns", data);
  }

  // Get campaign by ID
  Future<APIResponse> getCampaignById(int campaignId) async {
    return await fetch("/$_endpoint/campaigns/$campaignId");
  }

  // Update campaign status (pause, resume, cancel)
  Future<APIResponse> updateCampaignStatus(int campaignId, String status) async {
    return await generalPatch("/$_endpoint/campaigns/$campaignId/status", {"status": status});
  }

  // Update campaign details
  Future<APIResponse> updateCampaign(int campaignId, dynamic data) async {
    return await update("/$_endpoint/campaigns/$campaignId", data);
  }

  // Delete campaign
  Future<APIResponse> deleteCampaign(int campaignId) async {
    return await remove("/$_endpoint/campaigns/$campaignId", {});
  }

  // Estimate campaign cost
  Future<APIResponse> estimateCampaignCost({
    required String startDate,
    required String endDate,
    required int priority,
  }) async {
    return await fetchByParams("/$_endpoint/campaigns/estimate-cost", {
      "start_date": startDate,
      "end_date": endDate,
      "priority": priority,
    });
  }

  // Get daily campaign charges
  Future<APIResponse> getDailyCharges({
    required String startDate,
    required String endDate,
  }) async {
    return await fetchByParams("/$_endpoint/campaigns/daily-charges", {
      "start_date": startDate,
      "end_date": endDate,
    });
  }
}
