import 'package:contactapp/views/service/services.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class SpeedDialPage extends StatefulWidget {
  const SpeedDialPage({Key? key}) : super(key: key);

  @override
  _SpeedDialPageState createState() => _SpeedDialPageState();
}

class _SpeedDialPageState extends State<SpeedDialPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
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
