import 'dart:collection';
import 'dart:ffi';

import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/model/agenda_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/item_title.dart';
import '../service/agenda_bloc.dart';
import '../service/agenda_service.dart';
import 'event.dart';
import 'listview/lista_do_dia.dart';

List<Agenda> agendaList = [];

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with AutomaticKeepAliveClientMixin<Calendar> {
  late Map<DateTime, List<Agenda>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime focusedDaySelect = DateTime.now();
  bool noDate = false;
  bool _controllBarBottom = false;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endFloat;
  TextEditingController _eventControllerName = TextEditingController();
  TextEditingController _eventControllerHorario = TextEditingController();
  AgendaBloc _agendaBloc = AgendaBloc();

  @override
  void initState() {
    super.initState();
    _agendaBloc.fetch();
    selectedEvents = {};
    _atualizaCalendar();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<Agenda> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _agendaBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: _titlehometab(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("fundo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(45, 0, 0, 0),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height / 10),
            height: size.height * 0.55,
            // width: size.width * 0.9,
            alignment: Alignment.center,
            color: Color.fromARGB(235, 253, 253, 253),
            child: _calendar(),
          ),
        ],
      ),
      bottomNavigationBar: _controllBarBottom == false
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: SingleChildScrollView(
                child: Container(
                  height: size.height / 4,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(143, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      listaAgendamentos(),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Stack stackantingo() {
    return Stack(children: [
      // Container(
      //   height: size.height,
      //   width: size.width,
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       fit: BoxFit.cover,
      //       alignment: Alignment.center,
      //       image: AssetImage('fundo.png'),
      //       opacity: 20,
      //       colorFilter: ColorFilter.mode(
      //           Color.fromARGB(31, 255, 181, 152), BlendMode.color),
      //     ),
      //   ),
      // ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     children: [
      //       Column(
      //         children: [
      //           // Container(
      //           //   margin: EdgeInsets.only(top: size.height / 10),
      //           //   height: size.height * 0.55,
      //           //   // width: size.width * 0.9,
      //           //   alignment: Alignment.center,
      //           //   color: Color.fromARGB(235, 253, 253, 253),
      //           //   child: _calendar(),
      //           // ),
      //         ],
      //       ),
      //     ],
      //   ),

      // Column(
      //   children: [
      //     // Container(
      //     //   margin: EdgeInsets.only(top: size.height / 10),
      //     //   height: size.height * 0.55,
      //     //   // width: size.width * 0.9,
      //     //   alignment: Alignment.center,
      //     //   color: Color.fromARGB(235, 253, 253, 253),
      //     //   child: _calendar(),
      //     // ),

      //   ],
      // ),
      //     ),
      //   ],
    ]);
    // );
  }

  listaAgendamentos() {
    return Expanded(
      child: StreamBuilder(
        stream: _agendaBloc.StreamAgenda,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR 404'),
            );
          } else if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            List<Agenda>? agendados;
            if (snapshot.data != null) {
              agendados = snapshot.data;
              agendaList = agendados!;
              // print('MEU $selectedEvents; ZOVO');
              _groupEvents(agendaList);
            } else {
              //  _agendaBloc.fetch();
            }
          }

          return ListaDoDia(
            selectedEvents: _getEventsfromDay(_selectedDay),
          );
        },
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

  Future _atualizaCalendar() async {
    List<Agenda> listaAgenda = [];
    await _agendaBloc.StreamAgenda.timeout(Duration(seconds: 3))
        .map((event) => listaAgenda = event);
    setState(
      () {
        _groupEvents(listaAgenda);
      },
    );
  }

  _calendar() {
    final formats = DateFormat("HH:mm");

    return TableCalendar(
      locale: 'pt_BR',
      onPageChanged: (focusedDay) {
        focusedDaySelect = focusedDay;
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mês',
        CalendarFormat.twoWeeks: '2 Semana',
        CalendarFormat.week: 'Semana',
      },
      focusedDay: _selectedDay,
      weekNumbersVisible: false,
      weekendDays: const [DateTime.sunday],
      firstDay: DateTime(1990),
      lastDay: DateTime(2050),
      calendarFormat: format,
      onFormatChanged: (CalendarFormat _format) {
        setState(
          () {
            format = _format;
          },
        );
      },
      onDayLongPressed: (selectedDasy, focusedDay) {
        setState(() {
          _controllBarBottom = true;
        });
        dialogAgendamento(context, formats);
      },
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekVisible: true,
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(() {
          _selectedDay = selectDay;
          focusedDaySelect = focusDay;
        });
        _agendaBloc.fetch();
        print(_selectedDay);
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(_selectedDay, date);
      },
      eventLoader: _getEventsfromDay,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: Colors.brown,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        defaultDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.0),
            color: Color.fromARGB(255, 168, 168, 166)),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
        formatButtonDecoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(5.0),
        ),
        formatButtonTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    // }
    // );
  }

  dialogAgendamento(BuildContext context, DateFormat formats) async {
    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          actionsOverflowAlignment: OverflowBarAlignment.end,
          actionsPadding: EdgeInsets.all(10),
          actionsAlignment: MainAxisAlignment.end,
          title: const Text(
            "Marca horário",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            children: [
              TextFormField(
                controller: _eventControllerName,
                decoration: const InputDecoration(
                  hintText: 'Nome',
                  hintStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              DateTimeField(
                format: formats,
                controller: _eventControllerHorario,
                onShowPicker: (context, currentValue) async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.convert(time);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                setState(() {
                  _controllBarBottom = false;
                });
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                print('Clicou');
                if (_eventControllerName.text.isEmpty ||
                    _eventControllerHorario.text.isEmpty) {
                } else {
                  bool permitir = false;
                  permitir = await AgendaServices.getAgendadoByData(
                      _eventControllerHorario.text, _selectedDay.toString());
                  if (permitir == false) {
                    try {
                      selectedEvents[_selectedDay]!.add(
                        Agenda(
                          Nome: _eventControllerName.text,
                          horario: _selectedDay.toString(),
                          outro: _eventControllerHorario.text,
                        ),
                      );
                    } catch (e) {}
                    Agenda agendar = Agenda();
                    agendar.Nome = _eventControllerName.text;
                    agendar.outro = _eventControllerHorario.text;
                    agendar.horario = _selectedDay.toString();

                    bool favoritar =
                        await AgendaServices.saveAgenda(context, agendar);
                    setState(
                      () {
                        focusedDaySelect = _selectedDay;

                        _agendaBloc.fetch();
                        _controllBarBottom = false;
                        Navigator.pop(context);
                      },
                    );
                    //_agendaBloc.dispose();

                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Horário indisponível !"),
                          content: const Text(
                              "Já há cliente marcado neste horario !"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  }

                  // setState(
                  //   () {
                  //     focusedDaySelect = _selectedDay;
                  //     selectedEvents.clear();
                  //     // _agendaBloc.fetch();
                  //   },
                  // );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
