class Payment {
  int? id;
  double? amount;
  String? paymentMode;
  String? paymentReferenceId;
  String? paymentOrderId;
  String? paymentSignature;
  String? status;
  int? userId;
  double? subTotal;
  int? txt;
  String? memberId;


  Payment({
    this.id,
    this.amount,
    this.paymentMode,
    this.paymentOrderId,
    this.paymentReferenceId,
    this.userId,
    this.paymentSignature,
    this.status, 
    this.subTotal,
    this.txt,
    this.memberId,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
    } catch (e) {
      print("Exception - Payment.dart - Payment.fromJson():" + e.toString());
    }
  }
}
