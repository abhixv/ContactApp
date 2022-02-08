import 'package:contactapp/views/PageViews/call_history.dart';
import 'package:contactapp/views/PageViews/contact_page.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        controller: pageController,
        children: const [
          ContactPage(),
          CallHistoryPage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Theme.of(context).backgroundColor,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(color: Theme.of(context).accentColor, fontSize: 11),
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
          destinations: [
            NavigationDestination(
              icon: Icon(
                FluentSystemIcons.ic_fluent_history_regular,
                color: Theme.of(context).accentColor,
              ),
              selectedIcon: Icon(
                FluentSystemIcons.ic_fluent_history_filled,
                color: Theme.of(context).accentColor,
              ),
              label: "Call History",
            ),
            NavigationDestination(
              icon: Icon(
                FluentSystemIcons.ic_fluent_contact_card_regular,
                color: Theme.of(context).accentColor,
              ),
              selectedIcon: Icon(
                FluentSystemIcons.ic_fluent_contact_card_filled,
                color: Theme.of(context).accentColor,
              ),
              label: "Contacts",
            ),
          ],
        ),
      ),
    );
  }
}
