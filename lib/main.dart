import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  String titleApp = "Average Application";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: titleApp,
      theme:
      ThemeData(accentColor: Colors.tealAccent, primarySwatch: Colors.teal),
      home: HomePageApp(titleApp),
    );
  }
}

class HomePageApp extends StatefulWidget {
  final String? titleApp;

  HomePageApp(this.titleApp);

  @override
  _HomePageAppState createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePageApp> {
  List colorLists = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.pink,
    Colors.teal,
    Colors.orange,
    Colors.amber,
    Colors.purple,
    Colors.cyan,
  ];
  String subjectName = "";
  int? subjectPercent;
  int? subjectScore = 10;
  List<Subject>? allSubject;
  var formKey = GlobalKey<FormFieldState>();
  double average = 0;

  static int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allSubject = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.titleApp!,
            style: TextStyle(color: Colors.teal),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          }
        },
        child: Icon(Icons.check, color: Colors.black),
        backgroundColor: Colors.yellowAccent,
      ),
      body: applicationBodyPart(),
    );
  }

  Widget applicationBodyPart() {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // STATIC FORM BLOCK
          Expanded(
            child: Container(
              // color: Colors.yellowAccent,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide:
                                BorderSide(width: 3, color: Colors.green)),
                            border: OutlineInputBorder(),
                            labelText: "Subject",
                            hintText: "Enter Subject Name",
                            labelStyle: TextStyle(fontSize: 20.0)),
                        validator: (inputSubject) {
                          if (inputSubject!.length > 3) {
                            return null;
                          } else {
                            return "Subject Name Must Be Minimum 3 Symbols";
                          }
                        },
                        onSaved: (savedInput) {
                          setState(
                                () {
                              subjectName = savedInput!;
                              allSubject!.add(Subject(
                                  subjectName, subjectPercent, subjectScore));
                              // print(subjectName);
                              average = 0;
                              calculateTheAverage();
                            },
                          );
                        }),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              border:
                              Border.all(color: Colors.green, width: 3)),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              child: DropdownButton(
                                dropdownColor: Colors.lime[200],
                                hint: Text(
                                  "Score Percents",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                value: subjectPercent,
                                items: subjectPercentGenerate(),
                                onChanged: (int? selectedItem) {
                                  setState(() {
                                    subjectPercent = selectedItem;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              border:
                              Border.all(color: Colors.green, width: 3)),
                          child: DropdownButtonHideUnderline(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: DropdownButton(
                                dropdownColor: Colors.lime[200],
                                hint: Text(subjectScore.toString()),
                                value: subjectScore,
                                items: subjectScoreGenerate(),
                                onChanged: (int? selectedItem) {
                                  setState(() {
                                    subjectScore = selectedItem;
                                    print(subjectScore);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              // color: Colors.amberAccent,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Average: ${average.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 36.0,
                        color: showTheColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300]),
              // color: Colors.greenAccent,
              child: ListView.builder(
                itemBuilder: _itemBuilderForCards,
                itemCount: allSubject!.length,
              ),
            ),
            flex: 4,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> subjectPercentGenerate() {
    List<DropdownMenuItem<int>> percents = [];
    for (var i = 10; i < 101; i += 10) {
      percents.add(
        DropdownMenuItem(
          child: Text(
            "Percent: $i %",
            style: TextStyle(
              fontSize: 20.0,
              color: colorLists[Random().nextInt(colorLists.length)],
            ),
          ),
          value: i,
        ),
      );
    }
    return percents;
  }

  List<DropdownMenuItem<int>> subjectScoreGenerate() {
    List<DropdownMenuItem<int>> scores = [];
    for (var i = 10; i < 101; i += 10) {
      scores.add(
        DropdownMenuItem(
          child: Text(
            "Score: $i",
            style: TextStyle(
              fontSize: 20.0,
              color: colorLists[Random().nextInt(colorLists.length)],
            ),
          ),
          value: i,
        ),
      );
    }
    return scores;
  }

  Widget _itemBuilderForCards(context, index) {
    count += 1;
    print("COUNT: $count");
    return Dismissible(
      background: Container(
        color: colorLists[Random().nextInt(colorLists.length)],
      ),
      key: Key(
        count.toString(),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(
              () {
            print(direction);
            calculateTheAverage();
            var snackBar = SnackBar(
              content: Text(
                /*ochirilayotgan fanni nomini qando chiqarsa boladi Snackbarga*/ "${allSubject![index].name}"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            allSubject!.removeAt(index);
          },
        );
      },
      child: Card(
        color: colorLists[Random().nextInt(colorLists.length)],
        child: ListTile(
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  backgroundColor:
                  colorLists[Random().nextInt(colorLists.length)],
                  title: Text(
                    "Always continue learning",
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text("Here should be a picture"),
                      ],
                    ),
                  ),
                  actions: [
                    ButtonBar(
                      buttonPadding: EdgeInsets.all(54.0),
                      buttonHeight: 55.0,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.redAccent),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          title: Text(
            allSubject![index].name!,
            style: TextStyle(fontSize: 24.0),
          ),
          subtitle: Text(allSubject![index].percent.toString() + "%"),
          trailing: CircleAvatar(
            backgroundColor: colorLists[Random().nextInt(colorLists.length)],
            child: Text(
              allSubject![index].score.toString(),
              style: TextStyle(fontSize: 22.0),
            ),
          ),
        ),
      ),
    );
  }

  void calculateTheAverage() {
    average = 0;
    for (var element in allSubject!) {
      var percent = element.percent;
      var ball = element.score;
      average += (ball! * percent! / 100);
      print("AVERAGE" + average.toString());
    }
  }

  showTheColor() {
    if (average < 20) {
      return Colors.black;
    } else if (average >= 20 && average < 40) {
      return Colors.red;
    } else if (average >= 40 && average < 60) {
      return Colors.yellow;
    } else if (average >= 60 && average < 80) {
      return Colors.blue;
    } else if (average >= 80 && average <= 100) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }
}

class Subject {
  String? name;
  int? percent;
  int? score;

  Subject(this.name, this.percent, this.score);
}
