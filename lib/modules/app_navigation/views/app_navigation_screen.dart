import 'package:sharpvendor/core/utils/exports.dart';

class AppNavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setSystemOverlayStyle(navigationColor: AppColors.whiteColor);

    // Check if there's an initial index passed as argument
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['initialIndex'] != null) {
      final appNavController = Get.find<AppNavigationController>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appNavController.changeScreenIndex(args['initialIndex']);
      });
    }

    return GetBuilder<AppNavigationController>(
      builder: (appNavigationController) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(appNavigationController.currentScreenIndex),
              child: appNavigationController
                  .screens[appNavigationController.currentScreenIndex],
            ),
          ),
          bottomNavigationBar: Builder(
            builder: (context) {
              final isTablet = MediaQuery.of(context).size.width > 600;
              if (isTablet) {
                return NavigationBar(
                  backgroundColor: AppColors.whiteColor,
                  elevation: 6,
                  surfaceTintColor: AppColors.whiteColor,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                    (states) => TextStyle(
                      fontSize: 16.sp,
                      fontWeight: states.contains(MaterialState.selected)
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                  destinations: [
                    NavigationDestination(
                      icon: SvgPicture.asset(
                        SvgAssets.homeIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.blackColor,
                      ),
                      selectedIcon: SvgPicture.asset(
                        SvgAssets.homeIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.primaryColor,
                      ),
                      label: "Home",
                    ),
                    NavigationDestination(
                      icon: SvgPicture.asset(
                        SvgAssets.menuIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.blackColor,
                      ),
                      selectedIcon: SvgPicture.asset(
                        SvgAssets.menuIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.primaryColor,
                      ),
                      label: "Menu",
                    ),
                    NavigationDestination(
                      icon: SvgPicture.asset(
                        SvgAssets.ordersIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.blackColor,
                      ),
                      selectedIcon: SvgPicture.asset(
                        SvgAssets.ordersIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.primaryColor,
                      ),
                      label: "Orders",
                    ),
                    NavigationDestination(
                      icon: SvgPicture.asset(
                        SvgAssets.userIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.blackColor,
                      ),
                      selectedIcon: SvgPicture.asset(
                        SvgAssets.userIcon,
                        height: 24.sp,
                        width: 24.sp,
                        color: AppColors.primaryColor,
                      ),
                      label: "Profile",
                    ),
                  ],
                  selectedIndex: appNavigationController.currentScreenIndex,
                  onDestinationSelected: (index) {
                    appNavigationController.changeScreenIndex(index);
                  },
                );
              } else {
                return BottomAppBar(
                  surfaceTintColor: AppColors.whiteColor,
                  padding: const EdgeInsets.all(0.0),
                  color: AppColors.whiteColor,
                  elevation: 6,
                  shape: const CircularNotchedRectangle(),
                  // notchMargin: 12.sp,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          20.r,
                        ),
                        topRight: Radius.circular(
                          20.r,
                        ),
                      ),
                    ),
                    height: 60.sp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: BottomNavItem(
                            index: 0,
                            title: "Home",
                            activeIcon: SvgAssets.homeIcon,
                            iconSize: 25,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: BottomNavItem(
                            index: 1,
                            title: "Menu",
                            activeIcon: SvgAssets.menuIcon,
                            iconSize: 25,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: BottomNavItem(
                            index: 2,
                            title: "Orders",
                            activeIcon: SvgAssets.ordersIcon,
                            iconSize: 25,
                            fontSize: 13,
                          ),
                        ),
                        Expanded(
                          child: BottomNavItem(
                            index: 3,
                            title: "Profile",
                            activeIcon: SvgAssets.userIcon,
                            iconSize: 25,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatefulWidget {
  final String title;
  final String activeIcon;
  final int index;
  final int iconSize;
  final double fontSize;
  const BottomNavItem(
      {super.key,
      required this.title,
      required this.activeIcon,
      this.iconSize = 25,
      this.fontSize = 13,
      required this.index});

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppNavigationController>(
        builder: (homeController) {
          final isSelected = widget.index == homeController.currentScreenIndex;

          return GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: () {
              HapticFeedback.selectionClick();
              homeController.changeScreenIndex(widget.index);
            },
            child: Container(
              color: Colors.transparent,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(isSelected ? 4.sp : 0),
                      child: SvgPicture.asset(
                        widget.activeIcon,
                        height: widget.iconSize.sp,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                        width: widget.iconSize.sp,
                      ),
                    ),
                    SizedBox(
                      height: 3.sp,
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                        fontSize: widget.fontSize.sp,
                      ),
                      child: Text(widget.title),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
