import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'quiz_answer.jorm.dart';

class QuizAnswer {
  QuizAnswer();

  @PrimaryKey()
  int id;

  @BelongsTo(QuizQuestionBean)
  int questionId;

  @Column(isNullable: true)
  String text;

  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  @HasOne(QuizQuestionBean)
  QuizQuestion correctForQuestion;
}

@GenBean()
class QuizAnswerBean extends Bean<QuizAnswer> with _QuizAnswerBean {
  QuizAnswerBean(Adapter adapter) : super(adapter);

  MediaFileBean _mediaFileBean;
  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  QuizQuestionBean _quizQuestionBean;
  QuizQuestionBean get quizQuestionBean =>
      _quizQuestionBean ?? QuizQuestionBean(adapter);

  final String tableName = 'quiz_answers';
}