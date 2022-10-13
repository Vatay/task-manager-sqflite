import 'package:calendar/cubit/calendar_cubit.dart';
import 'package:calendar/screens/calendar_screen.dart';
import 'package:calendar/screens/day_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarCubit>(
      create: (context) => CalendarCubit()..getData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Calendar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => CalendarScreen(),
          '/day': (context) => DayScreen(),
        },
      ),
    );
  }
}
