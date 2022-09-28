import 'dart:convert';

import 'package:barbearia_adriano/source/service/sql/entity.dart';

class Agenda extends Entity {
  String? Nome;
  String? horario;

  Agenda({
    this.Nome,
    this.horario,
  });
  @override
  Map<String, dynamic> toMap() {
    return {
      'Nome': this.Nome,
      'horario': this.horario,
    };
  }

  Agenda copyWith({
    String? Nome,
    String? horario,
    int? idUser,
  }) {
    return Agenda(
      Nome: Nome ?? this.Nome,
      horario: horario ?? this.horario,
    );
  }

  factory Agenda.fromMap(Map<String, dynamic> map) {
    return Agenda(
      Nome: map['Nome'],
      horario: map['horario'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Agenda.fromJson(String source) => Agenda.fromMap(json.decode(source));

  @override
  String toString() => 'Agenda(Nome: $Nome, horario: $horario)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Agenda && other.Nome == Nome && other.horario == horario;
  }

  @override
  int get hashCode => Nome.hashCode ^ horario.hashCode;
}
