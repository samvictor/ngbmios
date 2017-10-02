import 'builders.dart';
import 'pastor_bio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'zoomable_image.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

//import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;


// Transition between screens using this animation
// set this before Navigator.push
int transition_type = 0;
// 0 = fade
// 1 = left
// 2 = right
// 3 = up
// 4 = down
// 5 = none

Color app_bar_color = new Color(0xff003880);
bool new_notif = false;
bool new_live = false;
bool new_message = false;
String message = '';


class HomeBtns extends StatelessWidget {
    Color _grid_col = Colors.white;
    double _grid_width = 2.0;
    
    @override
    Widget build (BuildContext context) {
        return
            new Column (
              children: <Widget> [
                new Container (height: _grid_width, color: _grid_col),
                build_flex_center( 
                  new Row (
                    children: <Widget> [ // 6 - 11
                      build_home_btn (context, 6),
                      new Container (width: _grid_width, color: _grid_col),
                      build_home_btn (context, 7),
                    ]
                  ),
                ),
                new Container (height: _grid_width, color: _grid_col),
                build_flex_center( 
                  new Row (
                    children: <Widget> [
                      build_home_btn (context, 8),
                      new Container (width: _grid_width, color: _grid_col),
                      build_home_btn (context, 9),
                    ]
                  ),
                ),
              ]
            );
    }
    List<String> all_btn_text = ['Media', 'Bible', 'Give', 'Connect'];


    double line_spacing = 10.0;

    List<Widget> all_text_widg = [
        text_container ('Media'.toUpperCase()), 
        text_container ('Bible'.toUpperCase()), 
        text_container ('Give'.toUpperCase()), 
        text_container ('Connect'.toUpperCase()),
    ];

    List<String> all_route = ['/demand', '/bible', '/give', '/social', '/times', '/social'];

    List<String> all_img_loc  = ['img/home/crowd.jpg', 'img/home/bible.jpg', 'img/home/texting.jpg',
                       'img/home/lady.jpg', 'img/home/crowd.jpg','img/home/crowd.jpg'];

    
    Widget build_home_btn (BuildContext context, int id, {EdgeInsets padding = null}) {
    
        if (padding == null)
          padding = new EdgeInsets.symmetric (vertical: 0.0);
        
        String btn_text = all_btn_text[id - 6];
        Widget text_widg = all_text_widg[id - 6];
        String route = all_route[id - 6];
        String img_loc = all_img_loc[id - 6];
        
        return build_flex_center (
          new Padding (
            child: new InkWell (
                child: new Stack (
                    children: <Widget> [
                      new Container (
                            child: new Image.asset(
                                  img_loc,
                                  fit: BoxFit.cover,
                            ),
                      ),
                      new Center(
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: new Color(0x90000000),
                          ),
                        ),
                      ),
                      text_widg,
                    ],
                    fit: StackFit.expand,
                ),
                onTap: () {
                    if (id == 7) // bible
                        launchURL('http://biblewebapp.com');
                    else
                        Navigator.of(context).pushNamed(route);
                },
            ),
            padding: padding,
          )
        );
    }
    
}






// ======================================== SCREENS ===========================================
class Give extends StatelessWidget {
  Give();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Give'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/give'),
      body: new Column(
        children: <Widget> [
            build_flex_center (
                new InkWell (
                    child: new Stack (
                        children: <Widget> [
                                new Image.asset(
                                      'img/mis/laptop.jpg',
                                      fit: BoxFit.cover,
                                ),
                          new Center(
                            child: new Container(
                              decoration: new BoxDecoration(
                                color: new Color(0x30000000),
                              ),
                            ),
                          ),
                          text_container(
                            'Give Online'.toUpperCase(),
                            font_size: 40.0,
                          ),
                        ],
                        fit: StackFit.expand,
                    ),
                    onTap: () =>
                        launchURL('http://my.simplegive.com/dl/?uid=new219209'),
                ), 
            ),
            build_flex_center (
                new InkWell (
                    child: new Stack (
                        children: <Widget> [
                                new Image.asset(
                                      'img/home/texting.jpg',
                                      fit: BoxFit.cover,
                                ),
                          new Center(
                            child: new Container(
                              decoration: new BoxDecoration(
                                color: new Color(0x30000000),
                              ),
                            ),
                          ),
                          text_container(
                            'Text to Give'.toUpperCase(),
                            font_size: 40.0,
                          ),
                        ],
                        fit: StackFit.expand,
                    ),
                    onTap: () => 
                        launchURL('sms:3472692663'),
                ), 
            ),
        ]
      ),
    );
  }
}

  
class Help extends StatelessWidget {
  Help();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Prayer Requests'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/help'),
      body: new Column(
        children: <Widget> [
          build_flex_center (
            new ListView (
                children: <Widget> [
                    new Center( 
                        child: new Text (
                            "The Sinner's Prayer",
                            style: new TextStyle(
                                fontSize: 24.0,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w300,
                            ),
                        ),
                    ),
                    new Container (height: 8.0),
                    new Text (
                        'Lord Jesus I come today a sinner. I believe you died for me and rose again! Today Lord, I denounce every work of Satan in my life. And I confess you with my mouth and I believe in my heart that you are my Lord and Savior Jesus Christ.',
                        style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700],
                        ),
                    ),
                    new Container (height: 8.0),
                    new Container(
                        child:  new Text(
                            'Amen, Amen, and Amen!',
                            style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[700],
                            ),
                        ),
                    ),
        
                    new Divider(height: 26.0, color: Colors.black54),
        
                    new InkWell (
                        child: new Row (
                            children: <Widget> [
                                new Container(
                                    child: new Image.asset(
                                      'img/mis/phone.png',
                                      fit: BoxFit.cover,
                                    ),
                                    width: 42.0,
                                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                                ),
                                new Text('24 hour Prayer Line\n(718) 740-HELP (4357)'),
                            ],
                        ),
                    onTap: () => launchURL('tel:+1 718 740 4357'),
                    ),
                    
                    new Container(height: 15.0),
                    
                    new InkWell (
                        child: new Row (
                            children: <Widget> [
                                new Container(
                                    child: new Image.asset(
                                      'img/mis/email.png',
                                      fit: BoxFit.cover,
                                    ),
                                    width: 42.0,
                                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                                ),
                                new Text('ngbmprayer@gmail.com'),
                            ],
                        ),
                    onTap: () => launchURL('mailto:ngbmprayer@gmail.com?subject=Prayer Request'),
                    ),
                ], 
            ),
            padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          )
        ]
      ),
    );
  }
}

  
class Bible extends StatelessWidget {
  Bible();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Bible'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/bible'),
      body: new Column(
        children: <Widget> [
          build_flex_center (
            new Text('Bible Page'),
          ),
          new BotBar(),
        ]
      ),
    );
  }
}

  
class Stream extends StatelessWidget {
  Stream();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar (
        title: new Text('Stream'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/stream'),
      body: new Column(
        children: <Widget> [
          build_flex_center (
            new Text('Stream Page'),
          ),
        ]
      ),
    );
  }
}


