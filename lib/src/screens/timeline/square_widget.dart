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
            SizedBox(
              height: 150.0,
              width: 150.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border:Border.all(color: Colors.white,width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(7))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              event.eventTitle.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold,color: Colors.white),
                            )),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 2),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                event.date,
                                style: const TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      // TODO: Make redirection if possible
                      // const SizedBox(height: 1),
                      // Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: TextButton(
                      //       onPressed: () {},
                      //       child: Text(event.location,
                      //           style: const TextStyle(fontSize: 8.0),
                      //       ),
                      //     ))
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
