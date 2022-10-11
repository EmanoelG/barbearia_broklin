import 'dart:async';

import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/service/agenda_service.dart';

class AgendaBloc {
  final streamController = StreamController<List<Agenda>>();
  Stream<List<Agenda>> get StreamAgenda => streamController.stream;

  Future<List<Agenda>> fetch() async {
    try {
      List<Agenda> agendados = await AgendaServices.getAgendados();
      streamController.add(agendados);
      return agendados;
    } catch (e) {
      streamController.addError(e);
      throw const FormatException();
    }
  }

  void dispose() {
    streamController.close();
  }
}
