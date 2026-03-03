import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final int id;
  final String name;
  final String code;

  const Language({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object> get props => [id, name, code];

  @override
  String toString() => name;
}
