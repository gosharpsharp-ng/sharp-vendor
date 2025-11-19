import 'package:sharpvendor/core/utils/exports.dart';

class CampaignService extends CoreService {
  Future<CampaignService> init() async => this;

  // Get all campaigns for the restaurant
  Future<APIResponse> getCampaigns() async {
    return await fetch("/restaurants/campaigns");
  }

  // Create a new campaign
  Future<APIResponse> createCampaign(dynamic data) async {
    return await send("/restaurants/campaigns", data);
  }

  // Get campaign by ID
  Future<APIResponse> getCampaignById(int campaignId) async {
    return await fetch("/restaurants/campaigns/$campaignId");
  }

  // Update campaign status (pause, resume, cancel)
  Future<APIResponse> updateCampaignStatus(int campaignId, String status) async {
    return await generalPatch("/restaurants/campaigns/$campaignId/status", {"status": status});
  }

  // Update campaign details
  Future<APIResponse> updateCampaign(int campaignId, dynamic data) async {
    return await update("/restaurants/campaigns/$campaignId", data);
  }

  // Delete campaign
  Future<APIResponse> deleteCampaign(int campaignId) async {
    return await remove("/restaurants/campaigns/$campaignId", {});
  }
}
