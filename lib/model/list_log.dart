import 'dart:async';

import 'package:directro_analitic/model/BD.dart';

import '../constants.dart';

class ListLog{
  late String logName;
  final MyLog myLog = MyLog();
  late bool isDataLoaded;


void initListLog(String nameLog) {
  logName = nameLog;
  isDataLoaded = false;
}

  String getTitle() {
    return titles.containsKey(logName)? titles[logName]!: logName;
  }

  Future<List<Record>> getRecords() async{
    return logName == "Instructors"? await myLog.getChildLogsForInstructors():await myLog.getChildLogs(logName);
  }

  void setTitle(String newLogName) {
    logName = newLogName;
  }

  /*Future<void> getInstructorsInfo() async{
    await myLog.getInfoInstructors();
  }*/

  Future<void> getInstructorsPhones() async{
    await myLog.getPhoneInstructors();
  }
}