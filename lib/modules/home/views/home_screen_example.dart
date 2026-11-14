import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/modules/home/controllers/home_controller.dart';
import 'package:diagnostics_patient/widgets/custom_buttons.dart';
import 'package:diagnostics_patient/widgets/custom_loaders.dart';
import 'package:diagnostics_patient/themes/app_theme.dart';

/// Example Home Screen - Demonstrates GetX best practices
/// This is a reference implementation for refactoring other screens
/// 
/// Key improvements:
/// - Uses Obx() instead of GetBuilder() for reactive updates
/// - No controller initialization on screen (done in binding)
/// - Reactive Rx variables instead of boolean flags
/// - Proper error and loading state handling
/// - Clean separation of concerns
/// - Const widgets where possible

class HomeScreenExample extends StatelessWidget {
  const HomeScreenExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get controller instance (created by binding)
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),
      body: Obx(
        () {
          // Show loader while loading initial data
          if (controller.isLoading.value) {
            return const Center(
              child: CustomProgressIndicator(),
            );
          }

          // Show error state
          if (controller.errorMessage?.value != null &&
              controller.errorMessage!.value.isNotEmpty) {
            return _buildErrorState(controller);
          }

          // Build main content
          return RefreshIndicator(
            onRefresh: () => controller.refreshHome(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banners Section
                  _buildBannersSection(controller),
                  const SizedBox(height: 24),

                  // Categories Section
                  _buildCategoriesSection(controller),
                  const SizedBox(height: 24),

                  // Packages Section
                  _buildPackagesSection(controller),
                  const SizedBox(height: 24),

                  // Offers Section
                  _buildOffersSection(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build banners section with shimmer loading
  Widget _buildBannersSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured',
          style: AppTypography.headingMedium,
        ),
        const SizedBox(height: 12),
        Obx(
          () {
            if (controller.isBannersLoading.value) {
              return ShimmerLoading(
                height: 160,
                borderRadius: 12,
              );
            }

            if (controller.banners.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No banners available'),
                ),
              );
            }

            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.banners.length,
                itemBuilder: (context, index) {
                  final banner = controller.banners[index];
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// Build categories section with shimmer loading
  Widget _buildCategoriesSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: AppTypography.headingMedium,
        ),
        const SizedBox(height: 12),
        Obx(
          () {
            if (controller.isCategoriesLoading.value) {
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(
                  4,
                  (index) => ShimmerLoading(
                    height: 80,
                    width: 80,
                    borderRadius: 8,
                  ),
                ),
              );
            }

            if (controller.categories.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No categories available'),
                ),
              );
            }

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: controller.categories.map((category) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.category,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// Build packages section with shimmer loading
  Widget _buildPackagesSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Packages',
          style: AppTypography.headingMedium,
        ),
        const SizedBox(height: 12),
        Obx(
          () {
            if (controller.isPackagesLoading.value) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ShimmerListItem(),
                  );
                },
              );
            }

            if (controller.packages.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No packages available'),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.packages.length,
              itemBuilder: (context, index) {
                final package = controller.packages[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_hospital, color: AppColors.primary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Package Name',
                              style: AppTypography.bodyMedium,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹999',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Build offers section
  Widget _buildOffersSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Offers',
          style: AppTypography.headingMedium,
        ),
        const SizedBox(height: 12),
        Obx(
          () {
            if (controller.offers.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No offers available'),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.offers.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_offer, color: AppColors.secondary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Special Offer',
                              style: AppTypography.bodyMedium,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Save up to 50%',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Build error state
  Widget _buildErrorState(HomeController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: AppTypography.headingMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.errorMessage?.value ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            label: 'Retry',
            onPressed: () => controller.refreshHome(),
          ),
        ],
      ),
    );
  }
}
