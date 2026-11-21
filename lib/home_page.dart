import 'package:flutter/material.dart';
import 'widgets.dart';
import 'nova_atividade_page.dart';
import 'dados.dart';
import 'tarefas_page.dart';
import 'cronograma_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaSelecionada = 0;

  // LISTA DE ATIVIDADES (compartilhada com a tela de tarefas)
  List<Map<String, dynamic>> get atividades => atividadesGlobais;

  // LISTA DE EXERCÍCIOS
  List<Map<String, String>> exercicios = [
    {
      'titulo': 'Exercício 1',
      'horario': 'Das 19:00 até as 20:00',
    },
    {
      'titulo': 'Exercício 2',
      'horario': 'Das 19:00 até as 20:00',
    },
  ];

  // DATA ATUAL
  String dataAtual() {
    DateTime agora = DateTime.now();

    List<String> dias = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];

    List<String> meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    return '${dias[agora.weekday - 1]}, '
        '${agora.day} de ${meses[agora.month - 1]}.';
  }

  // HORÁRIO ATUAL
  String horarioAtual() {
    DateTime agora = DateTime.now();

    String hora = agora.hour.toString().padLeft(2, '0');
    String minuto = agora.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
  }

  // BOTÃO ADICIONAR
  Future<void> adicionar() async {
    final nova = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const NovaAtividadePage()),
    );

    if (nova != null) {
      setState(() {
        atividades.insert(0, nova);
      });
    }
  }

  // ABRE OUTRA TELA E ATUALIZA A HOME AO VOLTAR
  Future<void> _abrirTela(Widget tela) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => tela),
    );
    setState(() {});
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
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
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
                  const Icon(
                    Icons.menu_book_rounded,
                    color: azul,
                    size: 23,
                  ),

                  const SizedBox(width: 8),

                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Study',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Connect',
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.notifications,
                    color: azul,
                  ),
                ],
              ),
            ),

            // CONTEÚDO PRINCIPAL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BOAS-VINDAS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: azul,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataAtual(),
                            style: const TextStyle(
                              color: Color(0xFF003C3B),
                              fontSize: 10,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            'Bons estudos hoje!',
                            style: TextStyle(
                              color: Color(0xFF001817),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Agora são ${horarioAtual()}.',
                            style: const TextStyle(
                              color: Color(0xFF003C3B),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // CARDS DE INFORMAÇÕES
                    const InfoCard(
                      titulo: 'Pendentes:',
                      numero: '5',
                      descricao: 'Tarefas, provas e trabalhos.',
                    ),

                    const SizedBox(height: 9),

                    const InfoCard(
                      titulo: 'Provas:',
                      numero: '2',
                      descricao: 'Nos próximos 13 dias.',
                    ),

                    const SizedBox(height: 9),

                    const InfoCard(
                      titulo: 'Estudos semanais:',
                      numero: '9h45',
                      descricao: '5 sessões planejadas.',
                    ),

                    const SizedBox(height: 14),

                    // PRÓXIMAS ATIVIDADES
                    Row(
                      children: [
                        const Text(
                          'Próximas Atividades:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        GestureDetector(
                          onTap: () => _abrirTela(const TarefasPage()),
                          child: const Text(
                            'Ver todas →',
                            style: TextStyle(
                              color: azul,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // LISTA DE ATIVIDADES EXCLUÍVEIS
                    ...List.generate(atividades.length, (index) {
                      final atividade = atividades[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _atividadeCard(
                          etiquetas: List<String>.from(
                            atividade['etiquetas'],
                          ),
                          titulo: atividade['titulo'],
                          horario: atividade['horario'],
                          onExcluir: () {
                            setState(() {
                              atividades.removeAt(index);
                            });
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 6),

                    // ESTUDOS DE HOJE
                    Row(
                      children: [
                        const Text(
                          'Estudos de hoje:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        GestureDetector(
                          onTap: () => _abrirTela(const CronogramaPage()),
                          child: const Text(
                            'Cronograma →',
                            style: TextStyle(
                              color: azul,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // LISTA DE EXERCÍCIOS EXCLUÍVEIS
                    ...List.generate(exercicios.length, (index) {
                      final exercicio = exercicios[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _atividadeCard(
                          titulo: exercicio['titulo']!,
                          horario: exercicio['horario']!,
                          onExcluir: () {
                            setState(() {
                              exercicios.removeAt(index);
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: BottomMenu(
        selectedIndex: paginaSelecionada,
        onTap: (index) {
          if (index == 1) {
            _abrirTela(const TarefasPage());
          } else if (index == 2) {
            _abrirTela(const CronogramaPage());
          } else {
            setState(() {
              paginaSelecionada = index;
            });
          }
        },
        onAdd: adicionar,
      ),
    );
  }

  // CARD REUTILIZÁVEL DE ATIVIDADES E EXERCÍCIOS
  Widget _atividadeCard({
    List<String> etiquetas = const [],
    required String titulo,
    required String horario,
    required VoidCallback onExcluir,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: fundoCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borda),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (etiquetas.isNotEmpty) ...[
                  Wrap(
                    spacing: 5,
                    children: etiquetas.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: corDaEtiqueta(tag),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 4),
                ],

                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (horario.isNotEmpty) ...[
                  const SizedBox(height: 3),

                  Text(
                    horario,
                    style: const TextStyle(
                      color: Color(0xFF9EADAC),
                      fontSize: 9,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 5),

          const Icon(
            Icons.edit_outlined,
            color: azul,
            size: 17,
          ),

          const SizedBox(width: 5),

          // BOTÃO DE EXCLUIR
          IconButton(
            onPressed: onExcluir,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFF00A5A5),
              size: 17,
            ),
          ),
        ],
      ),
    );
  }
}