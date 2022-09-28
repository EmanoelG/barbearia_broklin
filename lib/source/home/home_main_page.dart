import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:barbearia_adriano/source/model/agenda_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../service/agenda_service.dart';
import 'event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventControllerName = TextEditingController();
  TextEditingController _eventControllerHorario = TextEditingController();
  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._getEventsfromDay(selectedDay).map(
                            (Event event) => _agendado(event),
                          ),
                        ],
                      ),
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

  List<Widget> get _dateSelected {
    return [
      ..._getEventsfromDay(selectedDay).map(
        (Event event) => _agendado(event),
      ),
    ];
  }

  _calendar() {
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
  }

/* ..._getEventsfromDay(selectedDay).map(
          (Event event) => _agendado(event),
        ), */
  _agendado(Event event) {
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
                  text: event.horario,
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
                  text: event.title,
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
                        Event(
                          title: _eventControllerName.text,
                          horario: _eventControllerHorario.text,
                        ),
                      );
                      Agenda agendar = Agenda();
                      agendar.Nome = _eventControllerName.text;

                      agendar.horario = selectedDay.toString().substring(0, 19);

                      bool favoritar =
                          await AgendaServices.saveAgenda(context, agendar);
                    } else {
                      print('nao sei aqui');
                      try {
                        selectedEvents[selectedDay] = [
                          Event(
                            title: _eventControllerName.text,
                            horario: _eventControllerHorario.text,
                          )
                        ];
                      } catch (e) {}
                      Agenda agendar = Agenda();
                      agendar.Nome = _eventControllerName.text;
                                            agendar.outro = '';
                      agendar.horario = selectedDay.toString().substring(0, 19);

                      bool favoritar =
                          await AgendaServices.saveAgenda(context, agendar);
                    }
                  }
                  Navigator.pop(context);
                  _eventControllerName.clear();
                  setState(() {});
                  return;
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
}
