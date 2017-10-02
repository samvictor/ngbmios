import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; 
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:io';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/animation.dart';
import 'package:path_provider/path_provider.dart';
import 'audio.dart';
   
import 'builders.dart';
import 'widgets.dart';
   
// IOS


// This is the main file of this Flutter application
// Written by Sam for NGBM app for New Greater Bethel Ministries

// Screens & ids
//  0 = splash
//  1 = home 
//  2 = give
//  3 = help
//  4 = bible
//  5 = stream
//  6 = news
//  7 = about
//  8 = demand (on demand)
//  9 = mini   (ministries)
//      mini_page/{int} 
// 10 = times (service times)
// 11 = social    (social media)
// 12 = settings
// 13 = findus 
// 14 = form/{int}   

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(new MyApp(prefs: prefs));
}


// Transition between screens using this animation
// set this before Navigator.push
//int transition_type = 0;
// 0 = fade
// 1 = left
// 2 = right
// 3 = up
// 4 = down
// 5 = none

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute)
      return child;
    
    switch(transition_type) {
      case 0: {
        return new FadeTransition(opacity: animation, child: child);
      }
      break;
        
      case 1: {
        return  new SlideTransition(
          position: new FractionalOffsetTween(
            begin: new FractionalOffset(-1.0, 0.0),
            end: FractionalOffset.topLeft,
          ).animate(animation),
          child: child
        );
      }
      break;
        
      case 2: {
        return  new SlideTransition(
          position: new FractionalOffsetTween(
            begin: new FractionalOffset(-1.0, 0.0),
            end: FractionalOffset.topLeft,
          ).animate(animation),
          child: child
        );
      }
      break;
        
      case 5: {
        return child;
      }
      break;
        
      default: {
        return child;
      }
    }
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp({this.prefs});
  final SharedPreferences prefs;
  

  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NGBM',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Hot Reload App in IntelliJ). Notice that the counter
        // didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new BossMan(title: 'New Greater Bethel Ministries', prefs: prefs, bool_prefs: true),
      onGenerateRoute: (RouteSettings settings) {
        // these return so no break is necessary
        switch( settings.name.split('/')[1] ) {
          case 'give': 
            return new MyCustomRoute(
              builder: (_) => new Give(),
              settings: settings,
            );
          case 'help': 
            return new MyCustomRoute(
              builder: (_) => new Help(),
              settings: settings,
            );
          case 'bible': 
            return new MyCustomRoute(
              builder: (_) => new Bible(),
              settings: settings,
            );
          case 'stream': 
            return new MyCustomRoute(
              builder: (_) => new Stream(),
              settings: settings,
            );
          case 'news': 
            return new MyCustomRoute(
              builder: (_) => new News(),
              settings: settings,
            );
          case 'about': 
            return new MyCustomRoute(
              builder: (_) => new About(),
              settings: settings,
            );
          case 'demand': 
            return new MyCustomRoute(
              builder: (_) => new Demand(),
              settings: settings,
            );
          case 'mini': 
            return new MyCustomRoute(
              builder: (_) => new Mini(),
              settings: settings,
            );
          case 'mini_page': 
            // Expecting something like /mini_page/1
            return new MyCustomRoute(
              builder: (_) => new MiniPage( settings.name.split('/')[2] ),
              settings: settings,
            );
          //case 'times': 
          //  return new MyCustomRoute(
          //    builder: (_) => new Times(),
          //    settings: settings,
          //  );
          case 'social': 
            return new MyCustomRoute(
              builder: (_) => new Social(),
              settings: settings,
            );
          case 'settings': 
            return new MyCustomRoute(
              builder: (_) => new Settings(),
              settings: settings,
            );
          case 'findus': 
            return new MyCustomRoute(
              builder: (_) => new FindUs(),
              settings: settings,
            );
          case 'form': 
            // Expecting something like /form/1
            return new MyCustomRoute(
              builder: (_) => new BuildForm( settings.name.split('/')[2] ),
              settings: settings,
            );
          
          default: 
            print ('error: default reached at on generate route, switching on ');
            print (settings.name.split('/')[1]);
            return null;
        }
      }
    );
  }
}

class BossMan extends StatefulWidget {
  // this widget decides what page is displayed
  
  BossMan({Key key, this.title, this.prefs, this.bool_prefs}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;  
  final SharedPreferences prefs;
  final bool bool_prefs;

  @override
  _BossManState createState() => new _BossManState();
}

BuildContext home_context = null;

class _BossManState extends State<BossMan> with WidgetsBindingObserver, TickerProviderStateMixin {
  
  int _counter = 0;
  
  int _screen = 0;
  //  0 = splash
  //  1 = home 
  int _lang_set = 0;
  
  SharedPreferences _prefs;
  
