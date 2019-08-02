import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/activityAppBar.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class TextAnswerActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [TextAnswerActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  TextAnswerActivityView({this.activity, this.isReview});

  @override
  _TextAnswerActivityViewState createState() => _TextAnswerActivityViewState();
}

class _TextAnswerActivityViewState extends State<TextAnswerActivityView> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivityAppBar(widget.activity.title),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Text(widget.activity.description),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
                  child: Text(widget.activity.task),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Divider(color: Color(0xFF777777)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.isReview
                      ? BodyText(
                          "You Answered:",
                        )
                      : SizedBox(
                          height: Screen.height(context, percentage: 2.5),
                        ),
                ),
                widget.isReview
                    ? Container(
                        width: Screen.width(context, percentage: 12.5),
                        height: Screen.height(context, percentage: 38.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5.0) //
                              ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BodyText(
                            widget.activity.userText,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: Screen.width(context, percentage: 12.5),
                          height: Screen.height(context, percentage: 38.0),
                          color: Colors.white,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            controller: controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                      ),
                widget.isReview
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "To edit your answer, re-scan the QR code.",
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Color(0xFF777777),
                              ),
                        ),
                      )
                    : null,
              ],
            ),
          ),
          widget.isReview
              ? BottomBackButton()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: Screen.width(context),
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
                              child: BodyText(
                                "Pass",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlineButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  widget.activity.userText =
                                      controller.text.toString();
                                  Navigator.of(context).pop();
                                } else {
                                  Toast.show(
                                    "Please write down your answer!",
                                    context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Colors.black,
                                  );
                                }
                              },
                              borderSide: BorderSide(color: Color(0xFF777777)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: BodyText(
                                "Save",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
