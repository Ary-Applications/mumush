import 'package:flutter/material.dart';

import 'event.dart';

class SquareWidget extends StatelessWidget {
  SquareWidget({Key? key, required this.event}) : super(key: key);
  bool isActive = false;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.vertical, children: [
      Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 150.0,
                width: 150.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white.withOpacity(0.5)
                          : Colors.transparent,
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              event.eventTitle.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SpaceMono',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 4,
                            )),
                        // const SizedBox(height: 10),
                        const Spacer(),
                        Row(
                          children: [
                            // const SizedBox(width: 2),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  event.date,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'SpaceMono',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
      ),
    ]);
  }
}
