// ignore_for_file: must_be_immutable

import 'package:diagnostics_patient/config/app_config.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../Custome_Widgets/custome_widget.dart';

class ReportViewScreen extends StatelessWidget {
  final String name;

  ReportViewScreen({Key? key, required this.name}) : super(key: key);

  // ignore: non_constant_identifier_names
  String ReportPath = '${AppConfig.storageBaseUrl}report/';

  Future<void> openFile() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: themeColor,
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
              child: boldText(text: 'Report'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // if (name.split('.').last.toLowerCase() == 'pdf')

          // Expanded(child: OpenFilex.open();
          //     // FileView(
          //     //   controller: FileViewController.network('$ReportPath$name'),
          //     // ),
          //     // PDF().cachedFromUrl(
          //     //   '$ReportPath$name',
          //     //   placeholder: (progress) => Center(child: Text('$progress %')),
          //     //   errorWidget: (error) => Center(child: Text(error.toString())),
          //     // ),
          //     )
          // else
          //   Expanded(
          //     // height: MediaQuery.of(context).size.height,
          //     child: Center(
          //       child: regularText(text: 'File type not supported'),
          //     ),
          //   )
        ],
      ),
    );
  }
}
