import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barbearia_adriano/source/model/agenda.dart';

class ItemTitle extends StatefulWidget {
  Agenda event;
  ItemTitle({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<ItemTitle> createState() => _ItemTitleState();
}

class _ItemTitleState extends State<ItemTitle> {
  @override
  Widget build(BuildContext context) {
    return Card(
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
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
                text: widget.event.outro,
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
                text: widget.event.Nome,
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
