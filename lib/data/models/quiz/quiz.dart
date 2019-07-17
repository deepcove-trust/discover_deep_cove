import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'quiz.jorm.dart';

class Quiz {
  Quiz();

  @PrimaryKey()
  int id;

  @Column()
  DateTime lastModified;

  // todo: wait for jaguar to support default values
  @Column(name: 'unlocked', isNullable: true)
  bool unlocked;

  /// Returns true if the quiz is unlocked. This also takes into consideration
  /// whether there is an unlock code set (quiz is unlocked by default if no
  /// unlock code is set).
//  @IgnoreColumn()
//  bool get unlocked => unlockCode == null ? true : (_unlocked ?? false);

  @Column(isNullable: true)
  String unlockCode;

  @Column()
  String title;

  @Column(isNullable: true)
  int attempts;

  @Column(isNullable: true)
  int highScore;

  @HasMany(QuizQuestionBean)
  List<QuizQuestion> questions;

  @BelongsTo(MediaFileBean, isNullable: true)
  int imageId;

  @IgnoreColumn()
  MediaFile image; // TODO: Add method to preload this.
}

@GenBean()
class QuizBean extends Bean<Quiz> with _QuizBean {
  QuizBean(Adapter adapter)
      : quizQuestionBean = QuizQuestionBean(adapter),
        super(adapter);

  final QuizQuestionBean quizQuestionBean;

  MediaFileBean _mediaFileBean;
  MediaFileBean get mediaFileBean => _mediaFileBean ?? MediaFileBean(adapter);

  final String tableName = 'quizzes';

  Future<List<Quiz>> findWhereAndPreload(
      /* Expression | ExpressionMaker<ModelType> */ where) async {
    if (where is ExpressionMaker<Quiz>) where = where(this);
    List<Quiz> quizzes = await findWhere(where);

    for(Quiz quiz in quizzes){
      quiz.image = await _mediaFileBean.find(quiz.imageId);
    }

    return quizzes;

  }


}