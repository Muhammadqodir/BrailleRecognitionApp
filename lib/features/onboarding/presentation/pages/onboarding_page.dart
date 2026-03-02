import 'package:braillerecognition/core/widgets/button.dart';
import 'package:braillerecognition/core/widgets/gost_button.dart';
import 'package:braillerecognition/features/auth/presentation/login_page.dart';
import 'package:braillerecognition/features/onboarding/presentation/widgets/onboarding_item.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 12),
                      Image.asset("assets/images/icon.png", height: 25),
                      SizedBox(width: 8),
                      Text(
                        "Braille Recognition",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontFamily: "PoppinsBold"),
                      ),
                    ],
                  ),
                ),
                GostButton(
                  text: "Skip",
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
                SizedBox(width: 12),
              ],
            ),
            Expanded(
              child: PageView(
                controller: controller,
                children: [
                  OnboardingItem(
                    title: "Scan Braille Instantly",
                    description:
                        "Use your camera to quickly recognize Braille from books, notes, or homework. Just point and scan to get results in seconds.",
                    image: "assets/images/onboarding1.png",
                  ),
                  OnboardingItem(
                    title: "Use Top Lighting",
                    description:
                        "Make sure light falls from above. Avoid side shadows to keep Braille dots clear and easy to scan.",
                    image: "assets/images/inctruction_light.png",
                  ),
                  OnboardingItem(
                    title: "Keep Phone Parallel",
                    description:
                        "Hold your phone flat and parallel to the paper. This helps the camera capture Braille accurately.",
                    image: "assets/images/instruction_phone.png",
                  ),
                  OnboardingItem(
                    title: "Support Learning & Independence",
                    description:
                        "Help students learn, teachers check assignments, and families understand Braille. Make everyday communication easier.",
                    image: "assets/images/onboarding3.png",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: SmoothPageIndicator(
                controller: controller,
                count: 4,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Theme.of(context).primaryColor,
                ),
                onDotClicked: (index) {},
              ),
            ),
            CustomButton(
              onTap: () {
                if (controller.page == 3) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                } else {
                  controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              text: "Next",
              margin: EdgeInsets.all(12),
            ),
          ],
        ),
      ),
    );
  }
}
