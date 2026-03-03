import '../../domain/entities/language.dart';

class LanguageModel extends Language {
  const LanguageModel({
    required super.id,
    required super.name,
    required super.code,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}
