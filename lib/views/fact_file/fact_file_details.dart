import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/fact_file/nuggets/fact_nugget.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/image_source.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FactFileDetails extends StatefulWidget {
  final int entryId;

  FactFileDetails({@required this.entryId}) : assert(entryId != null);

  @override
  State<StatefulWidget> createState() => _FactFileDetailsState();
}

class _FactFileDetailsState extends State<FactFileDetails>
    with WidgetsBindingObserver {
  AudioPlayer player = AudioPlayer();
  Color pronounceColor = Colors.white;
  Color listenColor = Colors.white;
  bool _isButtonDisabled = false;
  int _currentImage = 0;
  FactFileEntry entry;

  StreamSubscription _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _playerCompleteSubscription = player.onPlayerCompletion.listen((event) {
      _onComplete();
    });
  }

  Future<void> loadData() async {
    entry = await FactFileEntryBean.of(context).findAndPreload(widget.entryId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.stop();

    _playerCompleteSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      setState(() {
        _isButtonDisabled = false;
        pronounceColor = Colors.white;
        listenColor = Colors.white;
      });
      player.stop();
    }
  }

  void _onComplete() {
    setState(() {
      _isButtonDisabled = false;
      pronounceColor = Colors.white;
      listenColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: buildContent(),
              bottomNavigationBar: BottomBackButton(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  buildContent() {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getCarousel(),
              ListView(
                children: [
                  getContent(),
                ],
              ),
            ],
          )
        : ListView(
            children: [
              getCarousel(),
              getContent(),
            ],
          );
  }

  getCarousel() {
    return FutureBuilder(
      future: loadImages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: Screen.width(context),
            height: Screen.width(context),
            child: Hero(
              tag: entry.id,
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Carousel(
                    autoplay: true,
                    images: snapshot.data,
                    autoplayDuration: Duration(seconds: 5),
                    dotBgColor: Color.fromRGBO(0, 0, 0, 0.5),
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 1000),
                    onImageChange: (prev, next) {
                      setState(() => _currentImage = next);
                    },
                  ),
                  entry.galleryImages[_currentImage].source == null
                      ? ImageSource(
                          isCopyright: true,
                          source: entry.galleryImages[_currentImage].name,
                        )
                      : Container(),
                ],
              ),
            ),
          );
        } else {
          return Container(
            width: Screen.width(context),
            height: Screen.width(context),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  // This future won't return until all images have been pre-cached.
  Future<List<Image>> loadImages() async {
    List<Image> images = List<Image>();
    for (MediaFile media in entry.galleryImages) {
      ImageProvider provider = FileImage(
        File(
          Env.getResourcePath(media.path),
        ),
      );
      await precacheImage(provider, context);
      images.add(
        Image(image: provider),
      );
    }
    return images;
  }

  playPronounce() {
    setState(() => pronounceColor = Theme.of(context).primaryColor);
    _isButtonDisabled = true;

    return player.play(Env.getResourcePath(entry.pronounceAudio.path),
        isLocal: true);
  }

  playListen() {
    setState(() => listenColor = Theme.of(context).primaryColor);
    _isButtonDisabled = true;

    return player.play(Env.getResourcePath(entry.listenAudio.path),
        isLocal: true);
  }

  getContent() {
    return Container(
      padding: EdgeInsets.all(
        Screen.width(context, percentage: 2),
      ),
      child: Column(
        children: [
          Heading(entry.primaryName),
          SizedBox(height: Screen.height(context, percentage: 1.56)),
          SubHeading(entry.altName),
          Divider(color: Colors.white, height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (entry.pronounceAudio != null)
                SizedBox(
                  width: Screen.width(
                        context,
                        percentage: Screen.isSmall(context)
                            ? 80
                            : Screen.isTablet(context) &&
                                    Screen.isLandscape(context)
                                ? 45
                                : 88.75,
                      ) /
                      2,
                  child: OutlineButton(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.music,
                          color: pronounceColor,
                          size: Screen.isSmall(context) ? 16 : 24,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Pronounce',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: pronounceColor,
                            fontSize: (Screen.isSmall(context) ? 16 : 20),
                          ),
                        ),
                      ],
                    ),
                    onPressed: _isButtonDisabled ? null : playPronounce,
                    borderSide: BorderSide(
                      color: pronounceColor,
                      width: 1.5,
                    ),
                  ),
                ),
              if (entry.listenAudio != null)
                SizedBox(
                  width: Screen.width(
                        context,
                        percentage: Screen.isSmall(context)
                            ? 80
                            : Screen.isTablet(context) &&
                                    Screen.isLandscape(context)
                                ? 45
                                : 88.75,
                      ) /
                      2,
                  child: OutlineButton(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.volumeUp,
                          color: listenColor,
                          size: Screen.isSmall(context) ? 16 : 24,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Listen',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: listenColor,
                            fontSize: (Screen.isSmall(context) ? 16 : 20),
                          ),
                        ),
                      ],
                    ),
                    onPressed: _isButtonDisabled ? null : playListen,
                    borderSide: BorderSide(
                      color: listenColor,
                      width: 1.5,
                    ),
                  ),
                )
            ],
          ),
          Divider(color: Colors.white, height: 50),
          Column(children: getNuggets()),
          Padding(
            padding: EdgeInsets.all(
              Screen.width(context, percentage: 1.25),
            ),
            child: BodyText(
              entry.bodyText,
              align: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  getNuggets() {
    return entry.nuggets.map((nugget) {
      return FactNugget(
        path: nugget.image != null ? nugget.image.path : null,
        name: nugget.name,
        text: nugget.text,
      );
    }).toList();
  }
}
