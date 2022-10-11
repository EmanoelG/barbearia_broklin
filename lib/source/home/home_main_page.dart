import 'dart:collection';

import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/model/agenda_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../service/agenda_bloc.dart';
import '../service/agenda_service.dart';
import 'event.dart';

List<Agenda> agendaList = [];

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with AutomaticKeepAliveClientMixin {
  late Map<DateTime, List<Agenda>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventControllerName = TextEditingController();
  TextEditingController _eventControllerHorario = TextEditingController();
  AgendaBloc _agendaBloc = AgendaBloc();
  @override
  void initState() {
    _agendaBloc.fetch();

    selectedEvents = {};
    // addSchedules();
    super.initState();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<Agenda> _getEventsfromDay(DateTime date) {
    print('Oq vem $date');
    print('Oq tem $selectedEvents');

    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventControllerName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // mod = Provider.of<AgendaServiceModel>(context);

    // selectedEvents[mod.selectedEvents];
    return Scaffold(
      appBar: AppBar(
        title: _titlehometab(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
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
              ), //Color.fromARGB(255, 0, 0, 0)
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height / 10),
                    height: size.height * 0.55,
                    width: size.width * 0.9,
                    alignment: Alignment.center,
                    color: Color.fromARGB(235, 253, 253, 253),
                    child: _calendar(),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    color: Color.fromARGB(235, 253, 253, 253),
                    height: size.height * 0.23,
                    width: size.width * 0.9,
                    child: Column(
                      children: [
                        ..._getEventsfromDay(selectedDay).map(
                          (Agenda event) => _agendado(event),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ..._getEventsfromDay(selectedDay).map(
          //   (Event event) => _agendado(event),
          // ),
        ],
      ),
      floatingActionButton: _addhorario(context),
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

  _calendar() {
    return StreamBuilder(
      stream: _agendaBloc.streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          return const Center(
            child: Text('ERORR'),
          );
        } else if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          print('Diferente de erro ');
          List<Agenda>? agendados;
          if (snapshot.data != null) {
            agendados = snapshot.data;
            agendaList = agendados!;
            print('MEU $selectedEvents ZOVO');
            _groupEvents(agendaList);
            // agendados?.forEach(
            //   (element) {
            //     var dataSave;

            //     dataSave = '${element.horario}';
            //     print('::: ' + dataSave);
            //     DateTime dataOrigen = DateTime.parse(dataSave);
            //     DateTime date = DateTime.utc(
            //         dataOrigen.year, dataOrigen.month, dataOrigen.day, 12);
            //     selectedEvents[date]?.add(
            //       Agenda(
            //         Nome: element.Nome ?? 'eheheh',
            //         horario: element.horario ?? '1240124',
            //       ),
            //     );
            //   },
            // );

          } else {
            _agendaBloc.fetch();
          }

          // var dataSave;
          //   dataSave = e.horario?.substring(0, 19);
          //   DateTime dataOrigen = DateTime.parse(dataSave);
          //   selectedEvents[dataOrigen]!.add(Agenda(
          //     Nome: e.Nome,
          //     horario: e.horario,
          //   ));
          //   setState(() {
          //     selectedEvents;
          //   });
        }

        return TableCalendar(
          locale: 'pt_BR',
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mês',
            CalendarFormat.twoWeeks: '2 Semana',
            CalendarFormat.week: 'Semana',
            // CalendarFormat.values: bucet,
          },
          focusedDay: selectedDay,
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
          startingDayOfWeek: StartingDayOfWeek.sunday,
          daysOfWeekVisible: true,
          onDaySelected: (DateTime selectDay, DateTime focusDay) {
            setState(() {
              selectedDay = selectDay;
              focusedDay = focusDay;
            });
            print(focusedDay);
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(selectedDay, date);
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
      },
    );
  }

  _agendado(Agenda event) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white60,
        child: ListTile(
          subtitle: Text.rich(
            TextSpan(
              style: TextStyle(fontWeight: FontWeight.bold),
              children: [
                const TextSpan(
                  text: 'Horário ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 3, 3),
                      fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: event.outro,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          title: Text.rich(
            TextSpan(
              style: TextStyle(fontWeight: FontWeight.bold),
              children: [
                const TextSpan(
                  text: 'Nome ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 3, 3),
                      fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: event.Nome,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton _addhorario(BuildContext context) {
    final format = DateFormat("HH:mm");
    return FloatingActionButton.extended(
      backgroundColor: Color.fromARGB(228, 0, 0, 0),
      onPressed: () => showDialog(
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
                  format: format,
                  controller: _eventControllerHorario,
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.convert(time);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  print('Clicou');
                  if (_eventControllerName.text.isEmpty ||
                      _eventControllerHorario.text.isEmpty) {
                  } else {
                    if (selectedEvents[selectedDay] != null) {
                      print('adiciona aqui');
                      selectedEvents[selectedDay]?.add(
                        Agenda(
                          Nome: _eventControllerName.text,
                          horario: _eventControllerHorario.text,
                        ),
                      );
                      Agenda agendar = Agenda();
                      agendar.Nome = _eventControllerName.text;

                      agendar.horario = selectedDay.toString().substring(0, 12);

                      bool favoritar =
                          await AgendaServices.saveAgenda(context, agendar);
                    } else {
                      print('nao sei aqui');
                      try {
                        selectedEvents[selectedDay] = [
                          Agenda(
                            Nome: _eventControllerName.text,
                            horario: selectedDay.toString(),
                          )
                        ];
                      } catch (e) {}
                      Agenda agendar = Agenda();
                      agendar.Nome = _eventControllerName.text;
                      agendar.outro = _eventControllerHorario.text;
                      agendar.horario = selectedDay.toString();

                      bool favoritar =
                          await AgendaServices.saveAgenda(context, agendar);
                    }
                  }
                  Navigator.pop(context);
                  //_eventControllerName.clear();
                },
              ),
            ],
          ),
        ),
      ),
      label: const Text(
        "Agendar Horario",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      icon: Icon(Icons.add),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
