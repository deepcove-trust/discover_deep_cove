import 'package:flutter/material.dart';

import '../../util/date_util.dart';
import '../../util/screen.dart';
import '../misc/text/body_text.dart';
import '../misc/text/sub_heading.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final String desc;
  final bool isUrgent;
  final bool hasMore;
  final bool hasDivider;
  final VoidCallback onTap;

  const NoticeTile({
    this.title,
    this.date,
    this.desc,
    this.isUrgent,
    this.hasMore,
    this.hasDivider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isUrgent
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(color: Theme.of(context).indicatorColor, width: 5),
                ),
              )
            : null,
        child: Padding(
          padding: EdgeInsets.all(Screen.isTablet(context) ? 24 : 8),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Divider(color: Colors.transparent, height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: Screen.width(context, percentage: Screen.isSmall(context) ? 75 : 80),
                            child: SubHeading(
                              title,
                              size: Screen.isTablet(context)
                                  ? 25
                                  : Screen.isSmall(context)
                                      ? 20
                                      : 22,
                              align: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            DateUtil.formatDate(date),
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: Screen.isTablet(context)
                                  ? 20
                                  : Screen.isSmall(context)
                                      ? 14
                                      : 16,
                            ),
                          ),
                        ],
                      ),
                      hasMore
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BodyText(
                                'MORE',
                                size: Screen.isTablet(context)
                                    ? 20
                                    : Screen.isSmall(context)
                                        ? 14
                                        : 16,
                              ),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  desc,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: Screen.isTablet(context)
                        ? 20
                        : Screen.isSmall(context)
                            ? 18
                            : 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              hasDivider ? Divider(color: Theme.of(context).primaryColorLight, height: 1) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
