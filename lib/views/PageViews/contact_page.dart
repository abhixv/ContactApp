import 'package:call_log/call_log.dart';
import 'package:contactapp/views/PageViews/call_history.dart';
import 'package:contactapp/views/custom_text_field.dart';
import 'package:contactapp/views/service/call_log/call_log.dart';
import 'package:contactapp/views/service/services.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with WidgetsBindingObserver {
  TextEditingController numberController = TextEditingController();
  String number = "";
  PhoneTextField pt = PhoneTextField();
  CallLogs cl = CallLogs();
  CallHistoryPage callHistoryPage = const CallHistoryPage();
  late Future<Iterable<CallLogEntry>> logs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    logs = cl.getCallLogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    numberController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state) {
      setState(() {
        logs = cl.getCallLogs();
      });
    }
  }

  void numberClick(String text) {
    number += text;
    setState(() {
      numberController.text = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "History",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).accentColor),
        ),
      ),
      body: FutureBuilder(
          future: logs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Iterable<CallLogEntry>? entries =
                  snapshot.data as Iterable<CallLogEntry>?;
              return ListView.builder(
                physics: const ScrollPhysics(
                    parent: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics())),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => getDetail(
                        context,
                        cl.getTitle(entries!.elementAt(index)),
                        cl.formatDate(DateTime.fromMillisecondsSinceEpoch(
                            entries.elementAt(index).timestamp!)),
                        cl.getTime(entries.elementAt(index).duration!),
                        entries.elementAt(index).number!),
                    child: Dismissible(
                      key: UniqueKey(),
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await FlutterPhoneDirectCaller.callNumber(
                              entries!.elementAt(index).number!);
                        } else {
                          final uri =
                              'sms:${entries!.elementAt(index).number!}?body=Hii';
                          if (await canLaunch(uri)) {
                            await launch(uri);
                          } else {
                            throw 'Could not launch $uri';
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor:
                                          getRandomElement(randomColor),
                                      child: Icon(
                                        Icons.person,
                                        color: Theme.of(context).accentColor,
                                      )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${cl.getTitle(entries!.elementAt(index))}",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                          cl.formatDate(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      entries
                                                          .elementAt(index)
                                                          .timestamp!)) +
                                              "\n" +
                                              cl.getTime(entries
                                                  .elementAt(index)
                                                  .duration!),
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      entries.elementAt(index).number!);
                                },
                                child: Icon(
                                  Icons.call,
                                  color: Theme.of(context).accentColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    onLongPress: () =>
                        pt.update!(entries.elementAt(index).number.toString()),
                  );
                },
                itemCount: entries!.length,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).canvasColor,
        child: Icon(
          FluentSystemIcons.ic_fluent_dialpad_filled,
          size: 30,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () => getDialPad(context),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.purpleAccent,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),
            Icon(
              Icons.message,
              color: Theme.of(context).accentColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Message",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  getDialPad(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).backgroundColor,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    readOnly: true,
                    controller: numberController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "",
                        hintStyle: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (number.isNotEmpty) {
                      setState(() {
                        number = number.substring(0, number.length - 1);
                        numberController.text = number;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FluentSystemIcons.ic_fluent_backspace_regular,
                      color: Theme.of(context).accentColor,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            keyCard(),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.zero,
                height: MediaQuery.of(context).size.height / 11.5,
                width: MediaQuery.of(context).size.width / 5.45,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50.0)),
                child: InkWell(
                  onTap: () async {
                    await FlutterPhoneDirectCaller.callNumber(number);
                  },
                  child: Center(
                      child: Icon(
                    Icons.call,
                    color: Theme.of(context).accentColor,
                  )),
                  borderRadius: BorderRadius.circular(50.0),
                )),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.call,
              color: Theme.of(context).accentColor,
            ),
            Text(
              " Call Now",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Row firstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("1"),
              child: Center(
                child: Text(
                  "1",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.09,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("2"),
              child: Center(
                child: Text(
                  "2",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.09,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("3"),
              child: Center(
                child: Text(
                  "3",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        const SizedBox(
          width: 15.0,
        ),
      ],
    );
  }

  Row secondRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("4"),
              child: Center(
                child: Text(
                  "4",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.09,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("5"),
              child: Center(
                child: Text(
                  "5",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.09,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("6"),
              child: Center(
                child: Text(
                  "6",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        const SizedBox(
          width: 15.0,
        ),
      ],
    );
  }

  Row thirdRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("7"),
              child: Center(
                child: Text(
                  "7",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.09,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("8"),
              child: Center(
                child: Text(
                  "8",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.09,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("9"),
              child: Center(
                child: Text(
                  "9",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        const SizedBox(
          width: 15.0,
        ),
      ],
    );
  }

  Row fourthRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("0"),
              child: Center(
                child: Text(
                  "0",
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 30.0),
                ),
              ),
              borderRadius: BorderRadius.circular(50.0),
            )),
        const SizedBox(
          width: 15.0,
        ),
      ],
    );
  }

  Column keyCard() {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        firstRow(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        secondRow(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        thirdRow(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        fourthRow(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
      ],
    );
  }

  getDetail(BuildContext context, String firstName, String date,
      String duration, String phoneNumber) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Theme.of(context).backgroundColor,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: getRandomElement(randomColor),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).accentColor,
                      size: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      firstName,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 25),
                    ),
                    subtitle: Text(
                      date,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).canvasColor,
                  ),
                  ListTile(
                    title: Text(
                      "Duration",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                    subtitle: Text(
                      duration,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).canvasColor,
                  ),
                  ListTile(
                    title: Text(
                      "Phone Number",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                    subtitle: Text(
                      phoneNumber,
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                    trailing: InkWell(
                      onTap: () async {
                        await FlutterPhoneDirectCaller.callNumber(phoneNumber);
                      },
                      child: Icon(
                        Icons.call,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
