import 'package:directro_analitic/model/list_log.dart';
import 'package:directro_analitic/widgets/one_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../model/BD.dart';
import '../style/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController editingController = TextEditingController();
  List<Record> duplicateRecords = []; // show to screen
  List<Record> pageRecords = [];
  bool isInitApp = true;

  ListLog log = ListLog();
  bool isCreateApp = true;
  late DateTime selectedDate;
  bool isChecked = false;

  @override
  void initState() {
    isChecked = false;
    selectedDate = DateTime.now();
    log.initListLog("Adminstrator");
    log.getInstructorsPhones();
    super.initState();
  }

  void searchRecords(String query) async {
    if (query.isNotEmpty) {
      List<Record> answerSearch = [];
      for (var r in pageRecords) {
        if (r.toStringForCompare().contains(query)) {
          answerSearch.add(r);
        }
      }
      setState(() {
        duplicateRecords.clear();
        duplicateRecords.addAll(answerSearch);
      });
    } else {
      setState(() {
        duplicateRecords.clear();
        duplicateRecords.addAll(pageRecords);
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      List<Record> answerSearch = [];
      for (var r in pageRecords) {
        if (DateFormat.yMd()
                .format(r.dateTime)
                .compareTo(DateFormat.yMd().format(picked)) ==
            0) {
          answerSearch.add(r);
        }
      }
      setState(() {
        duplicateRecords.clear();
        duplicateRecords.addAll(answerSearch);
      });
    } else {
      setState(() {
        duplicateRecords.clear();
        duplicateRecords.addAll(pageRecords);
      });
    }
  }

  void generateNewPage(String newTitle) async {
    isChecked = false;
    setState(() {
      selectedDate = DateTime.now();
      log.initListLog(newTitle);
      editingController.clear();
    });
    await setList();
  }

  Future<List<Record>> setList() async {
    duplicateRecords.clear();
    pageRecords.clear();
    pageRecords.addAll(await log.getRecords());
    duplicateRecords.addAll(pageRecords);
    return duplicateRecords;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text(
            log.getTitle(),
            style: TextStyle(fontSize: 28.0, color: Colors.black),
          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: -6,
                  children: [
                    Text(isChecked ? closeAction : openAction),
                    Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                            for (var record in duplicateRecords) {
                              isChecked
                                  ? record.showAction()
                                  : record.hideAction();
                            }
                          });
                        })
                  ],
                ),
                SizedBox(
                  width: screenWidth / 2,
                  height: screenHeight / 13,
                  child: TextField(
                    onChanged: (value) {
                      searchRecords(value);
                    },
                    controller: editingController,
                    decoration: const InputDecoration(
                        hintText: "Поиск",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await selectDate(context);
                    },
                    icon: Icon(Icons.date_range))
              ],
            ),
          ),
          Expanded(
              child: (duplicateRecords.isEmpty && log.isDataLoaded)
                  ? const Text(searchListIsEmpty)
                  : log.isDataLoaded
                      ? ListView.builder(
                          itemCount: duplicateRecords.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  duplicateRecords[index].changeHiddenAction();
                                });
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: oneRecord(duplicateRecords[index])),
                            );
                          })
                      : FutureBuilder(
                          future: setList(),
                          builder: (context,
                                  AsyncSnapshot<List<Record>> snapshot) =>
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          const CircularProgressIndicator(),
                                          Visibility(
                                            visible: snapshot.hasData,
                                            child: const Text(
                                              waiting,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                            ),
                                          )
                                        ])
                                  : snapshot.connectionState ==
                                          ConnectionState.done
                                      ? snapshot.hasError
                                          ? const Text("Ошибка")
                                          : snapshot.hasData
                                              ? ListView.builder(
                                                  itemCount:
                                                      duplicateRecords.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    log.isDataLoaded = true;
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          duplicateRecords[
                                                                  index]
                                                              .changeHiddenAction();
                                                        });
                                                      },
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: oneRecord(
                                                              duplicateRecords[
                                                                  index])),
                                                    );
                                                  })
                                              : const Text("Записей не найдено")
                                      : Text(
                                          "Сосотояние: ${snapshot.connectionState}")))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: bottomAppBarColor,
        child: Padding(
          padding: const EdgeInsets.all(paddingAppBar),
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () async {
                    generateNewPage("Adminstrator");
                  },
                  icon: Icon(icons['Adminstrator'])),
              IconButton(
                  onPressed: () async {
                    generateNewPage("Classes");
                  },
                  icon: Icon(icons['Classes'])),
              IconButton(
                  onPressed: () async {
                    generateNewPage("Instructors");
                  },
                  icon: Icon(icons['Instructors'])),
              IconButton(
                  onPressed: () async {
                    generateNewPage("Login");
                  },
                  icon: Icon(icons['Login'])),
              IconButton(
                  onPressed: () async {
                    generateNewPage("Registraion");
                  },
                  icon: Icon(icons['Registraion'])),
              IconButton(
                  onPressed: () async {
                    generateNewPage("Users");
                  },
                  icon: Icon(icons['Users'])),
            ],
          ),
        ),
      ),
    );
  }
}
