import 'package:flutter/material.dart';

// LISTA COMPARTILHADA ENTRE A HOME E A TELA DE TAREFAS
final List<Map<String, dynamic>> atividadesGlobais = [
  _nova(['Tarefa', 'Redação'], 'Redação sobre combate ao racismo.', _dia(0, 23, 0)),
  _nova(['Trabalho', 'Biologia', 'Prioridade'], 'Projeto de biologia.', _dia(0, 23, 50)),
  _nova(['Prova', 'Português'], 'Prova de português.', _dia(1, 13, 0)),
  _nova(['Prova', 'Redação'], 'Prova de redação', _dia(1, 15, 0)),
];

// DATA: hoje + [dias], com hora e minuto
DateTime _dia(int dias, int hora, int minuto) {
  final d = DateTime.now().add(Duration(days: dias));
  return DateTime(d.year, d.month, d.day, hora, minuto);
}

Map<String, dynamic> _nova(
    List<String> etiquetas,
    String titulo,
    DateTime? data, {
      bool temHora = true,
    }) {
  return {
    'etiquetas': etiquetas,
    'titulo': titulo,
    'horario': formatarHorario(data, temHora),
    'descricao': '',
    'data': data,
    'temHora': temHora,
    'concluida': false,
  };
}

bool mesmoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// "Hoje às 23:00", "Amanhã às 13:00" ou "25/11 às 14:30"
String formatarHorario(DateTime? data, bool temHora) {
  if (data == null) return '';

  final agora = DateTime.now();
  final amanha = agora.add(const Duration(days: 1));

  String dia;
  if (mesmoDia(data, agora)) {
    dia = 'Hoje';
  } else if (mesmoDia(data, amanha)) {
    dia = 'Amanhã';
  } else {
    dia = '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}';
  }

  if (!temHora) return dia;

  final h = data.hour.toString().padLeft(2, '0');
  final m = data.minute.toString().padLeft(2, '0');
  return '$dia às $h:$m';
}

// EM QUAL GRUPO A ATIVIDADE APARECE
const ordemGrupos = [
  'Atrasadas',
  'Anteriores',
  'Hoje',
  'Amanhã',
  'Próximos dias',
  'Sem data',
];

String grupoDaAtividade(Map<String, dynamic> a) {
  final data = a['data'] as DateTime?;
  if (data == null) return 'Sem data';

  final agora = DateTime.now();
  final hoje = DateTime.utc(agora.year, agora.month, agora.day);
  final dia = DateTime.utc(data.year, data.month, data.day);
  final diff = dia.difference(hoje).inDays;

  if (diff < 0) return a['concluida'] == true ? 'Anteriores' : 'Atrasadas';
  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Amanhã';
  return 'Próximos dias';
}

// COR DAS ETIQUETAS
Color corDaEtiqueta(String tag) {
  return switch (tag) {
    'Tarefa' || 'Biologia' => const Color(0xFF226C51),
    'Redação' || 'Trabalho' || 'Português' => const Color(0xFF344B8A),
    'Prioridade' || 'Prova' => const Color(0xFF713D55),
    _ => Colors.teal,
  };
}