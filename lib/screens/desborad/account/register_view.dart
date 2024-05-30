import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo/modal/user_modal.dart';
import 'package:firebase_todo/screens/desborad/account/login_view.dart';
import 'package:firebase_todo/screens/utils/ui_helper.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _SignUpUpState();
}

class _SignUpUpState extends State<RegisterView> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPassword = TextEditingController();
  var phoneNoController = TextEditingController();

  bool isHide = false;
  bool isHide1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: Color(0xffd6e2ea),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hSpace(),

                const Text(
                  "User Sign Up",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),

                hSpace(),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://static.thenounproject.com/png/736670-200.png"))),
                  ),
                ),
                hSpace(),

                /// Add User Form TextForm Fild
                uerInput(),
                hSpace(),
                InkWell(
                  onTap: () {
                    var mUserName = nameController.text.toString();
                    var mEmail = emailController.text.toString();
                    var mPass = passwordController.text.toString();
                    var confPassword = confirmPassword.text.toString();

                    print("object");

                    var auth = FirebaseAuth.instance;

                    //// check condition by block is empty
                    if (formKey.currentState!.validate()) {
                      //// us try and catch add data firebase
                      try {
                        auth
                            .createUserWithEmailAndPassword(
                          email: mEmail,
                          password: mPass,
                        )
                            .then((value) {
                          print("Added Complet");
                          var userModal = UserModal(
                              address: "jodhpur",
                              age: "21",
                              confirmPassword: confPassword,
                              dob: "21/11/1241",
                              email: mEmail,
                              gender: "fem",
                              mobNo: "121231234",
                              name: mUserName,
                              password: mPass,
                              uid: value.user!.uid);
                          var db = FirebaseFirestore.instance;
                          db
                              .collection("user")
                              .doc(value.user!.uid)
                              .set(userModal.toJson())
                              .then((value) {
                            print("User data add");
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                              ));
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
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
                        "Sign UP",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                hSpace(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Alerdy Login user"),
                    wSpace(mWidth: 5),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ));
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uerInput() {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Enter Your user name';
            }
            return null;
          },
          decoration: const InputDecoration(
              hintText: "User Name", border: OutlineInputBorder()),
        ),
        hSpace(),
        TextFormField(
          controller: emailController,
          validator: (value) {
            if (value == "" || !value!.contains("@")) {
              return 'Enter Your Valid Email';
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
          controller: passwordController,
          obscureText: isHide,
          validator: (value) {
            if (value == "" || value!.length < 5) {
              return 'Enter Your password';
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
        hSpace(),
        TextFormField(
          controller: confirmPassword,
          obscureText: isHide1,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          validator: (value) {
            if (value == "" || value!.length < 5) {
              return 'confirmPassword';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "confirmPassword",
              suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      isHide1 = !isHide1;
                    });
                  },
                  child:
                      Icon(isHide1 ? Icons.visibility_off : Icons.visibility)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        ),
        hSpace()
      ],
    );
  }
}
