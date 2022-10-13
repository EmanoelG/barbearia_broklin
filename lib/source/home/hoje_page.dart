import 'dart:collection';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/agenda.dart';
import '../service/agenda_bloc.dart';
import 'listview/lista_do_dia.dart';

class HojePage extends StatefulWidget {
  const HojePage({Key? key}) : super(key: key);

  @override
  State<HojePage> createState() => _HojePageState();
}

class _HojePageState extends State<HojePage>
    with AutomaticKeepAliveClientMixin {
  late List<Agenda> _listaAgenda;
  final AgendaBloc _agendaBloc = AgendaBloc();
  late Map<DateTime, List<Agenda>> selectedEvents;
  @override
  void initState() {
    _listaAgenda = [];
    _agendaBloc.fetch();

    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _groupEvents(List<Agenda> events) {
    selectedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    for (var event in events) {
      var hourRes = event.horario;
      DateTime datess = DateTime.parse(hourRes!);
      DateTime date = DateTime.utc(datess.year, datess.month, datess.day, 12);
      if (selectedEvents[date] == null) selectedEvents[date] = [];
      selectedEvents[date]!.add(event);
    }
  }

  List<Agenda> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: _titlehometab(),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: AssetImage('fundo.png'),
                  opacity: 20,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(31, 255, 181, 152), BlendMode.color),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: size.height / 10),
                  alignment: Alignment.topCenter,
                  color: Color.fromARGB(28, 253, 253, 253),
                  child: _searchproduto(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Color.fromARGB(26, 253, 253, 253),
                    child: StreamBuilder(
                      stream: _agendaBloc.StreamAgendaDay,
                      builder: (context, snapshot) {
                        if (snapshot.error != null) {
                          return Card(
                            child: Text('Error SqLite'),
                          );
                        }

                        return ListaDoDia(
                          selectedEvents: snapshot.data ?? [],
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          // _body(context),
        ],
      ),
    );
  }

  _fundoapp(Size size) {
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            image: AssetImage('fundo.png'),
            opacity: 20,
            colorFilter: ColorFilter.mode(
                Color.fromARGB(31, 255, 181, 152), BlendMode.color),
          ),
        ),
      ),
    );
  }

  Text _titlehometab() {
    return const Text.rich(
      textScaleFactor: 2,
      TextSpan(
        style: TextStyle(
          backgroundColor: Color.fromARGB(118, 190, 143, 99),
          shadows: <Shadow>[
            Shadow(
              offset: Offset(3.0, 2.8),
              blurRadius: 1.0,
              color: Color.fromARGB(195, 0, 0, 0),
            ),
          ],
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'BARBER',
            style: TextStyle(
                color: Color.fromARGB(195, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'SHOP',
            style: TextStyle(
                color: Color.fromARGB(195, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _body(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: _agendaBloc.StreamAgenda,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError != null) {
            return const Center(
              child: Card(child: Text('Error SqLite')),
            );
          } else if (snapshot.data!.isNotEmpty) {
            return const Center(
              child: Card(child: Text('Vazio')),
            );
          }
          print('OLOVO');
          return const Center(
            child: Card(child: Text('Vazio')),
          );
        },
      ),
    );
  }

  Padding _searchproduto() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          hintText: 'Pesquisar por nome',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
          prefix: const Icon(
            Icons.search,
            color: Colors.black26,
            size: 21,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
