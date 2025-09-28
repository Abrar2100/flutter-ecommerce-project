
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_page.dart'; // تأكد أن LoginPage موجودة في مشروعك

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({Key? key}) : super(key: key);

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   final List<Map<String, String>> _pages = [
//     {
//       "title": "Welcome 🎉",
//       "subtitle": "Discover amazing products at your fingertips.",
//       "image": "assets/images/shopping.png", // ضع الصورة المحلية هنا
//     },
//     {
//       "title": "Easy to Use 🛒",
//       "subtitle": "Browse, add to cart, and checkout in seconds.",
//       "image": "assets/images/cart.png",
//     },
//     {
//       "title": "Start Shopping 🚀",
//       "subtitle": "Create your account and enjoy the full experience.",
//       "image": "assets/images/checkout.png",
//     },
//   ];

//   void _nextPage() {
//     if (_currentPage < _pages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _finishOnboarding();
//     }
//   }

//   void _skip() {
//     _finishOnboarding();
//   }

//   Future<void> _finishOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('first_time', false); // حفظ أنه تم عرض الـ Onboarding
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // زر التخطي أعلى اليمين
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: _skip,
//                 child: const Text(
//                   "Skip",
//                   style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             // صفحات الـ Onboarding
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: _pages.length,
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   final page = _pages[index];
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         page["image"]!,
//                         height: 250,
//                       ),
//                       const SizedBox(height: 30),
//                       Text(
//                         page["title"]!,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.indigo,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         page["subtitle"]!,
//                         style: const TextStyle(fontSize: 16, color: Colors.grey),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             // مؤشر الصفحات
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 _pages.length,
//                 (index) => AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   width: _currentPage == index ? 20 : 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: _currentPage == index ? Colors.indigo : Colors.grey,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // زر التالي / ابدأ الآن
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _nextPage,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigo,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     _currentPage == _pages.length - 1 ? "Get Started" : "Next",
//                     style: const TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// ---

// 4️⃣ تعديل main.dart لعرض Onboarding أولاً

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'onboarding_page.dart';
// import 'login_page.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   bool showOnboarding = prefs.getBool('first_time') ?? true;

//   runApp(MyApp(showOnboarding: showOnboarding));
// }

// class MyApp extends StatelessWidget {
//   final bool showOnboarding;
//   const MyApp({required this.showOnboarding});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'E-Commerce App',
//       home: showOnboarding ? const OnboardingPage() : const LoginPage(),
//     );
//   }
// }

