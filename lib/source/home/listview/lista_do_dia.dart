import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../components/item_title.dart';
import '../../model/agenda.dart';

class ListaDoDia extends StatefulWidget {
  List<Agenda> selectedEvents = [];
  ListaDoDia({
    Key? key,
    required this.selectedEvents,
  }) : super(key: key);

  @override
  State<ListaDoDia> createState() => _ListaDoDiaState();
}

class _ListaDoDiaState extends State<ListaDoDia> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.selectedEvents.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          child: ItemTitle(
            event: widget.selectedEvents[index],
          ),
        );
      },
    );
  }
}
