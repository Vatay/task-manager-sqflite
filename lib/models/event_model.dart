import 'package:calendar/models/event_info.dart';

class EventModel {
  final int id;
  final DateTime date;
  List<EventInfo> events;

  EventModel({
    required this.id,
    required this.date,
    required this.events,
  });

  // Map<TimeOfDay, String> get events => _parseEvents();

  // Map<TimeOfDay, String> _parseEvents() {
  //   countEvents = 0;
  //   Map<TimeOfDay, String> result = {};
  //   // списки з евентами і часом окремо
  //   List<List<String>> timeAndEventApart = [];
  //   // создаєм список з евентами і часом однією строкою
  //   List<String> timeAndEventTogether = eventsData.split('-|-');
  //   timeAndEventTogether.removeLast();
  //   timeAndEventTogether.forEach((element) {
  //     List<String> auxiliaryList = element.split('+|+');
  //     timeAndEventApart.add(auxiliaryList);
  //   });
  //   // создаєм список з евентами і часом однією окрумо і додаємо в мап
  //   timeAndEventApart.forEach((element) {
  //     List<String> auxiliaryList = element[0].split(':');
  //     TimeOfDay time = TimeOfDay(
  //       hour: int.parse(auxiliaryList[0]),
  //       minute: int.parse(auxiliaryList[1]),
  //     );
  //     // Перевірка чи є вже такий час
  //     if (result[time] == null) {
  //       result[time] = element[1];
  //     } else {
  //       result[time] = result[time]! + '\n' + element[1];
  //     }
  //     countEvents += 1;
  //   });

  //   return result;
  // }
}
