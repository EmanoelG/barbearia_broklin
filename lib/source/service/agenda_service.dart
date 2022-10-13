import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/service/sql/agendao_dao.dart';
import 'package:provider/provider.dart';

import '../model/agenda_model.dart';

class AgendaServices {
  static Future<bool> saveAgenda(context, Agenda c) async {
    Agenda f = Agenda.fromJson(c.toMap());
    final dao = AgendaDAO();
    final ids = await dao.save(c);

    if (ids != null) {
      return false;
    } else {
      return true;
    }
  }

  static Future<List<Agenda>> getAgendados() async {
    // SELECT * from carro c, favorito f where c.id = f.id;
    List<Agenda> agen =
        await AgendaDAO().query("SELECT * from agenda order by outro;");

    return agen;
  }

  static Future<List<Agenda>> getAgendadosDay() async {
    DateTime hoje = DateTime.now();
    // ignore: prefer_interpolation_to_compose_strings
    final shoje = hoje.year.toString() +
        '-' +
        hoje.month.toString() +
        '-' +
        hoje.day.toString() +
        ' 00:00:00.000Z';

    List<Agenda> agen = await AgendaDAO().query(
        "select * from agenda where horario like ?  order by outro;", [shoje]);
    print('Agendados do dia : $agen');
    return agen;
  }

  static Future<bool> getAgendadoByData(hora, data) async {
    // SELECT * from carro c, favorito f where c.id = f.id; //"select * from agenda where outro = ?", [datase]
    Agenda? agen = await AgendaDAO().findByOutro(hora, data);
    if (agen != null) {
      return true;
    } else {
      return false;
    }
  }
}
