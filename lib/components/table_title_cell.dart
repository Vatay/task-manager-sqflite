import 'package:flutter/material.dart';

class TableTitleCell extends StatelessWidget {
  final String day;
  const TableTitleCell(this.day);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    );
  }
}
