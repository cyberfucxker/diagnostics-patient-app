import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/Screens/View/CartScreen/coupon_screen.dart';
import 'package:diagnostics_patient/Screens/View/CartScreen/wallet_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/coupon_controller.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/AllText.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/page_widget.dart';
import '../AddressListScreen/address_list_screen.dart';
import '../BookScreens/book_list_screen.dart';
import '../FamilyMemberListScreen/family_member_list_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // String? name;
  // String? email;
  // String? profile;
  bool isLoading = true;
  UserDetailsClass userDetails = UserDetailsClass();

  ///----- options list ----
  List<Options> options = [
    Options(name: Edit_Profile, widget: Container(), imagePath: "assets/profile/edit.png", type: 0),
    Options(name: Book_List, widget: Container(), imagePath: "assets/profile/booklist.png", type: 1, padding: 3),
    Options(name: Family_Member_List, widget: Container(), imagePath: "assets/profile/memberlist.png", type: 2, padding: 3),
    Options(name: Address_List, widget: Container(), imagePath: "assets/profile/addresslist.png", type: 3, padding: 3),
    Options(name: 'Coupon List', widget: Container(), imagePath: "assets/profile/booklist.png", type: 5, padding: 3),
    Options(name: 'Wallet', widget: Container(), imagePath: "assets/profile/booklist.png", type: 6, padding: 3),
    Options(name: LogOut, imagePath: "assets/profile/logout.png", type: 4),
  ];
  // TestDetailController userDetailController = Get.find<TestDetailController>();

  // data()  {
  //   setState(() async {
  //     final prefs = await SharedPreferences.getInstance();
  //
  //     await prefs.getInt(userId);
  //     name= prefs.getString(username);
  //     email= prefs.getString(useremail);
  //     profile= prefs.getString(userprofile);
  //     print('id========>${prefs.getInt(userId)}');
  //     print('name========>${prefs.getString(username)}');
  //     print('email========>${prefs.getString(useremail)}');
  //     print('imnage========>${prefs.getString(userprofile)}');
  //   });
  //
  // }
  // @override
  // void initState() {

  //   data();
  //   super.initState();
  //
  //
  // }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    setState(() {
      userDetails = data;
    });
    if (userDetails.isLoggedIn) {
      print('=========================>${userDetails.isLoggedIn}');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      //
      // ///------ appbar ------
      // appBar: customeAppBar(
      //   Profile[LANGUAGE_TYPE],
      //   false,false
      // ),

      ///------ body view -----
      body: body(),
    );
  }

  body() {
    return Column(
      children: [
        CustomAppBar(
          title: Profile[LANGUAGE_TYPE],
          isArrow: false,
          isAction: false,
        ),
        Expanded(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: themeColor,
                  ),
                )
              : userDetails.isLoggedIn == false
                  ? Center(
                      child: customeElevatedButton(
                        200,
                        Login[LANGUAGE_TYPE],
                        callback: () {
                          Get.to(() => LoginScreen(index: 4));
                        },
                      ),
                    )
                  : SingleChildScrollView(
                      // physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            height: 250,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/login/bg.png",
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),

                                  ///----- user image -----
                                  userDetails.profile.toString() == "null" && userDetails.profile.toString().isEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white, width: 2),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      "assets/home/profile.png",
                                                    ),
                                                    fit: BoxFit.cover)),
                                          ),
                                        )
                                      : userDetails.profile != ""
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                height: 120,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white, width: 2),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        userDetails.profile.toString(),
                                                      )),
                                                ),
                                                // child: CachedNetworkImage(
                                                //   imageUrl:
                                                //   userDetails.profile.toString(),
                                                //   fit: BoxFit.cover,
                                                //
                                                //
                                                //   // placeholder: (context, err){
                                                //   //   return placeHolder(
                                                //   //     isProfile: false,
                                                //   //     height: double.maxFinite,
                                                //   //     width: double.maxFinite,
                                                //   //   );
                                                //   // },
                                                //   // errorWidget: (context, err, reason){
                                                //   //   return placeHolder(
                                                //   //     isProfile: false,
                                                //   //     height: double.maxFinite,
                                                //   //     width: double.maxFinite,
                                                //   //   );
                                                //   // },
                                                // ),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                height: 120,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white, width: 2),
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/profile.png')),
                                                ),
                                                // child: CachedNetworkImage(
                                                //   imageUrl:
                                                //   userDetails.profile.toString(),
                                                //   fit: BoxFit.cover,
                                                //
                                                //
                                                //   // placeholder: (context, err){
                                                //   //   return placeHolder(
                                                //   //     isProfile: false,
                                                //   //     height: double.maxFinite,
                                                //   //     width: double.maxFinite,
                                                //   //   );
                                                //   // },
                                                //   // errorWidget: (context, err, reason){
                                                //   //   return placeHolder(
                                                //   //     isProfile: false,
                                                //   //     height: double.maxFinite,
                                                //   //     width: double.maxFinite,
                                                //   //   );
                                                //   // },
                                                // ),
                                              ),
                                            ),

                                  SizedBox(
                                    height: 15,
                                  ),

                                  ///----- user name ----
                                  Text(
                                    "${userDetails.name}",
                                    // '$name'=='null'?'':'$name',
                                    style: const TextStyle(fontSize: 18, fontFamily: "Bold", color: whiteColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),

                                  ///------- user email -----
                                  Text(
                                    "${userDetails.email}",
                                    // '$email'=='null'?'':'$email',
                                    style: const TextStyle(fontSize: 15, fontFamily: "Bold", color: Colors.grey),
                                  ),

                                  SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          ///---------- options view ----------
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: whiteColor,
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                return optionCard(index: index);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // InkWell(
                          //   onTap: (){
                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetailsScreen()));
                          //   },
                          //   child: Container(
                          //     color: themeColor,
                          //     height: 50,
                          //   ),
                          // )
                        ],
                      ),
                    ),
        ),
      ],
    );
  }

  ///------- option card -----
  optionCard({required int index}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            clickToFunction(options[index].type);
          },
          child: Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ///------- image with name -------
                Expanded(
                    child: Row(
                  children: [
                    Image.asset(
                      options[index].imagePath,
                      color: themeColor,
                      scale: 3.2,
                    ),
                    semiBoldText(
                      text: options[index].name,
                      size: 13,
                      color: blackColor,
                      // alignment: TextAlign.center,
                    ),
                  ],
                )),

                ///------ back arrow -----
                options[index].widget == null
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(
                          top: 7,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                        ),
                      )
              ],
            ),
          ),
        ),

        ///----- divider -----
        index == options.length - 1
            ? Container()
            : Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  height: 15,
                  thickness: 1,
                  // indent: kWIDTH * 0.12,
                  color: subTextColor.withOpacity(0.2),
                ),
              ),
      ],
    );
  }

  ///---- button click function ----------
  clickToFunction(int type) async {
    switch (type) {
      case 0:
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
        if (result == true) {
          getUserDetails();
        }
        print("result $result");
        break;

      case 1:
        Get.to(() => BookListScreen(isArrow: true));
        break;

      case 2:
        Get.to(() => const FamilyMemberList());
        break;

      case 3:
        Get.to(() => const AddressListScreen());
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => AddressListScreen()));
        break;

      case 4:
        showCustomDialog(
          context: context,
          title: ALERT[LANGUAGE_TYPE],
          msg: ARE_YOU_SURE_LOGOUT_FROM_LABORATORY_APP[LANGUAGE_TYPE],
          btnYesText: YES_PROCEED[LANGUAGE_TYPE],
          onPressedBtnYes: () async {
            getUserDetails();

            // SellerDetailsClass data = await sellerDetailsClass.getSellerDetails();
            // data.isLoggedIn=false;
            //   print('signout-------');
            //   print(data.isLoggedIn);
            //   print('signout-------');
            //   Navigator.popUntil(context, (route) => route.isFirst);
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SellerLoginScreen()));

            // final pref = await SharedPreferences.getInstance();
            // await pref.clear();
            SharedPreferences preferences = await SharedPreferences.getInstance();

            print('===========logout');
            print('lg ${preferences.getBool('isRemember')}');
            await userDetails.removeAllUserDetails();
            Get.find<TestDetailController>().getUserDetails();
            // await userDetailController.
            print('lg ${preferences.getBool('isRemember')}');
            print('===========');

            Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => LoginScreen()));
            // await Get.find<NearByLabController>().getLabList();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PagesWidget()));

            // final prefs = await SharedPreferences.getInstance();
            // prefs.clear();
            //
            // Navigator.popUntil(context, (route) => route.isFirst);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          onPressedButtonNo: () {
            Navigator.pop(context);
          },
          btnNoText: NO_WAIT[LANGUAGE_TYPE],
        );
        break;

      case 5:
        Get.to(() => CouponListScreen(
              fromCheckOut: false,
            ));
        break;
      case 6:
        Get.put(CouponController()).getWalletAmounts();
        Get.put(CouponController()).update();
        final wallet = await Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
        if (wallet == true) {
          getUserDetails();
        }
        break;
    }
  }
}

///---- option class ----------
class Options {
  dynamic name;
  Widget? widget;
  String imagePath;
  int type;
  double padding;

  Options({this.name, this.widget, required this.imagePath, required this.type, this.padding = 0});
}
