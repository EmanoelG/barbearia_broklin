import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../config/colors_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorAppMain,
        title: const Text(
          'Barber Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _bodymain(),
    );
  }

  Padding _bodymain() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _categoria(),
          _searchproduto(),
        ],
      ),
    );
  }

  Container _categoria() {
    return Container(
      width: 250,
      height: 50,
      child: const Text('Dia'),
    );
  }

  TableCalendar _searchproduto() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
    );
  }
}
