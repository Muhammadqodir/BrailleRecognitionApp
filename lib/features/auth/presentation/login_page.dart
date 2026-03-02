import 'dart:io';
import 'package:braillerecognition/core/utils/colors.dart';
import 'package:braillerecognition/core/widgets/button.dart';
import 'package:braillerecognition/core/widgets/custom_input.dart';
import 'package:braillerecognition/core/widgets/divider_text.dart';
import 'package:braillerecognition/core/widgets/outline_button.dart';
import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:braillerecognition/features/auth/presentation/register_page.dart';
import 'package:braillerecognition/features/home/presentation/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Navigate to home page
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false,
              );
            } else if (state is AuthError) {
              print(state.message);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            
            return ListView(
              children: [
                const SizedBox(height: 25, width: double.infinity),
                Text(
                  "Hey there!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: email,
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
                    size: 20,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  onChanged: (v) {},
                  hint: "Email",
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: password,
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedLockPassword,
                    size: 20,
                  ),
                  obscureText: true,
                  margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  onChanged: (v) {},
                  hint: "Password",
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    // Navigate to reset password page
                  },
                  child: Text(
                    "Forgot your password?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .color!
                          .withAlpha(100),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                CustomButton(
                  onTap: isLoading
                      ? null
                      : () {
                          if (email.text.isEmpty || password.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                              ),
                            );
                            return;
                          }
                          context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: email.text,
                                  password: password.text,
                                ),
                              );
                        },
                  text: "Login",
                  isLoading: isLoading,
                  margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
                ),
                const SizedBox(height: 24),
                const DividerWithText(text: "Or"),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineBtn(
                      onTap: isLoading
                          ? null
                          : () {
                              context
                                  .read<AuthBloc>()
                                  .add(const GoogleSignInRequested());
                            },
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(0),
                      child: Image.asset(
                        "assets/images/google.png",
                        height: 26,
                        width: 26,
                      ),
                    ),
                    if (Platform.isIOS)
                      Row(
                        children: [
                          const SizedBox(width: 24),
                          OutlineBtn(
                            onTap: isLoading
                                ? null
                                : () {
                                    context
                                        .read<AuthBloc>()
                                        .add(const AppleSignInRequested());
                                  },
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(0),
                            child: Image.asset(
                              "assets/images/apple.png",
                              height: 26,
                              width: 26,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Tappable(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Register",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: primaryColor,
                              fontFamily: "PoppinsBold",
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
