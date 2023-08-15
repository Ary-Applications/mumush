import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mumush/src/screens/timeline/square_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/resources/colors.dart';
import '../../di/injection.dart';
import '../../notification/pushnotification.dart';
import '../base/base.dart';
import 'event.dart';

Future<List<int>> getListFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final stringList = prefs.getStringList('my_list');
  if (stringList != null) {
    final List<int> intList = stringList.map((str) => int.parse(str)).toList();
    return intList;
  } else {
    return [];
  }
}

Future<void> appendToSavedList(int? value) async {
  if(value != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final existingList = prefs.getStringList('my_list') ?? [];
    if (!existingList.contains(value.toString())) {
      existingList.add(value.toString());
      prefs.setStringList('my_list', existingList);
    }
  }
}

Future<void> removeFromSavedList(int? value) async {
  if(value != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final existingList = prefs.getStringList('my_list') ?? [];
    if (existingList.contains(value.toString())) {
      existingList.remove(value.toString());
      await saveList(existingList);
    }
  }
}

Future<void> saveList(List<String> list) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('my_list', list);
}

class SquareWidget extends StatefulWidget {
  Event event;
  bool isActive = false;
  bool isScheduled = false;

  SquareWidget({Key? key, required this.event}) : super(key: key);

  @override
  _SquareWidgetState createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  final NotificationApi notificationApi = NotificationApi();

  @override
  void initState() {
    super.initState();
    _initializeAsyncData();
    // var intFromSharedPreferences = await getListFromSharedPreferences();
    // widget.isScheduled = intFromSharedPreferences.contains(widget.event.id);
  }

  Future<void> _initializeAsyncData() async {
  var intFromSharedPreferences = await getListFromSharedPreferences();
  widget.isScheduled = intFromSharedPreferences.contains(widget.event.id);
}
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This method is called when the widget appears in the widget tree.
    // You can put your state-setting code here.

    // setState(() async {
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    if (widget.isActive) {
      color = Colors.white.withOpacity(0.5);
    } else if (widget.isScheduled ) {
      color = primaryMarkerColor.withOpacity(0.5);
    } else {
      color = Colors.transparent;
    }

    return BaseStatefulView<SquareViewModel>(
        viewModel: getIt<SquareViewModel>(),
        onInit: (viewModel) async {},
        builder: (context, viewModel, child) {
          return Flex(direction: Axis.vertical, children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // toggleBool(widget.isScheduled);
                            if (widget.isScheduled) {
                              widget.isScheduled = false;
                              removeFromSavedList(widget.event.id);
                              notificationApi.cancelScheduledNotification(
                                  widget.event.id ?? 0);
                            } else {
                              widget.isScheduled = true;
                              appendToSavedList(widget.event.id);
                              notificationApi.scheduleNotification(
                                  widget.event);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: color,
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(7))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget.event.eventTitle.toUpperCase(),
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
                                          widget.event.date,
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
                    ),
                  ],
                ),
              ),
            ),
          ]);
        });
  }
  bool toggleBool(bool value) {
    return !value;
  }
}