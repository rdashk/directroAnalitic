import 'package:directro_analitic/constants.dart';
import 'package:flutter/material.dart';

Widget descriptionText() {
  return Center(
    child: DataTable(columns: const [
      DataColumn(
        label: Expanded(
          child: Text(
            buttonColumn,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            descriptionColumn,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      )
    ], rows: [
      DataRow(
        cells: <DataCell>[
          DataCell(RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(icons['Adminstrator'], size: 14),
              )
            ]),
          )),
          DataCell(Text(buttonsDescription['Adminstrator']!)),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          DataCell(RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(icons['Classes'], size: 14),
              )
            ]),
          )),
          DataCell(Text(buttonsDescription['Classes']!)),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          DataCell(RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(icons['Instructors'], size: 14),
              )
            ]),
          )),
          DataCell(Text(buttonsDescription['Instructors']!)),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          DataCell(RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(icons['Login'], size: 14),
              )
            ]),
          )),
          DataCell(Text(buttonsDescription['Login']!)),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          DataCell(RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(icons['Registraion'], size: 14),
              )
            ]),
          )),
          DataCell(Text(buttonsDescription['Registraion']!)),
        ],
      ),
      DataRow(
        cells: <DataCell>[
          DataCell(RichText(
            text: TextSpan(children: [
              WidgetSpan(
                child: Icon(icons['Users'], size: 14),
              )
            ]),
          )),
          DataCell(Text(buttonsDescription['Users']!)),
        ],
      ),
    ]),
  );
}
