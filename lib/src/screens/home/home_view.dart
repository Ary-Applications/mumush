import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mumush/src/di/injection.dart';
import 'package:mumush/src/screens/base/base.dart';
import 'package:mumush/src/screens/home/home_view_model.dart';
import 'package:url_launcher/link.dart';

class HomeView extends StatefulWidget {

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseStatefulView<HomeViewModel>(
        viewModel: getIt<HomeViewModel>(),
        onInit: (viewModel) {
         _viewModel = viewModel;
        },
        builder: (context, viewModel, child) {
          return Container(
            color: Color(0xFF1B0F27),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 130),
                    Container(
                       height: 250,
                        width:MediaQuery.of(context).size.width,
                        child: const FittedBox(
                            fit: BoxFit.cover ,
                            child: Image(image: AssetImage('assets/art/sky.png')),
                        )
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: 100),
                    Container(
                        height: 500,
                        width:MediaQuery.of(context).size.width,
                        child: const FittedBox(
                          fit: BoxFit.cover ,
                          child: Image(image: AssetImage('assets/art/graund.png')),
                        )
                    ),
                  ],
                ),
                FittedBox(
                  child: Container(
                      color: Colors.transparent,
                    child: Column(
                      children:
                      [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xFFEC6842),
                          child:Column(
                            children: [
                              SizedBox(height: 60),
                              const Text('NEED ASSISTANCE?',style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,color: Colors.white),),
                              const SizedBox(height: 10,),
                              TextButton(
                                onPressed: () => _viewModel.makePhoneCall("+40365425 074"),
                                child: const Text('CALL:(0365) 425 074',style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,color: Colors.white),),
                              ),

                            ],
                          ),

                          ),

                        SizedBox(height: 124),
                        Container(
                        height: 150,
                          width: 150,
                          color: Colors.transparent,
                          child: SvgPicture.asset('assets/art/mumush.svg')
                      ),
                      SizedBox(height: 80,),
                        Link(
                            uri:Uri.parse("https://www.google.com/maps/place/46°29'46.3%22N+24°47'29.2%22E/@46.4961944,24.7914444,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x1a29a39c83107b27!8m2!3d46.496199!4d24.791438"),
                            target: LinkTarget.blank,
                            builder:(context,followLink){
                              return TextButton(onPressed: followLink, child:Text('HOW TO GET TO THE FESTIVAL',style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,color: Colors.white),), );
                            }
                        ),
                     SizedBox(height: 100,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Link(
                              uri:Uri.parse('https://www.facebook.com/mumush.world/'),
                              target: LinkTarget.blank,
                              builder:(context,followLink){
                                return TextButton.icon(onPressed: followLink, icon: Icon(FontAwesomeIcons.facebook,color: Colors.white,size: 40,), label: const Text(''),);
                              }
                          ),
                          Link(
                              uri:Uri.parse('https://www.instagram.com/mumush_world/'),
                              target: LinkTarget.blank,
                              builder:(context,followLink){
                                return TextButton.icon(onPressed: followLink, icon: const Icon(FontAwesomeIcons.instagram,color: Colors.white,size: 40,), label: Text(''),);
                              }
                          ),
                          Link(
                              uri:Uri.parse('https://open.spotify.com/user/qnfogyg7kvywbyvl4kdtlmp35'),
                              target: LinkTarget.blank,
                              builder:(context,followLink){
                                return TextButton.icon(onPressed: followLink, icon: const Icon(FontAwesomeIcons.spotify,color: Colors.white,size: 40,), label: Text(''),);
                              }
                          ),
                          Link(
                              uri:Uri.parse('https://www.youtube.com/channel/UCipH85UPv3sr2GkpWZJIWTQ'),
                              target: LinkTarget.blank,
                              builder:(context,followLink){
                                return TextButton.icon(onPressed: followLink, icon: const Icon(FontAwesomeIcons.youtube,color: Colors.white,size: 40,), label: Text(''),);
                              }
                          ),
                          Link(
                              uri:Uri.parse('https://soundcloud.com/soundsofmumush'),
                              target: LinkTarget.blank,
                              builder:(context,followLink){
                                return TextButton.icon(onPressed: followLink, icon: const Icon(FontAwesomeIcons.soundcloud,color: Colors.white,size: 40,), label: Text(''),);
                              }
                          ),
                          Link(
                              uri:Uri.parse('https://www.mumush.world/'),
                              target: LinkTarget.blank,
                              builder:(context,followLink){
                                return TextButton.icon(onPressed: followLink, icon: const Icon(FontAwesomeIcons.globe,color: Colors.white,size: 40,), label: const Text(''),);
                              }
                          ),
                        ]
                      )

                      ]
                    ),
                  ),
                ),


              ],
            ),
          );
        });
  }
}

