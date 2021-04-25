import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final numberOfPages = 3;

void main() {
  runApp(MyApp());
}

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;

  PageOffsetNotifier(PageController pageController) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = pageController.page;
      notifyListeners();
    });
  }

  double get offset => _offset;

  double get page => _page;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme().apply(bodyColor: Colors.white, displayColor: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          accentColor: Colors.yellow),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController _controller;
  TweenSequence<Color> _colors;
  final purpleColor = Color.fromARGB(255, 94, 60, 196);
  final redColor = Color.fromARGB(255, 204, 51, 102);
  final blueColor = Color.fromARGB(255, 103, 153, 255);
  @override
  void initState() {
    _controller = PageController();
    _colors = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(
          begin: purpleColor,
          end: redColor,
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: redColor,
          end: blueColor,
        ),
        weight: 50,
      ),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PageOffsetNotifier(_controller),
      child: Consumer<PageOffsetNotifier>(
        builder: (context, notifier, child) => Scaffold(
            backgroundColor: _colors.animate(AlwaysStoppedAnimation(notifier.page / (numberOfPages - 1))).value,
            body: child,
            bottomNavigationBar: BottomNavigation(
              pageController: _controller,
            )),
        child: PageView(
          controller: _controller,
          children: [
            SinglePage(
              icon: Icons.home_work_outlined,
              upText: 'Basic',
              bottomDescription: 'One time payment build and purchased ios apps',
              bottomText: 'All extensions included',
              index: 0,
            ),
            SinglePage(
              icon: Icons.airplanemode_active,
              upText: 'Standard',
              bottomDescription: 'One time payment build and purchased ios apps',
              bottomText: 'All extensions included',
              index: 1,
            ),
            SinglePage(
              icon: Icons.access_alarm_sharp,
              upText: 'Premium',
              bottomDescription: 'One time payment build and purchased ios apps',
              bottomText: 'All extensions included',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class SinglePage extends StatefulWidget {
  const SinglePage({
    Key key,
    this.icon,
    this.upText,
    this.bottomText,
    this.bottomDescription,
    this.index,
  }) : super(key: key);

  @override
  _SinglePageState createState() => _SinglePageState();
  final int index;
  final IconData icon;
  final String upText;
  final String bottomText;
  final String bottomDescription;
}

class _SinglePageState extends State<SinglePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Consumer<PageOffsetNotifier>(
              builder: (context, notifier, child) => SlideTransition(
                position: Tween<Offset>(begin: Offset(0, -20), end: Offset(0, 0)).animate(
                  AlwaysStoppedAnimation(
                    _animationValueForSinglePage(notifier, widget.index),
                  ),
                ),
                child: child,
              ),
              child: Center(
                child: Text(
                  widget.upText,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
          ),
          //Spacer(),
          Expanded(
            flex: 4,
            child: Consumer<PageOffsetNotifier>(
              builder: (context, notifier, child) => Opacity(
                opacity: _animationValueForSinglePage(notifier, widget.index),
                child: child,
              ),
              child: Icon(
                widget.icon,
                size: 200,
              ),
            ),
          ),
          //Spacer(),
          Expanded(
            flex: 3,
            child: Consumer<PageOffsetNotifier>(
              builder: (context, notifier, child) => SlideTransition(
                  position: Tween<Offset>(begin: Offset(0, 20), end: Offset(0, 0)).animate(
                    AlwaysStoppedAnimation(
                      _animationValueForSinglePage(notifier, widget.index),
                    ),
                  ),
                  child: child),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Text(
                        widget.bottomText,
                        style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      widget.bottomDescription,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white.withOpacity(.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  final PageController pageController;

  const BottomNavigation({
    Key key,
    @required this.pageController,
  })  : assert(pageController != null),
        super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        height: kBottomNavigationBarHeight,
        padding: EdgeInsets.symmetric(horizontal: 36.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ThreeDots(
              pageController: widget.pageController,
            ),
            FloatingActionButton(
              onPressed: () {},
              child: Icon(
                Icons.arrow_forward,
                size: 26.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThreeDots extends StatelessWidget {
  final PageController pageController;

  const ThreeDots({
    Key key,
    @required this.pageController,
  })  : assert(pageController != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: numberOfPages,
      effect: SlideEffect(
        dotColor: Colors.grey,
        activeDotColor: Colors.white,
        dotHeight: 12.0,
        dotWidth: 12.0,
      ),
    );
  }
}

class SingleDot extends StatelessWidget {
  final bool isActive;

  const SingleDot({
    Key key,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = isActive ? 14.0 : 12.0;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.grey,
      ),
    );
  }
}

double _animationValueForSinglePage(PageOffsetNotifier notifier, int index) {
  // 0: not started animation, 1: done animation
  final result = (-1 * 1 * (notifier.page - index).abs() + 1).clamp(0.0, 1.0);
  print(result.toString());
  return result;
}
