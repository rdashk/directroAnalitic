import 'package:directro_analitic/constants.dart';
import 'package:directro_analitic/style/colors.dart';
import 'package:flutter/material.dart';

Widget myBottonBar(BuildContext context) {
  return BottomAppBar(
    color: bottomAppBarColor,
    child: Padding(
      padding: const EdgeInsets.all(paddingAppBar),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                //_logs.initListLog("Adminstrator");
                Navigator.pushNamed(context, '/admins');
              },
              icon: const Icon(Icons.app_registration_rounded)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/classes');
              },
              icon: const Icon(Icons.fitness_center)),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Instructors")));
              },
              icon: const Icon(Icons.school_outlined)),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Login")));
              },
              icon: const Icon(Icons.add_task)),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registraion")));
              },
              icon: const Icon(Icons.add_reaction_outlined)),
          IconButton(
              onPressed: () async {
                //await _log.getAllLogs();
                //print(_log.getChildLog("Users"));
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Users")));
              },
              icon: const Icon(Icons.assignment_ind)),
        ],
      ),
    ),
  );
}
