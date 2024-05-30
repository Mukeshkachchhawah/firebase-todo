import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/screens/desborad/account/phone_auth/otp_screen.dart';
import 'package:firebase_todo/screens/utils/ui_helper.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String phoneNumber = '';
  String countryCode = '+91';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://icons.veryicon.com/png/o/business/official-icon-of-qianjinding-supply-chain-2/mobile-phone-authentication-1.png",
                    ),
                  ),
                ),
              ),
              hSpace(),
              const Text(
                "Enter your Phone Number",
                style: TextStyle(fontSize: 25),
              ),
              hSpace(),
              const Text(
                "Please confirm your country code and \nenter your mobile number",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              hSpace(),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                  countryCode = phone.countryCode;
                },
              ),
              hSpace(),
              elevatedButton(
                text: "Send OTP",
                colors: Colors.blueGrey,
                onTap: sendOtp,
              ),
              hSpace(),
            ],
          ),
        ),
      ),
    );
  }

  void sendOtp() async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          User? user = userCredential.user;

          if (user != null) {
            // Store user data in Firestore
            await firestore.collection('users').doc(user.uid).set({
              'phoneNumber': user.phoneNumber,
              'uid': user.uid,
            });

            print("Auto sign in completed! ... ${user.uid}");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          /*    setState(() {
            mVerificationId = verificationId;
          }); */
          print("Code sent to the phone number.");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreens(
                    mVerification: verificationId, phoneNo: phoneNumber),
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Error during sending OTP: ${e.toString()}");
    }
  }
}
