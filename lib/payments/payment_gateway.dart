import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Result returned by a payment gateway after a successful payment.
class PaymentSuccessResponse {
  final String? paymentId;
  final String? orderId;
  final String? signature;

  const PaymentSuccessResponse({this.paymentId, this.orderId, this.signature});
}

/// Minimal, provider-agnostic payment gateway abstraction.
///
/// The original project integrated a hosted checkout SDK directly. To keep the
/// open-source code free of vendor credentials, the checkout flow talks to this
/// class instead. Plug in your own provider SDK by:
///
///  1. Implementing [PaymentGatewayDelegate] (open the provider checkout and
///     call back with a [PaymentSuccessResponse]).
///  2. Setting [PaymentGateway.delegate] once at start-up (e.g. in `main()`).
///  3. Creating payment orders on YOUR BACKEND (never embed secrets in the app)
///     and returning the order id from [PaymentGatewayDelegate.createOrder].
///
/// Public configuration (such as a publishable key) can be supplied with
/// `--dart-define=PAYMENT_PUBLIC_KEY=...`, see `lib/config/api_config.dart`.
class PaymentGateway {
  static const String eventPaymentSuccess = 'payment.success';

  /// Set this to your provider implementation. When null, checkout reports
  /// that no gateway is configured.
  static PaymentGatewayDelegate? delegate;

  final Map<String, Function> _handlers = {};

  void on(String event, Function handler) => _handlers[event] = handler;

  /// Creates a payment order via the configured delegate. Returns the order id
  /// or null when no delegate is configured / the order could not be created.
  Future<String?> createOrder({
    required String amountInMinorUnits,
    Map<String, String>? notes,
  }) async {
    final d = delegate;
    if (d == null) return null;
    return d.createOrder(amountInMinorUnits: amountInMinorUnits, notes: notes);
  }

  /// Opens the provider checkout. [options] is passed through unchanged.
  void open(Map<String, dynamic> options) {
    final d = delegate;
    if (d == null) {
      Get.snackbar('Payment', 'No payment gateway is configured.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }
    d.open(options, (PaymentSuccessResponse r) {
      final h = _handlers[eventPaymentSuccess];
      if (h != null) h(r);
    });
  }

  void clear() => _handlers.clear();
}

/// Implement this to connect a real payment provider.
abstract class PaymentGatewayDelegate {
  /// Ask your backend to create an order and return its id.
  Future<String?> createOrder({
    required String amountInMinorUnits,
    Map<String, String>? notes,
  });

  /// Launch the provider checkout; call [onSuccess] when payment completes.
  void open(Map<String, dynamic> options,
      void Function(PaymentSuccessResponse response) onSuccess);
}
