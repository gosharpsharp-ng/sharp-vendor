import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sharpvendor/core/services/app_update/app_update_service.dart';
import 'package:sharpvendor/core/services/push_notification_service.dart';
import 'package:sharpvendor/core/utils/exports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Load appropriate env file based on build mode
    const buildMode = String.fromEnvironment('BUILD_MODE', defaultValue: 'dev');
    await dotenv.load(fileName: buildMode == 'prod' ? '.env.prod' : '.env.dev');
    await GetStorage.init();

    // Initialize push notifications
    await PushNotificationService().initialize();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    setupServiceLocator();

    runApp(GoSharpSharp(navigatorKey: navigatorKey));

    // Check for app updates after app is running
    Future.delayed(const Duration(seconds: 2), () {
      AppUpdateService().initialize();
    });
  } catch (e, stackTrace) {
    debugPrint('CRITICAL INITIALIZATION ERROR: $e');
    debugPrint(stackTrace.toString());
    // Fallback to ensure something is run even if init fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Initialization Error: $e'),
            ),
          ),
        ),
      ),
    );
  }
}

class GoSharpSharp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const GoSharpSharp({super.key, required this.navigatorKey});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GoSharpSharp',
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          // navigatorKey: navigatorKey,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(0.85), boldText: false),
              child: child!,
            );
          },
        );
      },
    );
  }
}
