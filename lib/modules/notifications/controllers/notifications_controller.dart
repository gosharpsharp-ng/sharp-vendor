import 'package:sharpvendor/core/utils/exports.dart';

class NotificationsController extends GetxController {
  List<NotificationModel> notifications = [];
  NotificationModel? selectedNotification;
  setSelectedNotification(NotificationModel nt) {
    selectedNotification = nt;
    update();
  }

  final profileService = serviceLocator<ProfileService>();

  getSingleNotification() async {
    dynamic data = {
      "id": selectedNotification!.id,
    };
    APIResponse response = await profileService.getNotificationById(data);
    if (response.status == "success") {
      selectedNotification = NotificationModel.fromJson(response.data);
      update();
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
    }
  }

  final ScrollController notificationsScrollController = ScrollController();
  bool fetchingNotifications = false;

  void _notificationsScrollListener() {
    if (notificationsScrollController.position.pixels >=
        notificationsScrollController.position.maxScrollExtent - 100) {
      getNotifications(isLoadMore: true);
    }
  }

  int notificationsPageSize = 15;
  int totalNotifications = 0;
  int currentNotificationsPage = 1;

  setTotalNotifications(int val) {
    totalNotifications = val;
    update();
  }

  final getStorage = GetStorage();
  getNotifications({bool isLoadMore = false}) async {
    if (fetchingNotifications ||
        (isLoadMore && notifications.length >= totalNotifications)) return;

    fetchingNotifications = true;
    update();

    if (!isLoadMore) {
      notifications.clear(); // Clear only when not loading more
      currentNotificationsPage = 1;
    }

    dynamic data = {
      "page": currentNotificationsPage,
      "per_page": notificationsPageSize,
    };

    APIResponse response = await profileService.getNotifications(data);
    fetchingNotifications = false;

    if (response.status == "success") {
      List<NotificationModel> newNotifications = (response.data['data'] as List)
          .map((nf) => NotificationModel.fromJson(nf))
          .toList();

      if (isLoadMore) {
        notifications.addAll(newNotifications);
      } else {
        notifications = newNotifications;
      }

      setTotalNotifications(response.data['total']);
      currentNotificationsPage++; // Increment for next load more
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    notificationsScrollController.addListener(_notificationsScrollListener);
  }

  @override
  void onReady() {
    super.onReady();
    getNotifications();
  }
}
