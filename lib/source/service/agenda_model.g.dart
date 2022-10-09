// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AgendaModel on AgendaModelBase, Store {
  late final _$agendadosAtom =
      Atom(name: 'AgendaModelBase.agendados', context: context);

  @override
  List<Agenda> get agendados {
    _$agendadosAtom.reportRead();
    return super.agendados;
  }

  @override
  set agendados(List<Agenda> value) {
    _$agendadosAtom.reportWrite(value, super.agendados, () {
      super.agendados = value;
    });
  }

  late final _$errorAtom =
      Atom(name: 'AgendaModelBase.error', context: context);

  @override
  Exception get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(Exception value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$fetchAsyncAction =
      AsyncAction('AgendaModelBase.fetch', context: context);

  @override
  Future fetch() {
    return _$fetchAsyncAction.run(() => super.fetch());
  }

  @override
  String toString() {
    return '''
agendados: ${agendados},
error: ${error}
    ''';
  }
}
