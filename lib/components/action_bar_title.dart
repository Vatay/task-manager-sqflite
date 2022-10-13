import 'package:calendar/const.dart';
import 'package:flutter/material.dart';

class ActionBarTitile extends StatelessWidget {
  final String title;
  final int date;
  final VoidCallback onTapPrev;
  final VoidCallback onTapNext;
  const ActionBarTitile({
    required this.title,
    required this.date,
    required this.onTapPrev,
    required this.onTapNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onTapPrev,
          icon: Icon(Icons.arrow_circle_left_outlined),
        ),
        Text(
          '$title:  ${title != 'Місяць' ? date : kMonthNames[date - 1]}',
          style: Theme.of(context).textTheme.headline6,
        ),
        IconButton(
          onPressed: onTapNext,
          icon: Icon(Icons.arrow_circle_right_outlined),
        ),
      ],
    );
  }
}
