import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mumush/src/di/injection.dart';
import 'package:mumush/src/screens/base/base.dart';
import 'package:mumush/src/screens/home/home_view_model.dart';
import 'package:url_launcher/link.dart';
import 'dart:io' show Platform;

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;
  static const linkHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseStatefulView<HomeViewModel>(
        viewModel: getIt<HomeViewModel>(),
        onInit: (viewModel) {
          _viewModel = viewModel;
        },
        builder: (context, viewModel, child) {
          return Container(
            color: const Color(0xFF1B0F27),
            child: Stack(
              children: [
                Column(
                  children: [
                    // SizedBox(height: 130),
                    Container(
                        height: screenHeight * 0.5,
                        width: screenWidth,
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child: Image(image: AssetImage('assets/art/sky.png')),
                        )),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.20),
                    Container(
                        height: screenHeight * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child:
                              Image(image: AssetImage('assets/art/graund.png')),
                        )),
                  ],
                ),
                Column(
                  children: [
                    // SizedBox(height: screenHeight * 0.01),
                    Container(
                        height: screenHeight * 0.88,
                        width: MediaQuery.of(context).size.width / 2,
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child: Image(
                              image: AssetImage('assets/art/landing_left.png')),
                        )),
                  ],
                ),
                Column(
                  children: [
                    // SizedBox(height: screenHeight * 0.01),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Container(
                          height: screenHeight * 0.888,
                          width: MediaQuery.of(context).size.width / 2,
                          child: const FittedBox(
                            fit: BoxFit.cover,
                            child: Image(
                                image:
                                    AssetImage('assets/art/landing_right.png')),
                          )),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Platform.isIOS ? screenHeight * 0.612 : screenHeight * 0.64,
                      ),
                      Container(
                        child: Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.black, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp
                                ),
                              ),
                              height: screenHeight * 0.29,
                              width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Column(children: [
                    SizedBox(height: screenHeight * 0.34),
                    Container(
                        height: 155,
                        width: 155,
                        color: Colors.transparent,
                        child: SvgPicture.asset('assets/art/mumush.svg')),
                    SizedBox(
                      height: screenHeight * 0.11,
                    ),
                    Link(
                        uri: Uri.parse(
                            "https://www.google.com/maps/place/46°29'46.3%22N+24°47'29.2%22E/@46.4961944,24.7914444,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x1a29a39c83107b27!8m2!3d46.496199!4d24.791438"),
                        target: LinkTarget.blank,
                        builder: (context, followLink) {
                          return TextButton(
                              onPressed: followLink,
                              child: const Text(
                                'HOW TO GET TO THE FESTIVAL',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'SpaceMono',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(0.5, 0.5),
                                        blurRadius: 4.0,
                                        color: Colors.black,
                                      ),
                                    ]),
                              ));
                        }),
                    SizedBox(
                      height: screenHeight * 0.06,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Link(
                                    uri: Uri.parse(
                                        'https://www.facebook.com/mumush.world/'),
                                    target: LinkTarget.blank,
                                    builder: (context, followLink) {
                                      return TextButton.icon(
                                        onPressed: followLink,
                                        icon: const Icon(
                                          FontAwesomeIcons.facebook,
                                          color: Colors.white,
                                          size: linkHeight,
                                        ),
                                        label: const Text(''),
                                      );
                                    }),
                              ),
                              Expanded(
                                child: Link(
                                    uri: Uri.parse(
                                        'https://www.instagram.com/mumush_world/'),
                                    target: LinkTarget.blank,
                                    builder: (context, followLink) {
                                      return TextButton.icon(
                                        onPressed: followLink,
                                        icon: const Icon(
                                          FontAwesomeIcons.instagram,
                                          color: Colors.white,
                                          size: linkHeight,
                                        ),
                                        label: const Text(''),
                                      );
                                    }),
                              ),
                              Expanded(
                                child: Link(
                                    uri: Uri.parse(
                                        'https://open.spotify.com/user/qnfogyg7kvywbyvl4kdtlmp35'),
                                    target: LinkTarget.blank,
                                    builder: (context, followLink) {
                                      return TextButton.icon(
                                        onPressed: followLink,
                                        icon: const Icon(
                                          FontAwesomeIcons.spotify,
                                          color: Colors.white,
                                          size: linkHeight,
                                        ),
                                        label: Text(''),
                                      );
                                    }),
                              ),
                              Expanded(
                                child: Link(
                                    uri: Uri.parse(
                                        'https://www.youtube.com/channel/UCipH85UPv3sr2GkpWZJIWTQ'),
                                    target: LinkTarget.blank,
                                    builder: (context, followLink) {
                                      return TextButton.icon(
                                        onPressed: followLink,
                                        icon: const Icon(
                                          FontAwesomeIcons.youtube,
                                          color: Colors.white,
                                          size: linkHeight,
                                        ),
                                        label: Text(''),
                                      );
                                    }),
                              ),
                              Expanded(
                                child: Link(
                                    uri: Uri.parse(
                                        'https://soundcloud.com/soundsofmumush'),
                                    target: LinkTarget.blank,
                                    builder: (context, followLink) {
                                      return TextButton.icon(
                                        onPressed: followLink,
                                        icon: const Icon(
                                          FontAwesomeIcons.soundcloud,
                                          color: Colors.white,
                                          size: linkHeight,
                                        ),
                                        label: Text(''),
                                      );
                                    }),
                              ),
                              Expanded(
                                child: Link(
                                    uri: Uri.parse('https://www.mumush.world/'),
                                    target: LinkTarget.blank,
                                    builder: (context, followLink) {
                                      return TextButton.icon(
                                        onPressed: followLink,
                                        icon: const Icon(
                                          FontAwesomeIcons.globe,
                                          color: Colors.white,
                                          size: linkHeight,
                                        ),
                                        label: const Text(''),
                                      );
                                    }),
                              ),
                            ]),
                      ),
                    )
                  ]),
                ),
                Column(children: [
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    // height: 150,
                    width: MediaQuery.of(context).size.width,

                    // color: Colors.black.withOpacity(0.4),
                    child: Column(children: [
                      const SizedBox(height: 50),
                      TextButton(
                        onPressed: () {
                          showInfoPopUp();
                        },

                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ]),
                  )
                ]),
              ],
            ),
          );
        });
  }

  showInfoPopUp() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Center(
              child: Text("NEED ASSISTANCE?",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SpaceMono',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            content: Container(
              height: 100,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _viewModel.makePhoneCall("+40365425074");
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF1B0F27),
                          // fixedSize: Size(250, 50),
                        ),
                        child: const Text(
                          "Call Us",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'SpaceMono',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: const Color(0xFFEC6842),
          );
        });
  }
}
