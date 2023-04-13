import 'package:firebase_database/firebase_database.dart';
import '../constants.dart';
import 'package:intl/intl.dart';

class Record {
  final List<String> who;
  final String phone;
  final DateTime dateTime;
  final String action;

  bool hiddenAction = true;

  Record(
      {required this.dateTime,
      required this.who,
      this.phone = "",
      required this.action});

  static Record fromString(String record) {
    List<String> list = record.split(' ');
    String action = "";
    for (int i = 4; i < list.length; i++) {
      action += " " + list[i];
    }
    return Record(
        dateTime:
            DateFormat('yyyy-MM-dd hh-mm-ss').parse(list[0] + " " + list[1]),
        who: [toEng[list[2]]!],
        phone: list[3],
        action: action);
  }

  static Record instructorsFromString(String stroka) {
    List<String> list = stroka.split(' ');
    String action = "";
    for (int i = 5; i < list.length - 1; i++) {
      action += " " + list[i];
    }
    return Record(
        dateTime:
            DateFormat('yyyy-MM-dd hh-mm-ss').parse(list[0] + " " + list[1]),
        who: [list[2].substring(0, 5), list[3], list[4]],
        phone: list.last,
        action: action);
  }

  @override
  String toString() {
    if (who.length > 1) {
      return "Record($dateTime - ${who[2]} ${who[1][0]}. ($phone)\n$action\n)";
    }
    return "Record($dateTime - ${who[0]} $phone \n$action\n)";
  }

  String toStringForCompare() {
    if (phone.isEmpty) {
      return "${DateFormat('dd.MM.yy').format(dateTime)} ${who[0]} ${who[1]} ${who[2]} $action)";
    }
    return "${DateFormat('dd.MM.yy').format(dateTime)} ${who[0]} $phone $action)";
  }

  void changeHiddenAction() {
    hiddenAction = !hiddenAction;
  }

  bool isHiddenAction() {
    return hiddenAction;
  }

  void showAction() {
    hiddenAction = false;
  }

  void hideAction() {
    hiddenAction = true;
  }
}

class MyLog {
  late Map<String, List<String>> mapSnap;
  Map<String, String> instructorsPhones = {};

  Future<bool> getAllLogs() async {
    var snapshot = await FirebaseDatabase.instance.ref('/Log').get();
    if (snapshot.exists) {
      mapSnap = {};
      for (var child in snapshot.children) {
        if (child.children.isNotEmpty) {
          mapSnap[child.key.toString()] = [];
          for (var ch1 in child.children) {
            mapSnap[child.key.toString()]
                ?.add(ch1.key.toString() + " " + ch1.value.toString());
          }
        }
      }
    }
    return true;
  }

  int mapLength(String key) {
    return mapSnap[key]!.length;
  }

  List<Record> getChildLog(String key) {
    if (key == "Instructors") {
      return mapSnap[key]!
          .map((record) => Record.instructorsFromString(record))
          .toList();
    }
    return mapSnap[key]!.map((record) => Record.fromString(record)).toList();
  }

  Future<List<Record>> getChildLogs(String key) async {
    final snapshot = await FirebaseDatabase.instance.ref('/Log/$key').get();
    if (snapshot.exists) {
      return snapshot.children
          .map((record) => Record.fromString(
              record.key.toString() + " " + record.value.toString()))
          .toList()
          .reversed
          .toList();
    }
    return [];
  }

  /*Future<void> getInfoInstructors() async {
    var snapshot = await FirebaseDatabase.instance.ref('/Инструкторы').get();
    String phone = "";
    if (snapshot.exists) {
      for (var child in snapshot.children) {
        for (var info in child.children) {
          switch (info.key) {
            case "Телефон":
              phone = info.value.toString();
              break;
            case "ФИО":
            List<String> list = info.value.toString().split(" ");
              instructorsInfo["${list[0]} ${list[1]}"] = phone;
              break;
          }
        }
      }
    }
  }*/
  Future<void> getPhoneInstructors() async {
    var snapshot =
        await FirebaseDatabase.instance.ref('/Телефоны инструкторов').get();
    if (snapshot.exists) {
      for (var child in snapshot.children) {
        List<String> listFIO = child.key.toString().split(" ");
        instructorsPhones["${listFIO[0]} ${listFIO[1]}"] =
            child.value.toString();
      }
    }
  }

  Future<List<Record>> getChildLogsForInstructors() async {
    final snapshot =
        await FirebaseDatabase.instance.ref('/Log/Instructors').get();
    if (snapshot.exists) {
      List<Record> records = [];
      if (instructorsPhones.isEmpty) {
        await getPhoneInstructors();
      }
      for (var instr in snapshot.children) {
        List<String> list = instr.value.toString().split(" ");
        String phone = instructorsPhones.containsKey("${list[1]} ${list[2]}")
            ? instructorsPhones["${list[1]} ${list[2]}"]!
            : "";
        records.add(Record.instructorsFromString(
            instr.key.toString() + " " + instr.value.toString() + " " + phone));
      }
      return records.reversed.toList();
      /*return snapshot.children
          .map((record) => Record.instructorsFromString(
              record.key.toString() + " " + record.value.toString()))
          .toList()
          .reversed
          .toList();*/
    }
    return [];
  }
}
