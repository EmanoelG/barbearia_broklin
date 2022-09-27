import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:flutter/cupertino.dart';

import '../home/event.dart';
import '../service/agenda_service.dart';

class FavoritoServiceModel extends ChangeNotifier {
  late List<Agenda> selectedEvents;
  Future getAgendado() async {
    selectedEvents = await AgendaServices.getAgendados();
    notifyListeners();
  }
}
