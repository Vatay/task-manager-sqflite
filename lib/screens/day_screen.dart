import 'dart:math';

import 'package:calendar/components/dismissible_tile.dart';
import 'package:calendar/cubit/calendar_cubit.dart';
import 'package:calendar/models/event_info.dart';
import 'package:calendar/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DateTime dayDate = DateTime.now();
  EventModel? dayEvents = null;
  TimeOfDay timeValue = TimeOfDay(hour: 9, minute: 0);
  bool settingData = true;
  var _formKey = GlobalKey<FormState>();
  var _taskNameController = TextEditingController();

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (settingData) {
      RouteSettings settings = ModalRoute.of(context)!.settings;
      dayEvents = (settings.arguments as Map)['events'];
      dayDate = (settings.arguments as Map)['date'];
      settingData = false;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if (state is CalendarError) {
              return _errorBody(context, state);
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  (dayEvents == null || dayEvents!.events.length == 0)
                      ? Text(
                          'Подій не заплановано',
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : _eventsList(),
                  SizedBox(height: 15),
                  Divider(),
                  SizedBox(height: 10),
                  Text(
                    'Додати подію',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _textFormField(),
                        SizedBox(height: 15),
                        _dropdownButton(),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () => _submitForm(context),
                            child: Text('Додати'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          context.read<CalendarCubit>().getData();
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text('Події ${dayDate.day}.${dayDate.month}.${dayDate.year}'),
    );
  }

  Column _errorBody(BuildContext context, CalendarError state) {
    return Column(
      children: [
        Text(
          'Виникла помилка:',
          textAlign: TextAlign.center,
        ),
        Text(
          state.error,
          textAlign: TextAlign.center,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<CalendarCubit>().getData();
            Navigator.pop(context);
          },
          child: Text('Спробувати знову'),
        ),
      ],
    );
  }

// '9:0+|+Event1-|-9:0+|+Event2-|-19:0+|+Event3-|-';
  _submitForm(BuildContext context) {
    String eventText = _eventText();
    eventText +=
        '${timeValue.hour}:${timeValue.minute}+|+${_taskNameController.text}-|-';
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> row = {
        'id': Random().nextInt(99999999),
        'event': eventText,
        'date': dayDate.toString(),
      };
      if (dayEvents == null || dayEvents!.events.isEmpty) {
        context.read<CalendarCubit>().addEvent(row);
        dayEvents = EventModel(
          id: row['id'],
          date: dayDate,
          events: [EventInfo(time: timeValue, info: _taskNameController.text)],
        );
      } else {
        dayEvents!.events
            .add(EventInfo(time: timeValue, info: _taskNameController.text));
        context.read<CalendarCubit>().editEvent(dayEvents!.id, row);
      }
      setState(() {});
      _taskNameController.clear();
      _showSnackBar();
      FocusScope.of(context).unfocus();
    } else {
      print('No validate');
    }
  }

  TextFormField _textFormField() {
    return TextFormField(
      controller: _taskNameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Опис події',
        prefixIcon: Icon(Icons.mood),
      ),
      validator: (value) {
        if (value == null || value == '') {
          return 'Не залишай поле пустим';
        }
        return null;
      },
    );
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          'Данні успішно додано до Бази данних',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Row _dropdownButton() {
    int hour = 0;
    int minute = -30;
    return Row(
      children: [
        Text('Час події:'),
        SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField(
            value: timeValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_alarms_sharp)),
            isExpanded: true,
            onChanged: (value) {
              if (value != null) {
                timeValue = value;
              }
            },
            items: List.generate(
              48,
              (index) {
                minute += 30;
                if (minute == 60) {
                  minute = 0;
                  hour += 1;
                }
                return DropdownMenuItem(
                  child: Text(
                      '$hour : $minute${minute.toString().length == 1 ? "0" : ""}'),
                  value: TimeOfDay(hour: hour, minute: minute),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _eventsList() {
    List<Widget> _column = [
      Text(
        'Список подій',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline5,
      ),
      SizedBox(height: 10),
    ];
    for (int i = 0; i < dayEvents!.events.length; i++) {
      String timeItem =
          '${dayEvents!.events[i].time.hour}:${dayEvents!.events[i].time.minute}${dayEvents!.events[i].time.minute.toString().length == 1 ? "0" : ""}';
      _column.add(
        DismissibleTile(
          time: timeItem,
          event: dayEvents!.events[i].info,
          onDismissed: (direction) {
            _onDismissed(i);
          },
        ),
      );
    }

    return Column(
      children: _column,
    );
  }

  void _onDismissed(int i) {
    if (dayEvents!.events.length > 1) {
      dayEvents!.events.removeAt(i);

      Map<String, dynamic> row = {
        'id': dayEvents!.id,
        'event': _eventText(),
        'date': dayDate.toString(),
      };
      context.read<CalendarCubit>().editEvent(dayEvents!.id, row);
    } else {
      context.read<CalendarCubit>().deleteEvent(dayEvents!.id);
      dayEvents = null;
    }
    setState(() {});
  }

  String _eventText() {
    String eventText = '';
    if (dayEvents != null && dayEvents!.events.isNotEmpty) {
      dayEvents!.events.forEach((element) {
        eventText +=
            '${element.time.hour}:${element.time.minute}+|+${element.info}-|-';
      });
    }

    return eventText;
  }
}