class News extends StatefulWidget {
  @override
  NewsState createState() => new NewsState();
}
    
class NewsState extends State<News> {
    String pics = 'Loading...';
    bool loading = true;
    Map data_json = {};
    bool error = false;
    List <Widget> imgs = [];
    var img = new Text('loading...');
    
    _update_news() async {
        String data = '';
        try {
            data = await http.read('https://us-central1-hybrid-text-604.cloudfunctions.net/fb');
            var data_json = JSON.decode(data)['photos']['data'];
            var this_img_url;
            var this_big_url;
            //var img = null;
            for (int i = 0; i < data_json.length; i++) {
                this_img_url = data_json[i]['picture'];
                this_big_url = data_json[i]['images'][0]['source'];
                imgs.insert(0,  
                    new Stack(
                        children: <Widget> [
                            new Image.network(this_img_url, fit: BoxFit.cover),
                            new Image.network(this_big_url, fit: BoxFit.cover),
                            new InkWell(
                                onTap: () => launchURL(data_json[i]['link']), 
                            ),
                        ],
                        fit: StackFit.expand,
                    )
                );
            }
            
            if (mounted)
                setState ( () {
                    //pics = data;        
                    loading = false;
                });
        }
        catch (e) {
            print (e);
            if (mounted)
                setState(() {
                    error = true;
                });
            return;
        }
        
        if (mounted)
            setState ( () {
                //pics = data;        
                loading = false;
            });
    }
    @override
    initState() {
        _update_news();
        super.initState();
    }
    
    @override
    Widget build(BuildContext context) {
        new_notif = false;
        return new Scaffold (
          appBar: new AppBar(
            title: new Text('Announcements'),
            backgroundColor: app_bar_color
          ),
          drawer:  defaultTargetPlatform == TargetPlatform.iOS         
            ? null                                              
            : new MyDrawer('/news'),
          body: (loading)?
            new Center(
                child: new Text('Loading...', style: new TextStyle(fontSize: 20.0))
            ):
            new GridView.count(
                children: imgs,
                crossAxisCount: 2,
                primary: true,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
            ),
        );
    }
}


/*
class News extends StatefulWidget {
  @override
  NewsState createState() => new NewsState();
}
    
class NewsState extends State<News> {
  
  final DatabaseReference _feed_ref = FirebaseDatabase.instance.reference().child('all_feed');
  //StreamSubscription<Event> _feed_sub;
  var _feed_sub;
  
  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
    _feed_ref.keepSynced(true);
    _feed_sub = _feed_ref.limitToLast(10).onChildAdded.listen((Event event) {
      print('Child added: ${event.snapshot.value}');
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    _feed_sub.cancel();
  }
    
  Widget news_item(DataSnapshot snapshot) {
    var data = snapshot.value;
    return new Padding ( 
        child: new Container(
        child: new Material (
            child: new InkWell (
                child: new Padding (
                    child: new Column ( 
                        children:  <Widget> [
                            new Text(
                                data['message'].toString(),
                                style: new TextStyle(color: Colors.white),
                            ),
                            new Container(height: 15.0),
                            new Container(color: new Color(0x40000000), height: 0.5),
                            new Container(height: 4.0),
                            new Text(
                                new DateFormat.yMMMEd().addPattern('-').add_jm().format(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(
                                            data['created_time'].toString() + '000'
                                        )
                                    )
                                ),
                                style: new TextStyle(color: new Color(0x60ffffff)),
                            ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    padding: new EdgeInsets.all(15.0),
                ),
                onLongPress: () {
                    if (data['source'] == 'fb') {
                        fb_url('https://www.facebook.com/' + data['id']);
                    }
                },
            ),
            color: Colors.teal[900],
            //padding: new EdgeInsets.all(10.0),
            // height: 80.0,
            //minWidth: 3000.0,
            elevation: 4.0,
            type: MaterialType.button,
        ),
        width: 3000.0
        ),
        padding: new EdgeInsets.all(5.0),
    );
  }  
    
  @override
  Widget build(BuildContext context) {
    new_notif = false;
    
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Upcoming Events'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/news'),
      body: new Container ( 
        child: new FirebaseAnimatedList(
          key: new ValueKey<bool>(false),
          query: _feed_ref,
          reverse: false,
          sort: (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return new SizeTransition(
              sizeFactor: animation,
              child: news_item(snapshot),
            );
          },
        ),
        color: Colors.grey[900],
      ),
    );
  }
}

*/
  