  //final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  
  
  bool _only_home = false;
  
  //AudioPlayer audioPlayer;

  String localFilePath;

  //PlayerState playerState = PlayerState.stopped;

  //get isPlaying => playerState == PlayerState.playing;
  //get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  
  
  Animation animation_fade;
  AnimationController controller_fade;
  
  Animation animation_n;
  AnimationController controller_n;
  Animation animation_g;
  AnimationController controller_g;
  Animation animation_b;
  AnimationController controller_b;
  Animation animation_m;
  AnimationController controller_m;
  Animation animation_globe;
  AnimationController controller_globe;
  Animation animation_glow;
  AnimationController controller_glow;
  Animation animation_text;
  AnimationController controller_text;
  Animation animation_text2;
  AnimationController controller_text2;
  
  Animation animation_intro;
  AnimationController controller_intro;
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    
    
    home_context = context;
    
    
    _prefs = widget.prefs;
    _lang_set = _prefs.getInt('lang_set'); // <-this one
    var _player_state;
    
    // 0 => false, 1 => true
    if (_lang_set == null) _lang_set = 0;
    
    
    if(_screen == 0 && _lang_set > 0) {
      _screen = 1;
    }
    
    /*
    switch(_screen) {
      case 0: {
        // spash
        return _build_splash(context);
      }
      break;

      case 1: {
        // home
        return _build_home(context);
      }
      break;
      
      default: {
        return _build_home(context);
      }
    }*/
    
    if (_screen == 0) { // splash
      //audioPlayer.play(localFilePath);
      controller_n.forward();
    }
    else if (_screen == 1) {// home
      controller_fade.forward(); 
    }
    
    
    return 
      (_only_home)?
        _build_home(context): 
        new Stack (
          children:
            (_screen == 0)? 
              <Widget>[ _build_home(context), _build_splash(context) ]: 
              <Widget>[ _build_home(context), _build_fade(context) ],
          fit: StackFit.expand,
        );
    
  }
  
  
  // ====================================== Builders ==============================================
  
  // screen builders
  String lang = 'English';
  
