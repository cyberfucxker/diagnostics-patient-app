// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:diagnostics_patient/Models/lab_model.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/utils/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NearByLabController — optimized, pagination-safe, backward-compat
// ─────────────────────────────────────────────────────────────────────────────
class NearByLabController extends GetxController {

  // ── Public state (UI + other controllers read these) ─────────────────────
  LabModel?          nearByLab;
  List<LabModelList> labList          = [];
  LatLng?            center;

  bool isLoading           = false; // first-page shimmer
  bool isPaginationLoading = false; // bottom-of-list dot loader
  bool isAllDataLoaded     = false; // no more pages
  bool isMoreDataAvailable = false; // backward-compat flag
  bool hasError            = false; // first-page error state

  // ── Backward-compat getter/setter for `page`  ─────────────────────────────
  // AddAddressController used to do: nearByLabController.page = 1
  // Now it should call resetAndFetch() instead, but we keep the setter
  // so OLD code won't break during migration.
  int get page => _page;
  set page(int v) => _page = v; // kept for backward compat

  // ── Internal ─────────────────────────────────────────────────────────────
  int  _page       = 1;
  bool _isFetching = false; // hard guard — prevents duplicate API calls

  bool isCallDeterminePosition = false;

  // ── Cached search params (set on first call, reused by pagination) ────────
  double? _cachedLat;
  double? _cachedLng;
  String? _cachedSlug;
  String? _cachedCityName;

  final ScrollController scrollController = ScrollController();

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _init();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.onClose();
  }

  // ── Init (mirrors original onInit logic exactly) ─────────────────────────
  Future<void> _init() async {
    if (isCallDeterminePosition) {
      log('NearByLabController: calling determinePosition');
      await Get.put(AddAddressController()).determinePosition();
    }
    final addrCtrl = Get.put(AddAddressController());
    await getLabList(
      lat: addrCtrl.center?.latitude,
      lng: addrCtrl.center?.longitude,
    );
    // paginateTask() replaced by _onScroll listener added in onInit
  }

  // ── Scroll listener — fires 200 px before list end ───────────────────────
  void _onScroll() {
    if (!scrollController.hasClients) return;
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    if (_isFetching)     return;
    if (isAllDataLoaded) return;
    if (isLoading)       return;
    _fetchPage(isFirstPage: false);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC — used by AddAddressController (fetchData + getManagerCity)
  //
  //  MIGRATION PATH:
  //    OLD:  nearByLabController.page = 1;
  //          nearByLabController.labList = [];
  //          await nearByLabController.getLabList(lat, lng, slug, city);
  //
  //    NEW:  await nearByLabController.resetAndFetch(lat, lng, slug, city);
  //
  //  Both work — old pattern still compiles via the `page` setter above.
  // ─────────────────────────────────────────────────────────────────────────

  /// One-shot: resets pagination + fetches first page.
  /// Use this instead of manually setting page/labList from outside.
  Future<void> resetAndFetch({
    double? lat,
    double? lng,
    String? slug,
    String? cityName,
  }) async {
    if (_isFetching) return;
    if (lat      != null) _cachedLat      = lat;
    if (lng      != null) _cachedLng      = lng;
    if (slug     != null) _cachedSlug     = slug;
    if (cityName != null) _cachedCityName = cityName;
    _resetPagination();
    await _fetchPage(isFirstPage: true);
  }

  /// Original public method — kept for full backward compat.
  /// Internally delegates to resetAndFetch when called from outside,
  /// or to _loadNextPage when called by scroll (isFirstPage=false).
  Future<void> getLabList({
    double? lat,
    double? lng,
    String? slug,
    String? cityName,
  }) async {
    await resetAndFetch(
      lat: lat,
      lng: lng,
      slug: slug,
      cityName: cityName,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC — pull-to-refresh
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> refreshList() async {
    if (_isFetching) return;
    _resetPagination();
    await _fetchPage(isFirstPage: true);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CORE FETCH
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _fetchPage({required bool isFirstPage}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (isFirstPage) {
      isLoading = true;
      hasError  = false;
    } else {
      isPaginationLoading = true;
      isMoreDataAvailable = true;
    }
    update();

    try {
      final uri = Uri.parse('${baseUrl}get_lab');

      /* Original requestBody structure — preserved exactly */
      final Map<String, dynamic> requestBody = {
        'city': _cachedCityName ?? defaultCityName,
        'lat':  _cachedLat     ?? defaultLat,
        'lng':  _cachedLng     ?? defaultLng,
        'slug': _cachedSlug    ?? defaultSlug,
        'page': _page,
      };

      /* Original alternate body (commented out in source) — kept as-is
      Map<String, dynamic> requestBody = {};
      if (cityName != null) requestBody['city'] = cityName;
      if (lat != null) requestBody['lat'] = lat;
      if (lng != null) requestBody['lng'] = lng;
      if (slug != null) requestBody['slug'] = slug; */

      final jsonBody = jsonEncode(requestBody);

      log('--- API getLabList:: $uri');
      log('--- API getLabList jsonBody:: $jsonBody');

      final response = await http
          .post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (jsonResponse['status'] == 1) {
          nearByLab = LabModel.fromJson(jsonResponse);
          final newItems = nearByLab?.data ?? [];

          if (newItems.isNotEmpty) {
            labList = isFirstPage
                ? List.from(newItems)
                : [...labList, ...newItems];
            _page++;                      // advance only on success
            isMoreDataAvailable = true;
            hasError = false;
          } else {
            // Empty page → all data loaded
            isAllDataLoaded     = true;
            isMoreDataAvailable = false;
          }
        } else {
          // status != 1
          // Get.snackbar("Error", "data not found", ...); // commented in original
          if (isFirstPage) hasError = true;
          isAllDataLoaded     = true;
          isMoreDataAvailable = false;
          log('NearByLabController: status != 1 → ${jsonResponse['message']}');
        }
      }
    } catch (e) {
      log('NearByLabController error: $e');
      if (isFirstPage) {
        hasError = true;
      } else {
        // Pagination error — keep old list visible, show snackbar
        Get.snackbar(
          'Failed to load Data',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: redColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      _isFetching         = false;
      isLoading           = false;
      isPaginationLoading = false;
      update();
    }
  }

  // ── Reset helper ─────────────────────────────────────────────────────────
  void _resetPagination() {
    _page               = 1;
    labList             = [];
    nearByLab           = null;
    isAllDataLoaded     = false;
    isMoreDataAvailable = false;
    hasError            = false;
  }
}