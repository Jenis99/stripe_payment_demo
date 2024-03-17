import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  Stripe.publishableKey = 'YOUR_PUBLISHABLE_KEY';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Payment Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentForm(),
    );
  }
}

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController expYearController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expMonthController.dispose();
    expYearController.dispose();
    cvcController.dispose();
    super.dispose();
  }

  Future<void> processPayment() async {
    final String cardNumber = cardNumberController.text.trim();
    final int expMonth = int.parse(expMonthController.text.trim());
    final int expYear = int.parse(expYearController.text.trim());
    final String cvc = cvcController.text.trim();

    final PaymentMethodParams paymentMethodParams = PaymentMethodParams.cardFromMethodId(
      cvc: cvc,
      paymentMethodId: 'card',
    );

    final paymentMethod = await Stripe.instance.createPaymentMethod(paymentMethodParams);

    // Use the paymentMethod.id for further processing

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Your payment was processed successfully.'),
        actions: [
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String cardNumber = '';
    String expiryDate = '';
    String cardHolderName = '';
    String cvvCode = '';
    bool isCvvFocused = false;
    OutlineInputBorder? border;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Payment Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              cardBgColor: Colors.black,
              glassmorphismConfig: Glassmorphism.defaultConfig(),
              backgroundImage: 'assets/card_bg.png',
              obscureCardNumber: true,
              obscureInitialCardNumber: false,
              obscureCardCvv: true,
              isHolderNameVisible: false,
              height: 175,
              textStyle: TextStyle(color: Colors.yellowAccent),
              width: MediaQuery.of(context).size.width,
              isChipVisible: true,
              isSwipeGestureEnabled: true,
              animationDuration: Duration(milliseconds: 1000),
              frontCardBorder: Border.all(color: Colors.grey),
              backCardBorder: Border.all(color: Colors.grey),
            customCardTypeIcons: <CustomCardTypeIcon>[
              CustomCardTypeIcon(
                cardType: CardType.mastercard,
                cardImage: Image.asset(
                  'assets/mastercard.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ], onCreditCardWidgetChange: (CreditCardBrand ) {  },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Process Payment'),
              onPressed: processPayment,
            ),
          ],
        ),
      ),
    );
  }
}
