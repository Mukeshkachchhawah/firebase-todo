import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/screens/desborad/account/phone_auth/phone_auth_view.dart';
import 'package:firebase_todo/screens/desborad/splash_screen/splash_view.dart';
import 'package:firebase_todo/screens/pages/home_view.dart';
import 'package:firebase_todo/screens/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
} /* 
/* 
class _LoginViewState extends State<LoginView> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: textStyleFont30(),
            ),
            hSpace(),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
              controller: emailController,
            ),
            hSpace(),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
              controller: passwordController,
            ),
            hSpace(),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeView(),
                          )); */
                      var mEmail = emailController.text.toString();
                      var mPass = passwordController.text.toString();

                      var auth = FirebaseAuth.instance;

                      try {
                        auth
                            .createUserWithEmailAndPassword(
                                email: mEmail, password: mPass)
                            .then(
                          (value) {
                            print("Account Created");

                            var userModal = UserModal(
                                uid: value.user!.uid,
                                name: "Mukesh",
                                address: "Chokha",
                                age: '23',
                                confirmPassword: "1234546",
                                email: mEmail,
                                password: mPass,
                                dob: '10-02-1992',
                                gender: "Mal",
                                mobNo: "7296826128");

                            // user email ke sath user firestor data stor
                            var db = FirebaseFirestore.instance;

                            // email firebase console par   uid -------->  User UID
                            db
                                .collection("user")
                                .doc(value.user!.uid)
                                .set(userModal.toJson())
                                .then(
                                  (value) => print("User Auth Successful"),
                                );
                          },
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        // internet chack
                        print(e);
                      }
                    },
                    child: const Text("Log In")))
          ],
        ),
      ),
    );
  }
}
 */
 */

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  FocusNode emailNode = FocusNode();

  FocusNode passNode = FocusNode();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  var userController = TextEditingController();
  bool isHide = false;

  StateMachineController? machineController;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    super.initState();
    emailNode.addListener(focusEmail);

    passNode.addListener(focusPass);
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.removeListener(focusEmail);
    passNode.removeListener(focusPass);
  }

  void focusPass() {
    isHandsUp!.change(passNode.hasFocus);
  }

  void focusEmail() {
    isChecking!.change(emailNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hSpace(),

                  /// Rive Animation Add
                  riveAnimationUse(),

                  hSpace(mHeight: 20),
                  hSpace(),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  hSpace(),

                  emailAndPasswordFil(),
                  hSpace(),

                  hSpace(),
                  InkWell(
                    onTap: () async {
                      // ////// If Successfully Logged in(creds are Correct ////////)

                      if (_formKey.currentState!.validate()) {
                        String mEmail = emailController.text.toString();
                        String mPass = passwordController.text.toString();

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: mEmail, password: mPass);

                          var sp = await SharedPreferences.getInstance();
                          sp.setBool(SplashViewState.LOGIN_KEY, true);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                            // Show error message to user
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided.');
                            // Show error message to user
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Sign in",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  hSpace(),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterView(),
                              ));
                        },
                        child: Text("Create New Account")),
                  ),
                  hSpace(),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhoneAuthView(),
                              ));
                        },
                        child: Text("Sign In with Phone")),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget riveAnimationUse() {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: RiveAnimation.asset(
          "assets/animation/teddy-bear.riv",
          fit: BoxFit.cover,
          stateMachines: const ["Login Machine"],
          onInit: (artBoard) {
            machineController =
                StateMachineController.fromArtboard(artBoard, "Login Machine");
            if (machineController == null) return;

            artBoard.addController(machineController!);
            isChecking = machineController!.findInput("isChecking");
            numLook = machineController!.findInput("numLook");
            isHandsUp = machineController!.findInput("isHandsUp");
            trigSuccess = machineController!.findInput("trigSuccess");
            trigFail = machineController!.findInput("trigFail");
          },
        ),
      ),
    );
  }

  Widget emailAndPasswordFil() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          focusNode: emailNode,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          onChanged: (value) {
            numLook!.change(value.length + 10);
          },
          validator: (value) {
            if (value == "" || !value!.contains("@")) {
              return 'Enter your valid email';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        ),
        hSpace(),
        TextFormField(
          focusNode: passNode,
          controller: passwordController,
          obscureText: isHide,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          validator: (value) {
            if (value == "" || value!.length < 5) {
              return "Please enter valid Password(length must be 6 characters)!";
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      isHide = !isHide;
                    });
                  },
                  child:
                      Icon(isHide ? Icons.visibility_off : Icons.visibility)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        ),
      ],
    );
  }
}
