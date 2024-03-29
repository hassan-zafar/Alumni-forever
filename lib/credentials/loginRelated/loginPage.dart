import 'package:flutter/material.dart';
import 'package:forever_alumni/Database/database.dart';
import 'package:forever_alumni/screens/homepage.dart';
import 'package:forever_alumni/services/authentication_service.dart';
import 'package:forever_alumni/tools/custom_toast.dart';
import 'package:forever_alumni/tools/loading.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:get/get.dart';
import '../../commonUIFunctions.dart';
import '../../constants.dart';
import 'forgetPasswordPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _textFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: backgroundColorBoxDecoration(),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _textFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Hero(
                              tag: "logo",
                              child: Image.asset(
                                logo,
                                height: 90,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GlassContainer(
                          opacity: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              validator: (val) {
                                if (val == null) {
                                  return null;
                                }
                                if (val.isEmpty) {
                                  return "Field is Empty";
                                } else if (!val.contains("@") ||
                                    val.trim().length < 4) {
                                  return "Invalid E-mail!";
                                } else {
                                  return null;
                                }
                              },
                              // onSaved: (val) => phoneNo = val,
                              autofocus: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "E-mail",
                                labelStyle: TextStyle(fontSize: 15.0),
                                hintText: "Please enter your valid E-mail",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GlassContainer(
                          opacity: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                            ),
                            child: TextFormField(
                              obscureText: _obscureText,
                              validator: (val) {
                                if (val == null) {
                                  return null;
                                }
                                if (val.length < 6) {
                                  return 'Password Too Short';
                                } else {
                                  return null;
                                }
                              },
                              controller: _passwordController,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                border: InputBorder.none,
                                // filled: true,
                                //  fillColor: Colors.white,
                                labelText: "Password",
                                hintText:
                                    "Enter a valid password, min length 6",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 220, top: 8, bottom: 8, right: 12),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgetPasswordPage())),
                            child: GlassContainer(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Hero(
                                  tag: "passFor",
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => _handleLogin(),
                            child: buildSignUpLoginButton(
                                context: context,
                                btnText: "Log In",
                                assetImage: loginIcon,
                                color: containerColor,
                                hasIcon: true),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
// Move to Sign Up Page
                      ],
                    ),
                  ),
                ),
              ),
              _isLoading ? LoadingIndicator() : Container(),
            ],
          ),
        ),
        bottomSheet: buildSignUpLoginText(
            context: context,
            text1: "Don't have an account ",
            text2: "Sign Up",
            moveToLogIn: false),
      ),
    );
  }

  void _handleLogin() async {
    final _form = _textFormKey.currentState;
    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String email = _emailController.text;
      final String password = _passwordController.text;
      String userId = await AuthenticationService()
          .logIn(email: email, password: password)
          .onError((error, stackTrace) {
        errorToast(message: "Please Try again");
        setState(() {
          _isLoading = false;
          _emailController.clear();
          _passwordController.clear();
        });
        return null;
      });
      await DatabaseMethods()
          .fetchUserInfoFromFirebase(uid: userId)
          .then((value) => setState(() {
                _isLoading = false;
                Get.off(() => HomePage());
              }));
    }
  }
}
