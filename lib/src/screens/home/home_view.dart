import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mumush/src/di/injection.dart';
import 'package:mumush/src/screens/base/base.dart';
import 'package:mumush/src/screens/home/home_view_model.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../application/resources/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late HomeViewModel _viewModel;
  static const linkHeight = 24.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    _colorAnimation = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            color: primaryMarkerColor,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image.asset(
                        'assets/art/concept_2023_Landing_mobile_base.png',
                        fit: BoxFit.cover)),
                Center(
                    child: Image.asset(
                  'assets/art/mumush.png',
                  width: 150,
                  height: 150,
                )),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/art/home_right.png',
                    width: 346 / 1.2,
                    // Set the desired width for the small image
                    height:
                        736 / 1.2, // Set the desired height for the small image
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/art/home_left.png',
                    width: 346 / 1.2,
                    // Set the desired width for the small image
                    height:
                        736 / 1.2, // Set the desired height for the small image
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 12,
                  child: Link(
                    uri: Uri.parse(
                        "https://www.google.com/maps/place/46°29'46.3%22N+24°47'29.2%22E/@46.4961944,24.7914444,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x1a29a39c83107b27!8m2!3d46.496199!4d24.791438"),
                    target: LinkTarget.blank,
                    builder: (context, followLink) {
                      return TextButton(
                        onPressed: () {
                          // Show map options dialog
                          showMapOptions(context, followLink as void Function());
                        },
                        child: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, child) {
                            return Icon(
                              Icons.assistant_direction,
                              color: _colorAnimation.value,
                              size: 35,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                    top: 20,
                    right: 12,
                    child: TextButton(
                        onPressed: () {
                          showInfoPopUp();
                        },
                        child: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, child) {
                            return Icon(
                              Icons.info_rounded,
                              color: _colorAnimation.value,
                              size: 35,
                            );
                          },
                        ))),
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
            child: Text(
              "NEED ASSISTANCE?",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'SpaceMono',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          content: SizedBox(
            height: 200,
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
                        backgroundColor: primaryMarkerColor,
                      ),
                      child: const Text(
                        "Call Us",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'SpaceMono',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Link(
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
                      Link(
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
                      Link(
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
                              label: const Text(''),
                            );
                          }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Link(
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
                              label: const Text(''),
                            );
                          }),
                      Link(
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
                              label: const Text(''),
                            );
                          }),
                      Link(
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: const Color(0xFFEC6842),
        );
      },
    );
  }

  Future<void> showMapOptions(
      BuildContext context, void Function() followLink) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Map App'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                      46.4961944,
                      24.7914444,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Maps'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    MapsLauncher.launchQuery(
                        '46.4961944,24.7914444'); // Same coordinates as in the link
                    Navigator.of(context).pop();
                  },
                  child: const ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Google Maps'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launch(
                      'https://waze.com/ul?q=46.4961944,24.7914444',
                    );
                    Navigator.of(context).pop();
                  },
                  child: const ListTile(
                    leading: Icon(Icons.navigation),
                    title: Text('Waze'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
