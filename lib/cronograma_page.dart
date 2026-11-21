import 'package:flutter/material.dart';
import 'widgets.dart';
import 'dados.dart';
import 'nova_atividade_page.dart';
import 'tarefas_page.dart';

const List<String> diasDaSemana = [
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
  'Domingo',
];

// FICA FORA DA TELA PARA NÃO PERDER OS DADOS AO SAIR E VOLTAR
final Map<String, List<Map<String, String>>> cronogramaGlobal = {
  'Segunda': [
    {
      'horario': '19:00 - 20:00',
      'titulo': 'Exercício de sla',
      'materia': 'Matemática',
      'duracao': '1hr de duração',
    },
    {
      'horario': '19:00 - 20:00',
      'titulo': 'Estudar para sla',
      'materia': 'Português',
      'duracao': '1hr de duração',
    },
  ],
  'Terça': [
    {
      'horario': '19:00 - 20:00',
      'titulo': 'Exercício de sla',
      'materia': 'Matemática',
      'duracao': '1hr de duração',
    },
    {
      'horario': '19:00 - 20:00',
      'titulo': 'Estudar para sla',
      'materia': 'Português',
      'duracao': '1hr de duração',
    },
  ],
  'Quarta': [],
  'Quinta': [],
  'Sexta': [],
  'Sábado': [],
  'Domingo': [],
};

class CronogramaPage extends StatefulWidget {
  const CronogramaPage({super.key});

  @override
  State<CronogramaPage> createState() => _CronogramaPageState();
}

