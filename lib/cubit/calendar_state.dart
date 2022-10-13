part of 'calendar_cubit.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<TableRow> calendarGred;
  CalendarLoaded(this.calendarGred);

  @override
  List<Object> get props => [calendarGred];
}

class CalendarError extends CalendarState {
  final String error;
  CalendarError(this.error);

  @override
  List<Object> get props => [error];
}
