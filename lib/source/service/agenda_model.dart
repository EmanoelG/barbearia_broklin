import 'package:mobx/mobx.dart';
import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/service/agenda_service.dart';

part 'agenda_model.g.dart';

class AgendaModel = AgendaModelBase with _$AgendaModel;

abstract class AgendaModelBase with Store {
  @observable
  late List<Agenda> agendados;

  @observable
  late Exception error;

  @action
  fetch() async {
    try {
      agendados = await AgendaServices.getAgendados();
    } catch (e) {
      late Exception error;
    }
  }
}
