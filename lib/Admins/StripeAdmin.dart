import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Stripeadmin {

  Stripeadmin() {
    initStripeConnection();
  }

  Future<void> initStripeConnection() async {
    Stripe.publishableKey = "pk_test_QSBUITcb1wxJvulIeqykEvhS00JXKNrFUv";
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
    await Stripe.instance.applySettings();
  }

  /// Recibe euros y pide al servidor el PaymentIntent por su importe en céntimos.
  /// La Cloud Function `createPaymentIntent` debe devolver `clientSecret`.
  Future<void> cobrar(double importeEuros) async {
    if (!importeEuros.isFinite || importeEuros <= 0) {
      throw ArgumentError.value(
        importeEuros,
        'importeEuros',
        'Debe ser mayor que cero',
      );
    }
    final centimos = (importeEuros * 100).round();
    if ((centimos / 100 - importeEuros).abs() > 0.000001) {
      throw ArgumentError.value(
        importeEuros,
        'importeEuros',
        'Máximo dos decimales',
      );
    }

    final response = await FirebaseFunctions.instance
        .httpsCallable('createPaymentIntent')
        .call<Map<String, dynamic>>({'amount': centimos, 'currency': 'eur'});
    final clientSecret = response.data['clientSecret'];
    if (clientSecret is! String || clientSecret.isEmpty) {
      throw StateError('El servidor no devolvió un clientSecret válido');
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'MI APP 1',
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }
}
