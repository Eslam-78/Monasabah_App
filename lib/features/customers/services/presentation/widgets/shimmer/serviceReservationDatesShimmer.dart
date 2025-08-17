import 'package:calendar_builder/calendar_builder.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:shimmer/shimmer.dart';

class ServiceReservationDatesShimmer extends StatelessWidget {
  ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
      height: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenHeight / 1.7
          : screenUtil.screenWidth / 2.8,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(.8),
          highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
          enabled: true,
          child: CbMonthBuilder(
            cbConfig: CbConfig(
              startDate: DateTime.now(),
              endDate: DateTime(2110),
              selectedDate: DateTime.now(),
              selectedYear: DateTime(DateTime.now().year),
              weekStartsFrom: WeekStartsFrom.wednesday,
            ),

            ///start events dates

            ///end events dates

            monthCustomizer: MonthCustomizer(
                padding: const EdgeInsets.all(20),
                monthHeaderCustomizer: MonthHeaderCustomizer(
                  textStyle: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                scrollToSelectedMonth: true,
                monthButtonCustomizer: MonthButtonCustomizer(
                    currentDayColor: Colors.orange,
                    borderStrokeWidth: 2,
                    textStyleOnDisabled: const TextStyle(color: Colors.red),
                    highlightedColor: AppTheme.primaryColor),
                monthWeekCustomizer: MonthWeekCustomizer(
                    textStyle: const TextStyle(color: AppTheme.primaryColor))
                // monthWidth: 500,
                // monthHeight: 200
                ),
            yearDropDownCustomizer: YearDropDownCustomizer(
                yearButtonCustomizer: YearButtonCustomizer(
                  borderColorOnSelected: AppTheme.primarySwatch.shade500,
                ),
                yearHeaderCustomizer: YearHeaderCustomizer(
                    titleTextStyle:
                        const TextStyle(color: AppTheme.primaryColor))),
            onYearHeaderExpanded: (isExpanded) {
              print('isExpanded ' + isExpanded.toString());
            },
          )),
    );
  }
}
