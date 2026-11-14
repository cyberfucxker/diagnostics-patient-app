// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/View/lab_detail_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/near_by_lab_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';

// ═════════════════════════════════════════════════════════════════════════════
// SHIMMER
// ═════════════════════════════════════════════════════════════════════════════
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final bool isCircle;

  const _Shimmer({
    required this.width,
    required this.height,
    this.radius = 8,
    this.isCircle = false,
  });

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
    _anim = Tween<double>(begin: -2.0, end: 2.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width:  widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
          widget.isCircle ? null : BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end:   Alignment(_anim.value + 1, 0),
            colors: const [
              Color(0xFFE8ECF1),
              Color(0xFFF8FAFB),
              Color(0xFFDDE3EA),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Skeleton card shown during first-page loading ────────────────────────────
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Shimmer(width: 52, height: 52, radius: 12),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Shimmer(width: 160, height: 15),
                const SizedBox(height: 10),
                _row(),
                const SizedBox(height: 8),
                _row(w: 180),
                const SizedBox(height: 8),
                _row(w: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row({double w = 120}) => Row(children: [
    const _Shimmer(width: 13, height: 13, isCircle: true),
    const SizedBox(width: 7),
    _Shimmer(width: w, height: 11),
  ]);
}

// ═════════════════════════════════════════════════════════════════════════════
// PAGINATION LOADER  — three-dot pulse
// ═════════════════════════════════════════════════════════════════════════════
class _PaginationLoader extends StatefulWidget {
  const _PaginationLoader();
  @override
  State<_PaginationLoader> createState() => _PaginationLoaderState();
}

class _PaginationLoaderState extends State<_PaginationLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              final v = ((_ctrl.value - i * 0.25) % 1.0).clamp(0.0, 1.0);
              final s = 0.5 + 0.5 * (1 - (v - 0.5).abs() * 2).clamp(0.0, 1.0);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 9 * s, height: 9 * s,
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.5 + 0.5 * s),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═════════════════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.science_outlined, size: 40, color: themeColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Labs Found',
            style: TextStyle(fontFamily: 'Bold', fontSize: 17, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            'No nearby laboratories found\nin your current area',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 13,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ERROR STATE
// ═════════════════════════════════════════════════════════════════════════════
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 50, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          const Text(
            'Something went wrong',
            style: TextStyle(fontFamily: 'Bold', fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            'Check your connection and try again',
            style: TextStyle(fontFamily: 'Regular', fontSize: 13,
                color: Colors.grey.shade500),
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: themeColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: const Text('Retry',
                  style: TextStyle(fontFamily: 'Bold', fontSize: 14,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// END-OF-LIST BADGE
// ═════════════════════════════════════════════════════════════════════════════
class _EndBadge extends StatelessWidget {
  const _EndBadge();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Row(children: [
        Expanded(child: Divider(color: Colors.grey.shade300, endIndent: 12)),
        Text('All labs loaded',
            style: TextStyle(fontFamily: 'Regular', fontSize: 12,
                color: Colors.grey.shade400)),
        Expanded(child: Divider(color: Colors.grey.shade300, indent: 12)),
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// INFO ROW — reusable icon + text
// ═════════════════════════════════════════════════════════════════════════════
class _InfoRow extends StatelessWidget {
  final String? svgAsset;
  final String? pngAsset;
  final Color   iconColor;
  final String  text;
  final int     maxLines;

  const _InfoRow({
    this.svgAsset,
    this.pngAsset,
    required this.iconColor,
    required this.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final icon = svgAsset != null
        ? SvgPicture.asset(svgAsset!, height: 13, width: 13, color: iconColor)
        : Image.asset(pngAsset!, height: 13, width: 13, color: iconColor);

    return Row(
      crossAxisAlignment: maxLines > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Padding(padding: const EdgeInsets.only(top: 1), child: icon),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Regular',
                fontSize: 12,
                color: Color(0xFF8A96A3),
                fontWeight: FontWeight.w500,
                height: 1.4,
              )),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LAB CARD
// ═════════════════════════════════════════════════════════════════════════════
class _LabCard extends StatelessWidget {
  final dynamic lab;
  const _LabCard({required this.lab});

  @override
  Widget build(BuildContext context) {
    final name     = lab.name?.toString()     ?? '—';
    final phone    = lab.phone?.toString()    ?? '---';
    final address  = lab.address?.toString()  ?? 'N/A';
    final distance = lab.distance != null
        ? '${lab.distance!.toStringAsFixed(1)} kms away'
        : null;

    return GestureDetector(
      onTap: () => Get.to(
            () => LabDetailScreen(labModelList: lab),
        transition: Transition.cupertino,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: const Color(0x129a90b8),
                blurRadius: 18,
                offset: const Offset(0, 5)),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ─────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: '$imageUrl${lab.profilePic ?? ''}',
                width: 52, height: 52,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                const _Shimmer(width: 52, height: 52, radius: 12),
                errorWidget: (_, __, ___) => Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF3F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.biotech_rounded, color: themeColor, size: 26),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Details ────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 15,
                        color: Colors.black,
                        height: 1.3,
                      )),
                  const SizedBox(height: 8),

                  _InfoRow(
                    svgAsset: 'assets/lab_phone.svg',
                    iconColor: themeColor,
                    text: phone,
                  ),
                  const SizedBox(height: 5),

                  _InfoRow(
                    svgAsset: 'assets/location.svg',
                    iconColor: themeColor,
                    text: address,
                    maxLines: 2,
                  ),

                  if (distance != null) ...[
                    const SizedBox(height: 5),
                    _InfoRow(
                      pngAsset: 'assets/distance.png',
                      iconColor: Colors.blueAccent,
                      text: distance,
                    ),
                  ],
                ],
              ),
            ),

            // ── Arrow ──────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  size: 13, color: Color(0xFFBBC5D0)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// MAIN SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class NearByLabScreen extends StatelessWidget {
  NearByLabScreen({super.key}) {
    Get.put(NearByLabController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: Column(
        children: [
          CustomAppBar(
            title: near_by_lab[LANGUAGE_TYPE],
            isArrow: true,
            isAction: false,
          ),
          Expanded(
            child: GetBuilder<NearByLabController>(
              builder: (ctrl) {

                // ── 1. First-page shimmer ──────────────────────────────
                if (ctrl.isLoading && ctrl.labList.isEmpty) {
                  return ListView.builder(
                    itemCount: 6,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, __) => const _SkeletonCard(),
                  );
                }

                // ── 2. Error (first page) ──────────────────────────────
                if (ctrl.hasError && ctrl.labList.isEmpty) {
                  return _ErrorState(onRetry: ctrl.refreshList);
                }

                // ── 3. Empty ───────────────────────────────────────────
                if (ctrl.labList.isEmpty) {
                  return const _EmptyState();
                }

                // ── 4. List + pagination ───────────────────────────────
                return RefreshIndicator(
                  color: themeColor,
                  backgroundColor: Colors.white,
                  onRefresh: ctrl.refreshList,
                  child: ListView.builder(
                    controller: ctrl.scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    // +1 for footer (loader / end badge)
                    itemCount: ctrl.labList.length + 1,
                    itemBuilder: (context, index) {

                      // ── Footer ───────────────────────────────────────
                      if (index == ctrl.labList.length) {
                        if (ctrl.isPaginationLoading) {
                          return const _PaginationLoader();
                        }
                        if (ctrl.isAllDataLoaded) {
                          return const _EndBadge();
                        }
                        return const SizedBox.shrink();
                      }

                      // ── Card ─────────────────────────────────────────
                      return _LabCard(lab: ctrl.labList[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}