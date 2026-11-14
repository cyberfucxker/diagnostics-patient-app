import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/View/AddressListScreen/address_add_screen.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import '../../../componant/custome_appBar.dart';
import '../../../controller/checkout_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHIMMER
// ─────────────────────────────────────────────────────────────────────────────
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const _Shimmer({required this.width, required this.height, this.radius = 8});

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _anim = Tween<double>(begin: -2.0, end: 2.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        gradient: LinearGradient(
          begin: Alignment(_anim.value - 1, 0),
          end: Alignment(_anim.value + 1, 0),
          colors: const [
            Color(0xFFEEF0F3),
            Color(0xFFF8F9FA),
            Color(0xFFE4E7EB),
          ],
        ),
      ),
    ),
  );
}

class _AddressShimmerCard extends StatelessWidget {
  const _AddressShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Shimmer(width: 60, height: 13),
              _Shimmer(width: 60, height: 26, radius: 13),
            ]),
        const SizedBox(height: 10),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        const SizedBox(height: 12),
        Row(children: const [
          _Shimmer(width: 20, height: 20, radius: 10),
          SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _Shimmer(width: 100, height: 14),
            SizedBox(height: 7),
            _Shimmer(width: 220, height: 11),
            SizedBox(height: 5),
            _Shimmer(width: 180, height: 11),
          ]),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class CollectAddressScreen extends StatefulWidget {
  const CollectAddressScreen({Key? key}) : super(key: key);

  @override
  State<CollectAddressScreen> createState() => _CollectAddressScreenState();
}

class _CollectAddressScreenState extends State<CollectAddressScreen> {
  // ✅ FIX: Register/find the controller once and keep the reference.
  //    Never call Get.put() inside build() — that resets state on every rebuild.
  late final CheckoutController _ctrl;

