class ReportListModel {
  bool? success;
  List<ReportListDataModel>? data;
  String? msg;

  ReportListModel({
    this.success,
    this.data,
    this.msg,
  });

  factory ReportListModel.fromJson(Map<String, dynamic> json) => ReportListModel(
        success: json["success"],
        data: List<ReportListDataModel>.from(json["data"].map((x) => ReportListDataModel.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "msg": msg,
      };
}

class ReportListDataModel {
  String? patientName;
  int? testRegnId;
  int? balanceAmt;
  String? regnDateTimeString;
  String? selectedTest;
  int? net;
  int? amountPaid;

  ReportListDataModel({
    this.patientName,
    this.testRegnId,
    this.balanceAmt,
    this.regnDateTimeString,
    this.selectedTest,
    this.net,
    this.amountPaid,
  });

  factory ReportListDataModel.fromJson(Map<String, dynamic> json) => ReportListDataModel(
        patientName: json["PatientName"],
        testRegnId: json["TestRegnID"],
        balanceAmt: json["BalanceAmt"],
        regnDateTimeString: json["RegnDateTimeString"],
        selectedTest: json["SelectedTest"],
        net: json["Net"],
        amountPaid: json["AmountPaid"],
      );

  Map<String, dynamic> toJson() => {
        "PatientName": patientName,
        "TestRegnID": testRegnId,
        "BalanceAmt": balanceAmt,
        "RegnDateTimeString": regnDateTimeString,
        "SelectedTest": selectedTest,
        "Net": net,
        "AmountPaid": amountPaid,
      };
}
