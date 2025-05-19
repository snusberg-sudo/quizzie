import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  @JsonKey(name: 'question_text')
  final String questionText;

  final int id;
  final List<Map<String, dynamic>> choices;

  Question({required this.questionText, required this.id, required this.choices});

  factory Question.fromJson(Map<String, dynamic> json)=>_$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}