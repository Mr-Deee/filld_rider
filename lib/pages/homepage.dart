import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String? currentSelectedValue;
  List<String> cylindertype = ["5kg", "9kg", "  12kg"];
  final _cylindertype = TextEditingController();
  final _emailController = TextEditingController();
  final location = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.height * 0.44,
                      // decoration: BoxDecoration(
                      //     color: Colors.white70,
                      //     borderRadius: BorderRadius.circular(30),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         offset: const Offset(0, 5),
                      //         blurRadius: 6,
                      //         color: const Color(0xff000000).withOpacity(0.16),
                      //       ),
                      //     ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Sign Out'),
                                        backgroundColor: Colors.white,
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                  'Are you certain you want to Sign Out?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'Yes',
                                              style:
                                                  TextStyle(color: Colors.black),
                                            ),
                                            onPressed: () {
                                              print('yes');
                                              FirebaseAuth.instance.signOut();
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  "/authpage",
                                                  (route) => false);
                                              // Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Row(
          //     children: [
          //       Column(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(21.0),
          //             child: Text(
          //               "Fill Your Gas\n Instantly",
          //               style: TextStyle(fontSize: 39),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // Text("Dashboard"),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    blurRadius: 6,
                    color: const Color(0xff000000).withOpacity(0.16),
                  ),
                ],
                color: Colors.white38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Text("Order Gas",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)

                  Image.asset(
                    "assets/images/kg-cylinder-4-1.png",
                    // Set the desired width
                    height: 90,
                  ),

                  Image.asset(
                    "assets/images/kg-cylinder-5-1.png",
                    // Set the desired width
                    height: 120,
                  ),

                  Image.asset(
                    "assets/images/kg-cylinder-1-1.png",
                    // Set the desired width
                    height: 150,
                  ),
                ],
              ),
            ),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Container(
                    //
                    //   child: Text("<"),),
                    // Container(
                    //   child: Text(
                    //     "OrderDetail",
                    //     style:
                    //     TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    //   ),
                    // )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "OrderDetails",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              // height: 54,
                              // width:  104,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(15),
                              //   color:Color(0x0ffF3EEEC),
                              //
                              // ),
                              child: DropdownButton<String>(
                                value: currentSelectedValue,
                                hint: new Text("Select CylinderType"),
                                items: cylindertype.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.gas_meter,
                                          color: Colors.green,
                                        ),
                                        new Text(value)
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newvalue) {
                                  setState(() {
                                    currentSelectedValue = newvalue;
                                    // newvalue == newProduct.farmcode;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter Amount',
                            hintText: 'Not Less Than GHS 20',
                            prefixIcon: Icon(Icons.money),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),

      // bottomNavigationBar: (),
    );
  }
}
