import 'package:calendar/components/action_bar_title.dart';
import 'package:calendar/cubit/calendar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  var activeDateYear = DateTime.now().year;
  var activeDateMonth = DateTime.now().month;
  List<TableRow> calendarGrid = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if (state is CalendarLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if (state is CalendarError) {
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
                    },
                    child: Text('Спробувати знову'),
                  ),
                ],
              );
            }
            if (state is CalendarLoaded) {
              calendarGrid = state.calendarGred;
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(
                    'Таск-менеджер',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Divider(),
                  ActionBarTitile(
                      title: 'Рік',
                      date: activeDateYear,
                      onTapPrev: () {
                        activeDateYear -= 1;
                        context
                            .read<CalendarCubit>()
                            .changeDate(activeDateYear, activeDateMonth);
                      },
                      onTapNext: () {
                        activeDateYear += 1;
                        context
                            .read<CalendarCubit>()
                            .changeDate(activeDateYear, activeDateMonth);
                      }),
                  ActionBarTitile(
                    title: 'Місяць',
                    date: activeDateMonth,
                    onTapPrev: _prevMonth,
                    onTapNext: _nextMonth,
                  ),
                  SizedBox(height: 15),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Table(
                      border: TableBorder.all(color: Colors.white),
                      children: calendarGrid,
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

  void _nextMonth() {
    if (activeDateMonth == 12) {
      activeDateMonth = 1;
      activeDateYear += 1;
    } else {
      activeDateMonth += 1;
    }
    context.read<CalendarCubit>().changeDate(activeDateYear, activeDateMonth);
  }

  void _prevMonth() {
    if (activeDateMonth == 1) {
      activeDateMonth = 12;
      activeDateYear -= 1;
    } else {
      activeDateMonth -= 1;
    }
    context.read<CalendarCubit>().changeDate(activeDateYear, activeDateMonth);
  }
}
