import 'package:flutter/material.dart';
import 'splashh.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onSkip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashhPage()),
    );
  }


  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildPage(
                  image: 'assets/images/newBack1.jpg',
                  textTop: 'كل شحنة ولها طريقة',
                  textBottom: 'ونحن نوصلها أسرع مع جرين هب',
                ),
                _buildPage(
                  image: 'assets/images/newBack2.jpg',
                  textTop: 'توصيل آمن وسريع',
                  textBottom: 'نحن هنا لتلبية احتياجاتك',
                ),
                _buildPage(
                  image: 'assets/images/newBack3.jpg',
                  textTop: 'تجربة سلسة ومريحة',
                  textBottom: 'كل ما تحتاجه في مكان واحد',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 48), // مساحة للزر
              Row(
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.black : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required String image, required String textTop, required String textBottom}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: TextButton(
            onPressed: _onSkip,
            child: Text(
              'تخطي',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          bottom: 100, // موضع النص العلوي
          right: 20,
          child: Text(
            textTop,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 80, // موضع النص السفلي
          right: 20,
          child: Text(
            textBottom,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'مرحبًا بك في جرين هب!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}