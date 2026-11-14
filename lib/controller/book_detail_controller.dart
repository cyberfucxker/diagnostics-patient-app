// ignore_for_file: deprecated_member_use

import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:diagnostics_patient/Models/report_list_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/Screens/View/BookScreens/book_report_screen.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/booking_detail_model.dart';
import '../Models/user_details_class.dart';
import '../Screens/View/BookScreens/book_details_screen.dart';
import '../utils/AllText.dart';
import '../utils/api.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../widgets/custom_snackbar.dart';

class BookDetailController extends GetxController {
  bool isLoading = true;
  bool isFeedbackLoading = false;
  final String? orderId;
  BookingDetailModel? bookingDetailModel;
  bool isGoogleMapLoading = false;
  BitmapDescriptor? pinLocationIcon;
  List<ReportListDataModel>? reportListData = [];
  ReportListModel? reportListModel;
  ScrollController scrollController = ScrollController();
  UserDetailsClass userDetails = UserDetailsClass();

  BookDetailController({this.orderId});

  List<TimeLineDetail> timeLineDetail = [
    TimeLineDetail(
        time: '00:00',
        title: 'Process',
        des:
            'Your order is under processing, you will be notified once Accepted',
        isTrue: false),
    TimeLineDetail(
        time: '',
        title: 'Accepted',
        des: 'Your order has been accepted, Phlebo Details will be shared soon',
        isTrue: false),
    TimeLineDetail(
        time: '',
        title: 'Sample Collected',
        des:
            'Your sample is under processing, You will be notified once report is ready',
        isTrue: false),
    TimeLineDetail(
        time: '',
        title: 'Complete',
        des: 'Congratulations! Your report is ready you can download it below.',
        isTrue: false),
  ];

  List<TimeLineDetail> parcelReportLineDetail = [
    TimeLineDetail(
        time: '00:00',
        title: 'Process',
        des:
            'Your order is under processing, you will be notified once Accepted',
        isTrue: false),
    TimeLineDetail(
        time: '',
        title: 'Accepted',
        des: 'Your order has been accepted, Phlebo Details will be shared soon',
        isTrue: false),
    TimeLineDetail(
        time: '',
        title: 'Sample Collected',
        des:
            'Your sample is under processing, You will be notified once report is ready',
        isTrue: false),
    TimeLineDetail(
      time: '',
      title: 'Parcel Report Send',
      des: '',
      isTrue: true,
      // isTrue: false,
    ),
    TimeLineDetail(
        time: '',
        title: 'Complete',
        des: 'Congratulations! Your report is ready you can download it below.',
        isTrue: false),
  ];

  List<TimeLineDetail> rejectTimeLineDetail = [
    TimeLineDetail(
        time: '00:00',
        title: 'Process',
        des:
            'Your order is under processing, you will be notified once Accepted',
        isTrue: false),
    TimeLineDetail(
        time: '',
        title: 'Reject',
        des: 'Your order is Rejected.',
        isTrue: false),
    TimeLineDetail(
        time: '',
        title: 'Refund',
        des: 'Refund add your account in 5 to 7 working days',
        isTrue: false),
  ];

  onInit() {
    super.onInit();
    init();
  }

