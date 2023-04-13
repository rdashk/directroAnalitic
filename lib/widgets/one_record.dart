import 'package:directro_analitic/model/BD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget oneRecord(Record record) {
  var date = DateFormat('dd.MM.yy').format(record.dateTime);
  var who = (record.who.length == 1)
      ? "${record.who[0]}(${record.phone})"
      : //"${record.who[0]} ${record.who[2]} ${record.who[1].substring(0, 1)}. (${record.phone})";
      "${record.who[2]} ${record.who[1]}";

  var action = (record.who.length == 1)
      ? record.action
      : "${record.who[0]} ${record.who[2]} ${record.who[1].substring(0, 1)}. (${record.phone}) ${record.action}";

  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: record.isHiddenAction()
          ? timeWhoRow(date, who)
          : Column(
              children: [
                timeWhoRow(date, who),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    action,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              ],
            ));
}

Widget timeWhoRow(String date, String who) {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(
      date,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    ),
    const SizedBox(width: 22.0),
    Text(
      who,
      style: const TextStyle(fontSize: 18.0),
      textAlign: TextAlign.right,
    )
  ]);
}
