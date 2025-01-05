import 'package:flutter/material.dart';
import 'package:eco_trans/app/core/extensions/date/compare_dates.dart';
import 'package:eco_trans/app/core/extensions/string/capitalize_first_letter.dart';
import 'package:eco_trans/app/core/theme/text.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/utils/date.dart';
import '../../core/values/colors.dart';
import '../../data/models/entities/data_event.dart';

class OrganismCalendar extends StatelessWidget {
  const OrganismCalendar({
    super.key,
    required this.events,
    required this.selectedDay,
    this.onSelectDate,
    this.onChangePage,
  })  : headerStyle = const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        calendarStyle = const CalendarStyle(
          selectedTextStyle: TextStyle(color: Colors.white),
          selectedDecoration: BoxDecoration(
            color: secondColor,
            shape: BoxShape.circle,
          ),
        );

  final List<DataEvent> events;
  final DateTime selectedDay;
  final void Function(DateTime newDate)? onSelectDate;
  final void Function(DateTime newDate)? onChangePage;
  final HeaderStyle headerStyle;
  final CalendarStyle calendarStyle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(DateTime.now().year - 1),
            lastDay: DateTime(DateTime.now().year + 1),
            headerStyle: headerStyle,
            calendarStyle: calendarStyle,
            eventLoader: (day) => events
                .where((element) => element.date.isEqualDate(day))
                .toList(),
            selectedDayPredicate: (DateTime date) =>
                isSameDay(selectedDay, date),
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: onDaySelected,
            onPageChanged: onChangePage,
              availableGestures: AvailableGestures.horizontalSwipe
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(),
          ),
          ...events
              .where((element) => element.date.isEqualDate(selectedDay))
              .map(
                (event) => Padding(
                  padding: const EdgeInsets.all(6),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(16),
                      ),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 10.0,
                            color: event.color ?? primaryColor,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CustomText.l(
                                event.title.capitalizeFirstLetter,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText.sm(
                              UtilsDate.formatDDMMYYYYHHmm(event.date),
                              color: greyDark,
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
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    onSelectDate?.call(selectedDay);
  }
}
