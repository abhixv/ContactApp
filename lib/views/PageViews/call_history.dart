import 'package:contactapp/views/service/services.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({Key? key}) : super(key: key);

  @override
  _CallHistoryPageState createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.search),
        ),
        title: const TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Search Contacts",
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none),
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: contactName.length,
        physics: const ScrollPhysics(
            parent:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Dismissible(
              key: Key(contactName[index]),
              onDismissed: (direction) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  '${contactName[index]} Deleted',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                )));
                setState(() {
                  contactName.removeAt(index);
                  contactNumber.removeAt(index);
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            child: Text(
                              contactName[index].substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contactName[index],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                contactNumber[index],
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Icon(
                        FluentSystemIcons.ic_fluent_call_outbound_filled,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          FloatingActionButton(
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: const Icon(
              FluentSystemIcons.ic_fluent_dialpad_filled,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
