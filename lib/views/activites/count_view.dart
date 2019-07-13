import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/data/sample_data_activities.dart';
import 'package:discover_deep_cove/util/body1_text.dart';
import 'package:discover_deep_cove/util/heading_text.dart';
import 'package:discover_deep_cove/widgets/misc/back_nav_bottom.dart';

class CountView extends StatefulWidget {
  final CountActivity activity;
  final bool fromMap;

  ///Takes in a [CountActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  CountView({this.activity, this.fromMap});

  @override
  _CountViewState createState() => _CountViewState();
}

class _CountViewState extends State<CountView> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: HeadingText(
          text: widget.activity.title,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Text(widget.activity.description),
          ),
          SizedBox(height: (MediaQuery.of(context).size.width / 10) * 1.5),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
            child: Text(widget.activity.task),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Divider(color: Color(0xFF777777)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: widget.fromMap
                ? Body1Text(
                    text: "You Counted:",
                  )
                : SizedBox(
                    height: (MediaQuery.of(context).size.width / 10) * 0.5),
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.width / 10) * 3.5,
          ),
          widget.fromMap
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                  height: (MediaQuery.of(context).size.width / 4) * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        widget.activity.userCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(fontSize: 60),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                  height: (MediaQuery.of(context).size.width / 4) * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.5,
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronLeft,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (count > 1) {
                              setState(() {
                                count = count - 1;
                              });
                            }
                          },
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(fontSize: 60),
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.chevronRight,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (count < 100) {
                              setState(() {
                                count = count + 1;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          widget.fromMap
              ? Padding(
                  padding:
                      const EdgeInsets.only(left:20.0, right: 20.0, top: 40.0),
                  child: Text(
                    "To edit your answer, re-scan the QR code.",
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: Color(0xFF777777),
                        ),
                  ),
                )
              : Container(),
          Expanded(child: Container()),
          widget.fromMap
              ? BackNavBottom()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColorDark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Body1Text(
                            text: "Pass",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            widget.activity.activated = true;
                            widget.activity.userCount = count;
                            Navigator.of(context).pop();
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Body1Text(
                            text: "Save",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}