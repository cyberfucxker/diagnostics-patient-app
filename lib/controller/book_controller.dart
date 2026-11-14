import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/book_models.dart';
import '../Models/user_details_class.dart';
import '../utils/api.dart';
import '../utils/colors.dart';
import '../widgets/custom_snackbar.dart';

enum BookListFilterENUM { today, upcoming, past }

// ─────────────────────────────────────────────────────────────────────────────
// BookController — optimized: no duplicate calls, proper pagination guard
// ─────────────────────────────────────────────────────────────────────────────
class BookController extends GetxController {

  // ── State ─────────────────────────────────────────────────────────────────
  int  currentTabIndex = 0;
  bool isLoading       = true;   // first-page shimmer
  bool isListLoading   = false;  // pagination dot loader
  int  currentPage     = 1;

  List<OrderData>? orderData  = [];
  BookListModel?   bookListModel;

  // Kept for backward compat (screen used these)
  bool isFirstLoading  = false;
  bool isSecondLoading = true;
  bool isThirdLoading  = true;

  BookListFilterENUM bookListFilterENUM = BookListFilterENUM.today;
  int selectedType   = 4; // 1=past, 2=upcoming, 3=today, 4=all
  int selectedStatus = 1; // 1=all, 2=pending, 4=reject

  UserDetailsClass userDetails = UserDetailsClass();

  // ── Scroll ────────────────────────────────────────────────────────────────
  final ScrollController scrollController = ScrollController();

  // ── Guard — prevent duplicate API calls ───────────────────────────────────
  bool _isFetching = false;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    reloadAllList();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.onClose();
  }

  // ── Scroll threshold: 200px before end ───────────────────────────────────
  void _onScroll() {
    if (!scrollController.hasClients) return;
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    if (_isFetching)    return;
    if (!isListLoading) return; // no more pages
    if (isLoading)      return; // first page still loading
    allListFetch();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC — filter change
  // ─────────────────────────────────────────────────────────────────────────
  void changeFilter(dynamic value) {
    if (value == BookListFilterENUM.upcoming) {
      selectedType = 2;
    } else if (value == BookListFilterENUM.past) {
      selectedType = 1;
    } else if (value == BookListFilterENUM.today) {
      selectedType = 3;
    }
    bookListFilterENUM = value;
    reloadAllList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC — tab change
  // ─────────────────────────────────────────────────────────────────────────
  void changeTabIndex(int value) {
    currentTabIndex = value;
    switch (value) {
      case 0:
        selectedStatus = 1;
        isFirstLoading = false; isSecondLoading = true; isThirdLoading = true;
        break;
      case 1:
        selectedStatus = 2;
        isFirstLoading = true; isSecondLoading = false; isThirdLoading = true;
        break;
      case 2:
        selectedStatus = 4;
        isFirstLoading = true; isSecondLoading = true; isThirdLoading = false;
        break;
    }
    reloadAllList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PUBLIC — reset + reload
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> reloadAllList() async {
    // Force reset even if fetching — tab change needs fresh data
    _isFetching   = false;
    currentPage   = 1;
    isLoading     = true;
    isListLoading = true;
    orderData     = [];
    update();
    await allListFetch();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CORE FETCH
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> allListFetch() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      // Always fetch fresh user details
      userDetails = await UserDetailsClass().getUserDetails();

      final uri = Uri.parse(
        '$baseUrl$getBookList'
            '?user_id=${userDetails.userId}'
            '&type=$selectedType'
            '&status=$selectedStatus'
            '&page=$currentPage',
      );

      log('BookController ▶ GET $uri');
      final response = await http.get(uri)
          .timeout(const Duration(seconds: 15));

      log('BookController ◀ ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        if (json['status'] == 1) {
          // ── Safe parse — item-by-item, never crash on null ─────
          List<OrderData> newItems = [];
          final rawList =
              (json['data']?['data'] as List<dynamic>?) ?? [];

          for (final rawItem in rawList) {
            try {
              final raw = rawItem as Map<String, dynamic>;

              // ── Sanitize every String field before passing to fromJson ──
              // Replace null Strings with '' so fromJson never throws
              final safe = Map<String, dynamic>.from(raw);
              const stringFields = [
                'payment_method', 'time', 'date', 'status',
                'name', 'phone', 'email', 'address',
                'lab_name', 'city', 'state', 'pincode',
                'sampleboy_name', 'relation', 'gender',
              ];
              for (final key in stringFields) {
                if (safe.containsKey(key) && safe[key] == null) {
                  safe[key] = '';  // null → empty string
                }
              }

              // Sanitize nested sampleboy_details
              if (safe['sampleboy_details'] is Map) {
                final sb = Map<String, dynamic>.from(
                    safe['sampleboy_details'] as Map);
                for (final key in ['name', 'phone', 'email']) {
                  if (sb.containsKey(key) && sb[key] == null) {
                    sb[key] = '';
                  }
                }
                safe['sampleboy_details'] = sb;
              }

              newItems.add(OrderData.fromJson(safe));
            } catch (itemErr) {
              log('BookController: skipping item id=${rawItem is Map ? rawItem['id'] : '?'} → $itemErr');
            }
          }

          if (currentPage == 1) {
            orderData = List.from(newItems);
          } else {
            orderData?.addAll(newItems);
          }

          // Pagination — check raw json first, fallback to model
          final nextPage = json['data']?['next_page_url'];
          if (nextPage == null) {
            isListLoading = false;
          } else {
            currentPage++;
            isListLoading = true;
          }

          isLoading = false;
        } else {
          isLoading     = false;
          isListLoading = false;
          AppSnackbar.error(
            'Error',
            'Data not found',
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        isLoading     = false;
        isListLoading = false;
        log('BookController: HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('BookController error: $e');
      isLoading     = false;
      isListLoading = false;
      AppSnackbar.error(
        'Failed to load Data',
        'Something went wrong. Try again.',
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isFetching = false;
      update();
    }
  }

  // ── Backward compat helper ────────────────────────────────────────────────
  Future<void> getUserDetails() async {
    userDetails = await UserDetailsClass().getUserDetails();
    log('BookController: userId=${userDetails.userId}');
  }
}