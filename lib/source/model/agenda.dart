import 'dart:convert';

import 'package:barbearia_adriano/source/service/sql/entity.dart';

class Agenda extends Entity {
  String? Nome;
  DateTime? horario;
  int? idUser;
  Agenda({
    this.Nome,
    this.horario,
    this.idUser,
  });
  @override
  Map<String, dynamic> toMap() {
    return {
      'Nome': this.Nome,
      'horario': this.horario,
      'idUser': this.idUser,
    };
  }

  Agenda copyWith({
    String? Nome,
    DateTime? horario,
    int? idUser,
  }) {
    return Agenda(
      Nome: Nome ?? this.Nome,
      horario: horario ?? this.horario,
      idUser: idUser ?? this.idUser,
    );
  }

  factory Agenda.fromMap(Map<String, dynamic> map) {
    return Agenda(
      Nome: map['Nome'],
      horario: map['horario'],
      idUser: map['idUser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Agenda.fromJson(String source) => Agenda.fromMap(json.decode(source));

  @override
  String toString() =>
      'Agenda(Nome: $Nome, horario: $horario, idUser: $idUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Agenda &&
        other.Nome == Nome &&
        other.horario == horario &&
        other.idUser == idUser;
  }

  @override
  int get hashCode => Nome.hashCode ^ horario.hashCode ^ idUser.hashCode;
}
