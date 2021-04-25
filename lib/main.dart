import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  Animation<Color> _animationColor;

  @override
  void initState() {
    _controller = PageController();
    _colors = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.deepPurpleAccent,
          end: Colors.red,
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.blue,
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
          backgroundColor: _colors.animate(AlwaysStoppedAnimation(notifier.page / 2)).value,
          body: child,
        ),
        child: PageView(
          controller: _controller,
          children: [
            SinglePage(
              icon: Icons.home_work_outlined,
              upText: 'Standard',
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
              upText: 'Standard',
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
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
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
              child: Text(
                widget.upText,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 3,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.bottomText,
                      style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      widget.bottomDescription,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          //Spacer(),
          BottomNavigation(),
        ],
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      color: Colors.white,
    );
  }
}

double _animationValueForSinglePage(PageOffsetNotifier notifier, int index) {
  // 0: not started animation, 1: done animation
  final result = (-1 * 1 * (notifier.page - index).abs() + 1).clamp(0.0, 1.0);
  print(result.toString());
  return result;
}
