import 'dart:math';

import '../../data/models/quiz/quiz_answer.dart';
import '../../util/screen.dart';
import '../misc/text/body_text.dart';
import '../misc/text/heading.dart';
import '../misc/text/sub_heading.dart';
import 'quiz_image_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CorrectWrongOverlay extends StatefulWidget {
  final bool isCorrect;
  final String answer;
  final String guess;
  final QuizAnswer imageGuess;
  final QuizAnswer imageAnswer;
  final VoidCallback onTap;

  const CorrectWrongOverlay({
    this.isCorrect,
    this.answer,
    this.guess,
    this.imageAnswer,
    this.imageGuess,
    this.onTap,
  });

  @override
  State createState() => CorrectWrongOverlayState();
}

class CorrectWrongOverlayState extends State<CorrectWrongOverlay> with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  bool isImageQuestion;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _iconAnimation = CurvedAnimation(parent: _iconAnimationController, curve: Curves.elasticOut);
    _iconAnimation.addListener(() => setState(() {}));
    _iconAnimationController.forward();
    isImageQuestion = widget.imageGuess != null ? true : false;
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(190, 0, 0, 0),
      child: InkWell(
          onTap: () => widget.onTap(),
          child: isImageQuestion
              ? (Screen.isLandscape(context)
                  ? buildImageQuestionOverlayLandscape()
                  : buildImageQuestionOverlayPortrait())
              : buildTextQuestionOverlay()),
    );
  }

  buildImageQuestionOverlayPortrait() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Heading(widget.isCorrect ? 'Correct!' : 'Wrong!'),
        Container(
          height: Screen.width(context, percentage: 20),
          width: Screen.width(context, percentage: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Transform.rotate(
            angle: _iconAnimation.value * 2 * pi,
            child: Icon(
              widget.isCorrect ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
              size: Screen.width(context, percentage: 15),
              color: widget.isCorrect ? Colors.green : Colors.red,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: getResultImagesPortrait(),
        ),
        const BodyText('Tap to proceed')
      ],
    );
  }

  getResultImagesPortrait() {
    List<Widget> widgets = <Widget>[];

    widgets.add(
      Column(children: <Widget>[
        QuizImageButton(
          onTap: null,
          image: widget.imageGuess.image,
          text: widget.imageGuess.text,
        ),
        const SubHeading('Your answer')
      ]),
    );

    if (!widget.isCorrect) {
      widgets.add(Column(
        children: <Widget>[
          QuizImageButton(
            onTap: null,
            image: widget.imageAnswer.image,
            text: widget.imageAnswer.text,
          ),
          const SubHeading('Correct answer')
        ],
      ));
    }

    return widgets;
  }

  getResultImagesLandscape() {
    List<Widget> widgets = <Widget>[];

    widgets.add(
      Column(children: <Widget>[
        QuizImageButton(
          onTap: null,
          image: widget.imageGuess.image,
          text: widget.imageGuess.text,
        ),
        const SubHeading('Your answer')
      ]),
    );

    widgets.add(
      Container(
        height: Screen.width(context, percentage: 20),
        width: Screen.width(context, percentage: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Transform.rotate(
          angle: _iconAnimation.value * 2 * pi,
          child: Icon(
            widget.isCorrect ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
            size: Screen.width(context, percentage: 15),
            color: widget.isCorrect ? Colors.green : Colors.red,
          ),
        ),
      ),
    );

    if (!widget.isCorrect) {
      widgets.add(Column(
        children: <Widget>[
          QuizImageButton(
            onTap: null,
            image: widget.imageAnswer.image,
            text: widget.imageAnswer.text,
          ),
          const SubHeading('Correct answer')
        ],
      ));
    }

    return widgets;
  }

  buildImageQuestionOverlayLandscape() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Heading(widget.isCorrect ? 'Correct!' : 'Wrong!'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: getResultImagesLandscape(),
        ),
        const BodyText('Tap to proceed')
      ],
    );
  }

  buildTextQuestionOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: Screen.isTablet(context) ? 160 : 100,
          width: Screen.isTablet(context) ? 160 : 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Transform.rotate(
            angle: _iconAnimation.value * 2 * pi,
            child: Icon(
              widget.isCorrect ? FontAwesomeIcons.check : FontAwesomeIcons.xmark,
              size: Screen.isTablet(context) ? 100 : 80,
              color: widget.isCorrect ? Colors.green : Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Heading(
            widget.isCorrect
                ? 'Correct! ${widget.answer} is the right answer'
                : 'Wrong! You selected ${widget.guess} - the correct answer is ${widget.answer}',
          ),
        ),
        SizedBox(
          height: Screen.height(context, percentage: 5.0),
        ),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: BodyText('Tap to proceed'),
        ),
      ],
    );
  }
}
