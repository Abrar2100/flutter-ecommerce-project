import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.jpg",
      "title": "Welcome",
      "subtitle": "Book and manage appointments easily"
    },
    {
      "image": "assets/images/onboarding2.jpg",
      "title": "Browse Products",
      "subtitle": "Check categories and products instantly"
    },
    {
      "image": "assets/images/onboarding3.jpg",
      "title": "Fast & Secure",
      "subtitle": "Enjoy secure login and smooth checkout"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) => setState(() => currentIndex = index),
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // الصورة مع حواف منحنية
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    onboardingData[index]["image"]!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),
                // العنوان لونه أصفر
                Text(
                  onboardingData[index]["title"]!,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[700],
                  ),
                ),
                const SizedBox(height: 15),
                // النص تحت العنوان
                Text(
                  onboardingData[index]["subtitle"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
      // زر البدء
      bottomSheet: currentIndex == onboardingData.length - 1
          ? SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // زر أزرق
                  foregroundColor: Colors.white, // خط أبيض
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Container(
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingData.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex == index ? 12 : 8,
                    height: currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.blue[900]
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
    );
  }
}