  Widget _build_splash(BuildContext context) {
    return new Opacity( 
      child: new Scaffold (
        body: new Column ( children: <Widget> [
          new Flexible (
            child: new Stack (
              children: <Widget> [/*
                new FractionallySizedBox(
                  child: new Image.asset(
                    'img/mis/logo.jpg',
                    fit: BoxFit.contain,
                  ),
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  alignment: new FractionalOffset(0.5, 0.5),
                ),*/
                new Opacity (
                  child: new FractionallySizedBox(
                    child: new Image.asset(
                      'img/intro/globe.png',
                      fit: BoxFit.contain,
                    ),
                    heightFactor: 0.54*(3.0 - animation_globe.value*2.0),
                    widthFactor: 0.54*(3.0 - animation_globe.value*2.0),
                    alignment: new FractionalOffset(0.54, 0.55),
                  ),
                  opacity: animation_globe.value,
                ),
                new Opacity (
                  child: new FractionallySizedBox(
                    child: new Image.asset(
                      'img/intro/glow.png',
                      fit: BoxFit.contain,
                    ),
                    heightFactor: 0.795,
                    widthFactor: 0.795,
                    alignment: new FractionalOffset(0.54, 0.57),
                  ),
                  opacity: animation_glow.value,
                ),

                new Opacity (
                  child: new FractionallySizedBox(
                    child: new Image.asset(
                      'img/intro/M.png',
                      fit: BoxFit.contain,
                    ),
                    heightFactor: 0.215,
                    widthFactor: 0.215,
                    alignment: new FractionalOffset(0.85, animation_m.value/2 + 0.001),
                  ),
                  opacity: animation_m.value,
                ),
                new Opacity (
                  child: new FractionallySizedBox(
                    child: new Image.asset(
                      'img/intro/B.png',
                      fit: BoxFit.contain,
                    ),
                    heightFactor: 0.17,
                    widthFactor: 0.17,
                    alignment: new FractionalOffset(0.6, animation_b.value/2),
                  ),
                  opacity: animation_b.value,
                ),
                new Opacity (
                  child: new FractionallySizedBox(
                    child: new Image.asset(
                      'img/intro/G.png',
                      fit: BoxFit.contain,
                    ),
                    heightFactor: 0.18,
                    widthFactor: 0.18,
                    alignment: new FractionalOffset(0.39, animation_g.value/2),
                  ),
                  opacity: animation_g.value,
                ),
                new Opacity (
                  child: new FractionallySizedBox(
                    child: new Image.asset(
                      'img/intro/N.png',
                      fit: BoxFit.contain,
                    ),
                    heightFactor: 0.18,
                    widthFactor: 0.18,
                    alignment: new FractionalOffset(0.176, animation_n.value/2),
                  ),
                  opacity: animation_n.value,
                ),
              ],
              fit: StackFit.expand,
            ),
            flex: 4,
          ),
          new Flexible (
            child: new Opacity (
              child: new Text('Welcome to the',
                           textAlign: TextAlign.center,
                           style: new TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w300,
                              color: new Color(0xff004080),
                              fontFamily: 'Roboto',
                          )),
              opacity: animation_text.value,
            ),
            flex: 1,
          ),
          new Flexible (
            child: new Opacity (
              child: new Text('HOUSE OF BETHEL',
                           textAlign: TextAlign.center,
                           style: new TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w200,
                              color: new Color(0xff003060),
                              fontFamily: 'Roboto',
                           )),
              opacity: animation_text2.value,
            ),
            flex: 1,
          ),
        ],),
        backgroundColor: new Color(0xfffcfcff),
      ),
      opacity: animation_intro.value,
    );
  }
  
  Widget _build_fade(BuildContext context) {
    return new Opacity( 
      child: new Scaffold (
        backgroundColor: Colors.black,
      ),
      opacity: animation_fade.value,
    );
  }
  
  Widget _build_home(BuildContext context) {
      
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('New Greater Bethel Ministries'),
        backgroundColor: new Color(0xff003880),
      ),
      drawer: new MyDrawer('/'),
      body: new Builder(
      // Create an inner BuildContext so that the onPressed methods
      // can refer to the Scaffold with Scaffold.of().
        builder: (BuildContext context) {
          return new Container ( 
            child: new Column(
              children: <Widget> [
//                not_bar(),
                build_flex_center (
                    new Stack(
                      children: <Widget> [
                        new Container (
                              child: new Image.asset(
                                'img/banner/banner2.png',
                                fit: BoxFit.cover,
                              ),
                        ),
                        new InkWell (
                          //child: (new_live)? new Text('Now Live', style: new TextStyle(color: Colors.white)): new Text(''),
                          onTap: () => Navigator.of(context).pushNamed('/news'),
                        ),
                        /*new Positioned (
                          child: new Container (
                                child: new InkWell(
                                  child: new Padding (
                                    child: new Icon(
                                      Icons.menu,
                                      color: Colors.white
                                    ),
                                    padding: new EdgeInsets.symmetric(
                                      vertical: 40.0, 
                                      horizontal: 10.0
                                    ),
                                  ),
                                  onTap: () => Scaffold.of(context).openDrawer(),
                                ),
                            color: new Color(0x90000000),
                                             width: 50.0,
                          ),
                          left: 0.0,
                          top: 0.0,
                          bottom: 0.0,
            
                        ),*/
            
                      ],
                      fit: StackFit.expand,
                    ),
                    flex: 2,
                ),
                build_flex_center (
                  new HomeBtns(),
                  flex: 10,
                ),
              ]
            ),
            color: Colors.black,
          );
        }
      )
    );
  }
  
  // ============================ Handle Back Pressed ==============================
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
   
    // notifications 
    /*
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        if (mounted)
          setState((){
            print("onMessage:");
            print(message['target']);

            switch (message['target']) {
              case 'events':
                new_notif = true;
                break;
              case 'live':
                new_live = true;
                break;

              default:
                new_notif = true;
            }
          });
      },
      onLaunch: (Map<String, dynamic> message) {
        switch (message['target']) {
          case 'events':
            Navigator.of(context).pushNamed('/news');
            break;
          case 'live':
            Navigator.of(context).pushNamed('/demand');
            break;
            
          default:
            Navigator.of(context).pushNamed('/news');
        }
      },
      onResume: (Map<String, dynamic> message) {
        print('message');
        print(message);
        switch (message['target']) {
          case 'events':
            Navigator.of(context).pushNamed('/news');
            break;
          case 'live':
            Navigator.of(context).pushNamed('/demand');
            break;
            
          default:
            Navigator.of(context).pushNamed('/news');
        }
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      //assert(token != null);
      //setState(() {
      //  _homeScreenText = "Push Messaging token: $token";
      //});
      //print(_homeScreenText);
    });
    _firebaseMessaging.subscribeToTopic('all');
    */
    
    // animations
    controller_fade = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final CurvedAnimation curve_fade =
        new CurvedAnimation(parent: controller_fade, curve: Curves.easeIn);
    animation_fade = new Tween(begin: 1.0, end: 0.2).animate(curve_fade)
      ..addListener(() {
        setState(() {
          if (animation_fade.isCompleted) {
            _only_home = true;
          }
        });
      });
    //controller_fade.forward();

    // intro
    controller_n = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve_n =
        new CurvedAnimation(parent: controller_n, curve: Curves.ease);
    animation_n = new Tween(begin: 0.0, end: 1.0).animate(curve_n)
      ..addListener(() {
        setState(() {
          if (animation_n.value >= 0.5) {
            controller_g.forward();
          }
        });
      });
    
    controller_g = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve_g =
        new CurvedAnimation(parent: controller_g, curve: Curves.ease);
    animation_g = new Tween(begin: 0.0, end: 1.0).animate(curve_g)
      ..addListener(() {
        setState(() {
          if (animation_g.value >= 0.5) {
            controller_b.forward();
          }
        });
      });
    
    controller_b = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve_b =
        new CurvedAnimation(parent: controller_b, curve: Curves.ease);
    animation_b = new Tween(begin: 0.0, end: 1.0).animate(curve_b)
      ..addListener(() {
        setState(() {
          if (animation_b.value >= 0.5) {
            controller_m.forward();
          }
        });
      });
    
    controller_m = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve_m =
        new CurvedAnimation(parent: controller_m, curve: Curves.ease);
    animation_m = new Tween(begin: 0.0, end: 1.0).animate(curve_m)
      ..addListener(() {
        setState(() {
          if (animation_m.isCompleted) {
            controller_globe.forward();
          }
        });
      });
    
    controller_globe = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve_globe =
        new CurvedAnimation(parent: controller_globe, curve: Curves.ease);
    animation_globe = new Tween(begin: 0.0, end: 1.0).animate(curve_globe)
      ..addListener(() {
        setState(() {
          if (animation_globe.isCompleted) {
            controller_glow.forward();
          }
        });
      });
    
    controller_glow = new AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    final CurvedAnimation curve_glow =
        new CurvedAnimation(parent: controller_glow, curve: Curves.ease);
    animation_glow = new Tween(begin: 0.0, end: 1.0).animate(curve_glow)
      ..addListener(() {
        setState(() {
          if (animation_glow.isCompleted) {
            controller_text.forward();
          }
        });
      });
    
    controller_text = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve_text =
        new CurvedAnimation(parent: controller_text, curve: Curves.ease);
    animation_text = new Tween(begin: 0.0, end: 1.0).animate(curve_text)
      ..addListener(() {
        setState(() {
          if (animation_text.value >= 0.5) {
            controller_text2.forward();
          }
        });
      });
    
    controller_text2 = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve_text2 =
        new CurvedAnimation(parent: controller_text2, curve: Curves.ease);
    animation_text2 = new Tween(begin: 0.0, end: 1.0).animate(curve_text2)
      ..addListener(() {
        setState(() {
          if (animation_text2.isCompleted) {
            controller_intro.forward();
          }
        });
      });
    
    
    controller_intro = new AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    final CurvedAnimation curve_intro =
        new CurvedAnimation(parent: controller_intro, curve: Curves.ease);
    animation_intro = new Tween(begin: 1.0, end: 0.0).animate(curve_intro)
      ..addListener(() {
        setState(() {
          if (animation_intro.isCompleted) {
            _only_home = true;
            _prefs.setInt('lang_set', 1); // first launch complete
            print('done with fade out');
          }
        });
      });

    /*
    initAudioPlayer();
    
    
    // play audio
    Future playIntro() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = new File("${dir.path}/audio_asset.mp3");
      final audioData = await rootBundle.load("img/intro/bethel.mp3");
      final bytes = audioData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      localFilePath = file.path;
      //_launchLocalAsset();
    }
    playIntro();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();

    audioPlayer.setDurationHandler((d) => setState(() {
          //print('_AudioAppState.setDurationHandler => d ${d}');
          duration = d;
        }));

    audioPlayer.setPositionHandler((p) => setState(() {
          //print('_AudioAppState.setPositionHandler => p ${p}');
          position = p;
        }));

    audioPlayer.setCompletionHandler(() {
        
      onComplete();
        setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        //playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
    
    */
  }

  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  int back_counter = 0;
  Future dec() async {
    
    return (await new Future.delayed(new Duration(milliseconds: 1000), () => back_counter = 0));
  }
  
  @override
  didPopRoute() async {
    back_counter++;
    
    dec(); 
    
    
    if( back_counter > 1)
      return false;
    else
      return true;
  }
}




/* notes for IOS app:

restrict to portrait only
change spash image and launcher icon
setup firebase messaging


updates:
notification bar padding
events cycling
notifications
webview
bible app


before release:
playstore images
use "flex" to make sure banner image is right size

our leader
upcoming events
swat
prison

banner: 1280 width, 320 height
banner: 700 width, 200 height

change menu icons

back button message

global message system for 'message sent'
check 'get notification permision' on ios
just query fb data instead of keeping a database

new notification and new live on banner with data notification 
use firebase to load news images
add materials for ink splash


clipping on service times

intro in tab

*/