class _CronogramaPageState extends State<CronogramaPage> {
  // BOTÃO "+" CENTRAL: NOVA ATIVIDADE
  Future<void> _adicionarAtividade() async {
    final nova = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const NovaAtividadePage()),
    );

    if (nova != null) {
      atividadesGlobais.insert(0, nova);
    }
  }

  // BOTÃO "+" DE CADA DIA: NOVA SESSÃO DE ESTUDO
  Future<void> _adicionarSessao(String dia) async {
    final nova = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _NovaSessaoDialog(diaInicial: dia),
    );

    if (nova != null) {
      setState(() {
        final lista = cronogramaGlobal[nova['dia']!]!;
        lista.add(nova);
        lista.sort((a, b) => a['horario']!.compareTo(b['horario']!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001817),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: borda, width: 0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: azul,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF001817),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Study',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Connect',
                          style: TextStyle(
                            color: azul,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications, color: azul),
                ],
              ),
            ),

            // DIAS DA SEMANA
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final dia in diasDaSemana) _cardDia(dia),
                ],
              ),
            ),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: BottomMenu(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TarefasPage()),
            );
          }
        },
        onAdd: _adicionarAtividade,
      ),
    );
  }

  // CARD DE UM DIA
  Widget _cardDia(String dia) {
    final sessoes = cronogramaGlobal[dia]!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF022A29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0A5755)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  '$dia:',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _adicionarSessao(dia),
                child: Container(
                  width: 48,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00717A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borda),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (sessoes.isEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                'Nenhuma sessão planejada.',
                style: TextStyle(color: Color(0xFF9EADAC), fontSize: 11),
              ),
            ),

          for (final s in sessoes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _cardSessao(dia, s),
            ),
        ],
      ),
    );
  }

  // CARD DE UMA SESSÃO DE ESTUDO
  Widget _cardSessao(String dia, Map<String, String> s) {
    final subtitulo = [s['materia'] ?? '', s['duracao'] ?? '']
        .where((t) => t.isNotEmpty)
        .join(' ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF001413),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borda),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['horario']!,
                  style: const TextStyle(
                    color: Color(0xFF9EADAC),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s['titulo']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitulo.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitulo,
                    style: const TextStyle(
                      color: Color(0xFF9EADAC),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => cronogramaGlobal[dia]!.remove(s)),
            child: const Icon(
              Icons.delete_outline,
              color: Color(0xFF00A5A5),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// JANELA PARA CADASTRAR UMA SESSÃO DE ESTUDO
class _NovaSessaoDialog extends StatefulWidget {
  final String diaInicial;

  const _NovaSessaoDialog({required this.diaInicial});

  @override
  State<_NovaSessaoDialog> createState() => _NovaSessaoDialogState();
}

class _NovaSessaoDialogState extends State<_NovaSessaoDialog> {
  final _tituloController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _assuntosController = TextEditingController();

  // MATÉRIAS DISPONÍVEIS NA LISTA (pode acrescentar as suas)
  static const List<String> materias = [
    'Matemática',
    'Português',
    'Redação',
    'Biologia',
    'Física',
    'Química',
    'História',
    'Geografia',
    'Inglês',
    'Outra',
  ];

  String? materia;
  late String dia;
  TimeOfDay? inicio;
  String? erro;

  @override
  void initState() {
    super.initState();
    dia = widget.diaInicial;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _duracaoController.dispose();
    _assuntosController.dispose();
    super.dispose();
  }

  String _dois(int n) => n.toString().padLeft(2, '0');

  String _fmt(TimeOfDay t) => '${_dois(t.hour)}:${_dois(t.minute)}';

  String _duracaoTexto(int minutos) {
    final h = minutos ~/ 60;
    final m = minutos % 60;
    if (h == 0) return '${m}min de duração';
    if (m == 0) return '${h}hr de duração';
    return '${h}h${_dois(m)}min de duração';
  }

  Future<void> _escolherInicio() async {
    final h = await showTimePicker(
      context: context,
      initialTime: inicio ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: azul),
        ),
        child: child!,
      ),
    );
    if (h != null) setState(() => inicio = h);
  }

  void _concluir() {
    final titulo = _tituloController.text.trim();
    final duracao = int.tryParse(_duracaoController.text.trim());

    if (titulo.isEmpty) {
      setState(() => erro = 'Digite um título.');
      return;
    }
    if (inicio == null) {
      setState(() => erro = 'Escolha o horário de início.');
      return;
    }
    if (duracao == null || duracao <= 0) {
      setState(() => erro = 'Digite a duração em minutos.');
      return;
    }

    // HORÁRIO FINAL = INÍCIO + DURAÇÃO
    final inicioMin = inicio!.hour * 60 + inicio!.minute;
    final fimMin = (inicioMin + duracao) % (24 * 60);
    final fim = '${_dois(fimMin ~/ 60)}:${_dois(fimMin % 60)}';

    Navigator.pop(context, {
      'dia': dia,
      'horario': '${_fmt(inicio!)} - $fim',
      'titulo': titulo,
      'materia': materia ?? '',
      'duracao': _duracaoTexto(duracao),
      'assuntos': _assuntosController.text.trim(),
    });
  }

  Widget _rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // CAIXA ARREDONDADA PARA LISTAS E HORÁRIO
  Widget _caixa({required Widget child, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xFF001413),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borda),
        ),
        child: child,
      ),
    );
  }

  InputDecoration _decoracao(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9EADAC), fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF001413),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borda),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: azul),
      ),
    );
  }

  Widget _lista({
    required String? valor,
    required String dica,
    required List<String> itens,
    required ValueChanged<String?> onChanged,
  }) {
    return _caixa(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: valor,
          isExpanded: true,
          dropdownColor: fundoCard,
          hint: Text(
            dica,
            style: const TextStyle(color: Color(0xFF9EADAC), fontSize: 12),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: azul),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          items: itens
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const estiloTexto = TextStyle(color: Colors.white, fontSize: 12);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF022A29),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF0A5755)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nova sessão de estudos:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'faça seu cronograma de estudos!',
                style: TextStyle(color: azul, fontSize: 10),
              ),

              const SizedBox(height: 18),

              // TÍTULO
              _rotulo('Título:'),
              TextField(
                controller: _tituloController,
                style: estiloTexto,
                cursorColor: azul,
                decoration: _decoracao('EX: Prova de...'),
              ),

              const SizedBox(height: 14),

              // MATÉRIA + DIA DA SEMANA
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _rotulo('Matéria:'),
                        _lista(
                          valor: materia,
                          dica: 'Nome da matéria',
                          itens: materias,
                          onChanged: (v) => setState(() => materia = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _rotulo('Dia da semana:'),
                        _lista(
                          valor: dia,
                          dica: 'Escolha o dia',
                          itens: diasDaSemana,
                          onChanged: (v) {
                            if (v != null) setState(() => dia = v);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // INÍCIO + DURAÇÃO
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _rotulo('Início:'),
                        _caixa(
                          onTap: _escolherInicio,
                          child: Text(
                            inicio == null ? '00:00' : _fmt(inicio!),
                            style: TextStyle(
                              color: inicio == null
                                  ? const Color(0xFF9EADAC)
                                  : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _rotulo('Duração:'),
                        SizedBox(
                          height: 44,
                          child: TextField(
                            controller: _duracaoController,
                            keyboardType: TextInputType.number,
                            style: estiloTexto,
                            cursorColor: azul,
                            decoration: _decoracao('00 minutos'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ASSUNTOS
              _rotulo('Assuntos:'),
              TextField(
                controller: _assuntosController,
                style: estiloTexto,
                cursorColor: azul,
                maxLines: 4,
                decoration: _decoracao('Descreva...'),
              ),

              if (erro != null) ...[
                const SizedBox(height: 10),
                Text(
                  erro!,
                  style: const TextStyle(
                    color: Color(0xFFFF8A8A),
                    fontSize: 12,
                  ),
                ),
              ],

              const SizedBox(height: 18),

              // BOTÕES
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: borda),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Color(0xFF9EADAC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _concluir,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00717A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Concluir',
                      style: TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}