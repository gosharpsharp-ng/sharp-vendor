

import '../exports.dart';

class StartAndEndTimePicker extends StatelessWidget {
  const StartAndEndTimePicker({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartTimeSelected,
    required this.onEndTimeSelected,
  });

  final TimeOfDay? startTime;
  final ValueChanged<TimeOfDay> onStartTimeSelected;
  final TimeOfDay? endTime;
  final ValueChanged<TimeOfDay> onEndTimeSelected;

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                  "Open",
                  fontSize: 10.sp
              ),
              SizedBox(height: 4.h,),
              CustomTimePicker(
                  time: startTime ?? const TimeOfDay(hour: 8, minute: 00),
                  onTimeSelected: onStartTimeSelected),
            ],
          ),
        ),
        SizedBox(width: 24.w,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              customText(
                  "Close",
                  fontSize: 10.sp
              ),
              SizedBox(height: 4.h,),
              CustomTimePicker(
                  time: endTime ?? const TimeOfDay(hour: 20, minute: 00),
                  onTimeSelected: (value) {
                    if (toDouble(startTime!) > toDouble(value)) {
                      print("End time must be greater than start time");
                    } else {
                      onEndTimeSelected(value);
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({
    super.key,
    required this.onTimeSelected,
    required this.time,
  });
  final ValueChanged<TimeOfDay> onTimeSelected;
  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
        );
        if (selectedTime != null) {
          onTimeSelected(selectedTime);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        padding:  EdgeInsets.all(8.sp),
        child:  customText(
          time.format(context),
          fontSize: 10.sp,
        ),
      ),
    );
  }
}