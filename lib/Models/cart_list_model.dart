class CartListModel {
  CartListModel({this.status = 0, this.msg = '', CartData? data}) {
    this.data = data ?? CartData();
  }

  late int status;
  late String msg;
  late CartData data;

  factory CartListModel.fromJson(Map<String, dynamic> json) => CartListModel(
        status: json["status"] ?? 0,
        msg: json["msg"] ?? "",
        data: CartData.fromJson(json["data"] ?? {}),
      );
}

class CartData {
  CartData({
    List<Cart>? cart,
    this.txt = 0,
    this.defaultAddress = '',
  }) {
    this.cart = cart ?? [];
  }

  late List<Cart> cart;
  late int txt;
  late String defaultAddress;

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        cart: json["cart"] == null
            ? []
            : List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
        txt: json["txt"] ?? 0,
        defaultAddress: "${json["default_address"] ?? ""}",
      );

  Map<String, dynamic> toJson() => {
        "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
        "txt": txt,
        "default_address": defaultAddress,
      };
}

class Cart {
  Cart({
    this.memberId,
    this.memberName,
    this.relation,
    this.gender,
    List<Testdatum>? testdata,
    this.age,
  }) {
    this.testdata = testdata ?? [];
  }

  late int? memberId;
  late String? memberName;
  late String? relation;
  late String? gender;
  late int? age;
  late List<Testdatum> testdata;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    memberId: json["member_id"],
    memberName: json["member_name"],
    relation: json["relation"],
    gender: json["gender"],
    // ✅ age fix — backend string bhejta hai ("" ya "25"), int? expect karta tha
    age: json["age"] != null && json["age"].toString().trim().isNotEmpty
        ? int.tryParse(json["age"].toString())
        : null,
    testdata: json["testdata"] == null
        ? []
        : List<Testdatum>.from(
        json["testdata"].map((x) => Testdatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "member_name": memberName,
        "relation": relation,
        "gender": gender,
        "age": age,
        "testdata": List<dynamic>.from(testdata.map((x) => x.toJson())),
      };
}

class Testdatum {
  Testdatum(
      {this.testName,
      this.mrp,
      this.price,
      this.parameter,
      this.type,
      this.typeId,
      this.cartId,
      required this.discount});

  String? testName;
  double? mrp;
  double? price;
  int? parameter;
  int? type;
  Discount discount;
  int? typeId;
  int? cartId;

  factory Testdatum.fromJson(Map<String, dynamic> json) => Testdatum(
        testName: json["test_name"],
        // mrp: json["mrp"],
        mrp: json["mrp"] != null ? double.parse(json["mrp"].toString()) : 0.0,
        price: json["price"] != null
            ? double.parse(json["price"].toString())
            : 0.0,
        parameter: json["parameter"],
        type: json["type"],
        typeId: json["type_id"],
        discount: Discount.fromJson(json["discount"]),
        cartId: json["cart_id"],
      );

  Map<String, dynamic> toJson() => {
        "test_name": testName,
        "mrp": mrp,
        "price": price,
        "parameter": parameter,
        "type": type,
        "type_id": typeId,
        "cart_id": cartId,
        "discount": discount,
      };
}

class Discount {
  int per;
  double fixed;

  Discount({
    required this.per,
    required this.fixed,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        per: json["per"],
        fixed: json["fixed"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "per": per,
        "fixed": fixed,
      };
}
