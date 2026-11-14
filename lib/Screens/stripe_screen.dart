// ignore_for_file: null_check_always_fails

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Models/card_model.dart';

class StripeService {
  static String paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static String createCustomerUrl = 'https://api.stripe.com/v1/customers';
  var requireActionUrl;

  // static Map<String, String> headers = {'Authorization': 'Bearer ${global.getSystemFlagValue(global.systemFlagNameList.stripeSecret)}', 'Content-Type': 'application/x-www-form-urlencoded'};
  // WARNING: a secret key must never ship inside a mobile app. This legacy
  // client-side flow is kept only for local experiments; prefer creating
  // payment intents on your backend. Provide the key at build time with
  // --dart-define=STRIPE_SECRET_KEY=... (empty by default).
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${const String.fromEnvironment('STRIPE_SECRET_KEY')}'
  };

  static Future<Map<String, dynamic>> confirmPaymentIntent(String paymentIntentId, String paymentMethodId, {String? customerId}) async {
    try {
      Map<String, dynamic> body = {'payment_method': paymentMethodId};
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId/confirm'), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - confirmPaymentIntent(): ${err.toString()}');
    }
    return null!;
  }

  static Future<Map<String, dynamic>> createCustomer({String? source, String? email}) async {
    try {
      Map<String, dynamic> body = {'email': email};
      // log('stripe:- ${global.getSystemFlagValue(global.systemFlagNameList.stripeSecret)}');
      var response = await http.post(Uri.parse(StripeService.createCustomerUrl), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - createCustomer():${err.toString()}');
    }
    return null!;
  }

  static Future<Map<String, dynamic>> createPaymentIntent(int amount, String currency, String paymentMethodId, {String? customerId}) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount.toString(),
        'currency': 'INR',
        'customer': customerId,
        'payment_method': paymentMethodId,
      };
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - createPaymentIntent(): ${err.toString()}');
    }
    return null!;
  }

  static Future<Map<String, dynamic>> retrivePaymentIntent(String id) async {
    try {
      var response = await http.post(Uri.parse('${StripeService.paymentApiUrl}/$id'), headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - retrivePaymentIntent(): ${err.toString()}');
    }
    return null!;
  }

  static Future<Map<String, dynamic>> createPaymentMethod(CardModel card) async {
    try {
      Map<String, dynamic> body = {'type': "card", 'card[number]': card.number, 'card[exp_month]': card.expiryMonth.toString(), 'card[exp_year]': card.expiryYear.toString(), "card[cvc]": card.cvv};
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_methods'), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - createPaymentMethod():${err.toString()}');
    }
    return null!;
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }
}

class StripeTransactionResponse {
  String? message;
  bool? success;
  StripeTransactionResponse({this.message, this.success});
}