class About extends StatelessWidget {
  About();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Our Leader'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/about'),
      body: new Container ( 
        child: new Padding (
          child: new ListView(
            children: <Widget> [
                new Container(height: 10.0),
                new Row ( children: <Widget> [
                    new Flexible(child: new Container(),flex: 2,),
                    new Flexible (
                        child: new Image.asset('img/mis/pastor.jpg', fit: BoxFit.contain),
                        flex: 2,
                    ),
                    new Flexible(child: new Container(), flex: 2,),
                ]),
                new Container(height: 10.0),
                new Text('Dr. John H. Boyd II', style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                new Container(height: 10.0),
                new Text(pastor_bio),
                new Container(height: 20.0),
            ]
          ),
          padding: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        ),
        color: new Color(0xffe0e8f3),
      ),
    );
  }
}

  

class Demand extends StatefulWidget {
    @override
    DemandState createState() => new DemandState();
}
    
class DemandState extends State<Demand> {
  
  final DatabaseReference _live_ref = FirebaseDatabase.instance.reference().child('fb_live/status');
  //StreamSubscription<Event> _feed_sub;
  var _live_sub;
  bool _is_live = false;
  
  @override
  void initState() {
    super.initState();
    _live_ref.keepSynced(true);
    _live_sub = _live_ref.onValue.listen((Event event) {
      setState((){
        print('live is');
        print(event.snapshot.value);
          
        _is_live = event.snapshot.value == 'live';
        new_live = _is_live;
      });
    });
  }
   
  @override
  void dispose() {
    super.dispose();
    _live_sub.cancel();
  }
    
  @override
  Widget build(BuildContext context) {
     
      
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Media'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/demand'),
      body: new Column (
          children: <Widget> [
            build_flex_center (
                new InkWell (
                    child: new Stack (
                        children: <Widget> [
                          new Center (
                            child: new Row (
                              children: <Widget>[ new Expanded (
                                child: new Image.asset(
                                      'img/home/crowd.jpg',
                                      fit: BoxFit.cover,
                                ),
                              ),],
                            ),
                          ),
                          new Center(
                            child: new Container(
                              decoration: new BoxDecoration(
                                color: new Color(0x40ffffff),
                              ),
                            ),
                          ),
                          new Column ( children: <Widget> [
                                  text_container(
                                    'Live Stream'.toUpperCase(),
                                    color: Colors.black,
                                    font_size: 40.0
                                  ),
                                  (_is_live)?
                                    text_container(
                                        'Now Live'.toUpperCase(),
                                        color: Colors.red,
                                        font_size: 30.0
                                    ):
                                    text_container(
                                        'Offline'.toUpperCase(),
                                        color: Colors.black,
                                        font_size: 30.0
                                    ),
                              ],
                            mainAxisAlignment: MainAxisAlignment.center, 
                        ),
                        ],
                        fit: StackFit.expand,
                    ),
                    onTap: () => fb_home(), // set to home when done
                ), 
            ),
            build_flex_center (
                new InkWell (
                    child: new Stack (
                        children: <Widget> [
                          new Center (
                            child: new Row (
                              children: <Widget>[ new Expanded (
                                child: new Image.asset(
                                      'img/mis/demand.jpg',
                                      fit: BoxFit.cover,
                                ),
                              ),],
                            ),
                          ),
                          new Center(
                            child: new Container(
                              decoration: new BoxDecoration(
                                color: new Color(0x38000000),
                              ),
                            ),
                          ),
                          text_container(
                            'On Demand'.toUpperCase(),
                            font_size: 40.0
                          ),
                        ],
                        fit: StackFit.expand,
                    ),
                    onTap: () => 
                        launchURL('https://youtube.com/ngbmbm')
                ), 
            ),
          ],
        
      )
    );
  }
}

  
class Mini extends StatelessWidget {
  BuildContext this_context;
  Mini();
  
  
  Widget _build_mini_button(String img_path, String title, String dest) {
    return new Flexible(
        child: new InkWell ( 
            child: new Stack (
                children: <Widget> [
                    /*new Image.asset(
                      img_path,
                      fit: BoxFit.cover,
                    ),*/
                    new Container(color: Colors.blue),
                    /*new BackdropFilter(
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: new Color(0x80000000),
                          ),
                        ),
                        filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    ),*/

                    new Center(
                        child: new Text(
                            title, 
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                            ),
                        ),
                    ),
                ],
                fit: StackFit.expand,
            ),
        onTap: () => Navigator.of(this_context).pushNamed(dest),
        ),
        flex: 1,
        fit: FlexFit.tight,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    this_context = context;
    return new Scaffold (
      appBar: new AppBar (
        title: new Text('Ministries'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/mini'),
      body: new Column(
        children: <Widget> [
          build_flex_center (
            new Container (
                child: new Column (
                    children: <Widget> [
                        _build_mini_button('img/mini/tent.jpg', 'Tent Ministry', '/mini_page/0'),
                        new Container (height: 0.5, color: Colors.black),
                        _build_mini_button('img/mini/academy.jpg', 'Christian Academy', '/mini_page/1'),
                        new Container (height: 0.5, color: Colors.black),
                        _build_mini_button('img/mini/health.jpg', 'Health Fair', '/mini_page/2'),
                        new Container (height: 0.5, color: Colors.black),
                        _build_mini_button('img/mini/men.jpg', "Men's Ministry", '/mini_page/3'),
                        new Container (height: 0.5, color: Colors.black),
                        new Flexible(
                            child: new Container(
                                child: new InkWell ( 
                                    child: new Center (
                                        child: new Text(
                                            'Find Other Ministries on our Website',
                                            style: new TextStyle (
                                                color: Colors.white,
                                                fontSize: 16.0,
                                            ),
                                        ),
                                    ),
                                    onTap: () => launchURL('http://ngbm.org'),
                                ),
                                decoration: new BoxDecoration(color: Colors.grey[800])
                            ),
                            flex: 1,
                            fit: FlexFit.tight,
                        ),
                    ],
                ),
                color: Colors.grey[700],
            ),
          ),
        ]
      ),
    );
  }
}

class MiniPage extends StatelessWidget {
    String _page_id;
    List <String> _all_img_string = ['img/mini/tent.jpg', 'img/mini/academy.jpg', 
                                     'img/mini/health.jpg', 'img/mini/men.jpg'];
    List <String> _all_mini_name = ['SWAT Ministry', 'Prison Ministry', 
                                    'Health Fair', "Men's Ministry"];
    
    MiniPage (this._page_id);
    
    
    @override
    Widget build (BuildContext context) {
        int _id = int.parse(_page_id);
        return new Scaffold (
            appBar: new AppBar (
                title: new Text(_all_mini_name[_id]),
                backgroundColor: app_bar_color
            ),
            drawer:  defaultTargetPlatform == TargetPlatform.iOS         
                ? null                                              
                : new MyDrawer('/mini_page/'+_page_id),
            body: new Column ( children: <Widget> [
                new Expanded(
                    child: new ZoomableImage (
                        new AssetImage( _all_img_string[_id]), 
                        scale: 20.0,
                    ),
                ),
            ],),
        );
    }
}

/*  
class Times extends StatelessWidget {
  Times();
  
  Widget _build_title(String text) =>
                    new Text (text, 
                            style: new TextStyle(
                                fontSize: 26.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                            ));
  
  Widget _build_entry(String text) =>
                    new Padding ( 
                        child: new Text(text,
                                        style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.grey[50],
                                            fontWeight: FontWeight.w300,
                                        )),
                        padding: new EdgeInsets.only(top: 3.0),
                    );
    
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Service Times'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/times'),
      body: new Container (
        child: new Column(
        children: <Widget> [
          build_flex_center (
            new Stack (
                children: <Widget> [
                  new Container (
                    child: new Column (
                      children: <Widget>[ new Expanded (
                        child: new Image.asset(
                              'img/home/home4.png',
                              fit: BoxFit.cover,
                        ),
                      ),],
                    ),
                  ),
                  
                  new Center(
                    child: new BackdropFilter(
                        child: new Container(
                          decoration: new BoxDecoration(
                            color: new Color(0x80000000),
                          ),
                        ),
                        filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    ),
                  ),
                  
                  new Column( 
                    children: <Widget> [
                        new Container(height: 14.0),
                        _build_title('Sunday'),
                        _build_entry('8:00 am - Early Morning Service'),
                        _build_entry('9:00 am - Sunday School (all ages)'),
                        _build_entry('11:45 am - Noon Day Service'),
                        new Container(height: 12.0),
                        _build_title('Tuesday'),
                        _build_entry('5:00 am - Morning Glory Prayer'),
                        _build_entry('12:00 noon - Faith Clinic'),
                        new Container(height: 12.0),
                        _build_title('Wednesday'),
                        _build_entry('7:00 pm - Family Night Teaching'),
                        new Container(height: 12.0),
                        _build_title('Friday'),
                        _build_entry('7:00 pm - Deliverance Service'),
                        new Container(height: 12.0),
                        _build_title('Saturday'),
                        _build_entry('5:00 am - Morning Glory Prayer'),
                    ]
                ),
              ]
            ),
            padding: new EdgeInsets.only(top: 1.0),
          )
        ]
      ),
      decoration: new BoxDecoration(color: Colors.grey[700])),
    );
  }
}
*/

  
class Social extends StatelessWidget {
  Social();
  
  double _grid_width = 2.0;
    
  @override
  Widget build(BuildContext context) {
      
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Connect With Us'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/social'),
      body: 
            new Column(
                children: <Widget> [
                    new Flexible (
                        child: new Stack (
                            children: <Widget> [
                                new Image.asset(
                                    'img/mis/mic.jpg',
                                    fit: BoxFit.cover,
                                ),
                                new Container (color: new Color(0x30000000)),
                                new InkWell (
                                  child: text_container(
                                    'Talk To Us'.toUpperCase(),
                                    font_size: 30.0,
                                  ),  
                                  onTap: () => Navigator.of(context).pushNamed('/form/0'),
                                ),
                                
                            ],
                            fit: StackFit.expand,
                        ),
                        flex: 2,
                    ),
                    
                    new Container(color: Colors.white, height: _grid_width),
                    
                    new Flexible (
                        child: new Stack (
                            children: <Widget> [
                                new Image.asset(
                                    'img/mis/pray.jpg',
                                    fit: BoxFit.cover,
                                ),
                                new Container (color: new Color(0x30ffffff)),
                                new InkWell (
                                  child: text_container(
                                    'Prayer Requests'.toUpperCase(),
                                    font_size: 30.0,
                                    color: Colors.black,
                                  ),  
                                  onTap: () => Navigator.of(context).pushNamed('/form/1'),
                                ),
                            ],
                            fit: StackFit.expand,
                        ),
                        flex: 2,
                    ),
                    
                    new Container(color: Colors.white, height: _grid_width),
        
                    new Flexible (
                        child: new Row (
                          children: <Widget> [
                            new Flexible (
                                child: new Stack (
                                    children: <Widget> [ 
                               //         new Image.asset(
                               //           'img/social/fb.png',
                               //           fit: BoxFit.cover,
                               //         ),
                                        new Container(color: new Color(0xff4477ff)),
                                        new InkWell (
                                          child: text_container(
                                            'Facebook'.toUpperCase(), 
                                            font_size: 30.0,
                                          ),  
                                          onTap: () => fb_home(),
                                        ),
                                    ],
                                    fit: StackFit.expand,
                                ),
                                flex: 1,
                            ),
                    
                            new Container(color: Colors.white, width: _grid_width),
                            
                            new Flexible (
                                child: new Stack (
                                    children: <Widget> [ 
                                //        new Image.asset(
                                //          'img/social/yt.png',
                                //          fit: BoxFit.cover,
                                //        ),
                                        new Container(color: new Color(0xff7055ff)),
                                        new InkWell (
                                          child: text_container(
                                            'Instagram'.toUpperCase(),
                                            font_size: 30.0,
                                          ),  
                                          onTap: () async { 
                                            try {
                                                await launchURL('instagram://user?username=ngbmonline');
                                            }
                                            catch(e) {
                                                launchURL('https://www.instagram.com/ngbmonline/');
                                            }
                                          },
                                        ),
                                    ],
                                    fit: StackFit.expand,
                                ),
                                flex: 1,
                            ),
        /*
                            new Flexible (
                                child: new Stack (
                                    children: <Widget> [ 
                                        new Container(color: new Color(0xffffffff)),
                                        new InkWell (
                                          child: new Image.asset(
                                              'img/social/fb.png',
                                              fit: BoxFit.contain,
                                          ),
                                          onTap: () => fb_home(),
                                        ),
                                    ],
                                    fit: StackFit.expand,
                                ),
                                flex: 1,
                            ),
                    
                            new Flexible (
                                child: new Stack (
                                    children: <Widget> [ 
                                        new Container(color: new Color(0xffffffff)),
                                        new InkWell (
                                          child: new Image.asset(
                                              'img/social/insta.png',
                                              fit: BoxFit.contain,
                                          ),
                                          onTap: () async { 
                                            try {
                                                await launchURL('instagram://user?username=ngbmonline');
                                            }
                                            catch(e) {
                                                launchURL('https://www.instagram.com/ngbmonline/');
                                            }
                                          },
                                        ),
                                    ],
                                    fit: StackFit.expand,
                                ),
                                flex: 1,
                            ),
                    
                            
                            new Flexible (
                                child: new Stack (
                                    children: <Widget> [ 
                                        new Container(color: new Color(0xffffffff)),
                                        new InkWell (
                                          child: new Image.asset(
                                              'img/social/yt.png',
                                              fit: BoxFit.contain,
                                          ),
                                          onTap: () async { 
                                                launchURL('https://www.youtube.com/ngbmbm/');
                                          },
                                        ),
                                    ],
                                    fit: StackFit.expand,
                                ),
                                flex: 1,
                            ),
                    
                            
                            new Flexible (
                                child: new Stack (
                                    children: <Widget> [ 
                                //        new Image.asset(
                                //          'img/social/yt.png',
                                //          fit: BoxFit.cover,
                                //        ),
                                        new Container(color: new Color(0xffffffff)),
                                        new InkWell (
                                          child: text_container(
                                            'Insm'.toUpperCase(),
                                            font_size: 30.0,
                                          ),  
                                          onTap: () async { 
                                            launchURL('https://snapchat.com/add/ngbmonline');
                                          },
                                        ),
                                    ],
                                    fit: StackFit.expand,
                                ),
                                flex: 1,
                            ),*/
                            /*new IconButton(
                                icon: new Image.asset(
                                  'img/social/yt.png',
                                  fit: BoxFit.cover,
                                ),
                                iconSize: 55.0,
                                onPressed: () => launchURL('https://www.instagram.com/ngbmonline/'),
                            ),*/
                          ]
                        ),
                        flex: 1,
                    ),
                    new Container(color: Colors.white, height: _grid_width),
        
                    new Flexible (
                        child: new Stack (
                            children: <Widget> [
                                new Image.asset(
                                    'img/home/texting.jpg',
                                    fit: BoxFit.cover,
                                ),
                                new Container (color: new Color(0x50000000)),
                                new InkWell (
                                  child: text_container(
                                    'App Feedback'.toUpperCase(),
                                    font_size: 30.0,
                                    color: Colors.white,
                                  ),  
                                  onTap: () => Navigator.of(context).pushNamed('/form/2'),
                                ),
                            ],
                            fit: StackFit.expand,
                        ),
                        flex: 2,
                    ),
                    
                ]
            ),
    );
  }
}


  
class FindUs extends StatelessWidget {
  FindUs();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Find Us'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/findus'),
      body: new Column(
        children: <Widget> [
          build_flex_center (
            new ListView(
                children: <Widget> [
                    new Container (
                        child: new Container (
                            child: new InkWell (
                                child: new Image.asset(
                                    'img/mis/maps1.png',
                                    fit: BoxFit.cover,
                                ),
                                onTap: () => launchURL('https://www.google.com/maps/place/New+Greater+Bethel+Ministries'),
                            ),
                            decoration: new BoxDecoration(border: new Border.all(
                              color: Colors.grey[700],
                              width: 0.5,
                            )),
                        ),
                        padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    ),
                    new Container(height: 12.0),            
        
                    new Padding (
                        child: new MaterialButton (  
                            child: new Row (
                                children: <Widget> [
                                    new Container(
                                        child: new Image.asset(
                                          'img/mis/map_icon.png',
                                          fit: BoxFit.cover,
                                        ),
                                        width: 60.0,
                                        padding: new EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 10.0),
                                    ),
                                    new Text('NGBM, 215-32 Jamaica Ave\nQueens Village, NY 11428', 
                                                style: new TextStyle(color: Colors.white)),
                                ],
                            ),
                            onPressed: () => launchURL('https://www.google.com/maps/place/New+Greater+Bethel+Ministries'),
                            height: 60.0,
                            color: Colors.teal,
                        ),
                        padding: new EdgeInsets.symmetric( horizontal: 8.0 ),
                    ),
                    new Container(height: 8.0),
                    
                    new Padding (
                        child: new MaterialButton (
                            child: new Row (
                                children: <Widget> [
                                    new Container(
                                        child: new Icon(
                                            Icons.call,
                                            size: 38.0,
                                            color: Colors.white,
                                        ),
                                        /*new Image.asset(
                                          'img/mis/phone.png',
                                          fit: BoxFit.cover,
                                        ),*/
                                        padding: new EdgeInsets.fromLTRB(16.0, 0.0, 6.0, 0.0),
                                    ),
                                    new Text('(718) 740-4357', style: new TextStyle(color: Colors.white)),
                                ],
                            ),
                            onPressed: () => launchURL('tel:+1 718 740 4357'),
                            height: 55.0,
                            color: Colors.teal,
                        ),
                        padding: new EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    new Container(height: 12.0),
                    
                    new Container (
                        child: new Padding (
                            child: new Column (
                                children: <Widget> [
                                    new Text ( 'Service Times'.toUpperCase(), 
                                        style: new TextStyle(
                                            fontSize: 26.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                        )
                                    ),
                                    new Container(height: 12.0),
                                    _build_title('Sunday'),
                                    _build_entry('8:00 am - Early Morning Service'),
                                    _build_entry('9:30 am - Sunday School (all ages)'),
                                    _build_entry('11:45 am - Noon Day Service'),
                                    new Container(height: 12.0),
                                    _build_title('Tuesday'),
                                    _build_entry('5:00 am - Morning Glory Prayer'),
                                    _build_entry('12:00 noon - Faith Clinic'),
                                    new Container(height: 12.0),
                                    _build_title('Wednesday'),
                                    _build_entry('7:00 pm - Empowerment Night'),
                                    new Container(height: 12.0),
                                    _build_title('Friday'),
                                    _build_entry('7:00 pm - Deliverance Service'),
                                    new Container(height: 12.0),
                                    _build_title('Saturday'),
                                    _build_entry('5:00 am - Morning Glory Prayer'),
                                ],
                            ),
                            padding: new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 40.0),
                        ),
                        color:  new Color(0xFF016080),
                    ),
                ]
            ),
          )
        ]
      ),
    );
  }
    
      
  Widget _build_title(String text) =>
    new Row (
      children: <Widget> [
        new Text (text, 
            style: new TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
            )
        )
      ]
    );

  Widget _build_entry(String text) =>
    new Padding (
        child: new Row ( 
            children: <Widget> [
              new Text(text,
                style: new TextStyle (
                    fontSize: 17.0,
                    color: Colors.grey[100],
                    fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.left,
              ),
            ],
        ),
        padding: new EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 0.0),
    );
    
}


class Settings extends StatelessWidget {
  Settings();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Settings'),
        backgroundColor: app_bar_color
      ),
      drawer:  defaultTargetPlatform == TargetPlatform.iOS         
        ? null                                              
        : new MyDrawer('/settings'),
      body: new Column(
        children: <Widget> [
          build_flex_center (
            new Text('Settings Page'),
          )
        ]
      ),
    );
  }
}

class BuildForm extends StatefulWidget {
  String _page_id_out;
    
  BuildForm(this._page_id_out, { Key key }) : super(key: key);

  @override
  BuildFormState createState() => new BuildFormState(_page_id_out);
}


class BuildFormState extends State<BuildForm> {
    String _page_id;
    List <String> _all_type_string = ['Comment', 'Prayer Request', 'App Feedback'];
    List <String> _all_form_name = ['Talk To Us', 'Prayer Request', 'App Feedback'];
    BuildFormState (this._page_id);
    
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    
    String _name;
    String _email;
    String _text;
    bool _autovalidate = false;
    
    
    void showInSnackBar(String value) async {
        var _track_me = _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(value)
        ));
        await _track_me.closed;
        if(mounted)
          Navigator.of(context).pop();
    }
    
    String _validate_name (String value) {
        if (value.isEmpty)
          return 'Please enter your name.';
        
        return null;
    }
    String _validate_email (String value) {
        if (value.isEmpty)
          return 'Please enter your email address.';
        
        final RegExp email_regex = new RegExp(r'^.+@.+\..+$');
        if (!email_regex.hasMatch(value))
            return 'Please enter a valid email address';
        
        return null;
    }
    String _validate_text (String value) {
        if (value.isEmpty)
          return 'This field cannot be blank.';
        
        return null;
    }
    
    void _handleSubmitted () async {
        final FormState form = _formKey.currentState;
        if (!form.validate()) {
          _autovalidate = true;  // Start validating on every change.
          showInSnackBar('Please fix the errors in red before submitting.');
        } else {
          form.save();
          var _url = 'https://us-central1-hybrid-text-604.cloudfunctions.net/email';
          
          try {
              var response = await http.post(_url, body: {
                'key': r'NWrgeNTVDJA$aF$FJAdAFVJ%j039^@*72J',
                'name': _name,
                'email': _email,
                'type': _all_type_string[int.parse(_page_id)],
                'text': _text
              });
              if (!mounted)
                  return;
              await showInSnackBar(response.body);
              if (!mounted)
                  return;
              //Navigator.of(context).pop();
          }
          catch (e) {
            print(e);
            if (mounted)
                showInSnackBar('You are offline');
          }
        }
    }

    
    @override
    Widget build (BuildContext context) {
        int _id = int.parse(_page_id);
        return new Scaffold (
            key: _scaffoldKey,
            appBar: new AppBar (
                title: new Text(_all_form_name[_id]),
                backgroundColor: app_bar_color
            ),
            drawer:  defaultTargetPlatform == TargetPlatform.iOS         
                ? null                                              
                : new MyDrawer('/form/'+_page_id),
            body: new Form (
              key: _formKey,
              child: new ListView (
                children: <Widget> [
            
                    new TextFormField (
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        labelText: 'Name',
                      ),
                      maxLines: 2,
                      onSaved: (String value) { _name = value; },
                      validator: _validate_name,
                    ),
                    
                    new TextFormField (
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.alternate_email),
                        labelText: 'Your Email Address',
                      ),
                      maxLines: 2,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String value) { _email = value; },
                      validator: _validate_email,
                    ),
                    
                    new TextFormField (
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.create),
                        labelText: _all_type_string[_id],
                      ),
                      maxLines: 12,
                      onSaved: (String value) { _text = value; },
                      validator: _validate_text,
                    ),
            
                    new Container(
                      padding: const EdgeInsets.all(20.0),
                      alignment: const FractionalOffset(0.5, 0.5),
                      child: new RaisedButton(
                        child: new Text('SUBMIT', style: new TextStyle(color: Colors.white)),
                        color: Colors.teal,
                        onPressed: _handleSubmitted,
                      ),
                    ),
                    
                ],
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
              ),
              autovalidate: _autovalidate,
            ),
        );
    }
}

// ================================================= OTHER HELPERS ==========================================


class BotBar extends StatelessWidget {

  @override
  Widget build (BuildContext context) {
    return new Container (
        child: new Row( 
          children: <Widget> [ // 1 - 5
            _build_bot_btn (context, 1),
            _build_bot_btn (context, 2),
            _build_bot_btn (context, 3),
            //_build_bot_btn (context, 4),
            _build_bot_btn (context, 5),
          ],
        ),
      decoration: new BoxDecoration (color: new Color(0xFF181818)),
    );
  }
  

  Widget _build_bot_btn (BuildContext context, int id, {EdgeInsets padding = null}) {
    
    if (padding == null)
      padding = new EdgeInsets.symmetric (vertical: 20.0);
    
    
    String btn_text = ['', 'Home', 'Give', 'Prayer', 'Bible', 'Stream'][id];
    String route = ['', '/', '/give', '/help', '/bible', '/stream'][id];
    
    // assume padding is given. EAFP
    return build_flex_center (
      new Padding (
        child: new FlatButton(
          child: new Text (btn_text),
          onPressed: () {
              if(id == 1) // going home
                 Navigator.of(context).popUntil(ModalRoute.withName('/'));
              
              else if (id == 5) { // stream
                fb_home();
              }
              else {  
                //Navigator.of(context).pushNamedAndRemoveUntil(route, ModalRoute.withName('/')); 
                //Navigator.of(context).popUntil(ModalRoute.withName('/'));
                Navigator.of(context).pushNamed(route);
              }
     
          },
          textColor: Colors.white70,
        ),
        padding: padding,
      )
    );
    
  }
}

fb_home () async {   
    launchURL('https://www.facebook.com/ngbmonline/');
}
fb_url (String url) async { 
    try {
        await launchURL('fb://facewebmodal/f?href='+url);
    }
    catch(e) {
        launchURL(url);
    }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  


Widget not_bar() {
    return new Container (
            height: 24.0,//ui.window.padding.top,
            color: new Color(0xFF014080),
          );   
}

class MyDrawer extends StatelessWidget {
    String _curr_route = '/';
    MyDrawer(this._curr_route);
    
    @override
    Widget build(BuildContext context) {
      return new Drawer (
        child: 
          new Container ( 
            child: new ListView (
              children: <Widget> [
                //new DrawerHeader(
                //    child: new Text('logo'),
                //    padding: new EdgeInsets.symmetric(vertical: 2.0),
                //    margin: new EdgeInsets.all(0.0),
                //),
                not_bar(),
                new Container (
                    child: new ListTile(
                      leading: new Icon(Icons.home, color: (_curr_route == '/')? _icon_color: _icon_color_dull),
                      title: new Text('Home', style: new TextStyle(
                        color: (_curr_route == '/')? Colors.white : Colors.grey[300], 
                      )),
                      onTap: () => 
                        Navigator.of(context).popUntil(ModalRoute.withName('/')),
                    ),
                    color:  (_curr_route == '/')? new Color(0x50000000): null,
                ),
                _settings_tile(7, context),         // our leader
                new Divider( color: new Color(0xa0000000)),
                _settings_tile(9, context),         // upcoming events
                _settings_tile(8, context),         // give
                new Container (
                    child: new ListTile(
                      leading: new Icon(Icons.library_books, color: (_curr_route == '/bible')? _icon_color: _icon_color_dull),
                      title: new Text('Bible', style: new TextStyle(
                        color: (_curr_route == '/bible')? Colors.white : Colors.grey[300], 
                      )),
                      onTap: () => launchURL('http://biblewebapp.com'),
                    ),
                    color:  (_curr_route == '/bible')? new Color(0x50000000): null,
                ),
                _settings_tile(2, context),         // media
                new Divider( color: new Color(0xa0000000)),
                //_settings_tile(5, context),         // swat
                //_settings_tile(6, context),         // prison
                //new Divider( color: Colors.grey),
                _settings_tile(3, context),         // connect
                _settings_tile(1, context),         // find us
                //new Divider(),
                //_settings_tile(9, context),
              ],
            ),
            color:  new Color(0xFF015090),
        ),
      );
    }
    
    List <String> _titles = ['Home', 'Find Us', 'Media', 'Connect', 'Bible', 
                        'Swat Ministry', 'Prison Ministry', 'Our Leader', 
                        'Give', 'Announcements', 'Intro'];
    
    List <String> _paths = ['/', '/findus', '/demand', '/social', '/bible', 
                        '/mini_page/0', '/mini_page/1', '/about', 
                        '/give', '/news', '/'];
    
    List <Widget> _icons = [Icons.home, Icons.map, Icons.slideshow, Icons.smartphone,
                            Icons.library_books, Icons.people_outline, Icons.people_outline, 
                            Icons.person_outline, Icons.favorite_border, Icons.notifications_none];
    Color _icon_color = Colors.white;
    Color _icon_color_dull = Colors.grey[200];
    
    
    Widget _settings_tile(int t, BuildContext context) {
        bool _is_curr_route =  _curr_route == _paths[t];
        Color _this_icon_color = (_is_curr_route)? _icon_color: _icon_color_dull;
        
        if (_paths[t] == '/news' && new_notif)
            _this_icon_color = Colors.red;
        else if (_paths[t] == '/demand' && new_live)
            _this_icon_color = Colors.red;
        
        return new Container (
            child: new ListTile (
              leading: new Icon(_icons[t], color: _this_icon_color),
              title: new Text(_titles[t], style: new TextStyle(
                color: (_is_curr_route)? Colors.white : Colors.grey[300],  
              )),
              onTap: () => Navigator.of(context).pushNamed(_paths[t]),
            ),
            color: (_is_curr_route)? new Color(0x50000000): null,
        );
    }
}


Widget text_container (String text, {double font_size = 34.0, 
                        FontWeight weight = FontWeight.w300, 
                        Color color = Colors.white}) => 
    new Center ( 
        child: new Container (
            child: 
                new DefaultTextStyle(
                    child: new Text(text),
                    style: new TextStyle(
                        color: color,
                        fontSize: font_size,
                        fontWeight: weight,
                    ),
                ),
            padding: new EdgeInsets.all(0.8)
        ), 
    );


