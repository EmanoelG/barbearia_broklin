class Event {
  final String title;
  final String horario;
  Event({
    required this.title,
    required this.horario,
  });

  @override
  String toString() => 'Event(title: $title, horario: $horario)';
}
