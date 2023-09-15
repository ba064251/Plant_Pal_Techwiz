import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/PageView/editProfile.dart';
import 'package:testing/ProductScreen.dart';
import 'package:testing/UserMain/helpMenu.dart';
import 'package:testing/reusable_widget/reusable_textformfield.dart';
import '../DescriptionScreen.dart';
import '../reusable_widget/colors.dart';
import '../reusable_widget/text_widget.dart';

class main_screen extends StatefulWidget {

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final search_controller = TextEditingController();
  late String userId;

  _getUser() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    var id = user.getString('email');
    return id;
  }

  @override
  void initState() {
    _getUser().then((id) {
      //calling setState will refresh your build method.
      setState(() {
        userId = id;
      });
    });
    super.initState();
  }

  List images = [
    'images/slider1.jpg',
    'images/slider2.jpg',
    'images/slider3.jpg',
  ];
  List names = ["Abc", "Xyz", "Dfg"];
  List recom_images = [
    'images/pic1.png',
    'images/pic2.png',
    'images/pic3.png',
    'images/pic5.png'
  ];
  List mainImages=['images/plant1.png','images/plant2.png',
    'images/plant3.png','images/plant4.png','images/plant5.png',
    'images/plant6.png','images/plant7.png','images/plant8.png',
    'images/plant9.png'
  ];

  @override
  Widget build(BuildContext context) {
    print("Gmail:" + userId);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                currentAccountPictureSize: Size(80,80),
                decoration: BoxDecoration(
                  color: Color(0xff5c941b)
                ),
                accountName: Text('Basit'), accountEmail: Text('basit123@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/profilePic.jpg'),


              ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    menu(title: "Home",menuIcon: Iconsax.home2,),
                    const SizedBox(
                      height: 20,
                    ),

                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()));
                        },
                        child: menu(title: "Edit Profile",menuIcon: FontAwesomeIcons.penToSquare,)),
                    menu(title: "Feedback",menuIcon: Iconsax.message_add,),
                    const SizedBox(
                      height: 20,
                    ),
                    menu(title: "About",menuIcon: Iconsax.device_message,),
                    const SizedBox(
                      height: 20,
                    ),
                    menu(title: "Account Setting",menuIcon: Iconsax.settings,),

                  ],
                ),
              )

            ],
          ),
        ),
      ),
      appBar: AppBar(
       actions: [
         Container(
           margin: const EdgeInsets.only(
             right: 10,
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Container(

                 child: Column(
                   children: [
                     const SizedBox(
                       height: 8,
                     ),
                     Text(
                       '${userId}',
                       style: GoogleFonts.poppins(
                         fontSize: 14,
                         color: MyColors.button_color
                       ),
                     ),
                    
                   ],
                 ),
               ),
               const SizedBox(
                 width: 10,
               ),
               Container(
                 child: GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile(),));
                   },
                   child: const CircleAvatar(
                     radius: 20,
                     backgroundImage: AssetImage('images/profilePic.jpg'),

                   ),
                 ),
               )
             ],
           ),
         )
       ],
        backgroundColor: Colors.white,
        // title: Center(
        //   child: Container(
        //     width: 220,
        //     height: 220,
        //     decoration: const BoxDecoration(
        //         image: DecorationImage(image: AssetImage('images/appLogo.png'))),
        //   ),
        // ),

        centerTitle: true,
        leading: GestureDetector(
          onTap: () {

            // setState(() {
            //   drawerOpen=!drawerOpen;
            // });
            // if(drawerOpen==true)
            //   {
            //     ZoomDrawer.of(context)!.open();
            //
            //   }

            _scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                image:
                    DecorationImage(image: AssetImage('images/gridIcon.png'))),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 20),

                child: Row(

                  children: [
                    Expanded(


                        child: custom_field(
                            label: 'Search',
                            controller: search_controller,
                            prefixicon: const Icon(Iconsax.search_normal,size: 18,),
                            surfixneed: true)),

                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric( horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 10,
                    ),
                    // Carousel Section
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          CarouselSlider.builder(
                              itemCount: images.length,
                              itemBuilder: (context, index, realIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("${names[index]}")));
                                  },
                                  child: Container(
                                      margin:
                                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                      width: double.infinity,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.3),
                                              BlendMode.darken),
                                          image: AssetImage('${images[index]}'),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                );
                              },
                              options: CarouselOptions(
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  autoPlayCurve: Curves.easeInOut,
                                  scrollDirection: Axis.horizontal,
                                  autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000)))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(

                      "RECOMMENDATIONS",
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),

                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Recommendation section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 350,
                            width: double.infinity,
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection("Plants").snapshots(),
                                builder: (context, snapshot) {

                                  if(snapshot.hasData){
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: 4,
                                      itemBuilder: (BuildContext context, int index) {

                                        var name = snapshot.data!.docs[index]["Plant-Name"];
                                        var cat= snapshot.data!.docs[index]["Plant-Category"];
                                        var desc = snapshot.data!.docs[index]["Plant-Description"];
                                        var qty = snapshot.data!.docs[index]["Plant-Quantity"];
                                        var price = snapshot.data!.docs[index]["Plant-Price"];
                                        var growth = snapshot.data!.docs[index]["Plant-Growth"];
                                        String image = snapshot.data!.docs[index]["Plant-Image"];
                                        return GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen(
                                                plant_name: name,
                                                plant_category: cat,plant_description: desc,price: price,plant_growth: growth,plant_img: image
                                            ),));
                                          },
                                          child: Container(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      Card(
                                                        child: Container(
                                                          height: 300,
                                                          width: 200,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: 200,
                                                                decoration: BoxDecoration(
                                                                    color: MyColors.card_light_color1,
                                                                    borderRadius: const BorderRadius.only(
                                                                        bottomLeft:
                                                                        Radius.circular(70),
                                                                        bottomRight:
                                                                        Radius.circular(200))),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Container(
                                                                child: Container(
                                                                  margin: const EdgeInsets.symmetric(
                                                                      vertical: 3, horizontal: 10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Text(
                                                                              '${name}',
                                                                              style: GoogleFonts.poppins(
                                                                                  fontSize: 14,
                                                                                  color: MyColors
                                                                                      .heading_color),
                                                                            ),
                                                                            Text(
                                                                              '${cat}',
                                                                              style: GoogleFonts.poppins(
                                                                                  fontSize: 18,
                                                                                  fontWeight:
                                                                                  FontWeight.w600,
                                                                                  color: MyColors
                                                                                      .heading_color),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical: 5,
                                                                            horizontal: 10),
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                          color: MyColors
                                                                              .card_light_color2,
                                                                        ),
                                                                        child: Text(
                                                                          '\$${price}',
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight:
                                                                              FontWeight.w600),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      child: Image(
                                                        width: 200,
                                                        height: 200,
                                                        image: NetworkImage(image),
                                                      ),
                                                    )
                                                ),],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  if(snapshot.hasError){
                                    return const Icon(Icons.error);
                                  }

                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return const CircularProgressIndicator();
                                  }

                                  return Container();
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Top Products Section
                    Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Top Products',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductScreen(),));
                                    },
                                    child: Text(
                                      'View All',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: MyColors.button_color),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            ///Product Card
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              height: 350,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 350,
                                    width: double.infinity,
                                    child: StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection("Plants").snapshots(),
                                        builder: (context, snapshot) {

                                          if(snapshot.hasData){
                                            return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: 4,
                                              itemBuilder: (BuildContext context, int index) {
                                                var name = snapshot.data!.docs[index]["Plant-Name"];
                                                var cat= snapshot.data!.docs[index]["Plant-Category"];
                                                var desc = snapshot.data!.docs[index]["Plant-Description"];
                                                var qty = snapshot.data!.docs[index]["Plant-Quantity"];
                                                var price = snapshot.data!.docs[index]["Plant-Price"];
                                                var growth = snapshot.data!.docs[index]["Plant-Growth"];
                                                String image = snapshot.data!.docs[index]["Plant-Image"];
                                                return Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                                                  child: Card(
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen(price: price, plant_name: name, plant_img: image, plant_category: cat, plant_growth: growth, plant_description: desc),));
                                                      },
                                                      child: Container(
                                                        // padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                color: MyColors.card_light_color1,
                                                                image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: NetworkImage(image)),
                                                              ),
                                                              width: 200,
                                                              height: 200,
                                                            ),
                                                            Container(
                                                              padding:
                                                              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    name,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 16, fontWeight: FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    cat,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 16, fontWeight: FontWeight.w400),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Icon(Icons.circle, size: 8,color: Colors.green,),
                                                                      const SizedBox(width: 4,),
                                                                      Text(
                                                                        int.parse(qty)>1?"In Stock":"Out of Stock",
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize: 14,
                                                                          color: Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    '\$${price}',
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 16,
                                                                        color: MyColors.button_color,
                                                                        fontWeight: FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }

                                          if(snapshot.hasError){
                                            return const Icon(Icons.error);
                                          }

                                          if(snapshot.connectionState == ConnectionState.waiting){
                                            return const CircularProgressIndicator();
                                          }

                                          return Container();
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ]),
            ),
          ],
        ),
      )
    );
  }
}