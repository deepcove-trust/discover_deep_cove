import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/tab_page.dart';
import 'package:flutter/material.dart';
import 'package:discover_deep_cove/widgets/misc/tab_page.dart' as tab;

class FactFileIndex extends StatefulWidget {
  @override
  _FactFileIndexState createState() => _FactFileIndexState();
}

///Displays the tabs and a [tile] representing each [FactFileEntry]
class _FactFileIndexState extends State<FactFileIndex>
    with SingleTickerProviderStateMixin {
  TabController controller;

  List<FactFileCategory>  categories =
      List<FactFileCategory>(); // Todo: load from database

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: categories.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///Returns a list of [Text] widgets that are the tab labels
  List<Container> getTabHeadings() {
    List<Container> headings = List<Container>();

    for (int i = 0; i < categories.length; i++) {
      headings.add(
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: BodyText(
            text: categories[i].name,
            align: TextAlign.center,
          ),
        ),
      );
    }
    return headings;
  }

  ///Returns a list of [TabPage] widgets that are passed the list of category entries
  List<TabPage> getTabs() {
    List<TabPage> tabs = List<TabPage>();
    for (int i = 0; i < categories.length; i++) {
      tabs.add(TabPage(categories[i].entries));
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          color: Theme.of(context).primaryColorDark,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(child: Container()),
                TabBar(
                  labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  controller: controller,
                  tabs: getTabHeadings(),
                  indicatorColor: Theme.of(context).primaryColor,
                  isScrollable: true,
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(controller: controller, children: getTabs()),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
