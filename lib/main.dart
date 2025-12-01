import 'package:sharpvendor/core/services/app_update/app_update_service.dart';
import 'package:sharpvendor/core/services/push_notification_service.dart';
import 'package:sharpvendor/core/utils/exports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await ScreenUtil.ensureScreenSize();

  // Initialize push notifications
  await PushNotificationService().initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  setupServiceLocator();

  runApp(GoSharpSharp(navigatorKey: navigatorKey));

  // Check for app updates after app is running
  Future.delayed(const Duration(seconds: 2), () {
    AppUpdateService().initialize();
  });
}

class GoSharpSharp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const GoSharpSharp({
    super.key,
    required this.navigatorKey,
  });
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoSharpSharp',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // navigatorKey: navigatorKey,
    );
  }
}
