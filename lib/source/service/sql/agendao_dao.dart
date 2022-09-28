import 'package:barbearia_adriano/source/model/agenda.dart';

import 'base_dao.dart';

class AgendaDAO extends BaseDAO<Agenda> {
  @override
  String get tableName => "agenda";

  @override
  Agenda fromJson(Map<String, dynamic> map) {
    return Agenda.fromJson(map);
  }

  Future<List<Agenda>> findAllByTipo(String ids) async {
    final dbClient = await db;

    final list =
        await dbClient.rawQuery('select * from agenda where id =? ', [ids]);

    return list.map<Agenda>((json) => fromJson(json)).toList();
  }
}
