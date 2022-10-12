import 'dart:collection';
import 'dart:ffi';

import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/model/agenda_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../components/item_title.dart';
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
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endFloat;
  TextEditingController _eventControllerName = TextEditingController();
  TextEditingController _eventControllerHorario = TextEditingController();
  AgendaBloc _agendaBloc = AgendaBloc();
  @override
  void initState() {
    _agendaBloc.fetch();

    selectedEvents = {};

    super.initState();
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
      body: Container(
        child: Stack(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(top: size.height / 10),
                height: size.height * 0.55,
                // width: size.width * 0.9,
                alignment: Alignment.center,
                color: Color.fromARGB(235, 253, 253, 253),
                child: _calendar(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: size.height / 3,
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
    );
  }

//  listaAgendamentos(context),
  Expanded listaAgendamentos() {
    return Expanded(
      child: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ..._getEventsfromDay(selectedDay).map(
              (Agenda event) {
                return ItemTitle(
                  event: event,
                );
              },
            ),
          ],
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
    final formats = DateFormat("HH:mm");
    return StreamBuilder(
      stream: _agendaBloc.StreamAgenda,
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
          } else {
            _agendaBloc.fetch();
          }
        }

        return TableCalendar(
          locale: 'pt_BR',
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mês',
            CalendarFormat.twoWeeks: '2 Semana',
            CalendarFormat.week: 'Semana',
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
          onDayLongPressed: (selectedDay, focusedDay) =>
              dialogAgendamento(context, formats),
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

  FloatingActionButton _addhorario(BuildContext context) {
    final format = DateFormat("HH:mm");
    return FloatingActionButton.extended(
      backgroundColor: Color.fromARGB(228, 0, 0, 0),
      onPressed: () => dialogAgendamento(context, format),
      label: const Text(
        "Agendar Horario",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      icon: Icon(Icons.add),
    );
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
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                print('Clicou');
                if (_eventControllerName.text.isEmpty ||
                    _eventControllerHorario.text.isEmpty) {
                } else {
                  try {
                    selectedEvents[selectedDay]!.add(
                      Agenda(
                        Nome: _eventControllerName.text,
                        horario: selectedDay.toString(),
                        outro: _eventControllerHorario.text,
                      ),
                    );
                  } catch (e) {}
                  Agenda agendar = Agenda();
                  agendar.Nome = _eventControllerName.text;
                  agendar.outro = _eventControllerHorario.text;
                  agendar.horario = selectedDay.toString();

                  bool favoritar =
                      await AgendaServices.saveAgenda(context, agendar);

                  setState(
                    () {
                      selectedDay = selectedDay;
                      focusedDay = focusedDay;
                      selectedEvents.clear();
                      _agendaBloc.fetch();
                    },
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