  init() {
    getUserDetails();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/pin.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    // getBookDetail();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  String latlong = "";

  getBookDetail({String? id}) async {
    try {
      isLoading = true;
      update();
      print(
          "--- BOOKING DETAILS: ${Uri.parse(baseUrl + getBookDetailApi + '?order_id=$id')}");
      final response = await http
          .get(Uri.parse(baseUrl + getBookDetailApi + '?order_id=$id'));
      print("--- BOOKING DETAILS RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          bookingDetailModel = BookingDetailModel.fromJson(jsonResponse);

          await makeTimeLineList(bookingDetailModel!);

          center = bookingDetailModel!.data.useraddressdetails == null
              ? LatLng(21.237874, 72.888988)
              : LatLng(
                  bookingDetailModel!.data.useraddressdetails!.lat!,
                  bookingDetailModel!.data.useraddressdetails!.long!,
                );

          latlong = bookingDetailModel!.data.useraddressdetails == null
              ? "21.237874, 72.888988"
              : "${bookingDetailModel!.data.useraddressdetails!.lat!}, ${bookingDetailModel!.data.useraddressdetails!.long!}";
          // center = LatLng(21.237874, 72.888988);
          locateMarker(center!);
          isLoading = false;
          update();
        } else {
          AppSnackbar.error(
            "Error",
            "data not found",
          );
          isLoading = false;
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      AppSnackbar.error(
        "Failed to load Data",
        "Something went wrong. Try again,",
      );
      isLoading = false;
      update();
    }
  }

  Future<void> openFile(String fileName) async {
    try {
      // The URL from which you want to download the file
      String fileUrl = "${samplePathPdf}$fileName";

      // Get the device's temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String filePath = "${tempDir.path}/$fileName";

      // Use Dio to download the file
      Dio dio = Dio();
      await dio.download(fileUrl, filePath);

      // Once the file is downloaded, open it
      await OpenFilex.open(filePath);

      print('File downloaded and opened: $filePath');
    } catch (e) {
      print('Error downloading or opening the file: $e');
    }
  }

  getTime(value) {
    if (value != null && value != '') {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(value);
      String formattedDate = DateFormat('kk:mm').format(dateTime);
      return formattedDate;
    }
    return '00:00';
  }

  Future<void> makeTimeLineList(BookingDetailModel bookingDetailModel) async {
    if (bookingDetailModel.data.status == 3 ||
        bookingDetailModel.data.status == 4) {
      if (bookingDetailModel.data.status! >= 1) {
        rejectTimeLineDetail[0].isTrue = true;
        rejectTimeLineDetail[0].time =
            getTime(bookingDetailModel.data.orderplaceDate);
      }
      if (bookingDetailModel.data.status! >= 3) {
        rejectTimeLineDetail[1].isTrue = true;
        rejectTimeLineDetail[1].time =
            getTime(bookingDetailModel.data.rejectDatetime);
        rejectTimeLineDetail[1].des =
            bookingDetailModel.data.rejectDescription ?? '';
      }
      if (bookingDetailModel.data.status! >= 4) {
        rejectTimeLineDetail[2].isTrue = true;
        rejectTimeLineDetail[2].time =
            getTime(bookingDetailModel.data.refundDatetime);
      }
      // if()
    } else if (bookingDetailModel.data.status == 8) {
      if (bookingDetailModel.data.status! >= 1) {
        parcelReportLineDetail[0].isTrue = true;
        parcelReportLineDetail[0].time =
            getTime(bookingDetailModel.data.orderplaceDate);
      }
      if (bookingDetailModel.data.status! >= 2) {
        parcelReportLineDetail[1].isTrue = true;
        parcelReportLineDetail[1].time =
            getTime(bookingDetailModel.data.acceptDatetime);
      }
      if (bookingDetailModel.data.status! >= 5) {
        parcelReportLineDetail[2].isTrue = true;
        parcelReportLineDetail[2].time =
            getTime(bookingDetailModel.data.collectedDatetime);
      }
      if (bookingDetailModel.data.status! >= 7) {
        parcelReportLineDetail[4].isTrue = true;
        parcelReportLineDetail[4].time =
            getTime(bookingDetailModel.data.completeDatetime);
      }
    } else {
      if (bookingDetailModel.data.status! >= 1) {
        timeLineDetail[0].isTrue = true;
        timeLineDetail[0].time =
            getTime(bookingDetailModel.data.orderplaceDate);
      }
      if (bookingDetailModel.data.status! >= 2) {
        timeLineDetail[1].isTrue = true;
        timeLineDetail[1].time =
            getTime(bookingDetailModel.data.acceptDatetime);
      }
      if (bookingDetailModel.data.status! >= 5) {
        timeLineDetail[2].isTrue = true;
        timeLineDetail[2].time =
            getTime(bookingDetailModel.data.collectedDatetime);
      }
      if (bookingDetailModel.data.status! >= 7) {
        timeLineDetail[3].isTrue = true;
        timeLineDetail[3].time =
            getTime(bookingDetailModel.data.completeDatetime);
      }
    }
    return;
  }

  late GoogleMapController mapController;
  LatLng? center;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onMapTap(LatLng latLng) {
    center = latLng;
    // getAddress();
    locateMarker(latLng);
  }

  final Map<String, Marker> markers = {};

  locateMarker(LatLng latLng) async {
    final marker = Marker(
      draggable: true,
      alpha: 1,
      // anchor: Offset(0.5,0.5),
      markerId: const MarkerId("curr_loc"),
      position: latLng,
      infoWindow: InfoWindow(title: Your_Location[LANGUAGE_TYPE]),
      icon: pinLocationIcon!,
    );
    markers["Current Location"] = marker;
    update();
  }

  void launchMap() async {
    final String url =
        "https://maps.google.com/maps/search/?api=1&query=$latlong";
    if (await canLaunch(url)) {
      print("Can launch");
      canLaunch(
          "https://maps.google.com/maps/search/?api=1&query=$latlong");
      // void initState(){
      //   super.initState();
      //
      //   canLaunch( "https://maps.google.com/maps/search/?api=1&query=$lat,$long");
      // }

      await launch(url);
    } else {
      print("Could not launch");
      throw 'Could not launch Maps';
    }
  }

  double selectedRating = 4.0;
  double iconSize = 40;
  TextEditingController tcFeedback = TextEditingController();

  String s1 = 'assets/book_detail/smile-select.png';
  String us1 = 'assets/book_detail/smile-unselect.png';
  String s2 = 'assets/book_detail/poor-select.png';
  String us2 = 'assets/book_detail/poor-unselect.png';
  String s3 = 'assets/book_detail/silent-select.png';
  String us3 = 'assets/book_detail/silent-unselect.png';
  String s4 = 'assets/book_detail/love-select.png';
  String us4 = 'assets/book_detail/love-unselect.png';
  String s5 = 'assets/book_detail/laughing-select.png';
  String us5 = 'assets/book_detail/laughing-unselect.png';

  submitFeedback() async {
    if (tcFeedback.text.isEmpty) {
      AppSnackbar.warning('Enter Message', 'Message is required for submit');
      return;
    }
    Get.back();
    isFeedbackLoading = true;
    update();
    try {
      final response = await http.post(Uri.parse(baseUrl + addFeedBack), body: {
        "user_id": userDetails.userId.toString(),
        "ratting": selectedRating.round().toString(),
        "order_id": orderId.toString(),
        "description": tcFeedback.text.toString()
      });
      if (response.statusCode == 200) {
        tcFeedback.clear();
        selectedRating = 4.0;
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          AppSnackbar.success('Success', jsonResponse['msg']);
          isFeedbackLoading = false;
          update();
        } else {
          AppSnackbar.error(
            "Error",
            "data not found",
          );
          isFeedbackLoading = false;
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      AppSnackbar.error(
        "Failed to load Data",
        "Something went wrong. Try again,",
      );
      isFeedbackLoading = false;
      update();
    }
  }

  Future checkLoginApi() async {
    try {
      showLoadingMsg(
          context: Get.context!, title: 'Loading...', msg: 'Please Wait');

      final _response = await http.get(Uri.parse(
          "${AppConfig.hostUrl}check_login_api?phone=${userDetails.phone}"));
      if (_response.statusCode == 200) {
        var data = jsonDecode(_response.body);
        if (data['success'] == true) {
          await getReportList(userFid: data['data']['UserFID']);
        } else if (data['success'] == false) {
          showCustomDialog(
              context: Get.context,
              title: OOPS_ERROR,
              msg: data['msg'],
              btnYesText: OK,
              onPressedBtnYes: () {
                Navigator.pushReplacement(
                    Get.context!,
                    MaterialPageRoute(
                        builder: (context) => PagesWidget(
                              selectedIndex: 0,
                            )));
                // Navigator.pop(context);
              });
        } else {
          Navigator.pop(Get.context!);
          showCustomDialog(
              context: Get.context!,
              title: OOPS_ERROR,
              msg: data['msg'],
              btnYesText: OK,
              onPressedBtnYes: () {
                Navigator.pop(Get.context!);
              });
        }
      }
    } catch (e) {
      print('Exceptin : login_screen - _login()' + e.toString());
    }
  }

  Future getReportList({String? userFid}) async {
    update();
    try {
      reportListData!.clear();
      final response = await http.get(
        Uri.parse('${AppConfig.hostUrl}report-api?UserFID=$userFid'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          reportListModel = ReportListModel.fromJson(jsonResponse);
          if (reportListModel!.data != null &&
              reportListModel!.data!.length > 0) {
            reportListData!.addAll(reportListModel!.data!);
            isLoading = false;
            await Future.delayed(Duration.zero);

            Get.to(() => BookReportListScreen(userFid: userFid))!.then((_) {
              Navigator.pop(Get.context!);
              update();
            });

            update();
          } else {
            update();
          }
        } else {
          isLoading = false;
          update();
        }
      }
    } catch (e) {
      AppSnackbar.error(
        "Failed to load Data",
        e.toString(),
      );
      isLoading = false;
      update();
    }
  }

  // Future<Map<String, dynamic>> fetchInvoiceData() async {
  //   final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}show_printorder?user_id=${userDetails.userId}&id=256'));

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body); // Returning the decoded JSON response
  //   } else {
  //     throw Exception('Failed to load invoice data');
  //   }
  // }

  // Future<Map<String, dynamic>> fetchInvoiceData() async {
  //   try {
  //     UserDetailsClass data = await UserDetailsClass().getUserDetails();
  //     userDetails = data;

  //     final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}show_printorder?user_id=${userDetails.userId}&id=256'));
  //     print("response $response");
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 1) {
  //       } else {
  //         Get.snackbar(
  //           "Error",
  //           "data not found",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: redColor,
  //         );
  //         isLoading = false;
  //         update();
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Failed to load Data",
  //       "Something went wrong. Try again,",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //     isLoading = false;
  //     update();
  //   }
  // }

  Future<Map<String, dynamic>> fetchInvoiceData(int id) async {
    try {
      showLoadingMsg(
          context: Get.context!, title: 'Downloading...', msg: 'Please Wait');
      UserDetailsClass data = await UserDetailsClass().getUserDetails();
      userDetails = data;

      final response = await http.get(Uri.parse(
          '${AppConfig.apiBaseUrl}show_printorder?user_id=${userDetails.userId}&id=$id'));
      print("response $response");
      Navigator.pop(Get.context!);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == "1") {
          return jsonResponse;
        } else {
          AppSnackbar.error(
            "Error",
            "Data not found",
          );
          isLoading = false;
          update();
          return {};
        }
      } else {
        throw Exception(
            "Failed to load data with status code ${response.statusCode}");
      }
    } catch (e) {
      Navigator.pop(Get.context!);
      AppSnackbar.error(
        "Failed to load Data",
        "Something went wrong. Try again.",
      );
      isLoading = false;
      update();
      throw Exception("Error occurred: $e"); // Throw an exception on error
    }
  }

