import 'package:flutter/material.dart';
import 'widgets.dart';
import 'dados.dart';
import 'cronograma_page.dart';

class NovaAtividadePage extends StatefulWidget {
  final Map<String, dynamic>? atividadeInicial;

  const NovaAtividadePage({
    super.key,
    this.atividadeInicial,
  });

  @override
  State<NovaAtividadePage> createState() => _NovaAtividadePageState();
}

class _NovaAtividadePageState extends State<NovaAtividadePage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _materiaController = TextEditingController();
  final _descricaoController = TextEditingController();

  String tipo = 'Tarefa';
  bool prioridade = false;
  DateTime? data;
  TimeOfDay? hora;

  @override
  void initState() {
    super.initState();

    final atividade = widget.atividadeInicial;

    if (atividade != null) {
      _tituloController.text = atividade['titulo'] ?? '';
      _descricaoController.text = atividade['descricao'] ?? '';

      final etiquetas = List<String>.from(
        atividade['etiquetas'] ?? [],
      );

      const tipos = ['Tarefa', 'Prova', 'Trabalho'];

      tipo = tipos.firstWhere(
            (t) => etiquetas.contains(t),
        orElse: () => 'Tarefa',
      );

      prioridade = etiquetas.contains('Prioridade');

      final materias = etiquetas.where(
            (tag) => !tipos.contains(tag) && tag != 'Prioridade',
      );

      _materiaController.text =
      materias.isNotEmpty ? materias.first : '';

      final dataSalva = atividade['data'] as DateTime?;

      if (dataSalva != null) {
        data = DateTime(
          dataSalva.year,
          dataSalva.month,
          dataSalva.day,
        );

        if (atividade['temHora'] == true) {
          hora = TimeOfDay(
            hour: dataSalva.hour,
            minute: dataSalva.minute,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _materiaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }


  Future<void> _escolherData() async {
    final agora = DateTime.now();

    final escolhida = await showDatePicker(
      context: context,
      initialDate: data ?? agora,
      firstDate: DateTime(2000),
      lastDate: agora.add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: azul,
          ),
        ),
        child: child!,
      ),
    );

    if (escolhida != null) {
      setState(() => data = escolhida);
    }
  }

  // SELETOR DE HORÁRIO
  Future<void> _escolherHora() async {
    final escolhida = await showTimePicker(
      context: context,
      initialTime: hora ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: azul,
          ),
        ),
        child: child!,
      ),
    );

    if (escolhida != null) {
      setState(() => hora = escolhida);
    }
  }

  // JUNTA DATA E HORA EM UM ÚNICO DATETIME
  DateTime? _dataCompleta() {
    final base = data ?? (hora != null ? DateTime.now() : null);

    if (base == null) return null;

    return DateTime(
      base.year,
      base.month,
      base.day,
      hora?.hour ?? 0,
      hora?.minute ?? 0,
    );
  }

  // SALVAR ATIVIDADE OU ALTERAÇÕES
  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final materia = _materiaController.text.trim();
    final dataCompleta = _dataCompleta();

    Navigator.pop(context, {
      'etiquetas': [
        tipo,
        if (materia.isNotEmpty) materia,
        if (prioridade) 'Prioridade',
      ],
      'titulo': _tituloController.text.trim(),
      'horario': formatarHorario(dataCompleta, hora != null),
      'descricao': _descricaoController.text.trim(),
      'data': dataCompleta,
      'temHora': hora != null,
      'concluida': widget.atividadeInicial?['concluida'] ?? false,
    });
  }

  InputDecoration _decoracao(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        color: Color(0xFF9EADAC),
        fontSize: 12,
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF5F6E6D),
        fontSize: 12,
      ),
      filled: true,
      fillColor: fundoCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borda),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borda),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: azul),
      ),
    );
  }

  Widget _rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // BOTÃO DE DATA / HORA
  Widget _campoSeletor({
    required IconData icone,
    required String texto,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: fundoCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borda),
        ),
        child: Row(
          children: [
            Icon(
              icone,
              color: azul,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              texto,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const estiloTexto = TextStyle(
      color: Colors.white,
      fontSize: 13,
    );

    final editando = widget.atividadeInicial != null;

    return Scaffold(
      backgroundColor: const Color(0xFF001817),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: borda,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: azul,
                    ),
                  ),
                  Text(
                    editando ? 'Editar Atividade' : 'Nova Atividade',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // FORMULÁRIO
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TIPO
                      _rotulo('Tipo'),
                      Wrap(
                        spacing: 8,
                        children: ['Tarefa', 'Prova', 'Trabalho'].map((t) {
                          final selecionado = tipo == t;

                          return ChoiceChip(
                            label: Text(t),
                            selected: selecionado,
                            onSelected: (_) {
                              setState(() => tipo = t);
                            },
                            selectedColor: azul,
                            backgroundColor: fundoCard,
                            side: const BorderSide(color: borda),
                            labelStyle: TextStyle(
                              color: selecionado
                                  ? const Color(0xFF001817)
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            showCheckmark: false,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // TÍTULO
                      TextFormField(
                        controller: _tituloController,
                        style: estiloTexto,
                        cursorColor: azul,
                        decoration: _decoracao(
                          'Título',
                          hint: 'Ex.: Prova de português',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Digite um título';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // MATÉRIA
                      TextFormField(
                        controller: _materiaController,
                        style: estiloTexto,
                        cursorColor: azul,
                        decoration: _decoracao(
                          'Matéria',
                          hint: 'Ex.: Biologia',
                        ),
                      ),

                      const SizedBox(height: 12),

                      // PRIORIDADE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: fundoCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borda),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flag_outlined,
                              color: azul,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Marcar como prioridade',
                                style: estiloTexto,
                              ),
                            ),
                            Switch(
                              value: prioridade,
                              activeColor: azul,
                              onChanged: (v) {
                                setState(() => prioridade = v);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // DATA E HORÁRIO
                      _rotulo('Data e horário'),
                      Row(
                        children: [
                          Expanded(
                            child: _campoSeletor(
                              icone: Icons.calendar_today_outlined,
                              texto: data == null
                                  ? 'Data'
                                  : '${data!.day.toString().padLeft(2, '0')}/'
                                  '${data!.month.toString().padLeft(2, '0')}/'
                                  '${data!.year}',
                              onTap: _escolherData,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _campoSeletor(
                              icone: Icons.access_time,
                              texto: hora == null
                                  ? 'Horário'
                                  : '${hora!.hour.toString().padLeft(2, '0')}:'
                                  '${hora!.minute.toString().padLeft(2, '0')}',
                              onTap: _escolherHora,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // DESCRIÇÃO
                      TextFormField(
                        controller: _descricaoController,
                        style: estiloTexto,
                        cursorColor: azul,
                        maxLines: 4,
                        decoration: _decoracao(
                          'Descrição (opcional)',
                          hint: 'Detalhes da atividade...',
                        ),
                      ),

                      const SizedBox(height: 24),

                      // BOTÃO SALVAR
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: _salvar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azul,
                            foregroundColor: const Color(0xFF001817),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            editando
                                ? 'Salvar alterações'
                                : 'Salvar atividade',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),



    );
  }
}