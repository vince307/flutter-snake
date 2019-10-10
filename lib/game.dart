import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'children_at_different_game_states.dart';

enum Direction { LEFT, RIGHT, UP, DOWN }
enum GameState { START, RUNNING, FAILURE }
var isLargeScreen = false;
var controllBtnSize = 60.0;
var controllContainerSize = 120.0;

class Game extends StatefulWidget {
  final String name;
  final String navSide;
  Game(this.name, this.navSide);
  @override
  State<StatefulWidget> createState() => _GameState(this.name, this.navSide);
}

class _GameState extends State<Game> {
  var snakePosition;
  Point newPointPosition;
  Timer timer;
  Direction _direction = Direction.UP;
  var gameState = GameState.START;
  int score = 0;
  String name;
  String navSide;
  // In the constructor, require a name.
  _GameState(this.name, this.navSide);

  @override
  Widget build(BuildContext context) {

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: <Widget>[
                        Container(  // game screen text
                          width: 320,
                          height: 20,
                          padding: EdgeInsets.all(0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "name: ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.green[800], fontSize: 10.0, fontFamily: 'PressStart2P'),
                                      ),
                                      Text(
                                        "$name",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.green[800], fontSize: 12.0, fontFamily: 'PressStart2P'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "score: ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.green[800], fontSize: 10.0, fontFamily: 'PressStart2P'),
                                      ),
                                      Text(
                                        "$score",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.green[800], fontSize: 12.0, fontFamily: 'PressStart2P'),
                                      ),
                                    ],
                                  ),

                                ]),
                          ),
                        ),
                        Container(  // game screen
                          width: 320,
                          height: 320,
//                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2.0, color: Colors.green[800]),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (tapUpDetails) {
                              _handleTap(tapUpDetails);
                            },
                            child: _getChildBasedOnGameState(),
                          ),
                        ),

                        Container(  // controllers
                          margin: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                          width: controllContainerSize,
                          height: controllContainerSize,
                          child: RotationTransition(
                            turns: new AlwaysStoppedAnimation(45 / 360),

                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(  // up
                                      width: controllBtnSize,
                                      height: controllBtnSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(0),
                                          color: Colors.white
                                      ),
                                      child: FlatButton(
                                          color: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              _direction = Direction.UP;
                                            });
                                          },
                                          child: new RotationTransition(
                                            turns: new AlwaysStoppedAnimation(45 / 360),
                                            child: Icon(Icons.keyboard_arrow_left),
                                          )
                                      ),
                                    ),
                                    Container(  // right
                                      width: controllBtnSize,
                                      height: controllBtnSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(0),
                                          color: Colors.white
                                      ),
                                      child:
                                      FlatButton(
                                          color: Colors.yellow,
                                          onPressed: () {
                                            setState(() {
                                              _direction = Direction.RIGHT;
                                            });
                                          },
                                          child: new RotationTransition(
                                            turns: new AlwaysStoppedAnimation(-45 / 360),
                                            child: Icon(Icons.keyboard_arrow_right),
                                          )
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(  // left
                                        width: controllBtnSize,
                                        height: controllBtnSize,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(0),
                                            color: Colors.white
                                        ),
                                        child:
                                        FlatButton(
                                            color: Colors.yellow,
                                            onPressed: () {
                                              setState(() {
                                                _direction = Direction.LEFT;
                                              });
                                            },
                                            child: new RotationTransition(
                                              turns: new AlwaysStoppedAnimation(-45 / 360),
                                              child: Icon(Icons.keyboard_arrow_left),
                                            )
                                        )
                                    ),
                                    Container(  // down
                                      width: controllBtnSize,
                                      height: controllBtnSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(0),
                                          color: Colors.white
                                      ),
                                      child:
                                      FlatButton(
                                          color: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              _direction = Direction.DOWN;
                                            });
                                          },
                                          child: new RotationTransition(
                                            turns: new AlwaysStoppedAnimation(45 / 360),
                                            child: Icon(Icons.keyboard_arrow_right),
                                          )
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )


          ],
        );
  }

  void _handleTap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case GameState.START:
        startToRunState();
        break;
      case GameState.RUNNING:
        break;
      case GameState.FAILURE:
        setGameState(GameState.START);
        break;
    }
  }

  void startToRunState() {
    startingSnake();
    generatenewPoint();
    _direction = Direction.UP;
    setGameState(GameState.RUNNING);
    timer = new Timer.periodic(new Duration(milliseconds: 400), onTimeTick);
  }

  void startingSnake() {
    setState(() {
      final midPoint = (320 / 20 / 2);
      snakePosition = [
        Point(midPoint, midPoint - 1),
        Point(midPoint, midPoint),
        Point(midPoint, midPoint + 1),
      ];
    });
  }

  void generatenewPoint() {
    setState(() {
      Random rng = Random();
      var min = 0;
      var max = 320 ~/ 20;
      var nextX = min + rng.nextInt(max - min);
      var nextY = min + rng.nextInt(max - min);

      var newRedPoint = Point(nextX.toDouble(), nextY.toDouble());

      if (snakePosition.contains(newRedPoint)) {
        generatenewPoint();
      } else {
        newPointPosition = newRedPoint;
      }
    });
  }

  void setGameState(GameState _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }

  Widget _getChildBasedOnGameState() {
    var child;

    void httpPostUserData(String username, String score) async {
      var url = 'https://example.cloudfunctions.net/api/snake/saveUserScore/' + username + '/' + score;
      var response = await http.post(url, body: {});
      print('Response status: ${response.statusCode}');
    }

    switch (gameState) {
      case GameState.START:
        setState(() {
          score = 0;
        });
        child = gameStartChild;
        break;

      case GameState.RUNNING:
        List<Positioned> snakePiecesWithNewPoints = List();
        snakePosition.forEach(
          (i) {
            snakePiecesWithNewPoints.add(
              Positioned(
                child: gameRunningChild,
                left: i.x * 15.5,
                top: i.y * 15.5,
              ),
            );
          },
        );
        final latestPoint = Positioned(
          child: newSnakePointInGame,
          left: newPointPosition.x * 15.5,
          top: newPointPosition.y * 15.5,
        );
        snakePiecesWithNewPoints.add(latestPoint);
        child = Stack(children: snakePiecesWithNewPoints);
        break;

      case GameState.FAILURE:
        timer.cancel();
        httpPostUserData(this.name, score.toString());
        child = Container(
          width: 320,
          height: 320,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              "You Scored: $score\n\nTap to play again!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green[800], fontSize: 10.0, fontFamily: 'PressStart2P', fontWeight: FontWeight.normal),
            ),
          ),
        );
        break;
    }
    return child;
  }

  void onTimeTick(Timer timer) {
    setState(() {
      snakePosition.insert(0, getLatestSnake());
      snakePosition.removeLast();
    });

    var currentHeadPos = snakePosition.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 400 / 20 ||
        currentHeadPos.y > 400 / 20) {
      setGameState(GameState.FAILURE);
      return;
    }

    if (snakePosition.first.x == newPointPosition.x &&
        snakePosition.first.y == newPointPosition.y) {
      generatenewPoint();
      setState(() {
        if (score <= 10)
          score = score + 1;
        else if (score > 10 && score <= 25)
          score = score + 2;
        else
          score = score + 3;
        snakePosition.insert(0, getLatestSnake());
      });
    }
  }

  Point getLatestSnake() {
    var newHeadPos;

    switch (_direction) {
      case Direction.LEFT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.RIGHT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.UP:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.DOWN:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }
}