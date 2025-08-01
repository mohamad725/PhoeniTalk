import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uniapp/core/widgets/app_button.dart';
import 'package:uniapp/core/widgets/app_snack_bar.dart';
import 'package:uniapp/features/auth/data/services/auth_service.dart';
import 'package:uniapp/features/auth/views/register_view.dart';
import 'package:uniapp/features/auth/views/widgets/auth_text_field.dart';
import 'package:uniapp/features/pages/views/page_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: LoginViewBody());
  }
}

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/PhoeniTalk.png', height: 150),

                  Text(
                    "Lets get you in!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  AuthTextField(
                    label: 'Enter your email...',
                    controller: _emailController,

                    icon: Icon(Icons.mail),
                  ),

                  AuthTextField(
                    label: 'Enter your password...',
                    controller: _passwordController,
                    isObscure: true,
                    icon: Icon(Icons.lock),
                  ),
                  AppButton(
                    ontap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      AuthService authService = AuthService.instance;
                      final response = await authService.signInUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context,
                      );
                      setState(() {
                        isLoading = false;
                      });
                      if (response != null && response.id.isNotEmpty) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => QuizAppBottomNav(),
                          ),
                        );
                      } else {
                        if (context.mounted) {
                          snackBar(
                            text: "unable to sign in, please try again later",
                            context: context,
                          );
                        }
                      }
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Text.rich(
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
                                      builder: (context) => RegisterView(),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
