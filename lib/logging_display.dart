import 'package:flutter/material.dart';
import '/profile.dart';
import '/initial_questions_golf.dart';
import '/main.dart';
import 'package:app_v1/logging_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggingDisplayPage extends StatefulWidget {
  const LoggingDisplayPage({super.key});

  final String selected_sports;

  @override
  State<LoggingDisplayPage> createState() => _LoggingDisplayPageState();
}

class _LoggingDisplayPageState extends State<LoggingDisplayPage> {

  List logs = [];
  late SharedPreferences prefs;

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.containsKey(widget.selected_sports));
    String jsonlogs = prefs.getString(widget.selected_sports) ?? '[]';
    setState(() {
      logs = jsonDecode(jsonlogs);
    });
  }

  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
              child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                        children: [
                        Container(
                        width: 500,
                        height: 150,
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 150.0,
                                height: 200.0,
                                color: Colors.white,
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("LOG NUMBER"),
                                    ])),
                            Container(
                                width: 100.0,
                                height: 50.0,
                                color: Colors.greenAccent,
                                child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            print("add log");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const LoggingRecordPage()));
                                          },
                                          child: const Text("Add Log")),
                                    ])),
                          ],
                        )),
                    const Divider(
                      height: 20,
                      thickness: 2,
                      indent: 10,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                    Container(
                        width: 500.0,
                        height: 30.0,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                        Text('${widget.selected_sports} logs'
                            .toUpperCase()),
                    logs.isNotEmpty
                        ? ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text('${logs[index]["logDate"]}'),
                              subtitle: Text('${log[index]['logSport']}'),
                            ),
                          )
                        },
                        separatorBuilder: (BuildContext context, int index) = >
                        const Divider(),
                    itemCount: logs.length,
                  )
                  ])),
          ],
        ))))
    )
    ,
    );
  }
}
