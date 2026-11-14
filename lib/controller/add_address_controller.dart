// ignore_for_file: deprecated_member_use

import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/controller/add_family_member_controller.dart';
import 'package:diagnostics_patient/controller/address_list_controller.dart';
import 'package:diagnostics_patient/controller/category_Controller.dart';
import 'package:diagnostics_patient/controller/home_visit_controller.dart';
import 'package:diagnostics_patient/controller/near_by_lab_controller.dart';
import 'package:diagnostics_patient/controller/popular_package_controller.dart';
import 'package:diagnostics_patient/controller/test_controller.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:location/location.dart' as lc;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/address_list_model.dart';
import '../Models/user_details_class.dart';
import '../utils/AllText.dart';
import '../utils/api.dart';
import '../utils/strings.dart';

class AddAddressController extends GetxController with WidgetsBindingObserver {
  final formKey = GlobalKey<FormState>();

  // final AddressModel? address;

  // AddAddressController({this.address});

  AddressModel address = AddressModel();

  AddFamilyMemberController addFamilyMemberController =
      Get.put(AddFamilyMemberController());
  HomeVisitController homeVisitController = Get.put(HomeVisitController());

  late GoogleMapController mapController;
  LatLng? center;
  BitmapDescriptor? pinLocationIcon;
  final Map<String, Marker> markers = {};
  bool isGoogleMapLoading = true;
  bool isDefaultAddress = true;
  bool isAddingAddress = false;
  bool isGettingManagersCity = false;
  UserDetailsClass userDetails = UserDetailsClass();
  String? selectedDropdownValue;
  String? selectedSlug;
  int? selectedCityPhone;

  TextEditingController tcAddress = TextEditingController();
  TextEditingController tcHouseNo = TextEditingController();
  TextEditingController tcState = TextEditingController();
  TextEditingController tcPincode = TextEditingController();
  TextEditingController tcCity = TextEditingController();
  TextEditingController tcCity1 = TextEditingController();
  TextEditingController tcPhone = TextEditingController();
  TextEditingController tcSaveAS = TextEditingController();
  TextEditingController tcLandmark = TextEditingController();
  TextEditingController tcApartment = TextEditingController();
  int id = 0;
  String postalCode = "";
  String userAddAddress = "";
  List<CityList> managerCityList = [];
  ManageCityModel? manageCityModel;
  int selectedIndex = 0;
  double? lat;
  double? long;

  /* double? pickCityLat;
  double? pickCityLong;
  String? pickCityName; */

  final List<String> options = ['Home', "Parent's", 'Spouse', 'Others'];
  Position? position;
  bool isLocationDialogOpen = true;

  bool? _lastServiceEnabled;
  LocationPermission? _lastPermission;

  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getUserDetails();
    init();
    _initLocationState();
  }

  Future<void> _initLocationState() async {
    _lastServiceEnabled = await Geolocator.isLocationServiceEnabled();
    _lastPermission = await Geolocator.checkPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      // Check if location state changed since last time
      bool locationStateChanged = (serviceEnabled != _lastServiceEnabled) ||
          (permission != _lastPermission);

      // Update stored values
      _lastServiceEnabled = serviceEnabled;
      _lastPermission = permission;

      // Only proceed if location state changed
      if (locationStateChanged) {
        log('Location state changed: service=$serviceEnabled, permission=$permission');

        if (serviceEnabled &&
            (permission == LocationPermission.always ||
                permission == LocationPermission.whileInUse)) {
          // Close any open permission dialog
          if (Get.isDialogOpen ?? false) Get.back();

          // Get updated position
          Position? position = await determinePosition();
          if (position != null) {
            center = LatLng(position.latitude, position.longitude);
            log('Resumed position: $center');
          } else {
            center = LatLng(defaultLat, defaultLng);
            log('Resumed: Using default city: $center');
          }

          // Only call getManagerCity if location became available
          await getManagerCity();
          update();
        } else {
          // center = LatLng(defaultLat, defaultLng);
          log('Location disabled or permission denied.');
          // await getManagerCity();
          // update();
          
        }
      } else {
        log('Location state unchanged. Skipping getManagerCity()');
      }
    }
  }

