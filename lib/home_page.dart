import 'package:flutter/material.dart';
import 'widgets.dart';
import 'nova_atividade_page.dart';
import 'dados.dart';
import 'tarefas_page.dart';
import 'materias_page.dart';
import 'cronograma_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaSelecionada = 0;

  // LISTA DE ATIVIDADES COMPARTILHADA COM A TELA DE TAREFAS
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

  // QUANTIDADE DE ATIVIDADES PENDENTES
  int get quantidadePendentes {
    return atividades.where((atividade) {
      return atividade['concluida'] != true;
    }).length;
  }

  // QUANTIDADE DE PROVAS PARA HOJE E OS PRÓXIMOS 13 DIAS
  int get quantidadeProvas {
    final hoje = DateTime.now();
    final inicio = DateTime(hoje.year, hoje.month, hoje.day);
    final limite = inicio.add(const Duration(days: 13));

    return atividades.where((atividade) {
      final etiquetas =
      List<String>.from(atividade['etiquetas'] ?? []);
      final data = atividade['data'] as DateTime?;

      return etiquetas.contains('Prova') &&
          atividade['concluida'] != true &&
          data != null &&
          !data.isBefore(inicio) &&
          data.isBefore(limite.add(const Duration(days: 1)));
    }).length;
  }

  // QUANTIDADE DE ESTUDOS CADASTRADOS NA LISTA DE EXERCÍCIOS
  int get quantidadeEstudos {
    return exercicios.length;
  }

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
      MaterialPageRoute(
        builder: (_) => const NovaAtividadePage(),
      ),
    );

    if (!mounted) return;

    if (nova != null) {
      setState(() {
        atividades.insert(0, nova);
      });
    }
  }

  // EDITAR ATIVIDADE
  Future<void> _editarAtividade(int index) async {
    final atividade = atividades[index];

    final alterada = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => NovaAtividadePage(
          atividadeInicial: Map<String, dynamic>.from(atividade),
        ),
      ),
    );

    if (!mounted) return;

    if (alterada != null) {
      setState(() {
        atividades[index] = alterada;
      });
    }
  }

  // EDITAR EXERCÍCIO
  Future<void> _editarExercicio(int index) async {
    final exercicio = exercicios[index];

    final tituloController = TextEditingController(
      text: exercicio['titulo'] ?? '',
    );

    final horarioController = TextEditingController(
      text: exercicio['horario'] ?? '',
    );

    final resultado = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: fundoCard,
          title: const Text(
            'Editar exercício',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                style: const TextStyle(color: Colors.white),
                cursorColor: azul,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: azul),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: horarioController,
                style: const TextStyle(color: Colors.white),
                cursorColor: azul,
                decoration: const InputDecoration(
                  labelText: 'Horário',
                  labelStyle: TextStyle(color: azul),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, {
                  'titulo': tituloController.text.trim(),
                  'horario': horarioController.text.trim(),
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: azul,
                foregroundColor: const Color(0xFF001817),
              ),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    tituloController.dispose();
    horarioController.dispose();

    if (!mounted) return;

    if (resultado != null && resultado['titulo']!.isNotEmpty) {
      setState(() {
        exercicios[index] = resultado;
      });
    }
  }

  // ABRE OUTRA TELA E ATUALIZA A HOME AO VOLTAR
  Future<void> _abrirTela(Widget tela) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => tela),
    );

    if (!mounted) return;

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

                    // CARD DE ATIVIDADES PENDENTES
                    InfoCard(
                      titulo: 'Pendentes:',
                      numero: '$quantidadePendentes',
                      descricao: 'Tarefas, provas e trabalhos.',
                    ),

                    const SizedBox(height: 9),

                    // CARD DE PROVAS
                    InfoCard(
                      titulo: 'Provas:',
                      numero: '$quantidadeProvas',
                      descricao: 'Hoje e nos próximos 13 dias.',
                    ),

                    const SizedBox(height: 9),

                    // CARD DE ESTUDOS SEMANAIS
                    InfoCard(
                      titulo: 'Estudos semanais:',
                      numero: '$quantidadeEstudos',
                      descricao: 'Sessões cadastradas.',
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
                          onTap: () =>
                              _abrirTela(const TarefasPage()),
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

                    // LISTA DE ATIVIDADES
                    ...List.generate(atividades.length, (index) {
                      final atividade = atividades[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _atividadeCard(
                          etiquetas: List<String>.from(
                            atividade['etiquetas'] ?? [],
                          ),
                          titulo: atividade['titulo'] ?? '',
                          horario: atividade['horario'] ?? '',
                          onEditar: () => _editarAtividade(index),
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
                          onTap: () =>
                              _abrirTela(const CronogramaPage()),
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

                    // LISTA DE EXERCÍCIOS
                    ...List.generate(exercicios.length, (index) {
                      final exercicio = exercicios[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _atividadeCard(
                          titulo: exercicio['titulo']!,
                          horario: exercicio['horario']!,
                          onEditar: () => _editarExercicio(index),
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
          debugPrint('Ícone pressionado: $index');

          if (index == 1) {
            // ÍCONE DE TAREFAS
            _abrirTela(const TarefasPage());
          } else if (index == 2) {
            // ÍCONE DE CALENDÁRIO
            _abrirTela(const CronogramaPage());
          } else if (index == 3) {
            // ÍCONE DE MATÉRIAS
            _abrirTela(const MateriasPage());
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
    required VoidCallback onEditar,
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

          // BOTÃO DE EDITAR
          IconButton(
            onPressed: onEditar,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.edit_outlined,
              color: azul,
              size: 17,
            ),
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