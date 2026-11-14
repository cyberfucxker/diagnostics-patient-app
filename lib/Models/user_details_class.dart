// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsClass {
  bool isLoggedIn = false;
  String? name;
  String? email;
  int? phone;
  String? profile;
  int? userId;
  String? pass;
  String? d_o_b;
  int? age;
  String? gender;

  // bool? isRtlView;

  UserDetailsClass();

  UserDetailsClass.data({
    this.isLoggedIn = false,
    this.name,
    this.email,
    this.phone,
    this.profile,
    this.userId,
    this.pass,
    this.age,
    this.d_o_b,
    this.gender,
  });

  setUserDetails({
    bool? isLoggedIn,
    required String name,
    required String email,
    int? phone,
    String? profile,
    required String pass,
    required int userId,
    String? d_o_b,
    int? age,
    String? gender,
  }) async {
    SharedPreferences.getInstance().then((value) {
      value.setBool('isLoggedIn', true);
      value.setString('name', name);
      value.setString('email', email);
      value.setInt('phone', phone ?? 0);
      value.setString('profile_pic', profile ?? "");
      value.setInt('user_id', userId);
      value.setString('password', pass);
      value.setString('d_o_b', d_o_b ?? "");
      value.setInt('age', age ?? 0);
      value.setString('gender', gender ?? "");
    });
  }

  Future<UserDetailsClass> getUserDetails() async {
    late UserDetailsClass userDetailsClass;

    await SharedPreferences.getInstance().then(( value) {
      userDetailsClass = UserDetailsClass.data(
        isLoggedIn: value.getBool('isLoggedIn') ?? false,
        name: value.getString('name') ?? "",
        email: value.getString('email') ?? "",
        phone: value.getInt('phone') ?? 0,
        profile: value.getString('profile_pic') ?? "",
        userId: value.getInt('user_id'),
        pass: value.getString('password'),
        d_o_b: value.getString('d_o_b') ?? "",
        gender: value.getString('gender') ?? "",
        age: value.getInt('age') ?? 0,
      );
    });

    return userDetailsClass;
  }

  Future<bool> removeAllUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('email');
    await preferences.remove('isLoggedIn');
    await preferences.remove('name');
    await preferences.remove('phone');
    await preferences.remove('profile_pic');
    await preferences.remove('user_id');
    await preferences.remove('pass');
    await preferences.remove('age');
    await preferences.remove('d_o_b');
    await preferences.remove('gender');
    return true;
  }
}
