import 'package:contactapp/views/PageViews/call_history.dart';
import 'package:contactapp/views/PageViews/contact_page.dart';
import 'package:contactapp/views/PageViews/speed_dial.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        controller: pageController,
        children: const [
          SpeedDialPage(),
          CallHistoryPage(),
          ContactPage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.black,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;

              pageController.jumpToPage(index);
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(
                FluentSystemIcons.ic_fluent_dialpad_regular,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                FluentSystemIcons.ic_fluent_dialpad_filled,
                color: Colors.white,
              ),
              label: "Speed Dial",
            ),
            NavigationDestination(
              icon: Icon(
                FluentSystemIcons.ic_fluent_history_regular,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                FluentSystemIcons.ic_fluent_history_filled,
                color: Colors.white,
              ),
              label: "Call History",
            ),
            NavigationDestination(
              icon: Icon(
                FluentSystemIcons.ic_fluent_contact_card_regular,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                FluentSystemIcons.ic_fluent_contact_card_filled,
                color: Colors.white,
              ),
              label: "Contacts",
            ),
          ],
        ),
      ),
    );
  }
}
