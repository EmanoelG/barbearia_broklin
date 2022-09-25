import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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
                      Color.fromARGB(255, 0, 0, 0), BlendMode.color),
                ),
              ),
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
            backgroundColor: Color.fromARGB(155, 146, 146, 146),
            fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: 'BARBER',
            style: TextStyle(
                color: Color.fromARGB(255, 3, 3, 3),
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'SHOP',
            style: TextStyle(
                color: Color.fromARGB(255, 12, 12, 12),
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

      //Day Changed
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
          color: Colors.blue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: Color.fromARGB(124, 96, 194, 4),
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
          color: Colors.blue,
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
                onPressed: () {
                  print('Clicou');
                  if (_eventControllerName.text.isEmpty ||
                      _eventControllerHorario.text.isEmpty) {
                  } else {
                    if (selectedEvents[selectedDay] != null) {
                      selectedEvents[selectedDay]?.add(
                        Event(
                          title: _eventControllerName.text,
                          horario: _eventControllerHorario.text,
                        ),
                      );
                    } else {
                      selectedEvents[selectedDay] = [
                        Event(
                          title: _eventControllerName.text,
                          horario: _eventControllerHorario.text,
                        )
                      ];
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
