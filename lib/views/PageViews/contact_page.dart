import 'package:call_log/call_log.dart';
import 'package:contactapp/views/custom_text_field.dart';
import 'package:contactapp/views/service/call_log/call_log.dart';
import 'package:contactapp/views/service/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with WidgetsBindingObserver {
  PhoneTextField pt = new PhoneTextField();
  CallLogs cl = CallLogs();

  late AppLifecycleState _notification;
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
          //TextField(controller: t1, decoration: InputDecoration(labelText: "Phone number", contentPadding: EdgeInsets.all(10), suffixIcon: IconButton(icon: Icon(Icons.phone), onPressed: (){print("pressed");})),keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, onSubmitted: (value) => call(value),),
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
                        return GestureDetector(
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
    );
  }
}


// Card(
//                               child: ListTile(
//                                 leading: cl.getAvator(
//                                     entries!.elementAt(index).callType!),
//                                 title: cl.getTitle(entries.elementAt(index)),
//                                 subtitle: Text(cl.formatDate(
//                                         DateTime.fromMillisecondsSinceEpoch(
//                                             entries
//                                                 .elementAt(index)
//                                                 .timestamp!)) +
//                                     "\n" +
//                                     cl.getTime(
//                                         entries.elementAt(index).duration!)),
//                                 isThreeLine: true,
//                                 trailing: IconButton(
//                                     icon: const Icon(Icons.phone),
//                                     color: Colors.green,
//                                     onPressed: () {
//                                       cl.call(entries.elementAt(index).number!);
//                                     }),
//                               ),
//                             ),