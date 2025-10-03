import 'package:sharpvendor/core/utils/app_assets.dart';

class OnboardingContent {
  String image;
  String title;
  String desc;

  OnboardingContent({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: "Manage Your Menu with Ease",
    desc: "Add, edit, and organize your dishes in seconds. Update prices, availability, and photos to keep your menu fresh and appealing to customers.",
    image: PngAssets.onboardingOne,
  ),
  OnboardingContent(
    title: "Track Orders in Real-Time",
    desc: "Receive instant notifications for new orders. Accept, prepare, and complete orders seamlessly while keeping your customers updated every step of the way.",
    image: PngAssets.onboardingTwo,
  ),
  OnboardingContent(
    title: "Grow Your Business with Insights",
    desc: "Monitor your sales, track popular dishes, and view earnings at a glance. Make data-driven decisions to boost your restaurant's performance.",
    image: PngAssets.onboardingThree,
  ),
];
