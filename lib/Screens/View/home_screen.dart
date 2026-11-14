// ignore_for_file: deprecated_member_use

import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/themes/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/category_detail_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/package_details_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/parameter_details_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/popular_package_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/profile_details_screen.dart';
import 'package:diagnostics_patient/Screens/View/Reports/report_login_screen.dart';
import 'package:diagnostics_patient/Screens/View/lab_detail_screen.dart';
import 'package:diagnostics_patient/Screens/View/lifestyle_order_screen.dart';
import 'package:diagnostics_patient/Screens/View/near_by_lab.dart';
import 'package:diagnostics_patient/Screens/View/test_screen.dart';
import 'package:diagnostics_patient/Screens/call_back_screen.dart';
import 'package:diagnostics_patient/Screens/prescription_screen.dart';
import 'package:diagnostics_patient/Screens/test_detail_screen.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/category_Controller.dart';
import 'package:diagnostics_patient/controller/home_controller.dart';
import 'package:diagnostics_patient/controller/near_by_lab_controller.dart';
import 'package:diagnostics_patient/controller/popular_package_controller.dart';
import 'package:diagnostics_patient/controller/reportlogin_controller.dart';
import 'package:diagnostics_patient/controller/test_controller.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AddAddressController addAddressController;
  late CategoryController categoryListController;
  late NearByLabController nearByLabController;
  late PopularPackageController packageListController;
  late TestDetailController testDetailController;
  late TestController testController;
  late HomeController homeController;

  static String _displayStringForOption(String option) => option;

  @override
  void initState() {
    super.initState();

    // ✅ Controllers ek baar initialize
    addAddressController = Get.put(AddAddressController(), permanent: true);
    categoryListController = Get.put(CategoryController());
    nearByLabController = Get.put(NearByLabController());
    packageListController = Get.put(PopularPackageController());
    testDetailController = Get.put(TestDetailController());
    testController = Get.put(TestController());
    homeController = Get.put(HomeController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showUpgradeDialog(context);
      categoryListController.getCategory(false);
    });
  }

  Future<void> showUpgradeDialog(BuildContext context) async {
    final Upgrader upgrader = Upgrader(
      debugLogging: false,
      durationUntilAlertAgain: const Duration(milliseconds: 300),
    );
    await upgrader.initialize();
    if (upgrader.shouldDisplayUpgrade()) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return UpgradeAlert(
            upgrader: upgrader,
            showIgnore: false,
            showLater: false,
            barrierDismissible: false,
            shouldPopScope: () => false,
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            onUpdate: () => true,
            child: const SizedBox.shrink(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // ─── Header ───
                _buildHeader(),

                const SizedBox(height: 14),

                // ─── Search Bar ───
                _buildSearchBar(),

                const SizedBox(height: 16),

                // ─── Banner ───
                _buildBanner(),

                const SizedBox(height: 16),

                // ─── Quick Action Buttons ───
                _buildQuickActions(),

                const SizedBox(height: 8),

                // ─── Action Cards (Prescription, CallBack, Reports, Phone) ───
                _buildActionCards(),

                const SizedBox(height: 16),

                // ─── Lifestyle Categories ───
                _buildLifestyleSection(),

                const SizedBox(height: 16),

                // ─── Nearby Labs ───
                _buildNearbyLabsSection(),

                const SizedBox(height: 16),

                // ─── Popular Packages ───
                _buildPopularPackagesSection(),

                const SizedBox(height: 16),

                // ─── Our Offers ───
                _buildOffersSection(),

                const SizedBox(height: 16),

                // ─── Popular Tests ───
                _buildPopularTestsSection(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/app_logo_wordmark.png', height: 28),
        _buildCityDropdown(),
      ],
    );
  }

  Widget _buildCityDropdown() {
    return GetBuilder<AddAddressController>(
      builder: (addController) {
        if (addController.manageCityModel?.data == null ||
            addController.manageCityModel!.data!.isEmpty) {
          return const SizedBox();
        }

        final cityItems = addController.manageCityModel!.data!
            .where((e) => e.city != null && e.city!.trim().isNotEmpty)
            .map((e) => e.city!.trim())
            .toSet()
            .toList();

        String? currentCity = addController.tcCity.text.trim();
        if (!cityItems.contains(currentCity)) {
          currentCity = cityItems.first;
        }

        return Container(
          // ✅ Max width fixed
          constraints: const BoxConstraints(maxWidth: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, color: themeColor, size: 14),
              const SizedBox(width: 4),
              // ✅ Flexible + isExpanded
              Flexible(
                child: DropdownButton<String>(
                  value: currentCity,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: themeColor, size: 16),
                  isDense: true,
                  menuMaxHeight: 300,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 13,
                    fontFamily: "Regular",
                  ),
                  items: cityItems.map((cityName) {
                    final label = addController.manageCityModel!.data!
                        .firstWhere((e) => e.city!.trim() == cityName);
                    return DropdownMenuItem<String>(
                      value: cityName,
                      enabled: label.status != 0,
                      child: Text(
                        cityName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color:
                          label.status == 0 ? Colors.grey : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    if (value == null) return;
                    final selectedItem = addController.manageCityModel!.data!
                        .firstWhere((e) => e.city?.trim() == value);

                    if (selectedItem.status == 0) {
                      AppSnackbar.warning(
                        'City Unavailable',
                        'This city is not available at the moment.',
                      );
                      return;
                    }

                    setState(() {
                      addController.selectedDropdownValue = value;
                      addController.tcCity.text = value;
                      addController.changeCity(value);
                    });

                    addController.selectedCityPhone = selectedItem.phone;
                    addController.update();

                    final lat = selectedItem.lat;
                    final lng = selectedItem.lng;
                    final slug = selectedItem.slug;
                    if (lat == null || lng == null || slug == null) return;

                    nearByLabController.page = 1;
                    nearByLabController.labList = [];

                    fetchData(
                      context,
                      slug: slug,
                      value: value,
                      lat: lat,
                      lng: lng,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // SEARCH BAR
  // ═══════════════════════════════════════════

  Widget _buildSearchBar() {
    return GetBuilder<CategoryController>(
      builder: (categController) {
        return Autocomplete<String>(
          displayStringForOption: _displayStringForOption,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return categoryListController.seggestionList
                .where((option) => option
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) async {
            await categoryListController.searchAPI(
              selection,
              cityName: addAddressController.selectedDropdownValue,
              lat: addAddressController.center!.latitude,
              lng: addAddressController.center!.longitude,
            );
            FocusScope.of(context).requestFocus(FocusNode());
            categoryListController.cSearch.clear();
          },
          fieldViewBuilder: (context, textEditingController, focusNode,
              onFieldSubmitted) {
            categoryListController.cSearch = textEditingController;
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: textEditingController,
                focusNode: focusNode,
                cursorColor: themeColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: themeColor, size: 22),
                  hintText: Search[LANGUAGE_TYPE],
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                    fontFamily: "Regular",
                  ),
                  suffixIcon: textEditingController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: Colors.grey.shade400),
                    onPressed: () {
                      textEditingController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  )
                      : null,
                ),
                onChanged: (_) => categoryListController.update(),
                onSubmitted: (value) async {
                  await categoryListController.searchAPI(
                    value,
                    cityName: addAddressController.selectedDropdownValue,
                    lat: addAddressController.center!.latitude,
                    lng: addAddressController.center!.longitude,
                  );
                  FocusScope.of(context).requestFocus(FocusNode());
                  textEditingController.clear();
                  Get.back();
                },
              ),
            );
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // BANNER
  // ═══════════════════════════════════════════

  Widget _buildBanner() {
    return GetBuilder<CategoryController>(
      builder: (catController) {
        if (catController.isLoading) {
          return _shimmerBox(height: 160, borderRadius: 16);
        }
        if (categoryListController.bannerModelList.isEmpty) {
          return const SizedBox();
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CarouselSlider(
            items: categoryListController.bannerModelList.map((banner) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                        '${AppConfig.hostUrl}public$banner'),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 160,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 600),
              autoPlayCurve: Curves.easeInOut,
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // QUICK ACTIONS (Tests / Labs / Packages)
  // ═══════════════════════════════════════════

  Widget _buildQuickActions() {
    return Row(
      children: [
        _quickActionTile(
          label: 'Tests',
          iconPath: 'assets/test_icon.svg',
          bgColor: const Color(0xffEEE5FF),
          onTap: () => Get.to(() => TestScreen()),
        ),
        const SizedBox(width: 8),
        _quickActionTile(
          label: 'Labs',
          iconPath: 'assets/lab_icon.svg',
          bgColor: const Color(0xffE2F4FF),
          onTap: () => Get.to(() => NearByLabScreen()),
        ),
        const SizedBox(width: 8),
        _quickActionTile(
          label: 'Packages',
          iconPath: 'assets/tip_icon.svg',
          bgColor: const Color(0xffFFEAFD),
          onTap: () => Get.to(() => PopularPackageScreen()),
        ),
      ],
    );
  }

  Widget _quickActionTile({
    required String label,
    required String iconPath,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(iconPath, height: 18, width: 18),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy',
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // ACTION CARDS
  // ═══════════════════════════════════════════

  Widget _buildActionCards() {
    return Column(
      children: [
        Row(
          children: [
            _actionCard(
              label: 'Upload Prescription',
              icon: null,
              imagePath: 'assets/prescription.png',
              bgColor: Colors.teal.shade100,
              onTap: () => Get.to(() => PrecriptionScreen()),
            ),
            const SizedBox(width: 10),
            _actionCard(
              label: 'Request a Callback',
              icon: Icons.call_rounded,
              bgColor: const Color(0xffEEE5FF),
              onTap: () => Get.to(() => CallBackScreen()),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _actionCard(
              label: 'Download Reports',
              icon: null,
              imagePath: 'assets/report.png',
              bgColor: const Color(0xff90c0fd),
              onTap: () {
                Get.put(ReportloginController()).phoneController.text = '';
                Get.put(ReportloginController()).otpController.text = '';
                Get.to(() => ReportLoginScreen());
              },
            ),
            const SizedBox(width: 10),
            GetBuilder<AddAddressController>(
              builder: (_) {
                if (_.selectedCityPhone == 0) return const Expanded(child: SizedBox());
                return _actionCard(
                  label: '+91-${_.selectedCityPhone}',
                  icon: Icons.call_rounded,
                  bgColor: const Color(0xffffc686),
                  onTap: () async {
                    final Uri phoneUri =
                    Uri(scheme: 'tel', path: '+91${_.selectedCityPhone}');
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionCard({
    required String label,
    IconData? icon,
    String? imagePath,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null)
                Image.asset(imagePath, height: 20)
              else if (icon != null)
                Icon(icon, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // SECTION HEADER
  // ═══════════════════════════════════════════

  Widget _sectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // LIFESTYLE / CATEGORY SECTION
  // ═══════════════════════════════════════════

  Widget _buildLifestyleSection() {
    return GetBuilder<CategoryController>(
      builder: (controller) {
        if (controller.isLoading) {
          return _buildHorizontalShimmer(height: 160, itemWidth: 150);
        }
        if (categoryListController.categoryModelList?.isEmpty ?? true) {
          return const SizedBox();
        }
        final list = categoryListController.categoryModelList!;
        final count = list.length >= 5 ? 5 : list.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              'Test by Lifestyle Disorder',
              onViewAll: () => Get.to(() => TestByLifeStyleOrderScreen()),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: count,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Get.to(() =>
                        CategoryDetailScreen(id: list[index].id!)),
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        right: index == count - 1 ? 0 : 0,
                        bottom: 8,
                        top: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppImages.defaultImage),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.network(
                              list[index].image,
                              height: 60,
                              width: 60,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              list[index].name.toString(),
                              style: const TextStyle(
                                fontFamily: "Bold",
                                color: Colors.white,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // NEARBY LABS SECTION
  // ═══════════════════════════════════════════

  Widget _buildNearbyLabsSection() {
    return GetBuilder<NearByLabController>(
      builder: (controller) {
        if (controller.isLoading) {
          return _buildHorizontalShimmer(height: 200, itemWidth: 240);
        }
        if (nearByLabController.labList?.isEmpty ?? true) {
          return const SizedBox();
        }
        final labs = nearByLabController.labList!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              'Nearby Laboratories',
              onViewAll: () {
                nearByLabController.isCallDeterminePosition = true;
                nearByLabController.update();
                Get.to(() => NearByLabScreen());
              },
            ),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: labs.length,
                itemBuilder: (context, index) {
                  final lab = labs[index];
                  return GestureDetector(
                    onTap: () =>
                        Get.to(() => LabDetailScreen(labModelList: lab)),
                    child: Container(
                      width: 240,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 10,
                        bottom: 10,
                        top: 4,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lab.name ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Gilroy',
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          _labInfoRow(
                              'assets/lab_phone.svg', lab.phone ?? '---'),
                          const SizedBox(height: 6),
                          _labInfoRow(
                              'assets/location.svg', lab.address ?? '',
                              maxLines: 2),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Image.asset('assets/distance.png',
                                  height: 15,
                                  width: 15,
                                  color: Colors.blueAccent),
                              const SizedBox(width: 6),
                              Text(
                                '${(lab.distance ?? 0).toStringAsFixed(1)} kms',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Gilroy',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _labInfoRow(String svgPath, String text, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: SvgPicture.asset(svgPath, height: 14, width: 14),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontFamily: 'Gilroy',
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // POPULAR PACKAGES SECTION
  // ═══════════════════════════════════════════

  Widget _buildPopularPackagesSection() {
    return GetBuilder<PopularPackageController>(
      builder: (controller) {
        if (controller.isLoading) {
          return _buildHorizontalShimmer(height: 180, itemWidth: 170);
        }
        if (packageListController.popularPackageModelList?.isEmpty ?? true) {
          return const SizedBox();
        }
        final list = packageListController.popularPackageModelList!;
        final count = list.length >= 5 ? 5 : list.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              'Popular Packages',
              onViewAll: () => Get.to(() => PopularPackageScreen()),
            ),
            SizedBox(
              height: 185,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: count,
                itemBuilder: (context, index) {
                  final pkg = list[index];
                  return GestureDetector(
                    onTap: () =>
                        Get.to(() => PackageDetailScreen(pkg.id)),
                    child: Container(
                      width: 170,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        bottom: 8,
                        top: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppImages.defaultImage),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pkg.name} (${pkg.noOfParameter})',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "Bold",
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                if (pkg.price != 0) ...[
                                  Flexible(
                                    child: Text(
                                      "₹${pkg.price}",
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 11,
                                        decoration:
                                        TextDecoration.lineThrough,
                                        decorationColor: Colors.red, // line color
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                  const Text(" / ",
                                      style:
                                      TextStyle(color: Colors.white70)),
                                ],
                                Text(
                                  "₹${pkg.mrp}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (pkg.discount.per != 0)
                                  _discountBadge('${pkg.discount.per}%'),
                              ],
                            ),
                            const Divider(color: Colors.white54, height: 12),
                            ...pkg.parameterList.take(4).map((e) => Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 1),
                              child: Row(
                                children: [
                                  const Icon(Icons.done,
                                      color: Colors.redAccent, size: 10),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      e.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // OFFERS SECTION
  // ═══════════════════════════════════════════

  Widget _buildOffersSection() {
    return GetBuilder<CategoryController>(
      builder: (controller) {
        if (controller.isLoading) {
          return _buildHorizontalShimmer(height: 150, itemWidth: 240);
        }
        if (categoryListController.offerModelList?.isEmpty ?? true) {
          return const SizedBox();
        }
        final offers = categoryListController.offerModelList!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Our Offers'),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return GestureDetector(
                    onTap: () {
                      if (offer.type == 'Parameter') {
                        Get.to(() => ParameterDetailScreen(offer.typeId));
                      } else if (offer.type == 'Package') {
                        Get.to(() => PackageDetailScreen(offer.typeId));
                      } else if (offer.type == 'Profiles') {
                        Get.to(() => ProfileDetailScreen(offer.typeId));
                      }
                    },
                    child: Container(
                      width: 240,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 10,
                        bottom: 10,
                        top: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(
                              '${AppConfig.storageBaseUrl}category/${offer.image}'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // POPULAR TESTS SECTION
  // ═══════════════════════════════════════════

  Widget _buildPopularTestsSection() {
    return GetBuilder<TestController>(
      builder: (controller) {
        if (controller.isLoading) {
          return _buildHorizontalShimmer(height: 185, itemWidth: 150);
        }
        if (testController.testModelList?.isEmpty ?? true) {
          return const SizedBox();
        }
        final list = testController.testModelList!;
        final count = list.length >= 5 ? 5 : list.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              'Popular Tests',
              onViewAll: () => Get.to(() => TestScreen()),
            ),
            SizedBox(
              height: 185,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: count,
                itemBuilder: (context, index) {
                  final test = list[index];
                  return GestureDetector(
                    onTap: () {
                      Get.put(TestDetailController())
                          .getTestDetail(test.id!);
                      Get.to(() => TestDetailsScreen(testListModel: test));
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 8,
                        bottom: 8,
                        top: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(AppImages.defaultImage),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${test.profileName} (${test.countOfParamas})',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "Bold",
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                if (test.price != 0) ...[
                                  Flexible(
                                    child: Text(
                                      "₹${test.price}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        decoration:
                                        TextDecoration.lineThrough,
                                        decorationColor: Colors.red, // line color
                                        decorationThickness: 2, // optional
                                      ),
                                    ),
                                  ),
                                  const Text(" / ",
                                      style:
                                      TextStyle(color: Colors.white)),
                                ],
                                Text(
                                  "₹${test.mrp}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (test.discount.per != 0)
                                  _discountBadge('${test.discount.per}%'),
                              ],
                            ),
                            const Divider(color: Colors.white54, height: 12),
                            ...(test.paramaterData ?? []).take(4).map((e) =>
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 1),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.done,
                                          color: Colors.redAccent, size: 10),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          e,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════
  // SHIMMER HELPERS
  // ═══════════════════════════════════════════

  /// ✅ Single shimmer box — banner ya kisi bhi rectangle ke liye
  Widget _shimmerBox({required double height, double? width, double borderRadius = 12}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// ✅ Horizontal list shimmer — ek baar dikhao, multiple loaders nahi
  Widget _buildHorizontalShimmer(
      {required double height, required double itemWidth}) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 10, top: 4, bottom: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              child: Container(
                width: itemWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════
  // DISCOUNT BADGE
  // ═══════════════════════════════════════════

  Widget _discountBadge(String label) {
    return Container(
      height: 22,
      width: 38,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/popular_package/discount.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontFamily: "Regular",
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // FETCH ALL DATA
  // ═══════════════════════════════════════════

  Future<void> fetchData(
      BuildContext context, {
        required String slug,
        required String value,
        required double lat,
        required double lng,
      }) async {
    showLoadingMsg(
      context: Get.context!,
      title: 'Please Wait...',
      msg: 'Fetching data for $value...',
    );

    nearByLabController.page = 1;
    nearByLabController.labList = [];

    try {
      await Future.wait([
        nearByLabController.getLabList(
          lat: addAddressController.center!.latitude,
          lng: addAddressController.center!.longitude,
          slug: slug,
          cityName: value,
        ),
        categoryListController.getCategory(false,
            cityName: value, lat: lat, lng: lng),
        categoryListController.getBannerList(),
        categoryListController.getSuggestionList(cityName: value),
        packageListController.getPopularPackage(
            cityName: value, lat: lat, lng: lng),
        testController.getTest(cityName: value, lat: lat, lng: lng),
      ]);
    } catch (e) {
      log('fetchData error: $e');
    } finally {
      Get.back();
    }
  }
}