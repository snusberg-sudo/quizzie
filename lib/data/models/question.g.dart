// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  questionText: json['question_text'] as String,
  id: (json['id'] as num).toInt(),
  choices:
      (json['choices'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'question_text': instance.questionText,
  'id': instance.id,
  'choices': instance.choices,
};
