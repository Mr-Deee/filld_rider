import 'package:flutter/material.dart';

class ordergas extends StatefulWidget {
  const ordergas({Key? key}) : super(key: key);

  @override
  State<ordergas> createState() => _ordergasState();
}

class _ordergasState extends State<ordergas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 58.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Container(
                  //
                  //   child: Text("<"),),
                  Container(
                    child: Text(
                      "OrderDetail",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  )
                ],
              ),
            ),
            SizedBox( height: 30,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(

                height:  MediaQuery.of(context).size.height * 0.7,
                width:  MediaQuery.of(context).size.height * 0.7,
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
                          child: Text("OrderType",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 84,
                            width:  294,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:Color(0x0ffF3EEEC),

                            ),
                          ),
                        ),
                      ],
                    )
                  ],


                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
