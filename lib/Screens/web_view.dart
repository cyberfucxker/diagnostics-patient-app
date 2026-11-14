import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  const CustomWebView({Key? key, required this.url}) : super(key: key);
  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  String? host;
  List<PopupMenuItem>? popupList;
  WebViewController controller = WebViewController();

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
          onHttpError: (HttpResponseError error) {},
          // onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
    final uri = Uri.parse(widget.url);
    host = uri.host;
    popupList = [
      PopupMenuItem(
        child: GestureDetector(
          onTap: () {
            Clipboard.setData(
              ClipboardData(
                text: widget.url,
              ),
            );
          },
          // child: Text(
          //   'Copy Link',
          //   style: TextStyle(color: appThemeModel.value.isDarkModeEnabled.value ? Colors.white : Colors.black, fontSize: 16),
          // ),
        ),
      ),
      PopupMenuItem(
        child: GestureDetector(
          onTap: () {
            launchUrl(Uri.parse(widget.url));
          },
          child: Text(
            'Open in browser',
            // style: TextStyle(color: appThemeModel.value.isDarkModeEnabled.value ? Colors.white : Colors.black, fontSize: 16),
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: themeColor,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(child: Icon(Icons.arrow_back_ios))),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('CCAvenue'),
            ),
          ],
        ),

        automaticallyImplyLeading: false,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
