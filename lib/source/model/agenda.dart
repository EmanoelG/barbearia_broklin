import 'dart:convert';

import 'package:barbearia_adriano/source/service/sql/entity.dart';

class Agenda extends Entity {
  String? Nome;
  String? horario;
  int? id;
  String? outro;
  Agenda({
    this.Nome,
    this.horario,
    this.id,
    this.outro,
  });
  @override
  Map<String, dynamic> toMap() {
    return {
      'Nome': Nome,
      'horario': horario,
      'id': id,
      'outro': outro,
    };
  }

  Agenda copyWith({
    String? Nome,
    String? horario,
    int? id,
    String? outro,
  }) {
    return Agenda(
      Nome: Nome ?? this.Nome,
      horario: horario ?? this.horario,
      id: id ?? this.id,
      outro: outro ?? this.outro,
    );
  }

  factory Agenda.fromMap(Map<String, dynamic> map) {
    return Agenda(
      Nome: map['Nome'],
      horario: map['horario'],
      id: map['id']?.toInt(),
      outro: map['outro'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Agenda(Nome: $Nome, horario: $horario, id: $id, outro: $outro)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Agenda &&
        other.Nome == Nome &&
        other.horario == horario &&
        other.id == id &&
        other.outro == outro;
  }

  @override
  int get hashCode {
    return Nome.hashCode ^ horario.hashCode ^ id.hashCode ^ outro.hashCode;
  }

  // factory Agenda.fromJson(String source) => Agenda.fromMap(json.decode(source));
//{id: 1, nome: Emanoel, horario: 2022-09-29 00:00:00, outro: null}
  Agenda.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    Nome = json['nome'];
    horario = json['horario'];
    outro = json['outro'];
  }

 
}