  @override
  void initState() {
    super.initState();
    // ✅ FIX: Use Get.put with permanent:false so it survives navigation but is
    //    cleaned up when the screen is disposed. If the controller was already
    //    registered upstream, replace with Get.find<CheckoutController>().
    _ctrl = Get.put(CheckoutController());

    // ✅ FIX: Single deferred fetch — never call inside build().
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_ctrl.isAddressLoading) _ctrl.fetchAddress();
    });
  }

  Future<void> _goToAddAddress(
      {bool isEdit = false, dynamic address}) async {
    Get.find<AddAddressController>()
      ..tcPhone.text = isEdit ? '' : ''
      ..tcHouseNo.text = ''
      ..tcSaveAS.text = 'Home';

    final result = await Get.to<bool>(() => LocationScreen(
      isEdit: isEdit,
      address: address,
      isAddressShowCity: false,
      isAddressShowdroup: false,
    ));

    if (result == true) _ctrl.fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          CustomAppBar(
            title: COLLECT_ADDRESS[LANGUAGE_TYPE],
            isArrow: true,
            isAction: false,
          ),
          Expanded(
            // ✅ FIX: One top-level GetBuilder wraps the entire list area.
            //    _ctrl.update() inside changeSelectedAddress() triggers this
            //    builder so every card — including its Radio groupValue — gets
            //    a fresh selectedAddress value on each tap.
            child: GetBuilder<CheckoutController>(
              builder: (ctrl) {
                // ── Shimmer loading ──────────────────────────────────────
                if (ctrl.isAddressLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 150), // ✅ 2 buttons ke liye extra space
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (_, __) => const _AddressShimmerCard(),
                  );
                }

                // ── No addresses ─────────────────────────────────────────
                if (ctrl.isAddressNull) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.location_off_outlined,
                              size: 38, color: themeColor),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No saved addresses',
                          style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 16,
                            color: blackColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Add a delivery address to continue',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 13,
                            color: subTextColor.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 32),
                          child: customeElevatedButton(
                            width,
                            ADD_ADDRESS_ADD[LANGUAGE_TYPE],
                            callback: () => _goToAddAddress(),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ── Address list ─────────────────────────────────────────
                // ✅ FIX: selectedAddressId is derived fresh inside the
                //    builder on every update(), so every card reads the
                //    correct, current value when it rebuilds.
                final selectedId =
                    ctrl.selectedAddress.id?.toString() ?? '';

                return Stack(
                  children: [
                    ListView.builder(
                      padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 150), // ✅ 2 buttons ke liye extra space
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                      ctrl.addressListModel?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final data =
                        ctrl.addressListModel!.data![index];
                        final isDefault = data.isDefault == 1;

                        // ✅ FIX: Both isSelected and groupValue now use the
                        //    same selectedId derived from ctrl inside this
                        //    builder scope, guaranteeing consistency.
                        final isSelected =
                            selectedId == (data.id?.toString() ?? '');

                        return _AddressCard(
                          data: data,
                          isDefault: isDefault,
                          isSelected: isSelected,
                          // ✅ FIX: groupValue passed down explicitly so
                          //    Radio does not call Get.find() itself —
                          //    avoiding stale lookups outside the builder.
                          selectedGroupValue: selectedId,
                          onSelect: () =>
                              ctrl.changeSelectedAddress(data),
                          onEdit: () => _goToAddAddress(
                              isEdit: true, address: data),
                          onDelete: () =>
                              ctrl.DeleteAddress(id: data.id),
                        );
                      },
                    ),

                    // ── Buttons pinned at bottom ──────────────────
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✅ Add New Address button
                          customeElevatedButton(
                            width,
                            ADD_ADDRESS_ADD[LANGUAGE_TYPE],
                            callback: () async {
                              Get.find<AddAddressController>()
                                ..tcPhone.text   = ''
                                ..tcHouseNo.text = ''
                                ..tcSaveAS.text  = 'Home';

                              final result = await Get.to<bool>(
                                    () => LocationScreen(
                                  isEdit:              false,
                                  isAddressShowCity:   false,
                                  isAddressShowdroup:  false,
                                ),
                              );
                              if (result == true) _ctrl.fetchAddress();
                            },
                          ),
                          const SizedBox(height: 10),
                          // Deliver to this address button
                          customeElevatedButton(
                            width,
                            COLLECT_TO_THIS_ADDRESS[LANGUAGE_TYPE],
                            callback: () async {
                              await _ctrl.getUserByCityLists();
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ADDRESS CARD
// ─────────────────────────────────────────────────────────────────────────────
// ✅ FIX: _AddressCard is a pure "dumb" widget. It receives selectedGroupValue
//    from its parent (which lives inside GetBuilder) instead of calling
//    Get.find() internally. This means:
//      • No stale state — the parent's GetBuilder drives every rebuild.
//      • Radio's groupValue and isSelected are always in sync.
//      • No extra reactive subscription needed inside this widget.
class _AddressCard extends StatelessWidget {
  final dynamic data;
  final bool isDefault;
  final bool isSelected;

  /// ✅ FIX: Passed in from the GetBuilder scope so Radio reflects live state.
  final String selectedGroupValue;

  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.data,
    required this.isDefault,
    required this.isSelected,
    required this.selectedGroupValue,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: dataId cached once to avoid repeated toString() conversions
    //    inside the widget tree during the same build pass.
    final dataId = data.id?.toString() ?? '';

    // ✅ Whole card is tappable — GestureDetector wraps AnimatedContainer.
    //    HitTestBehavior.opaque ensures taps on empty/padding areas also fire.
    //    Edit/Delete buttons call onTap independently and stop propagation via
    //    their own GestureDetector so they don't also trigger card selection.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? themeColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? themeColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 14 : 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Default badge + actions ────────────────────────────────
            if (isDefault) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              size: 12, color: themeColor),
                          const SizedBox(width: 4),
                          Text(
                            DEFAULT[LANGUAGE_TYPE],
                            style: TextStyle(
                              fontFamily: 'Bold',
                              fontSize: 11,
                              color: themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ActionButtons(onEdit: onEdit, onDelete: onDelete),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 14, color: Color(0xFFEEEEEE)),
              ),
            ],

            // ── Radio + address details ────────────────────────────────
            Padding(
              padding:
              EdgeInsets.fromLTRB(6, isDefault ? 0 : 12, 12, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ FIX: Radio uses selectedGroupValue passed from the
                  //    parent's GetBuilder scope — not a stale Get.find().
                  //    This ensures the groupValue updates on every rebuild
                  //    triggered by ctrl.update().
                  SizedBox(
                    width: 38,
                    child: Radio<String>(
                      value: dataId,
                      groupValue: selectedGroupValue,
                      activeColor: themeColor,
                      onChanged: (_) => onSelect(),
                    ),
                  ),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '${data.name ?? ''}',
                                style: const TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: 15,
                                  color: blackColor,
                                ),
                              ),
                            ),
                            if (!isDefault)
                              _ActionButtons(
                                  onEdit: onEdit, onDelete: onDelete),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${data.houseNo ?? ''}, '
                              '${data.address ?? ''}, '
                              '${data.city ?? ''} - '
                              '${data.pincode ?? ''}, '
                              '${data.state ?? ''}',
                          style: const TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 13,
                            color: subTextColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // AnimatedContainer
    ); // GestureDetector
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION BUTTONS — edit + delete
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionButtons(
      {required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    // ✅ AbsorbPointer alternative: wrap the whole button row in a
    //    GestureDetector with onTap:(){} so taps here do NOT bubble up
    //    to the parent card's GestureDetector.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {}, // absorb — prevents card onSelect from firing
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.edit_outlined, size: 16, color: themeColor),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  size: 16, color: Colors.red),
            ),
          ),
        ],
      ), // Row
    ); // GestureDetector (absorb)
  }
}