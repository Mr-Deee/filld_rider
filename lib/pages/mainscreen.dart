import 'package:flutter/material.dart';
import 'package:filld_rider/pages/homepage.dart';
import 'package:filld_rider/pages/ratingTabPage.dart';
import 'ProfileTab.dart';
import 'earningsTabPage.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    homepage(),
    EarningsTabPage(),
    RatingTabPage(),
    ProfileTabPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            left: 20,
            right: 20,
            bottom: 29,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BottomNavigationBar(
                  backgroundColor: Colors.white.withOpacity(0.95),
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black38,
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  selectedFontSize: 11,
                  unselectedFontSize: 10,
                  selectedLabelStyle: TextStyle(height: 1.1),
                  unselectedLabelStyle: TextStyle(height: 1.1),
                  selectedIconTheme: IconThemeData(size: 22),
                  unselectedIconTheme: IconThemeData(size: 22),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.credit_card_outlined),
                      label: 'Earnings',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.star),
                      label: 'Rating',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_rounded),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
