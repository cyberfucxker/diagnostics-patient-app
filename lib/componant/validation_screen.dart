import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/strings.dart';

///---- mobile number validation ----
String? validateMobile(String? mbno) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  // if (mbno!.isEmpty) {
  //   return AppStrings.enterMobileNo;
  // } else if (mbno.length > 10) {
  //   return AppStrings.enterValidateDigitNumber;
  // } else if (!regExp.hasMatch(mbno)) {
  //   return AppStrings.validNumber;
  // } else {
  //   return null;
  // }
}

///---- Email validation ----
String? validateEmail(String? email) {
  String patttern = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]";
  RegExp regExp = new RegExp(patttern);
  if (email!.isEmpty || email == null) {
    return "Please enter email";
  } else if (!regExp.hasMatch(email)) {
    return Valid_Email[LANGUAGE_TYPE];
  } else {
    return null;
  }
}

String? validatePass(String? pass) {
  if (pass!.isEmpty || pass == null) {
    return "Please enter password";
  } else {
    return null;
  }
}

String? validateSay(String? say) {
  if (say!.isEmpty || say == null) {
    return "Please enter say something";
  } else {
    return null;
  }
}

String? validateName(String? name) {
  if (name!.isEmpty || name == null) {
    return "Please enter name";
  } else {
    return null;
  }
}

String? validateFullName(String? fullName) {
  if (fullName!.isEmpty || fullName == null) {
    return "Please enter full name";
  } else {
    return null;
  }
}

String? validatePhone(String? phone) {
  if (phone != null && (phone.isEmpty || int.parse(phone) < 10)) {
    return "Please enter phone number";
  } else {
    return null;
  }
}

String? validateAge(String? age) {
  if (age != null && age.isEmpty) {
    return "Please enter Age";
  } else {
    return null;
  }
}

String? validateDOB(String? dob) {
  if (dob != null && dob.isEmpty) {
    return "Please Select dob";
  } else {
    return null;
  }
}

String? validateDate(String? date) {
  if (date != null && date.isEmpty) {
    return "Please Select Date";
  } else {
    return null;
  }
}

String? validateTime(String? time) {
  if (time != null && time.isEmpty) {
    return "Please Select Time";
  } else {
    return null;
  }
}

String? validateAddress(String? val) {
  if (val!.isEmpty || val == null) {
    return "Please enter address";
  } else {
    return null;
  }
}

String? validateHousNo(String? val) {
  if (val!.isEmpty || val == null) {
    return "Please enter House No";
  } else {
    return null;
  }
}

String? validateState(String? val) {
  if (val!.isEmpty || val == null) {
    return "Please enter State";
  } else {
    return null;
  }
}

String? validatePinCode(String? val) {
  if (val!.isEmpty || val == null) {
    return "Please enter pincode";
  } else {
    return null;
  }
}

String? validateCity(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please select a branch';  // ya jo bhi message ho
  }
  return null;
}

String? validateSaveAS(String? val) {
  if (val!.isEmpty || val == null) {
    return "Please enter Save as";
  } else {
    return null;
  }
}
