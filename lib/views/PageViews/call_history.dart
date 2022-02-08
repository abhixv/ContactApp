import 'dart:typed_data';
import 'package:contactapp/views/custom_text_field.dart';
import 'package:contactapp/views/service/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({Key? key}) : super(key: key);

  @override
  _CallHistoryPageState createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  List<Contact>? contacts;

  @override
  void initState() {
    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.search,
            color: Theme.of(context).accentColor,
          ),
        ),
        title: PhoneTextField(),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: (contacts) == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts!.length,
              physics: const ScrollPhysics(
                  parent: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics())),
              itemBuilder: (BuildContext context, int index) {
                Uint8List? image = contacts![index].photo;
                String num = (contacts![index].phones.isNotEmpty)
                    ? (contacts![index].phones.first.number)
                    : "--";
                return InkWell(
                  onTap: () => getDetail(context, contacts![index].name.first,
                      contacts![index].name.last, num),
                  child: Dismissible(
                    key: UniqueKey(),
                    background: slideLeftBackground(),
                    secondaryBackground: slideRightBackground(),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        final bool res = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).backgroundColor,
                                content: const Text(
                                    "Are you sure you want to delete?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      contacts![index].delete();
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              );
                            });
                        return res;
                      } else {
                        await FlutterPhoneDirectCaller.callNumber(num);
                      }
                    },
                    onDismissed: (direction) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(
                            '${contacts![index].name.first} Deleted',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w300),
                          )));
                      setState(() {
                        contacts![index].delete();
                      });
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
                                (contacts![index].photo == null)
                                    ? CircleAvatar(
                                        backgroundColor:
                                            getRandomElement(randomColor),
                                        child: Icon(
                                          Icons.person,
                                          color: Theme.of(context).accentColor,
                                        ))
                                    : CircleAvatar(
                                        backgroundColor:
                                            getRandomElement(randomColor),
                                        backgroundImage: MemoryImage(image!),
                                      ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${contacts![index].name.first} ${contacts![index].name.last}",
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      num,
                                      style: TextStyle(
                                          color: Theme.of(context).canvasColor,
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
                            InkWell(
                              onTap: () async {
                                await FlutterPhoneDirectCaller.callNumber(num);
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
                );
              },
            ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              width: 20,
            ),
            Icon(
              Icons.call,
              color: Theme.of(context).accentColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Call now",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Theme.of(context).accentColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                " Delete",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  getDetail(BuildContext context, String firstName, String lastName,
      String phoneNumber) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Theme.of(context).backgroundColor,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
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
                    "$firstName $lastName",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w300,
                        fontSize: 25),
                  ),
                ),
                Divider(
                  color: Theme.of(context).canvasColor,
                ),
                const SizedBox(
                  height: 8,
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
                        fontSize: 14),
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
          );
        });
  }
}
