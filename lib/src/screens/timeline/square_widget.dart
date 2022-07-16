import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'event.dart';

class SquareWidget extends StatelessWidget {
  const SquareWidget({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 150.0,
              width: 150.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            event.eventTitle,
                            style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                          )),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                event.date,
                                style: TextStyle(fontSize: 10.0),
                              )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(event.location,
                                style: TextStyle(fontSize: 15.0)),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
