import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/service/sql/agendao_dao.dart';
import 'package:provider/provider.dart';

import '../model/agenda_model.dart';

class AgendaServices {
  static Future<bool> saveAgenda(context, Agenda c) async {
    Agenda f = Agenda.fromJson(c.toJson());
    final dao = AgendaDAO();
    final ids = await dao.save(c);

    if (ids != null) {
      print('SAve');

      Provider.of<FavoritoServiceModel>(context, listen: false).getAgendado();
      return false;
    } else {
      // dao.save(f);
      // print('Save');

      Provider.of<FavoritoServiceModel>(context, listen: false).getAgendado();
      return true;
    }
  }

  static Future<List<Agenda>> getAgendados() async {
    // SELECT * from carro c, favorito f where c.id = f.id;
    List<Agenda> agen = await AgendaDAO().query("SELECT * from agendados ;");
    print('return agendados $agen');
    return agen;
  }

  static Future<List<Agenda>> getAgendadoByData(datase) async {
    // SELECT * from carro c, favorito f where c.id = f.id;
    List<Agenda> agen = await AgendaDAO()
        .query("SELECT * from agendados where dataTimes = ?", [datase]);
    print('return agendados $agen');
    return agen;
  }
}
