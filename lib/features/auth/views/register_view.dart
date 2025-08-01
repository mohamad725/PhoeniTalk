import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uniapp/core/widgets/app_button.dart';
import 'package:uniapp/core/widgets/app_snack_bar.dart';
import 'package:uniapp/features/auth/data/services/auth_service.dart';
import 'package:uniapp/features/auth/views/login_view.dart';
import 'package:uniapp/features/auth/views/widgets/auth_text_field.dart';
import 'package:uniapp/features/pages/views/page_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: RegisterViewBody());
  }
}

class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),

          child: SingleChildScrollView(
            child: Column(
              spacing: 50,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to PhoeniTalk!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "let's create your account.",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Column(
                  spacing: 20,
                  children: [
                    AuthTextField(
                      controller: _userNameController,
                      label: 'Enter your username',
                      icon: Icon(Icons.person),
                    ),
                    AuthTextField(
                      icon: Icon(Icons.mail),
                      label: "Enter your email",
                      controller: _emailController,
                    ),
                    AuthTextField(
                      controller: _passwordController,
                      label: "Enter your pasword",
                      icon: Icon(Icons.lock),
                      isObscure: true,
                    ),

                    AppButton(
                      ontap: () async {
                        AuthService authService = AuthService.instance;

                        final response = await authService.signUpUser(
                          email: _emailController.text,
                          password: _passwordController.text,
                          displayName: _userNameController.text,
                          context: context,
                        );

                        if (response != null && response.id.isNotEmpty) {
                          if (context.mounted) {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => QuizAppBottomNav(),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            snackBar(
                              text: "Unable to sign up, please try again later",
                              context: context,
                            );
                          }
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Don't have an account?"),
                            TextSpan(
                              text: " Register here",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) => LoginView(),
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
