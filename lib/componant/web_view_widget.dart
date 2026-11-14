import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';

import 'package:diagnostics_patient/Screens/View/BookScreens/book_list_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageWidget extends StatefulWidget {
  final String url;
  const WebViewPageWidget({super.key, required this.url});

  @override
  State<WebViewPageWidget> createState() => _WebViewPageWidgetState(this.url);
}

class _WebViewPageWidgetState extends State<WebViewPageWidget> {
  String url;
  WebViewController controller = WebViewController();

  final GlobalKey webViewKey = GlobalKey();

  double progress = 0;
  final urlController = TextEditingController();

  _WebViewPageWidgetState(this.url) : super();

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onUrlChange: (change) {
            setState(() {
              this.url = change.url.toString();
              urlController.text = this.url;
            });
            log('onUrlChange : ' + url.toString());
            bool _isSuccess = url.toString().contains('Success');
            bool _isAborted = url.toString().contains('Aborted');
            bool _isFail = url.toString().contains('Failure');
            if (_isSuccess) {
              Future.delayed(Duration(seconds: 2)).then((value) {
                Get.back();
                Get.dialog(
                  Center(
                    child: Container(
                      height: 280,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: darkBlue,
                      ),
                      child: Column(
                        children: [
                          boldText(text: 'Test Book successfully', color: whiteColor, size: 26),
                          SizedBox(
                            height: 20,
                          ),
                          regularText(text: ORDER_SUCCESS_MSG2[LANGUAGE_TYPE], color: subTextColor, size: 16, alignment: TextAlign.center),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: customeElevatedButton(MediaQuery.of(context).size.width * 0.9, TRACK_ORDER[LANGUAGE_TYPE], callback: () {
                              Get.to(() => BookListScreen());
                            }),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: customeElevatedButtonOutLine(
                              MediaQuery.of(context).size.width * 0.9,
                              BACK_TO_SHOP[LANGUAGE_TYPE],
                              color: themeSecondaryColor,
                              callback: () async {
                                Get.offAll(() => PagesWidget(
                                      selectedIndex: 0,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                AppSnackbar.success(
                  "Success",
                  "Success",
                );
              });
            } else if (_isAborted) {
              Future.delayed(Duration(seconds: 2)).then((value) {
                Get.back();
                AppSnackbar.warning(
                  "Action",
                  "Thank you for shopping with us.We will keep you posted regarding the status of your order through e-mail",
                );
              });
            } else if (_isFail) {
              Future.delayed(Duration(seconds: 2)).then((value) {
                Get.back();
                AppSnackbar.error(
                  "Fail",
                  "Thank you for shopping with us.However,the transaction has been declined",
                );
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: 'Reports', isArrow: true, isAction: false),
            Expanded(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
