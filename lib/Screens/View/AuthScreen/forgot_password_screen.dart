import 'package:flutter/material.dart';

import '../../../componant/validation_screen.dart';
import '../../../utils/AllText.dart';
import '../../../utils/App_Images.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              AppImages.defaultImage,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          child: Icon(
                        Icons.arrow_back_ios,
                        color: whiteColor,
                      ))),
                  const SizedBox(
                    height: 30,
                  ),

                  ///---- Logo ----
                  Image.asset(
                    'assets/labLogo1.jpg',
                    // AppImages.newAppLogo,
                    height: 150,
                    width: 90,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  loginText(FORGOT_PASSWORD[LANGUAGE_TYPE]),
                  const SizedBox(
                    height: 6,
                  ),
                  loginSubText(FORGOT_PASSWORD_DES[LANGUAGE_TYPE]),
                  const SizedBox(
                    height: 30,
                  ),

                  ///---- Email textField -----
                  textFildHeader(Enter_Email_Address[LANGUAGE_TYPE], width),
                  customeTextFild(validateEmail, emailController, width, "",
                      TextInputType.emailAddress),
                  const SizedBox(
                    height: 30,
                  ),

                  ///----Login Button----
                  customeElevatedButton(width, SEND[LANGUAGE_TYPE],
                      callback: () {
                    if (key.currentState!.validate()) {}
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => PagesWidget()))
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
