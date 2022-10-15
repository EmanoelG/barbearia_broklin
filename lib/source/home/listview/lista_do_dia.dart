import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../components/item_title.dart';
import '../../model/agenda.dart';
import '../../service/agenda_bloc.dart';
import '../../service/agenda_service.dart';

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
  AgendaBloc _agendaBloc = AgendaBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _agendaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.selectedEvents.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (_) async {
            var idToDelete;

            idToDelete = widget.selectedEvents[index].id;
            widget.selectedEvents.removeAt(index);
            await AgendaServices.deleteById(idToDelete);
            setState(
              () {
                _agendaBloc.fetch();
              },
            );
          },
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ItemTitle(
            event: widget.selectedEvents[index],
          ),
        );
      },
    );
  }
}
