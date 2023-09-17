import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/AddtoCart.dart';
import 'package:testing/PageView/editProfile.dart';
import 'package:testing/ProductScreen.dart';
import 'package:testing/reusable_widget/reusable_textformfield.dart';
import '../DescriptionScreen.dart';
import '../Wishlist.dart';
import '../reusable_widget/colors.dart';
import '../reusable_widget/text_widget.dart';

class main_screen extends StatefulWidget {

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  String userId = ' ';

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Users").where("User-Email",isEqualTo: userId).snapshots(),
              builder: (context,snapshot) {
                var dataLength = snapshot.data!.docs.length;
                if (snapshot.hasData || snapshot.data != null) {
                  return ListView.builder(
                    itemCount: dataLength,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String userName = snapshot.data!.docs[index]['User-Name'];
                      String userEmail = snapshot.data!.docs[index]['User-Email'];
                      String userImage = snapshot.data!.docs[index]['User-Image'];
                    return SizedBox(
                      child: Column(
                        children: [
                          UserAccountsDrawerHeader(
                            currentAccountPictureSize: const Size(80,80),
                            decoration: const BoxDecoration(
                                color: Color(0xff5c941b)
                            ),
                            accountName: Text(userName), accountEmail: Text(userEmail),
                            currentAccountPicture: CircleAvatar(
                              backgroundImage: NetworkImage(userImage),


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
                                  height: 10,
                                ),

                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()));
                                    },
                                    child: menu(title: "Edit Profile",menuIcon: Iconsax.edit,)),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WishListScreen(),));
                                    },
                                    child: menu(title: "Wishlist",menuIcon: Iconsax.heart,)),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen(),));
                                    },
                                    child: menu(title: "Your Cart",menuIcon: Iconsax.shopping_cart,)),
                                const SizedBox(
                                  height: 10,
                                ),


                              ],
                            ),
                          )

                        ],
                      ),
                    );
                  },);
                } if (snapshot.hasError) {
                  return const Icon(Icons.error_outline);
                } if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                return Container();
              }),
        ),
        appBar: AppBar(
          title: text_custome(text: "PlantPal", size: 18, fontWeight: FontWeight.w600,color: MyColors.heading_color,),
          backgroundColor: Colors.white,

          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Iconsax.category),color: Colors.black,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
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
                            controller: searchController,
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
                                        //var qty = snapshot.data!.docs[index]["Plant-Quantity"];
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
                                          child: SizedBox(
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  child: Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 40,
                                                      ),
                                                      Card(
                                                        child: SizedBox(
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
                                                              SizedBox(
                                                                child: Container(
                                                                  margin: const EdgeInsets.symmetric(
                                                                      vertical: 3, horizontal: 10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 110,
                                                                              child: Text(
                                                                                name,
                                                                                style: GoogleFonts.poppins(
                                                                                    fontSize: 14,
                                                                                    color: MyColors
                                                                                        .heading_color),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              cat,
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
                                                                          '\$$price',
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
                                                    child: SizedBox(
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
                    SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
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
                                                      child: SizedBox(
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
                                                                    '\$$price',
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