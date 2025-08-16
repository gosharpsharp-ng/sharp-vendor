import 'package:sharpvendor/core/utils/widgets/time_picker.dart';

import '../exports.dart';

class DayTimePicker extends StatefulWidget {
  const DayTimePicker({
    super.key,
    required this.disabled,
    required this.startTime,
    required this.endTime,
    required this.onStartTimeSelected,
    required this.onEndTimeSelected,
    required this.onDisableTap,

    required this.title,
  });

  final String title;
  final bool disabled;
  final TimeOfDay? startTime;
  final ValueChanged<TimeOfDay> onStartTimeSelected;
  final Function onDisableTap;
  final TimeOfDay? endTime;
  final ValueChanged<TimeOfDay> onEndTimeSelected;

  @override
  _DayTimePickerState createState() => _DayTimePickerState();
}

class _DayTimePickerState extends State<DayTimePicker> {
  late bool isPickerDisabled;

  @override
  void initState() {
    super.initState();
    isPickerDisabled = widget.disabled;
  }

  void togglePickerState(bool value) {
    setState(() {
      isPickerDisabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 7.h),
          child: Row(

            children: [
              Transform.scale(
                scale: 0.5,
                child: Switch(
                  value: !isPickerDisabled,
                  onChanged: (value) {
                    togglePickerState(!value);
                    widget.onDisableTap();
                  },
                  activeColor: AppColors.primaryColor,
                  inactiveThumbColor: AppColors.obscureTextColor,
                  inactiveTrackColor: Colors.grey.withOpacity(0.5),
                ),
              ),
              Expanded(
                child: Container(
                  // height: 20.h,
                  child: AbsorbPointer(
                    absorbing: isPickerDisabled,
                    child: ColorFiltered(
                      colorFilter: isPickerDisabled
                          ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                          : const ColorFilter.mode(
                          Colors.transparent, BlendMode.color),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: customText(
                              widget.title,
                              fontSize: 12.sp,
                              color: isPickerDisabled
                                  ? Colors.grey
                                  : AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: StartAndEndTimePicker(
                              startTime: widget.startTime,
                              endTime: widget.endTime,
                              onStartTimeSelected: widget.onStartTimeSelected,
                              onEndTimeSelected: widget.onEndTimeSelected,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}