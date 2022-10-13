import 'dart:async';

import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/service/agenda_service.dart';

class AgendaBloc {
  final _streamController = StreamController<List<Agenda>>();
  final _streamControllerDay = StreamController<List<Agenda>>();
  Stream<List<Agenda>> get StreamAgenda => _streamController.stream;

  Stream<List<Agenda>> get StreamAgendaDay => _streamControllerDay.stream;

  Future<List<Agenda>> fetch() async {
    try {
      List<Agenda> agendados = await AgendaServices.getAgendados();
      List<Agenda> agendadosDay = await AgendaServices.getAgendadosDay();
      _streamController.add(agendados);
      _streamControllerDay.add(agendadosDay);
      print('Carregou !');
      return agendados;
    } catch (e) {
      _streamController.addError(e);
      _streamControllerDay.addError(e);
      throw const FormatException();
    }
  }

  void dispose() {
    _streamController.close();
  }
}
