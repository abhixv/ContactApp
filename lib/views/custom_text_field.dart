import 'package:contactapp/views/service/call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';

class PhoneTextField extends StatefulWidget {
  PhoneTextField({Key? key}) : super(key: key);
  Function? update;

  @override
  _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  TextEditingController t1 = TextEditingController();
  CallLogs cl = CallLogs();
  bool empty = false;
  @override
  void initState() {
    super.initState();
    widget.update = (text) {
      setState(() {
        t1.text = text;
      });
    };

    t1.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    t1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: t1,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      decoration: const InputDecoration(
        hintText: "Search Contacts",
        hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(10),
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        cl.call(t1.text);
        t1.text = "";
      },
    );
  }
}
