import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:diagnostics_patient/Models/address_list_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';

class LocationScreen extends StatefulWidget {
  final bool? isEdit;
  final AddressModel? address;
  final bool? isAddressShowCity;
  final bool? isAddressShowdroup;

  const LocationScreen({
    super.key,
    this.isEdit,
    this.address,
    this.isAddressShowCity,
    this.isAddressShowdroup,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

// ✅ FIX: Controller ko global scope se hataya — ab Get.find() direct
//    State class ke andar hoga, lifecycle safe rahega.

class _LocationScreenState extends State<LocationScreen> {
  late final AddAddressController locationController;
  final width = MediaQuery.of(Get.context!).size.width;

  @override
  void initState() {
    super.initState();

    locationController = Get.find<AddAddressController>();

    // ✅ MAIN FIX: Edit mode mein address model ka data fields mein prefill karo.
    //    Pehle ye sirf blank set hota tha (caller mein tcHouseNo.text = ''),
    //    ab existing data aa jaayega bottom sheet open hone se pehle.
    if (widget.isEdit == true && widget.address != null) {
      final addr = widget.address!;

      // House / flat number
      locationController.tcHouseNo.text = addr.houseNo ?? '';

      // ✅ FIX: apartment aur landmark ab model ke dedicated fields se aate hain
      //    Pehle address field se map hota tha jo galat tha
      locationController.tcApartment.text = addr.apartment ?? '';
      locationController.tcLandmark.text  = addr.landmark  ?? '';

      // Save As chip — name field se match karo (Home / Work / Other)
      final savedAs = addr.name ?? 'Home';
      locationController.tcSaveAS.text = savedAs;
      final idx = locationController.options
          .indexWhere((o) => o.toLowerCase() == savedAs.toLowerCase());
      locationController.selectedIndex = idx >= 0 ? idx : 0;

      // Map center — saved lat/long pe le jaao
      if (addr.lat != null && addr.long != null) {
        locationController.center = LatLng(addr.lat!, addr.long!);
      }

      // Address text field bhi prefill karo
      locationController.tcAddress.text = addr.address ?? '';

      locationController.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialPosition = locationController.center != null
        ? LatLng(
      locationController.center!.latitude,
      locationController.center!.longitude,
    )
        : LatLng(defaultLat, defaultLng);

    log('--- initialPosition: $initialPosition');

    return Scaffold(
      body: PlacePicker(
        apiKey: googleApiKey,
        hintText: "Find a place ...",
        searchingText: "Please wait ...",
        selectText: "Enter Complete Address",
        initialPosition: initialPosition,
        useCurrentLocation: true,
        selectInitialPosition: true,
        usePinPointingSearch: true,
        usePlaceDetailSearch: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        ignoreLocationPermissionErrors: true,
        pinBuilder: (context, state) {
          return Image.asset('assets/marker1.png');
        },

        // ── Bottom card shown on map ──────────────────────────────────
        selectedPlaceWidgetBuilder:
            (context, selectedPlace, state, isSearchBarFocused) {
          final address = selectedPlace?.formattedAddress ?? '';
          // ✅ FIX: selectedPlace ya addressComponents null ho sakta
          //    hai — chain null-safety se access karo.
          final shortName =
          (selectedPlace?.addressComponents?.isNotEmpty == true)
              ? (selectedPlace?.addressComponents?[0].shortName ?? '')
              : '';

          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const Text(
                      'Select Pick Up Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Location name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_rounded,
                            color: themeColor, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            shortName ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Full address
                    Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ FIX: selectedPlace null check — map loading ya
                    //    pin settle na ho tab null crash hota tha.
                    //    Force unwrap (!) hataya, null guard lagaya.
                    customeElevatedButton(
                      double.infinity,
                      'Enter Complete Address',
                      callback: () {
                        if (selectedPlace == null) return;
                        _handlePlaceSelected(context, selectedPlace);
                      },
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          );
        },

        onPlacePicked: (PickResult result) {
          _handlePlaceSelected(context, result);
        },
        onTapBack: () => Get.back(),
      ),
    );
  }

  // ── Place selected — update lat/long/address then open bottom sheet ───────
  void _handlePlaceSelected(BuildContext context, PickResult result) {
    String? postalCode;
    for (final component in result.addressComponents ?? []) {
      if (component.types.contains('postal_code')) {
        postalCode = component.longName;
        break;
      }
    }

    // ✅ FIX: Edit mode mein naya place select karne pe sirf address/lat/long
    //    update hoga — houseNo, apartment, landmark wahi rahenge jo initState
    //    mein prefill kiye the. User ne map pe koi naya pin nahi daala toh
    //    uske fields waise hi rahenge.
    //
    //    Agar user ne naya location select kiya toh address update hoga,
    //    baaki detail fields waise hi rahenge (user manually change kar sakta).
    locationController
      ..tcAddress.text = result.formattedAddress ?? ''
      ..lat = result.geometry!.location.lat
      ..long = result.geometry!.location.lng
      ..postalCode = postalCode ?? '';

    // ✅ FIX: Sirf non-edit mode mein hi apartment/landmark blank karein.
    //    Edit mode mein initState ke prefilled values rahne dein.
    if (widget.isEdit != true) {
      locationController
        ..selectedIndex = 0
        ..tcApartment.text = ''
        ..tcLandmark.text = '';
    }

    log('--- tcAddress: ${locationController.tcAddress.text}');

    _showBottomSheet(context, result);
  }

  // ── Bottom Sheet ──────────────────────────────────────────────────────────
  void _showBottomSheet(BuildContext context, PickResult result) {
    // Postal code extract (idempotent — already done in _handlePlaceSelected)
    for (final component in result.addressComponents ?? []) {
      if (component.types.contains('postal_code')) {
        locationController.postalCode = component.longName;
        break;
      }
    }
    log('Postal Code: ${locationController.postalCode}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Handle ──────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const Text(
                    'Enter Complete Address',
                    style:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const Divider(height: 20),

                  // ── Selected address preview ─────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 18, color: Colors.pinkAccent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.addressComponents?.isNotEmpty == true
                                  ? result.addressComponents![0].shortName
                                  : '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              result.formattedAddress ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  // ── Save As chips ────────────────────────────────────
                  textFildHeader('Save As*', width),
                  const SizedBox(height: 8),
                  GetBuilder<AddAddressController>(
                    builder: (addCtrl) => Wrap(
                      spacing: 8,
                      children: List.generate(
                        locationController.options.length,
                            (i) => ChoiceChip(
                          label: Text(locationController.options[i]),
                          selected: locationController.selectedIndex == i,
                          onSelected: (_) {
                            locationController.selectedIndex = i;
                            locationController.tcSaveAS.text =
                            locationController.options[i];
                            locationController.update();
                          },
                          selectedColor: Colors.cyan[100],
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: locationController.selectedIndex == i
                                  ? Colors.cyan
                                  : Colors.grey,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: locationController.selectedIndex == i
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Form fields (ab prefilled honge edit mode mein) ──
                  Form(
                    key: locationController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('HOUSE NO./FLAT NO.*'),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: locationController.tcHouseNo,
                          validator: (v) => (v?.isEmpty ?? true)
                              ? 'Please enter house/flat number'
                              : null,
                        ),

                        const SizedBox(height: 12),
                        _fieldLabel('APARTMENT/BUILDING NAME/COLONY*'),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: locationController.tcApartment,
                          validator: (v) => (v?.isEmpty ?? true)
                              ? 'Please enter apartment/colony name'
                              : null,
                        ),

                        const SizedBox(height: 12),
                        _fieldLabel('LANDMARK*'),
                        const SizedBox(height: 5),
                        _buildTextField(
                          controller: locationController.tcLandmark,
                          validator: (v) => (v?.isEmpty ?? true)
                              ? 'Please enter landmark'
                              : null,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Save / Update button ─────────────────────────────
                  GetBuilder<AddAddressController>(
                    builder: (addCtrl) => addCtrl.isAddingAddress
                        ? const Center(
                        child: CircularProgressIndicator(
                            color: themeColor))
                        : customeElevatedButton(
                      double.infinity,
                      widget.isEdit == true
                          ? Update[LANGUAGE_TYPE]
                          : Save[LANGUAGE_TYPE],
                      callback: () async {
                        if (locationController
                            .formKey.currentState!
                            .validate()) {
                          if (widget.isEdit == true) {
                            await locationController.addAddress(
                              isEdit: true,
                              addressId: widget.address!.id,
                            );
                          } else {
                            locationController.addAddress();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Shared field widgets ──────────────────────────────────────────────────
  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        color: subTextColor,
        fontFamily: 'Regular',
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Regular',
        fontSize: 14,
        color: blackColor,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}