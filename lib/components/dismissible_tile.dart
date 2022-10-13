import 'package:flutter/material.dart';

class DismissibleTile extends StatelessWidget {
  final String time;
  final String event;
  final DismissDirectionCallback onDismissed;
  const DismissibleTile({
    required this.time,
    required this.event,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // direction: DismissDirection.endToStart,
      background: buildSwipeAction(Alignment.centerLeft),
      secondaryBackground: buildSwipeAction(Alignment.centerRight),
      key: UniqueKey(),
      onDismissed: onDismissed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(time),
            ),
            Expanded(
              child: Text(
                event,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwipeAction(AlignmentGeometry alignment) => Container(
        alignment: alignment,
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
        ),
      );
}
