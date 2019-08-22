import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/activityAppBar.dart';
import 'package:discover_deep_cove/widgets/fact_file/editAnswer.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CountActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [CountActivityView] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  CountActivityView({this.activity, this.isReview});

  @override
  _CountActivityViewState createState() => _CountActivityViewState();
}

class _CountActivityViewState extends State<CountActivityView> {
  int count = 0;

  buildContent() {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getTopHalf(),
              getBottomHalf(),
            ],
          )
        : Column(
            children: [
              getTopHalf(),
              Flexible(
                child: getBottomHalf(),
              ),
            ],
          );
  }

  getBottomHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.isReview
            ? SizedBox(
                height: Screen.height(
                  context,
                  percentage: Screen.isTablet(context)
                      ? 20.0
                      : Screen.isSmall(context) ? 5.0 : 10.0,
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: widget.isReview
              ? Body(
                  "You Counted:",
                  size: Screen.isTablet(context) ? 30.0 : 0,
                )
              : SizedBox(
                  height: Screen.height(context, percentage: 5.0),
                ),
        ),
        SizedBox(
          height: Screen.height(
            context,
            percentage: Screen.isTablet(context)
                ? 20.0
                : Screen.isSmall(context) ? 5.0 : 10.0,
          ),
        ),
        widget.isReview
            ? Container(
                width: Screen.width(context),
                height: Screen.height(context, percentage: 10.0),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      widget.activity.userCount.toString(),
                      style: TextStyle(
                        fontSize: Screen.isSmall(context) ? 40 : 60,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: Screen.width(context),
                height: Screen.height(context,
                    percentage: !Screen.isPortrait(context) ? 15.0 : 10.0),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Transform.scale(
                      scale: Screen.isTablet(context) ? 2 : 1.5,
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
                    Body(
                      count.toString(),
                      size: Screen.isSmall(context)
                          ? 40
                          : Screen.isTablet(context) ? 80 : 50,
                    ),
                    Transform.scale(
                      scale: Screen.isTablet(context) ? 2 : 1.5,
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
        Expanded(child: Container()),
        widget.isReview
            ? Container()
            : Container(
                width: Screen.width(context),
                color: Theme.of(context).primaryColorDark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        onPressed: () => Navigator.of(context).pop(),
                        borderSide: BorderSide(color: HexColor("FF777777")),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Body('Pass'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        onPressed: () => saveAnswer(),
                        borderSide: BorderSide(color: HexColor("FF777777")),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Body(
                          "Save",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        widget.isReview
            ? Padding(
                padding: EdgeInsets.only(
                  left: Screen.width(context, percentage: 2.5),
                  right: Screen.width(context, percentage: 2.5),
                  top: Screen.height(context, percentage: 5.0),
                  bottom: Screen.height(context, percentage: 2.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    EditAnswer(),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  getTopHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 2.5),
            vertical: Screen.height(context, percentage: 5.0),
          ),
          child: Body(
            widget.activity.description,
            size: Screen.isTablet(context) ? 30.0 : 0,
          ),
        ),
        SizedBox(
          height: Screen.height(
            context,
            percentage: Screen.isTablet(context) ? 10.0 : 5.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 2.5),
            vertical: Screen.height(context, percentage: 5.0),
          ),
          child: Body(
            widget.activity.task,
            size: Screen.isTablet(context) ? 30.0 : 0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.height(context, percentage: 5.0),
          ),
          child: Divider(
            color: HexColor("FF777777"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ActivityAppBar(widget.activity.title),
        body: buildContent(),
        bottomNavigationBar: widget.isReview ? BottomBackButton() : null,
        backgroundColor: Theme.of(context).backgroundColor);
  }

  void saveAnswer() async {
    widget.activity.userCount = count;
    await ActivityBean.of(context).update(widget.activity);
    Navigator.of(context).pop();
  }
}
