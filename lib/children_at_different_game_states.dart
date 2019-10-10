import 'package:flutter/material.dart';

final Widget gameStartChild = Container(
  width: 360,
  height: 320,
//  padding: const EdgeInsets.all(32),
  child: Center(
    child: Text(
      "Just TAP to\n start the\n Game!",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.green[800], fontSize: 14.0, fontFamily: 'PressStart2P', fontWeight: FontWeight.bold),
    ),
  ),
);

final Widget gameRunningChild = Container(
  width: 17.5,
  height: 17.5,
  decoration: new BoxDecoration(
    color: const Color.fromRGBO(76, 175, 80, 1),
    shape: BoxShape.rectangle,
  ),
);

final Widget newSnakePointInGame = Container(
  width: 15.5,
  height: 15.5,
  decoration: new BoxDecoration(
    color: const Color.fromRGBO(255, 152, 0, 1),
    border: new Border.all(color: Colors.white),
    borderRadius: BorderRadius.circular(20),
  ),
);

//class which gives the snake HEAD
class Point {
  double x;
  double y;

  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }
}
