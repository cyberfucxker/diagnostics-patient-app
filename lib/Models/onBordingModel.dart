import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/strings.dart';

class OnbordingModel {
  String image;
  String title;
  String description;

  OnbordingModel({required this.image, required this.title, required this.description});
}

List<OnbordingModel> contents = [
  OnbordingModel(
    title: Need_A_Doctor[LANGUAGE_TYPE],
    image: 'assets/login/logo1.png',
    description: Need_A_Doctor_Des[LANGUAGE_TYPE],
  ),
  OnbordingModel(
    title: Health_Advice[LANGUAGE_TYPE],
    image: 'assets/login/logo1.png',
    description: Health_Advice_Des[LANGUAGE_TYPE],
  ),
  OnbordingModel(
    title: Home_Service[LANGUAGE_TYPE],
    image: 'assets/login/logo1.png',
    description: Home_Service_Des[LANGUAGE_TYPE],
  ),
];