/* @override
void didChangeAppLifecycleState(AppLifecycleState state) async {
  if (state == AppLifecycleState.resumed) {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (serviceEnabled &&
        (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse)) {

      // Close any open permission dialog
      if (Get.isDialogOpen ?? false) Get.back();

      // Get updated position
      Position? position = await determinePosition();
      if (position != null) {
        center = LatLng(position.latitude, position.longitude);
        log('Resumed position: $center');
      } else {
        center = LatLng(defaultLat, defaultLng);
        log('Resumed: Using default city: $center');
      }

      // Call getManagerCity with updated center
      await getManagerCity();

      update(); 
    }
  }
} */

/* 
  init() async {
    tcSaveAS.text = 'Home';
    isGoogleMapLoading = true;
    update();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/pin.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    await getManagerCity();
    determinePosition();
    await getAddress();
    Future.delayed(Duration(seconds: 3), () async {
      await setData();
    });
  } */

  init() async {
    tcSaveAS.text = 'Home';
    isGoogleMapLoading = true;
    update();

    // Set custom pin
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/pin.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });

    // 1. Get the current position first
    position = await determinePosition();
    if (position != null) {
      center = LatLng(position!.latitude, position!.longitude);
      log('Init: Current position: $center');
    } else {
      center = LatLng(defaultLat, defaultLng);
      log('Init: Using default city: $center');
    }

    // 2. Call getManagerCity with current center
    await getManagerCity();

    // 3. Load saved address if any
    await getAddress();

    Future.delayed(Duration(seconds: 3), () async {
      await setData();
    });
  }

  setData() {
    try {
      if (address != null) {
        if (address.isDefault == 1) {
          isDefaultAddress = true;
        } else {
          isDefaultAddress = false;
        }
        tcAddress.text = address.address!;
        tcHouseNo.text = address.houseNo!;

        tcState.text = address.state!;
        tcPincode.text = address.pincode!;

        tcPhone.text = address.phone == null ? "" : address.phone!.toString();
        tcSaveAS.text = address.name != null ? address.name! : '';
        center = LatLng(address.lat!, address.long!);
        print('--- No ${tcHouseNo.text}');
        print('--- No2 ${address.houseNo!}');
      } else {}
    } catch (e) {
      print('Add address controller' + e.toString());
    }
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    update();
    print(data);
  }

  changeIsDefaultAddress() {
    isDefaultAddress = !isDefaultAddress;
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onMapTap(LatLng latLng) async {
    center = latLng;
    await getAddress();
    await locateMarker(latLng);
    update();
  }

  Future<Position?> determinePosition() async {
    try {
      lc.Location location = lc.Location();

      // Step 1: Check if location services are enabled
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          log("Location services are disabled.");
          // showPermissionDialog(); // Show the permission dialog
          return null;
        }
      }

      // Step 2: Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log("Location permission denied");
          // showPermissionDialog(); // Show the dialog if still denied
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log("Location permission denied forever");
        // showPermissionDialog(); // Ask user to open settings
        return null;
      }

      // Step 3: If permission granted, get location
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error in determinePosition(): $e');
      log("Error determining position: $e");
      return null;
    }
  }

  Future<void> showPermissionDialog() async {
    final prefs = await SharedPreferences.getInstance();
    bool alreadyShown = prefs.getBool('isLocationDialogOpen') ?? false;
    if (!alreadyShown && !(Get.isDialogOpen ?? false)) {
      await prefs.setBool('isLocationDialogOpen', true); // Mark dialog as open

      Get.defaultDialog(
        barrierDismissible: false,
        contentPadding: EdgeInsets.zero,
        backgroundColor: themeSecondaryColor,
        titlePadding: EdgeInsets.only(top: 20),
        title: Give_Location_Permission[LANGUAGE_TYPE],
        titleStyle: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            fontFamily: 'Gilroy'),
        radius: 10,
        content: WillPopScope(
          onWillPop: () async => false, // Disable back button
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  'We use your location to show labs and services available near you. This helps you quickly find the most relevant options in your area.',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Gilroy'),
                ),
              ),
              SizedBox(height: 20),
              // Retry button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await prefs.setBool('isLocationDialogOpen', false);

                      Get.back(); // Close the dialog
                      // await  determinePosition(); // Retry location check
                      Position? position = await determinePosition();
                      if (position != null) {
                        center = LatLng(position.latitude, position.longitude);
                      }
                    },
                    child: Container(
                      // height: 30,
                      child: Center(
                        child: Text(
                          Retry[LANGUAGE_TYPE],
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Gilroy'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Open Settings button
                  GestureDetector(
                    onTap: () async {
                      await prefs.setBool('isLocationDialogOpen', false);

                      await Geolocator.openAppSettings();
                      await Geolocator.openLocationSettings();

                      // Wait 3-4 seconds to allow user to turn on location and come back
                      await Future.delayed(Duration(seconds: 4));

                      bool isLocationEnabled =
                          await lc.Location().serviceEnabled();
                      LocationPermission permission =
                          await Geolocator.checkPermission();

                      if (!isLocationEnabled ||
                          permission == LocationPermission.denied ||
                          permission == LocationPermission.deniedForever) {
                        // showPermissionDialog(); // Still no permission/service, show again
                      } else {
                        if (Get.isDialogOpen ?? false)
                          Get.back(); // Close dialog

                        Position? position = await determinePosition();
                        if (position != null) {
                          center =
                              LatLng(position.latitude, position.longitude);
                        }
                      }
                    },
                    child: Container(
                      // height: 50,
                      // width: 220,
                      child: Center(
                        child: Text(
                          Open_Setting[LANGUAGE_TYPE],
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Gilroy'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
  }

  String? cityName;
  String? branchName;

  /*  Future getAddress() async {
     if (center == null) {
      var position = await determinePosition();
      if (position != null) {
        center = LatLng(position.latitude, position.longitude);
      }
    }
    // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(center!.latitude, center!.longitude);
    Placemark place = placemarks[0];
    print("place $place");
    // String _address = '${place.street},${place.postalCode},${place.subLocality},${place.locality},${place.administrativeArea},${place.country}';
    String _address =
        "${place.name!.trim()}, ${place.locality}, ${place.street}, ${place.subAdministrativeArea}, ${place.postalCode}";
    // String _address = '${place.subLocality} ${place.locality}, ${place.administrativeArea}, ${place.country}';
    // tcAddress.text = _address;
    locateMarker(center!);
    isGoogleMapLoading = false;

    tcState.text = place.administrativeArea!;
    // tcPincode.text = place.postalCode!;
    tcCity.text = place.locality!;

    addFamilyMemberController.cityController.text = place.locality!;
    addFamilyMemberController.stateController.text = place.administrativeArea!;
    addFamilyMemberController.pinCodeController.text = place.postalCode!;
    print(addFamilyMemberController.cityController.text);

    homeVisitController.stateController.text = place.administrativeArea!;
    homeVisitController.pinCodeController.text = place.postalCode!;
    homeVisitController.tcAddress.text = _address;
    homeVisitController.cityController.text = place.locality!;
    branchName = place.locality;

    address.address = _address;
    address.city = place.locality;
    address.lat = center!.latitude;
    address.long = center!.longitude;

    // address.state = place.subAdministrativeArea.

    update();
  } */
  Future getAddress() async {
    try {
      if (center == null) {
        try {
          var position = await determinePosition();
          if (position != null) {
            center = LatLng(position.latitude, position.longitude);
          } else {
            center = LatLng(defaultLat, defaultLng);
          }
        } catch (e) {
          // timeout or permission issue
          center = LatLng(defaultLat, defaultLng);
          print("determinePosition() failed, using default location: $e");
        }
        update();
      }

      // Reverse-geocode
      List<Placemark> placemarks = [];
      try {
        placemarks = await placemarkFromCoordinates(
          center!.latitude,
          center!.longitude,
        ).timeout(const Duration(seconds: 5));
      } catch (e) {
        print("Reverse geocode failed: $e — using default address.");
        placemarks = [
          Placemark(
            name: AppConfig.defaultCityName,
            locality: AppConfig.defaultCityName,
            administrativeArea: '',
            postalCode: '',
            subAdministrativeArea: AppConfig.defaultCityName,
            street: '',
          )
        ];
      }

      //  Use first placemark
      final place = placemarks.isNotEmpty
          ? placemarks.first
          : Placemark(locality: AppConfig.defaultCityName);
      print("Place: $place");

      final _address = "${place.name?.trim() ?? ''}, "
          "${place.locality ?? ''}, "
          "${place.street ?? ''}, "
          "${place.subAdministrativeArea ?? ''}, "
          "${place.postalCode ?? ''}";

      locateMarker(center!);
      isGoogleMapLoading = false;

      tcState.text = place.administrativeArea ?? '';
      tcCity.text = place.locality ?? '';

      addFamilyMemberController.cityController.text = place.locality ?? '';
      addFamilyMemberController.stateController.text =
          place.administrativeArea ?? '';
      addFamilyMemberController.pinCodeController.text = place.postalCode ?? '';

      homeVisitController.stateController.text = place.administrativeArea ?? '';
      homeVisitController.pinCodeController.text = place.postalCode ?? '';
      homeVisitController.tcAddress.text = _address;
      homeVisitController.cityController.text = place.locality ?? '';
      branchName = place.locality ?? '';

      address.address = _address;
      address.city = place.locality ?? '';
      address.lat = center!.latitude;
      address.long = center!.longitude;

      update();
    } catch (e, s) {
      print("getAddress() error: $e");
      print(s);
      center = LatLng(defaultLat, defaultLng);
    }
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  locateMarker(LatLng latLng) async {
    final Uint8List markIcons = await getImages("assets/pin.png", 150);
    final marker = Marker(
      draggable: true,
      alpha: 1,
      // anchor: Offset(0.5,0.5),
      markerId: const MarkerId("curr_loc"),
      position: latLng,
      infoWindow: InfoWindow(title: Your_Location[LANGUAGE_TYPE]),
      // icon: pinLocationIcon!,
      icon: BitmapDescriptor.fromBytes(markIcons),
    );
    markers["Current Location"] = marker;
    update();
  }

  getManagerCity({bool isEdit = false, addressId}) async {
    log("Getting manager city...");
    isGettingManagersCity = true;
    update();

    try {
      /*    final response = await http.get(Uri.parse(baseUrl +
          "$getCity" +
          '?lat=${center!.latitude}&lng=${center!.longitude}')); */


      final double lat = center?.latitude ?? defaultLat;
      final double lng = center?.longitude ?? defaultLng;

      final response = await http.get(
        Uri.parse('$baseUrl$getCity?lat=$lat&lng=$lng'),
      );
      log("API: ${Uri.parse(baseUrl + "$getCity" + '?lat=$lat&lng=$lng')}");
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log("json response-----------$jsonResponse");
        if (jsonResponse['status'] == 1) {
          manageCityModel = ManageCityModel.fromJson(jsonResponse);
          if (address.city == '') {
            // if( manageCityModel!.data != null && manageCityModel!.data!.length > 0  && manageCityModel!.data!.where((element) => element.name == address!.city).toList()  != null && manageCityModel!.data!.where((element) => element.name == address!.city).toList().length > 0 ){
            //   tcCity.text = address.
            // }
            tcCity.text = manageCityModel!.data![0].city!;
            id = manageCityModel!.data![0].id!;
            selectedDropdownValue = manageCityModel!.data!.isNotEmpty
                ? manageCityModel!.data![0].city
                : null;
            log(" asdda   ${manageCityModel!.data![0].status}");

            update();
          } else {
            log("Else ${address.city ?? "No City"}");

            for (int i = 0; i < manageCityModel!.data!.length; i++) {
              log("For i $i");
              log('====');

              if (manageCityModel!.data![i].city!.toLowerCase() ==
                  address.city?.toLowerCase()) {
                log(manageCityModel!.data![i].city.toString());
                log("askdn" + manageCityModel!.data![i].status.toString());

                tcCity.text = manageCityModel!.data![i].city!;
                selectedDropdownValue = manageCityModel!.data!.isNotEmpty
                    ? manageCityModel!.data![i].city
                    : null;
                selectedSlug = manageCityModel!.data!.isNotEmpty
                    ? manageCityModel!.data![i].slug
                    : null;

                if (manageCityModel!.data != null) {
                  center = LatLng(manageCityModel!.data![i].lat,
                      manageCityModel!.data![i].lng!);
                  selectedCityPhone = manageCityModel!.data![i].phone;
                }

                update();
              } else {
                tcCity.text = manageCityModel!.data![0].city!;
                id = manageCityModel!.data![0].id!;
                selectedDropdownValue = manageCityModel!.data!.isNotEmpty
                    ? manageCityModel!.data![0].city
                    : null;
                selectedSlug = manageCityModel!.data!.isNotEmpty
                    ? manageCityModel!.data![0].slug
                    : null;
                if (manageCityModel!.data != null) {
                  center = LatLng(manageCityModel!.data![0].lat,
                      manageCityModel!.data![0].lng!);
                }
                selectedCityPhone = manageCityModel!.data![0].phone;
                update();
              }
            }
            String cityData = '''
                CITY NAME :: $selectedDropdownValue
                CITY LAT :: ${center!.latitude}
                CITY LNG :: ${center!.longitude}
                ''';
            log("CITY DATA :: $cityData");
            await Get.find<NearByLabController>().resetAndFetch(
              lat: center!.latitude,
              lng: center!.longitude,
              slug: selectedSlug,
              cityName: selectedDropdownValue,
            );
            await Get.find<CategoryController>()
                .getSuggestionList(cityName: selectedDropdownValue);

            await Get.find<CategoryController>().getCategory(
              false,
              cityName: selectedDropdownValue,
              lat: center!.latitude,
              lng: center!.longitude,
            );
            await Get.find<PopularPackageController>().getPopularPackage(
              cityName: selectedDropdownValue,
              lat: center!.latitude,
              lng: center!.longitude,
            );
            await Get.find<TestController>().getTest(
              cityName: selectedDropdownValue,
              lat: center!.latitude,
              lng: center!.longitude,
            );
          }

          isGettingManagersCity = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          isGettingManagersCity = false;
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {

      isGettingManagersCity = false;
      update();
    }
  }



  addAddress({bool isEdit = false, addressId}) async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    isAddingAddress = true;
    update();
    print('=======================>$userDetails');
    int isDefaultInt;
    if (isDefaultAddress) {
      isDefaultInt = 1;
    } else {
      isDefaultInt = 0;
    }

    var _body;


    Map<String, String> body = {
      'id': isEdit ? addressId.toString() : "0",
      'user_id': userDetails.userId.toString(),
      'name': tcSaveAS.text,
      'house_no': tcHouseNo.text,
      'pincode': postalCode.isNotEmpty ? postalCode : '302001',
      'city': id.toString(),
      'state': tcState.text,
      'is_default': isDefaultInt.toString(),
      'address': tcAddress.text,
      'lat': lat.toString(),
      'long': long.toString(),
      'phone_no': tcPhone.text ?? '',
      'apartment': tcApartment.text,
      'landmark': tcLandmark.text,
    };
    print("_body $body");
    print(Uri.parse(baseUrl + "$saveAddress"));
    try {
      final response =
          await http.post(Uri.parse(baseUrl + "$saveAddress"), body: body);
      print('--- Save Address: ${Uri.parse(baseUrl + "$saveAddress")}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("json response-----------$jsonResponse");

        if (jsonResponse['status'] == 1) {
          await Get.put(AddressListController()).AddressList();
          Get.back(result: true);
          Get.back(result: true);
          // Get.back(result: true);
          Get.snackbar(
            "Success",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
          isAddingAddress = false;

          update();
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          isAddingAddress = false;
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      Get.snackbar(
        "Failed to load Data",
        "Something went wrong. Try again,",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      isAddingAddress = false;
      update();
    }
  }

  void changeCity(String? value) {
    print("value $value");
    int ind =
        manageCityModel!.data!.indexWhere((element) => element.city == value);
    print(ind);
    id = manageCityModel!.data![ind].id!;
    print("id $id");
    tcCity.text = value!;
    update();
  }

  void changeCityAddress(String? value) {
    print("value $value");
    int ind =
        manageCityModel!.data!.indexWhere((element) => element.name == value);
    print(ind);
    id = manageCityModel!.data![ind].id!;
    print("id $id");
    tcCity1.text = value!;
    update();
  }

  Future<void> fetchData({
    required String slug,
    required String value,
    required double lat,
    required double lng,
    String? message,
  }) async {
    final nearByLabController = Get.find<NearByLabController>();
    final categoryListController = Get.find<CategoryController>();
    final packageListController = Get.find<PopularPackageController>();
    final testController = Get.find<TestController>();
    // Show the loader
    showLoadingMsg(
      context: Get.context!,
      title: 'Please Wait...',
      msg: message ??
          'We are fetching the latest data. This may take a few moments.',
    );

    try {
      // Call all the APIs
      // Reset page and labList before fetching data
      await Future.wait([
        nearByLabController.resetAndFetch(       // ← page/labList reset internally
          lat: center!.latitude,
          lng: center!.longitude,
          slug: slug,
          cityName: value,
        ),
        categoryListController.getCategory(
          false,
          cityName: value,
          lat: lat,
          lng: lng,
        ),
        categoryListController.getBannerList(),
        categoryListController.getSuggestionList(cityName: value),
        packageListController.getPopularPackage(
          cityName: value,
          lat: lat,
          lng: lng,
        ),
        testController.getTest(
          cityName: value,
          lat: lat,
          lng: lng,
        ),
      ]);

      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  @override
  void onClose() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
      SystemNavigator.pop();
      // isLocationDialogOpen = false;
    }
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void dispose() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
      SystemNavigator.pop();
      // isLocationDialogOpen = false;
    }
    super.dispose();
  }
}
