import 'package:calendar/models/event_model.dart';
import 'package:flutter/material.dart';

class TableBodyCell extends StatelessWidget {
  final int day;
  final EventModel? events;
  final bool currentMonth;
  final bool thisDay;
  final DateTime date;
  const TableBodyCell({
    required this.day,
    required this.date,
    required this.events,
    this.currentMonth = true,
    this.thisDay = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/day',
            arguments: {'date': date, 'events': events});
      },
      child: SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: _selectColors(),
                fontSize: 16,
              ),
            ),
            if (events != null && events!.events.length != 0)
              Text(
                '${events!.events.length}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _selectColors() {
    if (thisDay) {
      return Colors.orange;
    } else if (!currentMonth) {
      return Colors.grey;
    }
    return Colors.black;
  }
}
