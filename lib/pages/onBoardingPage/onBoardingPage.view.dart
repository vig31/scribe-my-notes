import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();

  int currentIndexPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.position.addListener(() {
        currentIndexPage = _pageController.page!.ceil();
        setState(() {
          currentIndexPage;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_pageController.page!.toInt() == 3) {
              Navigator.pushReplacementNamed(context, "/home");
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInCubic,
              );
            }
          },
          child: const Icon(Icons.arrow_forward_rounded)),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              pageSnapping: true,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "lib/resources/images/secure_notes.svg",
                        fit: BoxFit.cover,
                        width: 240,
                        height: 240,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Secure Your Notes",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Your Notes, Your Privacy. We've got you covered with the latest in biometric security. Keep your notes safe and sound with your unique fingerprint or face recognition.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "lib/resources/images/manage_notes.svg",
                        fit: BoxFit.cover,
                        width: 240,
                        height: 240,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Easy Management",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Simplicity is key. We've designed our app with an intuitive interface, so you can effortlessly create, edit, and organize your notes. Enjoy a hassle-free note-taking experience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "lib/resources/images/style_notes.svg",
                        fit: BoxFit.cover,
                        width: 240,
                        height: 240,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Style Your Notes",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Express yourself. Our app offers essential styling features, including bold, italic, and more. Make your notes uniquely yours with rich text formatting.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "lib/resources/images/notify_notes.svg",
                        fit: BoxFit.cover,
                        width: 240,
                        height: 240,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Never Miss a Beat",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Stay on top of your notes with custom notifications. Set specific times to receive reminders for important notes, ensuring you never forget a thing.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          DotsIndicator(
            dotsCount: 4,
            position: currentIndexPage,
            decorator: DotsDecorator(
              activeColor: Theme.of(context).colorScheme.primary,
              size: const Size.square(8),
              color: Theme.of(context).disabledColor,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          )
        ],
      ),
    );
  }
}
