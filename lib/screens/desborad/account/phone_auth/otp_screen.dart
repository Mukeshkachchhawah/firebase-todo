import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/screens/pages/home_view.dart';
import 'package:firebase_todo/screens/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

// ignore: must_be_immutable
class OtpScreens extends StatefulWidget {
  String mVerification;
  String phoneNo;
  OtpScreens({super.key, required this.mVerification, required this.phoneNo});

  @override
  State<OtpScreens> createState() => _OtpScreensState();
}
// main code

class _OtpScreensState extends State<OtpScreens> {
  /// global

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController otpController = TextEditingController();
  String mVerificationId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
            child: Column(
              //    mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                        "https://cdn3.iconfinder.com/data/icons/cloud-technology-fill-group-of-networked/512/Cloud_two_step_verification-512.png"),
                    scale: 2,
                  )),
                ),
                hSpace(),
                const Text(
                  "OTP Verification Code",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                hSpace(),
                const Text(
                  "Please enter the verification code sent to ",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                hSpace(),
                Text(
                  "${widget.phoneNo}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                hSpace(),
                PinFieldAutoFill(
                  controller: otpController,
                  codeLength: 6,
                  decoration: UnderlineDecoration(
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),
                ),
                hSpace(),
                InkWell(
                    onTap: () {},
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )),
                hSpace(),
                ElevatedButton(
                  onPressed: () async {
                    String otp = otpController.text.trim();
                    if (widget.mVerification.isNotEmpty) {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: widget.mVerification,
                          smsCode: otp,
                        );

                        UserCredential userCredential =
                            await auth.signInWithCredential(credential);
                        User? user = userCredential.user;

                        if (user != null) {
                          // Store user data in Firestore
                          await firestore
                              .collection('users')
                              .doc(user.uid)
                              .set({
                            'phoneNumber': user.phoneNumber,
                            'uid': user.uid,
                          });

                          print("Auto sign in with phone ${user.uid}");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeView(),
                            ),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        print("Error during OTP verification: ${e.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid OTP. Please try again."),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Verify"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// testing
/* 

class _OtpScreensState extends State<OtpScreens> {
  /// global
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController otpController = TextEditingController();
  String mVerificationId = "";
  bool isResendEnabled = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startVerification();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void _startVerification() {
    auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNo,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          await _storeUserData(user);
          _navigateToHome();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed. Please try again.")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          mVerificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          mVerificationId = verificationId;
        });
      },
    );
  }

  void _startResendTimer() {
    setState(() {
      isResendEnabled = false;
    });
    _timer = Timer(Duration(seconds: 30), () {
      setState(() {
        isResendEnabled = true;
      });
    });
  }

  Future<void> _storeUserData(User user) async {
    await firestore.collection('users').doc(user.uid).set({
      'phoneNumber': user.phoneNumber,
      'uid': user.uid,
    });
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(
                        "https://cdn3.iconfinder.com/data/icons/cloud-technology-fill-group-of-networked/512/Cloud_two_step_verification-512.png"),
                    scale: 2,
                  )),
                ),
                hSpace(),
                const Text(
                  "OTP Verification Code",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                hSpace(),
                const Text(
                  "Please enter the verification code sent to ",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                hSpace(),
                Text(
                  "${widget.phoneNo}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                hSpace(),
                PinFieldAutoFill(
                  controller: otpController,
                  codeLength: 6,
                  decoration: UnderlineDecoration(
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),
                ),
                hSpace(),
                InkWell(
                    onTap: isResendEnabled
                        ? () {
                            _startVerification();
                            _startResendTimer();
                          }
                        : null,
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: 16,
                        color: isResendEnabled ? Colors.red : Colors.grey,
                      ),
                    )),
                hSpace(),
                ElevatedButton(
                  onPressed: () async {
                    String otp = otpController.text.trim();
                    if (mVerificationId.isNotEmpty) {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: mVerificationId,
                          smsCode: otp,
                        );

                        UserCredential userCredential =
                            await auth.signInWithCredential(credential);
                        User? user = userCredential.user;

                        if (user != null) {
                          await _storeUserData(user);
                          _navigateToHome();
                        }
                      } catch (e) {
                        print("Error during OTP verification: ${e.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid OTP. Please try again."),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text("Verify"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */