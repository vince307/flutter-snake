import 'package:flutter/material.dart';
import 'game.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

/// Local vars
///
String _imagePath = 'assets/flutter_icon.png';
String _usernameVal = '';
String _navSide = 'right';
var isLargeScreen = false;

/// Theme Colors
///
ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      accentColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textSelectionColor: Colors.amberAccent,
      errorColor: Color.fromRGBO(255, 193, 7, 1),
      textSelectionHandleColor: Colors.black,
      appBarTheme:_appBarTheme()
  );
}

/// AppBarTheme
///
AppBarTheme _appBarTheme(){
  return AppBarTheme(
    elevation: 0.0,
    textTheme: TextTheme(
      headline: TextStyle(color: Colors.white, fontSize: 44.0, fontFamily: 'PressStart2P'),
      title: TextStyle(color: Colors.white, fontSize: 28.0, fontFamily: 'PressStart2P'),
      body1: TextStyle(color: Colors.white, fontSize: 34.0, fontFamily: 'PressStart2P'),
    ),
    color: Color.fromRGBO(205, 220, 57, 1),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}

/// App
///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Function duringSplash = () {
      /// some logic to run on splash screen;
      /// by default this return int 2,
      /// which will show Username Screen;
      /// check Map below (line 67);
        return 2;
    };

    Map<int, Widget> op = {1: Home(), 2: Username()};

    return MaterialApp(
      title: 'Olden Days Snake Game',
      theme: _buildLightTheme(),
      home: AnimatedSplash(
        imagePath: _imagePath,
        home: Home(),
        customFunction: duringSplash,
        duration: 2500,
        type: AnimatedSplashType.BackgroundProcess,
        outputAndHome: op,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Home
///
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Snake"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(56, 142, 60, 1),

      ),
      backgroundColor: Colors.white,
      body: Game(_usernameVal, _navSide),
    );
  }
}

/// Select Navigation Side Screen (NOT USED)
///
class SelectNavSide extends StatefulWidget {
  @override
  _SelectNavSide createState() => _SelectNavSide(_navSide);
}

class _SelectNavSide extends State<SelectNavSide> {

  _SelectNavSide(_navSide);

  void _handleNavSideSelection(side) {
    setState(() {
      _navSide = side;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Snake"),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(56, 142, 60, 1),
        ),
        body: Center(
            child: Container(
                child: Column (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                            Text('On which side of the \r\nphone place game \r\ncontrollers?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontFamily: 'PressStart2P')),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: SizedBox(
                                child:
                                new OutlineButton(
                                  onPressed: () => _handleNavSideSelection("left"),
                                  child: Icon(Icons.arrow_back_ios),
                                  textColor: Colors.green[800],
                                  borderSide: BorderSide(
                                      color: Colors.green[800], style: BorderStyle.solid,
                                      width: 1
                                  ),
                                  shape: RoundedRectangleBorder(side: BorderSide(
                                      color: Colors.green[800],
                                      width: 1,
                                      style: BorderStyle.solid
                                  ),
                                      borderRadius: BorderRadius.circular(5)),
                                )
                            ),
                          ),
                          Container(
                            child: SizedBox(
                                child:
                                new OutlineButton(
                                  onPressed: () => _handleNavSideSelection("right"),
                                  child: Icon(Icons.arrow_forward_ios),
                                  textColor: Colors.green[800],
                                  borderSide: BorderSide(
                                      color: Colors.green[800], style: BorderStyle.solid,
                                      width: 1
                                  ),
                                  shape: RoundedRectangleBorder(side: BorderSide(
                                      color: Colors.green[800],
                                      width: 1,
                                      style: BorderStyle.solid
                                  ),
                                      borderRadius: BorderRadius.circular(5)),
                                )
                            ),
                          ),
                        ],
                      ),
                    ]
                )
            )
        ));
  }
}

/// Home Screen
///
class HomeSt extends StatefulWidget {
  @override
  _HomeStState createState() => _HomeStState();
}

class _HomeStState extends State<HomeSt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
            child: Container(
                child: Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 250.0, child: Image.asset("assets/flutter_icon.png")),
                      Text('production', style: TextStyle(color: Colors.black, fontSize: 20.0)),
                    ]
                )
            )
        ));
  }
}


/// Username Screen
///
class Username extends StatefulWidget {
  @override
  _Username createState() => _Username(_usernameVal);
}

class _Username extends State<Username> {
  bool _isValid = false;
  bool _isTooLong = false;
  bool _isDisable = true;
  var _controller = TextEditingController();

  _Username(_usernameVal);

