
import 'package:filld_rider/pages/homepage.dart';
import 'package:filld_rider/pages/ratingTabPage.dart';
import 'package:flutter/material.dart';

import 'ProfileTab.dart';
import 'earningsTabPage.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: TabBarView(

        physics: NeverScrollableScrollPhysics(),

        controller: tabController,

        children: [
          homepage(),
          EarningsTabPage(),
          RatingTabPage(),
           ProfileTabPage(),
        ],

      ),
      bottomNavigationBar:
      Container(
        margin: EdgeInsets.all(20),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              onItemClicked(index);
              setState(
                    () {
                  selectedIndex = index;
                },
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == selectedIndex ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .128,
                  height: index == selectedIndex ? size.width * .014 : 0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Icon(
                  listOfIcons[index],
                  size: size.width * .076,
                  color: index == selectedIndex
                      ? Colors.black
                      : Colors.black38,
                ),
                // SizedBox(height: size.width * .03),
              ],
            ),
          ),
        ),
      ),

      // BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Home",
      //     ),
      //
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.credit_card),
      //       label: "Earnings",
      //     ),
      //
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.star),
      //       label: "Ratings",
      //     ),
      //
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: "Account",
      //     ),
      //
      //   ],
      //   unselectedItemColor: Colors.grey,
      //   selectedItemColor: Colors.black,
      //   type: BottomNavigationBarType.fixed,
      //   selectedLabelStyle: TextStyle(fontSize: 12.0),
      //   showUnselectedLabels: true,
      //   currentIndex: selectedIndex,
      //   onTap: onItemClicked,
      // ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.credit_card_outlined,
    Icons.star,
    Icons.person_rounded,
  ];
}
