import 'package:calendar/components/table_body_cell.dart';
import 'package:calendar/components/table_title_cell.dart';
import 'package:calendar/const.dart';
import 'package:calendar/models/event_model.dart';
import 'package:flutter/material.dart';

class BuildCalendar {
  BuildCalendar();

  final DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  List<TableRow> calendarGrid = [];

  TableRow calendarGridTitles = TableRow(
    children: List.generate(
      kDays.length,
      (index) => TableTitleCell(kDays[index]),
    ),
  );

  List<TableRow> buildCalendarGred({
    required int year,
    required int month,
    required List<EventModel> allEvents,
  }) {
    int daysCurrentMonth = DateTime(year, month + 1, 0).day;
    int daysPrevMonth = DateTime(year, month, 0).day;

    int startWeekday = DateTime(year, month).weekday;
    int lastWeekday = DateTime(year, month, daysCurrentMonth).weekday;
    int monthYear;
    bool thisDay = false;

    List<TableBodyCell> rowItems = [];

    List<EventModel> filterEvents = [];
    allEvents.forEach((element) {
      if (element.date.year == year &&
          (element.date.month == month ||
              element.date.month == month + 1 ||
              element.date.month == month - 1)) {
        filterEvents.add(element);
      }
    });

    calendarGrid
      ..clear()
      ..add(calendarGridTitles);

    // попередній місяць
    if (startWeekday > 1) {
      monthYear = month - 1;
      if (monthYear == 0) {
        monthYear = 12;
        year -= 1;
      }
      for (var i = startWeekday; i > 1; i--) {
        DateTime currentDay = DateTime(year, month - 1, daysPrevMonth - i + 2);
        thisDay = false;
        EventModel? events = null;
        filterEvents.forEach((element) {
          if (element.date == currentDay) {
            events = element;
          }
        });

        if (today == currentDay) {
          thisDay = true;
        }
        rowItems.add(TableBodyCell(
          day: daysPrevMonth - i + 2,
          currentMonth: false,
          date: DateTime(year, month - 1, daysPrevMonth - i + 2),
          events: events,
          thisDay: thisDay,
        ));
      }
    }
    // Вибраный місяць
    for (var i = 1; i < daysCurrentMonth + 1; i++) {
      EventModel? events = null;
      DateTime currentDay = DateTime(year, month, i);
      thisDay = false;
      filterEvents.forEach((element) {
        if (element.date == currentDay) {
          events = element;
        }
      });

      if (today == currentDay) {
        thisDay = true;
      }
      rowItems.add(TableBodyCell(
        day: i,
        date: DateTime(year, month, i),
        events: events,
        thisDay: thisDay,
      ));
      if (startWeekday == 7) {
        calendarGrid.add(
          TableRow(
            children: rowItems,
          ),
        );
        rowItems = [];
        startWeekday = 0;
      }
      startWeekday += 1;
    }
    // Наступний місяць
    if (lastWeekday < 7) {
      monthYear = month + 1;
      if (monthYear == 13) {
        monthYear = 1;
        year += 1;
      }
      for (var i = 1; i <= 7 - lastWeekday; i++) {
        EventModel? events = null;
        DateTime currentDay = DateTime(year, monthYear, i);
        thisDay = false;
        filterEvents.forEach((element) {
          if (element.date == currentDay) {
            events = element;
          }
        });
        if (today == currentDay) {
          thisDay = true;
        }
        rowItems.add(
          TableBodyCell(
            day: i,
            currentMonth: false,
            date: DateTime(year, monthYear, i),
            events: events,
            thisDay: thisDay,
          ),
        );
      }
      calendarGrid.add(
        TableRow(
          children: rowItems,
        ),
      );
    }

    return calendarGrid;
  }
}