  void _handleStartTap() {
    setState(() {
      _isValid = false;
      if(_usernameVal.length < 3) {
        _isValid = true;
      };
      if(_usernameVal.length > 32) {
        _isTooLong = true;
      };
      if(!_isTooLong && !_isValid){
        if(!isLargeScreen){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectNavSide()),);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
        }
      }
    });
  }

  _onClear() {
    setState(() {
      _isDisable = true;
      WidgetsBinding.instance.addPostFrameCallback( (_) => _controller.clear());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void calculateWhetherDisabledReturnsBool(text) {
    setState(() {
      _isDisable = true;
      if(text.length >= 3) {
        _isDisable = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      setState(() {
        isLargeScreen = true;
      });
    } else {
      setState(() {
        isLargeScreen = false;
      });
    }

    return Scaffold(
        body: OrientationBuilder(builder: (context, orientation) {
          return Row(children: <Widget>[
            isLargeScreen ?
            (
                Expanded(
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('SNAKE', style: TextStyle(
                                      color: Colors.green[800],
                                      fontSize: 44.0,
                                      fontFamily: 'PressStart2P')),
                                  SizedBox(height: 20.0, child: null),
                                  _usernameInputBox(
                                      context,
                                      _controller,
                                      setState,
                                      calculateWhetherDisabledReturnsBool,
                                      _isDisable,
                                      1,
                                      _onClear),
                                  Text(_isValid
                                      ? 'Your username must have at least 3 characters.'
                                      : '', style: TextStyle(
                                      color: Color.fromRGBO(255, 152, 0, 1),
                                      fontSize: 14.0)),
                                  Text(_isTooLong
                                      ? 'Your username is too long.'
                                      : '', style: TextStyle(
                                      color: Colors.red, fontSize: 14.0)),
                                  _usernameStartBtn(
                                      context, _isDisable, _handleStartTap, 1)
                                ]
                            )
                        )
                    )
                )
            )
                :
            (
                Expanded(
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: <Widget>[
                                      Text('SNAKE', style: TextStyle(
                                          color: Colors.green[800],
                                          fontSize: 34.0,
                                          fontFamily: 'PressStart2P')),
//                                        SizedBox(height: 10.0, child: null),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Text(_isValid
                                                ? 'Your username must have at least 3 characters.'
                                                : '', style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 152, 0, 1),
                                                fontSize: 14.0)),
                                            Text(_isTooLong
                                                ? 'Your username is too long.'
                                                : '', style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14.0)),
                                            _usernameInputBox(
                                                context,
                                                _controller,
                                                setState,
                                                calculateWhetherDisabledReturnsBool,
                                                _isDisable,
                                                0.9,
                                                _onClear),
                                          ],
                                        ),
                                      ),
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Column(
                                                    children: [
                                                      Text(true ? '' : '',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  255, 152, 0,
                                                                  1),
                                                              fontSize: 14.0)),
                                                      Text(true ? '' : '',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14.0)),
                                                      SizedBox(
                                                        height: 50,
                                                        child: _usernameStartBtn(
                                                            context, _isDisable,
                                                            _handleStartTap,
                                                            0.25),
                                                      )
                                                    ]
                                                )
                                            )
                                          ]
                                      ),
                                    ],
                                  ),
                                ]
                            )
                        )
                    )
                )
            ),
          ]);
        }
      ));
  }
}

/// Username Start Btn
///
SizedBox _usernameStartBtn(context, _isDisable, _handleStartTap, _widthPercentage) {
  return new SizedBox(
      width: MediaQuery.of(context).size.width * _widthPercentage,
      child:
      new OutlineButton(
        onPressed: _isDisable ? null : _handleStartTap,
        child: Text('Start', style: TextStyle(
            color: Colors.green[800]
        )
        ),
        textColor: Colors.green[800],
        borderSide: BorderSide(
            color: Colors.green[800], style: BorderStyle.solid,
            width: 1
        ),
        shape: RoundedRectangleBorder(side: BorderSide(
            color: Colors.green[800],
            width: 1,
            style: BorderStyle.solid
        ),
            borderRadius: BorderRadius.circular(5)),
      )
  );
}

/// Username Input Box
///
Container _usernameInputBox(context, _controller, setState, calculateWhetherDisabledReturnsBool, _isDisable, _widthPercentage, _onClear) {
  return Container(
    width: MediaQuery.of(context).size.width * _widthPercentage,
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.green[800],
          primaryColor: Colors.green[800],
          scaffoldBackgroundColor: Colors.green[800],
          buttonColor: Colors.green[800],
          hintColor: Colors.green[800],
          cursorColor: Colors.green[800],
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            labelStyle: TextStyle(
              color: Colors.green[800],
            ),
          ),
        ),
        child:
          TextField(
            controller: _controller,
            onChanged: (text) {
            setState(() {
              _usernameVal = text;
            });
            calculateWhetherDisabledReturnsBool(text);
            },
            autofocus: true,
            style: new TextStyle(color: Colors.black87),
            decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1,color: Colors.green[800]),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1,color: Colors.green[800]),

            ),
            labelText: 'Username',
            suffixIcon: IconButton(
              onPressed: () {
                _onClear();
              },
              icon: Icon(Icons.clear),
              color: Colors.green[800],
            ),
            ),
          ),
      )
  );
}