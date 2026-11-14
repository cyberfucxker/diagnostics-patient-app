import 'package:flutter/material.dart';
import 'package:diagnostics_patient/Models/onBordingModel.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';

class OnBoardingScreens extends StatefulWidget {
  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                AppImages.defaultImage,
              ),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginScreen(index: 0)),
                        );
                      },
                      child: Text(
                        Skip[LANGUAGE_TYPE],
                        style: const TextStyle(
                          color: subTextColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    //itemCount: contents.length,
                    itemCount: contents.length,
                    onPageChanged: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, i) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 60,
                                  ),
                                  child: Image.asset(
                                    contents[i].image,
                                    height: MediaQuery.of(context).size.height * 0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  contents[i].title,
                                  style: const TextStyle(
                                      fontSize: 26,
                                      // fontWeight: FontWeight.w400,
                                      color: whiteColor,
                                      fontFamily: "Bold"
                                      // color: ThemeManager().getBlackColor,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  contents[i].description,
                                  style: const TextStyle(fontSize: 15, color: subTextColor, height: 1.3),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 26, 10.0, 42.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: List.generate(
                                        contents.length,
                                        (index) => buildDot(index, context),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: IconButton(
                                        onPressed: () async {
                                          if (currentIndex == contents.length - 1) {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) => LoginScreen(index: 0),
                                              ),
                                            );
                                          }
                                          _controller.nextPage(
                                            duration: const Duration(milliseconds: 100),
                                            curve: Curves.bounceIn,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 30 : 18,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? whiteColor : subTextColor,
        border: currentIndex == index ? Border.all(color: themeColor) : Border.all(),
      ),
    );
  }
}
