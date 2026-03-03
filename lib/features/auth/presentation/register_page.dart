import 'dart:io';

import 'package:braillerecognition/core/utils/colors.dart';
import 'package:braillerecognition/core/widgets/button.dart';
import 'package:braillerecognition/core/widgets/custom_input.dart';
import 'package:braillerecognition/core/widgets/custom_select.dart';
import 'package:braillerecognition/core/widgets/divider_text.dart';
import 'package:braillerecognition/core/widgets/outline_button.dart';
import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:braillerecognition/features/auth/presentation/login_page.dart';
import 'package:braillerecognition/features/navigation/presentation/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  String role = "";
  bool accept = false;

  final List<String> roles = const [
    "Parent of Visually Impaired Children",
    "Teacher of Visually Impaired Students",
    "Regular Education Teacher",
    "Special Education Department",
    "Language Enthusiast",
    "Other",
  ];

  @override
  void dispose() {
    name.dispose();
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
                  builder: (context) => const MainPage(),
                ),
                (route) => false,
              );
            } else if (state is AuthError) {
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
                  "Create an Account",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: name,
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 20,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  onChanged: (v) {},
                  hint: "Name",
                ),
                const SizedBox(height: 12),
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
                CustomSelect(
                  title: "Who are you?",
                  items: roles,
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedQuestion,
                    size: 20,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
                  onChanged: (v) {
                    setState(() {
                      role = roles[v];
                    });
                  },
                  hint: "Who are you?",
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CupertinoCheckbox(
                        value: accept,
                        checkColor: Colors.white,
                        activeColor: primaryColor,
                        onChanged: (v) {
                          setState(() {
                            accept = v!;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              accept = !accept;
                            });
                          },
                          child: Text(
                            "By continuing you accept our Privacy Policy",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .color!
                                  .withAlpha(100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                CustomButton(
                  onTap: isLoading
                      ? null
                      : () {
                          if (name.text.isEmpty ||
                              email.text.isEmpty ||
                              password.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                              ),
                            );
                            return;
                          }
                          if (!accept) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please accept the privacy policy'),
                              ),
                            );
                            return;
                          }
                          context.read<AuthBloc>().add(
                                RegisterRequested(
                                  name: name.text,
                                  email: email.text,
                                  password: password.text,
                                  passwordConfirmation: password.text,
                                ),
                              );
                        },
                  text: "Register",
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
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Tappable(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
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
