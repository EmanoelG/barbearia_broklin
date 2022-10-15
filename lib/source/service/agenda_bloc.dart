import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/service/agenda_service.dart';

class AgendaBloc {
  final _streamController = BehaviorSubject<List<Agenda>>();
  final _streamControllerDay = BehaviorSubject<List<Agenda>>();
  Stream<List<Agenda>> get StreamAgenda => _streamController.stream;

  Stream<List<Agenda>> get StreamAgendaDay => _streamControllerDay.stream;

  fetch() async {
    try {
      List<Agenda> agendados = await AgendaServices.getAgendados();
      List<Agenda> agendadosDay = await AgendaServices.getAgendadosDay();
      _streamController.add(agendados);
      _streamControllerDay.add(agendadosDay);

      print('Carregou !');
      // return agendados;
    } catch (e) {
      _streamController.addError(e);
      _streamControllerDay.addError(e);
      throw const FormatException();
    }

    try {
      AgendaServices.deleteFromAllMenorNow();
    } catch (e) {}
  }

  void dispose() {
    _streamController.close();
    _streamControllerDay.close();
  }
}

class CounterBloc {
  // variável que irá receber o valor da stream transformada
  late Observable<int> streamTransformada;

  final _counterController = BehaviorSubject<int>();

// Observable(stream) sendo retornada pelo getter, o fato é que independete do get funcionar como uma função
// ele SEMPRE vai retornar o mesmo objeto nesse caso, já que ele chama: _counterController.stream
// e o objeto se mantém o mesmo durante TODA A VIDA do BLoC

  ValueStream<int> get counterFlux => _counterController.stream;

// Observable(stream) sendo retornado pelo getter, o problema desse pedaço do código é:
// como os transformadores de Observable(stream) (map,where,take e outros..)
// te retornam um novo Observable(stream), e o getter funciona como uma função, cada vez que ele é chamado
// o mesmo irá retornar um objeto da classe Stream(Observable) diferente, com isso, teremos novamente
// o problema abordado anteriormente nesse Post, para resolver isso, temos de atribuir o Observable(stream)
// retornado das transformações a uma variável,nesse caso, vamos atribuir essas transformações no construtor, por exemplo:
/*
  CounterBloc(){
    streamTransformada = _counterController
    .stream
    .map((a) => a * 2);
  }
Dessa forma, esse objeto da classe Observable(stream) só será atribuído
UMA VEZ, QUANDO O BLOC FOR INSTANCIADO
   
*/

  Stream<int> get counterFluxTransformado =>
      _counterController.stream.map((a) => a * 2);

  Sink<int> get counterEvent => _counterController.sink;
/*
No Dart, os getters funcionam da mesma forma que funções, logo quando você
invoca a transformação de uma stream (como o método map) que lhe retorna um novo observable(stream)
ou seja, um novo objeto da classe observable(stream) e se esse getter abaixo for chamad dentro de um
StreamBuilder, o mesmo irá produzir o efeito colateral que foi citado anteriormente nesse post, já que irá retornar
um novo objeto da classe Observable(stream)
  Observable<int> get counterFlux => _counterController
    .stream
    .map((a) => a * 2);
*/

  void dispose() {
    _counterController.close();
  }
}
