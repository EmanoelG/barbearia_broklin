import 'package:flutter/material.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(fit: BoxFit.contain, 'fundo_main.jpg'),
                Expanded(
                    child: Image.asset(fit: BoxFit.fill, 'fundo_main.jpg')),
              ],
            ),
            Card(
              color: Colors.white70,
              child: Container(height: 400, child: _calendar()),
            ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => _agendado(event),
            ),
          ],
        ),
      ),
      floatingActionButton: _addhorario(context),
    );
  }

  Column _calendar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TableCalendar(
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
        ),
      ],
    );
  }

/* ..._getEventsfromDay(selectedDay).map(
          (Event event) => _agendado(event),
        ), */
  _agendado(Event event) {
    return Container(
      alignment: Alignment.bottomCenter
      ,
      child: Card(
        child: ListTile(
          subtitle: Text(
            event.horario,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          title: Text(
            event.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton _addhorario(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "Add Event",
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
              TextFormField(
                controller: _eventControllerHorario,
                decoration: const InputDecoration(
                  hintText: 'Horario',
                  hintStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
      label: const Text(
        "Agendar Horario",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      icon: Icon(Icons.add),
    );
  }
}
