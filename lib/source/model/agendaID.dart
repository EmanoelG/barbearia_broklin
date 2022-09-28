import 'dart:convert';

import 'package:barbearia_adriano/source/service/sql/entity.dart';

class AgendaIDs extends Entity {
  String? Nome;
  String? horario;

  String? id;
  AgendaIDs({
    this.Nome,
    this.horario,
    this.id,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'Nome': Nome,
      'horario': horario,
      'id': id,
    };
  }

  AgendaIDs copyWith({
    String? Nome,
    String? horario,
    String? id,
  }) {
    return AgendaIDs(
      Nome: Nome ?? this.Nome,
      horario: horario ?? this.horario,
      id: id ?? this.id,
    );
  }

  factory AgendaIDs.fromMap(Map<String, dynamic> map) {
    return AgendaIDs(
      Nome: map['Nome'],
      horario: map['horario'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AgendaIDs.fromJson(String source) =>
      AgendaIDs.fromMap(json.decode(source));

  @override
  String toString() => 'AgendaIDs(Nome: $Nome, horario: $horario, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AgendaIDs &&
        other.Nome == Nome &&
        other.horario == horario &&
        other.id == id;
  }

  @override
  int get hashCode => Nome.hashCode ^ horario.hashCode ^ id.hashCode;
}
