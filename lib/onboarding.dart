import 'package:filld_rider/pages/Authpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';




class OnBoardingPage extends StatefulWidget {

  static const String idScreen = "Onboard";

  OnBoardingPage({Key? key}) : super(key: key);
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        AuthPage()), (Route<dynamic> route) => false);
    //Navigator.of(context).pop();
    // Navigator.of(context).pushNamed(homepage.idScreen);
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //         builder: (BuildContext context) =>homepage())
    //);
  }

  /*Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.jpg', width: 256.0),
      alignment: Alignment.bottomCenter,
    );
  }*/

  @override
  Widget build(BuildContext context) {

    const bodyStyle = TextStyle(fontSize: 15.0);
    const pageDecoration = const PageDecoration(
      pageColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      imageFlex: 3,
      bodyPadding: EdgeInsets.fromLTRB(10.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.only(top:10),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Choose your cylinder size",
          body:
          'Pick a maximum of two cylinders and decide \nhow much you want to buy.',

          image: Image(image: AssetImage('assets/images/onboarding-1-1.png'),),
          decoration: pageDecoration,
        ),

        PageViewModel(
          title: "Select LPG Station",
          body:
          "Select from our database your nearest \n"
          "LPG station.",
          image: Image(image: AssetImage('assets/images/nearest-lpg-station-1.png',),),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Secure in-app payments",
          body:
          "Pay via mobile money or credit card after\ndelivery guy arrives "
              "",
          image: Image(image: AssetImage('assets/images/pay-in-app-1-1.png'),),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Delivered to your doorstep.",
          body:
          "Conveniently delivered right to you."
              "",
          image: Image(image: AssetImage('assets/images/right-to-your-doorstep-2-1.png'),),
          decoration: pageDecoration,
        ),
      ],

     // child: Container(),
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      dotsFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator
        (
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}