  // Future<bool> requestPermissions() async {
  //   PermissionStatus status = await Permission.storage.request();
  //   return status.isGranted;
  // }

  Future<void> handleDownloadButton(int id) async {
    final invoiceData = await fetchInvoiceData(id);
    // await generateInvoicePdf();
    await generateInvoicePdf(invoiceData);
    // OpenFilex.open(pdfFile.path);

    // print('Download complete! PDF saved to: ${pdfFile.path}');
  }

  // Future<File> generateInvoicePdf(Map<String, dynamic> invoiceData) async {
  //   final pdf = pw.Document();

  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Text('Order Number: ${invoiceData['data']['orderdata']['id']}', style: pw.TextStyle(fontSize: 20)),
  //             pw.Text('Date: ${invoiceData['data']['orderdata']['date']}'),
  //             pw.SizedBox(height: 20),
  //             pw.Text('Customer:'),
  //             pw.Text('${invoiceData['data']['orderdata']['useraddressdetails']['name']}'),
  //             pw.Text('${invoiceData['data']['orderdata']['useraddressdetails']['address']}'),
  //             pw.SizedBox(height: 20),
  //             pw.Text('Items:'),
  //             // pw.Table.fromTextArray(
  //             //   headers: ['Description', 'Quantity', 'Price'],
  //             //   data: invoiceData['data']['orderdata'].map((item) {
  //             //     return [
  //             //       item['item_name'],
  //             //       '1', // Quantity is not available in the API response
  //             //       item['price'].toString(),
  //             //     ];
  //             //   }).toList(),
  //             // ),
  //             pw.SizedBox(height: 20),
  //             pw.Text('Total: \$${invoiceData['data']['orderdata']['final_total']}'),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //   // Get the directory to store the PDF file (Documents folder on iOS/Android)
  //   final outputDir = await getExternalStorageDirectory();
  //   final filePath = '${outputDir?.path}/invoice.pdf'; // File path for download location
  //   // Save the PDF to the file system
  //   final file = File(filePath);
  //   await file.writeAsBytes(await pdf.save());
  //   print('PDF Saved at: $filePath');
  //   return file;
  // }
  // Future<File> generateInvoicePdf(Map<String, dynamic> invoiceData) async {
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       margin: pw.EdgeInsets.all(32),
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             // Header Section
  //             pw.Center(
  //               child: pw.Text(
  //                 'Invoice',
  //                 style: pw.TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             pw.Divider(thickness: 2, color: PdfColors.grey),
  //             // Order Details
  //             pw.SizedBox(height: 10),
  //             pw.Text(
  //               'Order Number: ${invoiceData['data']['orderdata']['id']}',
  //               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.Text(
  //               'Date: ${invoiceData['data']['orderdata']['date']}',
  //               style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
  //             ),
  //             pw.SizedBox(height: 20),
  //             // Customer Details
  //             pw.Text(
  //               'Customer Details:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.Text('${invoiceData['data']['orderdata']['orderdata'][0]['memberdetails']['name']}(${invoiceData['data']['orderdata']['orderdata'][0]['memberdetails']['relation']})'),
  //             pw.Text('${invoiceData['data']['orderdata']['useraddressdetails']['address']}'),
  //             pw.SizedBox(height: 20),
  //             // Items Section
  //             pw.Text(
  //               'Items:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(height: 10),
  //             pw.Table.fromTextArray(
  //               headers: ['Name', 'Parameter', 'Price'], // Table headers
  //               data: invoiceData['data']['orderdata']['orderdata']
  //                   .map<List<String>>((item) => [
  //                         item['item_name'].toString(), // Ensure string
  //                         item['parameter'].toString(), // Fixed quantity or replace with item['quantity'].toString()
  //                         '\₹${item['price'].toString()}' // Price with currency symbol
  //                       ])
  //                   .toList(),
  //               headerStyle: pw.TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: PdfColors(1.0, 1.0, 1.0),
  //               ),
  //               headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
  //               cellStyle: pw.TextStyle(fontSize: 12),
  //               cellAlignment: pw.Alignment.centerLeft,
  //               columnWidths: {
  //                 0: pw.FlexColumnWidth(2),
  //                 1: pw.FlexColumnWidth(1),
  //                 2: pw.FlexColumnWidth(1),
  //               },
  //             ),
  //             pw.SizedBox(height: 20),
  //             // Total Amount
  //             pw.Align(
  //               alignment: pw.Alignment.centerRight,
  //               child: pw.Text(
  //                 'Total: \$${invoiceData['data']['orderdata']['final_total']}',
  //                 style: pw.TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //   // Get the directory to store the PDF file (Documents folder on iOS/Android)
  //   final outputDir = await getExternalStorageDirectory();
  //   final filePath = '${outputDir?.path}/invoice.pdf'; // File path for download location
  //   // Save the PDF to the file system
  //   final file = File(filePath);
  //   await file.writeAsBytes(await pdf.save());
  //   print('PDF Saved at: $filePath');
  //   return file;
  // }
  // Future<File> generateInvoicePdf() async {
  //   final pdf = pw.Document();
  //   // Load the asset image as bytes
  //   final ByteData data = await rootBundle.load('assets/splashLogo.png');
  //   final Uint8List bytes = data.buffer.asUint8List();
  //   pdf.addPage(
  //     pw.Page(
  //       margin: pw.EdgeInsets.all(32),
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             // Header Section
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                   children: [
  //                     pw.Text(
  //                       style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text('support@example.com'),
  //                   ],
  //                 ),
  //                 pw.Container(
  //                   width: 80,
  //                   height: 80,
  //                   child: pw.Image(
  //                     pw.MemoryImage(bytes), // Pass logo as bytes
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             pw.Divider(thickness: 1),
  //             // Customer Information (Static Data)
  //             pw.SizedBox(height: 10),
  //             pw.Text(
  //               'Patient Details:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.Text('Name: John Doe'),
  //             pw.SizedBox(height: 10),
  //             // Appointment Details (Static Data)
  //             pw.Text(
  //               'Appointment:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.Text('Date: 2024-12-30'),
  //             pw.Text('Time: 10:00 AM'),
  //             pw.SizedBox(height: 20),
  //             // Items Section (Static Data)
  //             pw.Text(
  //               'Tests/Items:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(height: 10),
  //             pw.Table.fromTextArray(
  //               headers: ['Name', 'Parameters', 'Price'],
  //               data: [
  //                 ['Blood Test', 'Hemoglobin, RBC, WBC', '₹500'],
  //                 ['X-Ray', 'Chest X-Ray', '₹700'],
  //               ],
  //               headerStyle: pw.TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: PdfColors.white,
  //               ),
  //               headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
  //               cellStyle: pw.TextStyle(fontSize: 12),
  //               cellAlignment: pw.Alignment.centerLeft,
  //               columnWidths: {
  //                 0: pw.FlexColumnWidth(2),
  //                 1: pw.FlexColumnWidth(1),
  //                 2: pw.FlexColumnWidth(1),
  //               },
  //             ),
  //             pw.SizedBox(height: 20),
  //             // Pricing Details (Static Data)
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text('Subtotal:', style: pw.TextStyle(fontSize: 14)),
  //                 pw.Text('₹1200'),
  //               ],
  //             ),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text('Discount:', style: pw.TextStyle(fontSize: 14)),
  //                 pw.Text('- ₹100'),
  //               ],
  //             ),
  //             pw.Divider(thickness: 1),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text(
  //                   'Total:',
  //                   style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //                 ),
  //                 pw.Text(
  //                   '₹1100',
  //                   style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //   // Get the directory to store the PDF file
  //   final outputDir = await getExternalStorageDirectory();
  //   final filePath = '${outputDir?.path}/invoice.pdf';
  //   // Save the PDF to the file system
  //   final file = File(filePath);
  //   await file.writeAsBytes(await pdf.save());
  //   print('PDF saved at: $filePath');
  //   return file;
  // }
  // Future<File> generateInvoicePdf() async {
  //   final pdf = pw.Document();
  //   // Load the asset image as bytes
  //   final ByteData data = await rootBundle.load('assets/splashLogo.png');
  //   final Uint8List bytes = data.buffer.asUint8List();
  //   pdf.addPage(
  //     pw.Page(
  //       margin: pw.EdgeInsets.all(32),
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             // **Header Section**
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                   children: [
  //                     pw.Text(
  //                       style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text('support@example.com'),
  //                   ],
  //                 ),
  //                 pw.Container(
  //                   width: 80,
  //                   height: 80,
  //                   child: pw.Image(
  //                     pw.MemoryImage(bytes), // Pass logo as bytes
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             pw.Divider(thickness: 1),
  //             // **Customer Information**
  //             pw.SizedBox(height: 10),
  //             pw.Text(
  //               'Patient Details:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.Text('Name: Lav Jain'),
  //             pw.SizedBox(height: 10),
  //             // **Appointment Details**
  //             pw.Text(
  //               'Appointment:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.Text('Date: 2024-12-28'),
  //             pw.Text('Time: 6:00 AM - 7:00 AM'),
  //             pw.SizedBox(height: 20),
  //             // **Items Section**
  //             pw.Text(
  //               'Tests/Items:',
  //               style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //             ),
  //             pw.SizedBox(height: 10),
  //             pw.Table.fromTextArray(
  //               headers: ['Name', 'Parameters', 'Price'],
  //               data: [
  //                 ['Lipid Profile Panel', '8 Parameters', '₹500'],
  //               ],
  //               headerStyle: pw.TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: PdfColors.white,
  //               ),
  //               headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
  //               cellStyle: pw.TextStyle(fontSize: 12),
  //               cellAlignment: pw.Alignment.centerLeft,
  //               columnWidths: {
  //                 0: pw.FlexColumnWidth(2),
  //                 1: pw.FlexColumnWidth(1),
  //                 2: pw.FlexColumnWidth(1),
  //               },
  //             ),
  //             pw.SizedBox(height: 20),
  //             // **Pricing Details**
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text('Subtotal:', style: pw.TextStyle(fontSize: 14)),
  //                 pw.Text('₹500'),
  //               ],
  //             ),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text('Discount:', style: pw.TextStyle(fontSize: 14)),
  //                 pw.Text('- ₹0'),
  //               ],
  //             ),
  //             pw.Divider(thickness: 1),
  //             pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text(
  //                   'Total:',
  //                   style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //                 ),
  //                 pw.Text(
  //                   '₹500',
  //                   style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //   // **Save PDF to File**
  //   final outputDir = await getExternalStorageDirectory();
  //   final filePath = '${outputDir?.path}/invoice.pdf';
  //   // Save the PDF to the file system
  //   final file = File(filePath);
  //   await file.writeAsBytes(await pdf.save());
  //   print('PDF saved at: $filePath');
  //   return file;
  // }
  // Future<void> generateInvoicePdf() async {
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       build: (context) => pw.Column(
  //         children: [
  //           // Header
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Text(
  //                     style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
  //                   ),
  //                   pw.Text("(Raj.) India"),
  //                   pw.Text("GST: Not Applicable"),
  //                 ],
  //               ),
  //               pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                 children: [
  //                   pw.Text("INVOICE", style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           pw.SizedBox(height: 20),
  //           pw.Container(
  //             padding: pw.EdgeInsets.all(8),
  //             color: const PdfColor.fromInt(0xffd9d9d9),
  //             child: pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //               children: [
  //                 pw.Text("Invoice No: 123-456-789"),
  //                 pw.Text("Invoice Date: 02 May, 2024"),
  //                 pw.Text("Booking Id: 001000"),
  //                 pw.Text("Sample Collection Date: Jan 24, 2022"),
  //               ],
  //             ),
  //           ),
  //           pw.SizedBox(height: 20),
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Text("Bill From:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                   pw.Text("CIN No.: U85110RJ2013PTC044047"),
  //                 ],
  //               ),
  //               pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Text("Customer Billing Details:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                   pw.Text("Lav Jain"),
  //                   pw.Text("Customer Address"),
  //                   pw.Text("Customer Phone No."),
  //                   pw.Text("Customer Email Address"),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           pw.SizedBox(height: 20),
  //           // Table Header
  //           pw.Container(
  //             padding: pw.EdgeInsets.all(8),
  //             color: const PdfColor.fromInt(0xff005ba2),
  //             child: pw.Row(
  //               children: [
  //                 pw.Expanded(child: pw.Text("TEST DESCRIPTION", style: pw.TextStyle(color: PdfColor.fromHex('#005ba2')))),
  //                 pw.Text("AMOUNT", style: pw.TextStyle(color: PdfColor.fromHex('#005ba2'))),
  //               ],
  //             ),
  //           ),
  //           // Table Content
  //           pw.Container(
  //             padding: pw.EdgeInsets.all(8),
  //             child: pw.Column(
  //               children: [
  //                 pw.Row(
  //                   children: [
  //                     pw.Expanded(child: pw.Text("Lav Jain | Male | Self\nLipid Profile")),
  //                     pw.Text("₹500/-"),
  //                   ],
  //                 ),
  //                 pw.Divider(),
  //                 pw.Row(
  //                   children: [
  //                     pw.Text("₹799/-"),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // Total
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Text("TOTAL AMOUNT"),
  //               pw.Text("₹1299/-"),
  //             ],
  //           ),
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Text("DISCOUNT"),
  //               pw.Text("₹0/-"),
  //             ],
  //           ),
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Text("GRAND TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //               pw.Text("₹1299/-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.SizedBox(height: 20),
  //           pw.Text("Amount Chargeable (in Words): Rupees Twelve Hundred Ninety Nine Only"),
  //           pw.SizedBox(height: 10),
  //           pw.Text("Company's PAN No.: AAGCR7195A"),
  //           pw.SizedBox(height: 20),
  //           pw.Text("Important Notes:"),
  //           pw.Bullet(text: "This invoice can be used for tax exemption under section 80-D."),
  //           pw.Bullet(text: "Reports sent on registered mail ID according to the respective TAT."),
  //         ],
  //       ),
  //     ),
  //   );
  //   // Save the PDF
  //   final output = await getApplicationDocumentsDirectory();
  //   final file = File("${output.path}/invoice.pdf");
  //   await file.writeAsBytes(await pdf.save());
  //   await OpenFilex.open(file.path);
  //   print("PDF saved at: ${file.path}");
  // }
  // Future<void> generateInvoicePdf() async {
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       build: (context) => pw.Column(
  //         children: [
  //           // Header
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Text(
  //                     style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
  //                   ),
  //                   pw.Text("(Raj.) India"),
  //                   pw.Text("GST: Not Applicable"),
  //                 ],
  //               ),
  //               pw.Text(
  //                 "INVOICE",
  //                 style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           pw.SizedBox(height: 20),
  //           // Invoice Details Row with Vertical Alignment
  //           pw.Container(
  //             padding: pw.EdgeInsets.all(8),
  //             color: const PdfColor.fromInt(0xff005ba2), // Blue Background
  //             child: pw.Row(
  //               mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
  //               children: [
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                   children: [
  //                     pw.Text(
  //                       "Invoice No:",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text(
  //                       "123-456-789",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
  //                     ),
  //                   ],
  //                 ),
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                   children: [
  //                     pw.Text(
  //                       "Invoice Date:",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text(
  //                       "02 May, 2024",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
  //                     ),
  //                   ],
  //                 ),
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                   children: [
  //                     pw.Text(
  //                       "Booking Id:",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text(
  //                       "001000",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
  //                     ),
  //                   ],
  //                 ),
  //                 pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                   children: [
  //                     pw.Text(
  //                       "Sample Collection Date:",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
  //                     ),
  //                     pw.Text(
  //                       "Jan 24, 2022",
  //                       style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           pw.SizedBox(height: 20),
  //           // Customer and Billing Details
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Text("Bill From:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                   pw.Text("CIN No.: U85110RJ2013PTC044047"),
  //                 ],
  //               ),
  //               pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.Text("Customer Billing Details:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                   pw.Text("Lav Jain"),
  //                   pw.Text("Customer Address"),
  //                   pw.Text("Customer Phone No."),
  //                   pw.Text("Customer Email Address"),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           pw.SizedBox(height: 20),
  //           // Table Header
  //           pw.Container(
  //             padding: pw.EdgeInsets.all(8),
  //             color: const PdfColor.fromInt(0xff005ba2),
  //             child: pw.Row(
  //               children: [
  //                 pw.Expanded(
  //                   child: pw.Text(
  //                     "TEST DESCRIPTION",
  //                     style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
  //                   ),
  //                 ),
  //                 pw.Text(
  //                   "AMOUNT",
  //                   style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // Table Content
  //           pw.Container(
  //             padding: pw.EdgeInsets.all(8),
  //             child: pw.Column(
  //               children: [
  //                 pw.Row(
  //                   children: [
  //                     pw.Expanded(child: pw.Text("Lav Jain | Male | Self\nLipid Profile")),
  //                     pw.Text("₹500/-"),
  //                   ],
  //                 ),
  //                 pw.Divider(),
  //                 pw.Row(
  //                   children: [
  //                     pw.Text("₹799/-"),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // Total Amount Section
  //           pw.SizedBox(height: 10),
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Text("TOTAL AMOUNT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //               pw.Text("₹1299/-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Text("DISCOUNT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //               pw.Text("₹0/-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //             ],
  //           ),
  //           pw.Row(
  //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //             children: [
  //               pw.Text("GRAND TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
  //               pw.Text("₹1299/-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
  //             ],
  //           ),
  //           pw.SizedBox(height: 20),
  //           // Additional Notes
  //           pw.Text("Amount Chargeable (in Words): Rupees Twelve Hundred Ninety Nine Only"),
  //           pw.SizedBox(height: 10),
  //           pw.Text("Company's PAN No.: AAGCR7195A"),
  //           pw.SizedBox(height: 20),
  //           pw.Text("Important Notes:"),
  //           pw.Bullet(text: "This invoice can be used for tax exemption under section 80-D."),
  //           pw.Bullet(text: "Reports sent on registered mail ID according to the respective TAT."),
  //         ],
  //       ),
  //     ),
  //   );
  //   // Save the PDF
  //   final output = await getApplicationDocumentsDirectory();
  //   final file = File("${output.path}/invoice.pdf");
  //   await file.writeAsBytes(await pdf.save());
  //   await OpenFilex.open(file.path);
  //   print("PDF saved at: ${file.path}");
  // }

  Future<Uint8List> loadAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  Future<void> generateInvoicePdf(Map<String, dynamic> invoiceData) async {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    final pdf = pw.Document();

    final logoImage = pw.MemoryImage(
      await loadAsset('assets/labLogo.png'), // Update the path to your logo
    );

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImage, width: 200, height: 80),
                pw.Text(
                  "INVOICE",
                  style: pw.TextStyle(
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor(0.1255, 0.2392, 0.4196)),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Invoice Details Row with Vertical Alignment
            pw.Container(
              padding: pw.EdgeInsets.all(8),
              color: const PdfColor.fromInt(0xff005ba2),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        "Invoice No:",
                        style: pw.TextStyle(
                            color: PdfColor(1.0, 1.0, 1.0),
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "${invoiceData['data']['orderdata']['id']}",
                        style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        "Invoice Date:",
                        style: pw.TextStyle(
                            color: PdfColor(1.0, 1.0, 1.0),
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "${invoiceData['data']['orderdata']['date']}",
                        style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        "Booking Id:",
                        style: pw.TextStyle(
                            color: PdfColor(1.0, 1.0, 1.0),
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "${invoiceData['data']['orderdata']['id']}",
                        style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        "Sample Collection Date:",
                        style: pw.TextStyle(
                            color: PdfColor(1.0, 1.0, 1.0),
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "${invoiceData['data']['orderdata']['orderplace_date']}",
                        style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left Column: Bill From
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Bill From:",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        color: const PdfColor.fromInt(0xFF333333), // Dark Gray
                      ),
                    ),
                    pw.Row(
                      children: [
                        pw.Text(
                          "CIN No.: ",
                          style: pw.TextStyle(
                            fontSize: 9,
                            color:
                                const PdfColor.fromInt(0xFF333333), // Dark Gray
                          ),
                        ),
                        pw.Text(
                          "----", // Bold CIN Number
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color:
                                const PdfColor.fromInt(0xFF333333), // Dark Gray
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      AppConfig.companyName,
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold, // Bold company name
                        color: const PdfColor.fromInt(
                            0xFFFF0000), // Red accent
                      ),
                    ),
                    pw.Text(
                      "${(invoiceData['data']['orderdata']['useraddressdetails'] != null) ? invoiceData['data']['orderdata']['useraddressdetails']['address'] : ""}",
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: const PdfColor.fromInt(0xFF333333), // Dark Gray
                      ),
                    ),
                    pw.Text(
                      "(${((invoiceData['data']['orderdata']['useraddressdetails'] != null)) ? invoiceData['data']['orderdata']['useraddressdetails']['state'] : ""}.) India",
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: const PdfColor.fromInt(0xFF333333), // Dark Gray
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      "GST: Not Applicable",
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: const PdfColor.fromInt(0xFF333333), // Dark Gray
                      ),
                    ),
                  ],
                ),

                // Right Column: Customer Billing Details
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Customer Billing Details:",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                        color: const PdfColor.fromInt(0xFF333333), // Dark Gray
                      ),
                    ),
                    pw.Container(
                      width: 150,
                      child: pw.Text(
                        // "${invoiceData['data']['orderdata']['orderdata'][0]['memberdetails']['name']}",
                        "${userDetails.name}",
                        maxLines: 2,
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFFFF0000),
                        ),
                      ),
                    ),
                    pw.Text(
                      "${userDetails.phone}",
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: const PdfColor.fromInt(0xFFFF0000),
                      ),
                    ),
                    pw.Container(
                      width: 150,
                      child: pw.Text(
                        "${userDetails.email}",
                        maxLines: 2,
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFFFF0000),
                        ),
                      ),
                    ),

                    /* pw.Text(
                      "Customer Phone No.",
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: const PdfColor.fromInt(0xFF333333),
                      ),
                    ),
                    pw.Text(
                      "Customer Email Address",
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: const PdfColor.fromInt(0xFF333333),
                      ),
                    ), */
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Table Header
            // pw.Container(
            //   padding: pw.EdgeInsets.all(8),
            //   color: const PdfColor.fromInt(0xff005ba2),
            //   child: pw.Row(
            //     children: [
            //       pw.Expanded(
            //         child: pw.Text(
            //           "TEST DESCRIPTION",
            //           style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
            //         ),
            //       ),
            //       pw.Text(
            //         "AMOUNT",
            //         style: pw.TextStyle(color: PdfColor(1.0, 1.0, 1.0), fontWeight: pw.FontWeight.bold),
            //       ),
            //     ],
            //   ),
            // ),
            // pw.Container(
            //   padding: pw.EdgeInsets.all(8),
            //   child: pw.Column(
            //     children: [
            //       // First Row: Lav Jain | Male | Self
            //       pw.Column(
            //         crossAxisAlignment: pw.CrossAxisAlignment.start,
            //         children: [
            //           pw.Text(
            //             "Lav Jain | Male | Self",
            //             style: pw.TextStyle(
            //               color: const PdfColor.fromInt(0xFFFF0000), // Red color
            //               fontWeight: pw.FontWeight.bold,
            //               fontSize: 10,
            //             ),
            //           ),
            //           pw.Divider(thickness: 0.5), // Thin divider below name
            //           pw.Row(
            //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //             children: [
            //               pw.Text(
            //                 "Lipid Profile",
            //                 style: pw.TextStyle(
            //                   fontSize: 9,
            //                   color: const PdfColor.fromInt(0xFF333333), // Dark Gray color
            //                 ),
            //               ),
            //               pw.Text(
            //                 "₹500/-",
            //                 style: pw.TextStyle(
            //                   fontSize: 10,
            //                   fontWeight: pw.FontWeight.bold,
            //                   color: const PdfColor.fromInt(0xFF333333), // Dark Gray
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //       pw.SizedBox(height: 8), // Space between rows

            //       // Second Row: Rahul Jain | Male | Brother
            //       pw.Column(
            //         crossAxisAlignment: pw.CrossAxisAlignment.start,
            //         children: [
            //           pw.Text(
            //             "Rahul Jain | Male | Brother",
            //             style: pw.TextStyle(
            //               color: const PdfColor.fromInt(0xFFFF0000), // Red color
            //               fontWeight: pw.FontWeight.bold,
            //               fontSize: 10,
            //             ),
            //           ),
            //           pw.Divider(thickness: 0.5), // Thin divider below name
            //           pw.Row(
            //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //             children: [
            //               pw.Text(
            //                 style: pw.TextStyle(
            //                   fontSize: 9,
            //                   color: const PdfColor.fromInt(0xFF333333), // Dark Gray color
            //                 ),
            //               ),
            //               pw.Text(
            //                 "₹799/-",
            //                 style: pw.TextStyle(
            //                   fontSize: 10,
            //                   fontWeight: pw.FontWeight.bold,
            //                   color: const PdfColor.fromInt(0xFF333333), // Dark Gray
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            pw.Container(
              padding: pw.EdgeInsets.all(8),
              color: const PdfColor.fromInt(0xff005ba2),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      "DESCRIPTION",
                      style: pw.TextStyle(
                        color: PdfColor(1.0, 1.0, 1.0),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    "AMOUNT",
                    style: pw.TextStyle(
                      color: PdfColor(1.0, 1.0, 1.0),
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.Container(
              padding: pw.EdgeInsets.all(8),
              child: pw.Column(
                children: invoiceData['data']['orderdata']['orderdata']
                    .map<pw.Widget>((order) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Member Details
                      pw.Text(
                        "${order['memberdetails']['name']} | ${order['memberdetails']['gender']} | ${order['memberdetails']['relation']}",
                        style: pw.TextStyle(
                          color:
                              const PdfColor.fromInt(0xFFFF0000), // Red color
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      pw.Divider(thickness: 0.5), // Thin divider below name

                      // Item Details
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "${order['item_name']}",
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: const PdfColor.fromInt(
                                  0xFF333333), // Dark Gray color
                            ),
                          ),
                          pw.Text(
                            "${order['price']}/-",
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor.fromInt(
                                  0xFF333333), // Dark Gray
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8), // Space between rows
                    ],
                  );
                }).toList(),
              ),
            ),

            // Total Amount Section
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("TOTAL AMOUNT",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("${invoiceData['data']['orderdata']['final_total']}/-",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("DISCOUNT",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    "${invoiceData['data']['orderdata']['wallet_discount']}/-",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("GRAND TOTAL",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("${invoiceData['data']['orderdata']['subtotal']}/-",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 20),

            // Additional Notes Section
            pw.Text(
              // "Amount Chargeable (in Words): Rupees Twelve Hundred Ninety Nine Only",
              "Amount Chargeable (in Words): Rupees ${NumberToWord().convert('en-in', invoiceData['data']['orderdata']['subtotal']).capitalizeFirst} Only",
              style: pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              "Company's PAN No.: AAGCR7195A",
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              "Please make Cheques in Favor of \"${AppConfig.companyName}\"",
              style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
            ),
            pw.SizedBox(height: 20),

            // Footer Notes
            pw.Text(
              "Important Notes:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Bullet(
                text:
                    "${AppConfig.companyName} is exempt from GST being a healthcare service provider."),
            pw.Bullet(
                text:
                    "This invoice can be used for tax exemption under section 80-D."),
            pw.Bullet(
                text:
                    "Reports sent on registered mail ID according to the respective TAT."),
            pw.Bullet(
                text:
                    "All disputes/claims concerning to reports are subject to ${AppConfig.legalJurisdiction}."),
            pw.SizedBox(height: 20),

            // Footer Line
            pw.Divider(),
            // pw.Row(
            //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            //   children: [
            //     pw.Text("support@example.com", style: pw.TextStyle(fontSize: 10)),
            //   ],
            // ),
            pw.Container(
              color: const PdfColor.fromInt(0xff005ba2),
              padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      AppConfig.supportPhone,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor(1.0, 1.0, 1.0), // White text
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      "support@example.com",
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor(1.0, 1.0, 1.0), // White text
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      AppConfig.websiteUrl,
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor(1.0, 1.0, 1.0), // White text
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    // Save the PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);

    print("PDF saved at: ${file.path}");
  }
}
