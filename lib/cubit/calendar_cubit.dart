import 'package:bloc/bloc.dart';
import 'package:calendar/database/database.dart';
import 'package:calendar/models/event_model.dart';
import 'package:calendar/models/event_info.dart';
import 'package:calendar/services/build_calendar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial());

  var today = DateTime.now();
  var activeDate = DateTime.now();
  List<EventModel> allEvents = [];
  List<TableRow> calendarGred = [];

  final dbHelper = DBHelper.instance;

  void getData() async {
    emit(CalendarLoading());
    try {
      final List<Map<String, dynamic>> rows = await dbHelper.queryAllRows();
      if (rows.length == 0) {
        print('DB пуста');
        allEvents = [];
      } else {
        allEvents = [];
        for (var row in rows) {
          final List<EventInfo> oneDayEvents = _parseEvents(row['event']);
          allEvents.add(EventModel(
            id: row['id'],
            date: DateTime.parse(row['date']),
            events: oneDayEvents,
          ));
        }
      }

      calendarGred = BuildCalendar().buildCalendarGred(
        year: activeDate.year,
        month: activeDate.month,
        allEvents: allEvents,
      );
      emit(CalendarLoaded(calendarGred));
    } catch (e) {
      emit(CalendarError('Error: $e'));
    }
  }

  void addEvent(Map<String, dynamic> row) async {
    try {
      await dbHelper.insert(row);
    } catch (e) {
      emit(CalendarError('Error: $e'));
    }
  }

  void editEvent(int id, Map<String, dynamic> row) async {
    try {
      await dbHelper.update(id, row);
    } catch (e) {
      emit(CalendarError('Error: $e'));
    }
  }

  void deleteEvent(int id) async {
    try {
      await dbHelper.delete(id);
    } catch (e) {
      emit(CalendarError('Error: $e'));
    }
  }

  void changeDate(int year, int month) {
    calendarGred = BuildCalendar().buildCalendarGred(
      year: year,
      month: month,
      allEvents: allEvents,
    );
    emit(CalendarLoaded(calendarGred));
  }

  List<EventInfo> _parseEvents(String eventsData) {
    List<EventInfo> result = [];
    // списки з евентами і часом окремо
    List<List<String>> timeAndEventApart = [];
    // создаєм список з евентами і часом однією строкою
    List<String> timeAndEventTogether = eventsData.split('-|-');
    timeAndEventTogether.removeLast();
    timeAndEventTogether.forEach((element) {
      List<String> auxiliaryList = element.split('+|+');
      timeAndEventApart.add(auxiliaryList);
    });
    // создаєм список з евентами і часом однією окрумо і додаємо в мап
    timeAndEventApart.forEach((element) {
      List<String> auxiliaryList = element[0].split(':');
      TimeOfDay time = TimeOfDay(
        hour: int.parse(auxiliaryList[0]),
        minute: int.parse(auxiliaryList[1]),
      );
      // Перевірка чи є вже такий час
      result.add(
        EventInfo(time: time, info: element[1]),
      );
    });

    return result;
  }
}
