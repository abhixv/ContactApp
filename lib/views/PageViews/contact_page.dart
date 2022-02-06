import 'package:call_log/call_log.dart';
import 'package:contactapp/views/PageViews/call_history.dart';
import 'package:contactapp/views/custom_text_field.dart';
import 'package:contactapp/views/service/call_log/call_log.dart';
import 'package:contactapp/views/service/services.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: logs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Iterable<CallLogEntry>? entries =
                      snapshot.data as Iterable<CallLogEntry>?;
                  return Expanded(
                    child: ListView.builder(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor:
                                              getRandomElement(randomColor),
                                          child: const Icon(Icons.person)),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${cl.getTitle(entries!.elementAt(index))}",
                                            style: const TextStyle(
                                                color: Colors.white,
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
                                              style: const TextStyle(
                                                color: Colors.white,
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
                                    child: const Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onLongPress: () => pt.update!(
                              entries.elementAt(index).number.toString()),
                        );
                      },
                      itemCount: entries!.length,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.withOpacity(0.3),
        child: const Icon(
          FluentSystemIcons.ic_fluent_dialpad_filled,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () => getDialPad(context),
      ),
    );
  }

  getDialPad(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.black,
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "",
                        hintStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300)),
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FluentSystemIcons.ic_fluent_backspace_regular,
                      color: Colors.white,
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
                  child: const Center(
                      child: Icon(
                    Icons.call,
                    color: Colors.white,
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

  Row firstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.zero,
            height: MediaQuery.of(context).size.height / 11.5,
            width: MediaQuery.of(context).size.width / 5.45,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("1"),
              child: const Center(
                child: Text(
                  "1",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("2"),
              child: const Center(
                child: Text(
                  "2",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("3"),
              child: const Center(
                child: Text(
                  "3",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("4"),
              child: const Center(
                child: Text(
                  "4",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("5"),
              child: const Center(
                child: Text(
                  "5",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("6"),
              child: const Center(
                child: Text(
                  "6",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("7"),
              child: const Center(
                child: Text(
                  "7",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("8"),
              child: const Center(
                child: Text(
                  "8",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("9"),
              child: const Center(
                child: Text(
                  "9",
                  style: TextStyle(
                      color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.0)),
            child: InkWell(
              onTap: () => numberClick("0"),
              child: const Center(
                child: Text(
                  "0",
                  style: TextStyle(
                      color: Colors.white,
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
        backgroundColor: Colors.black,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
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
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    title: Text(
                      firstName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 25),
                    ),
                    subtitle: Text(
                      date,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: const Text(
                      "Duration",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                    subtitle: Text(
                      duration,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  ListTile(
                    title: const Text(
                      "Phone Number",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18),
                    ),
                    subtitle: Text(
                      phoneNumber,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                    trailing: InkWell(
                      onTap: () async {
                        await FlutterPhoneDirectCaller.callNumber(phoneNumber);
                      },
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
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
