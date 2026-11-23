import 'package:flutter/material.dart';
import 'widgets.dart';
import 'home_page.dart';
import 'tarefas_page.dart';
import 'cronograma_page.dart';

class MateriasPage extends StatefulWidget {
  const MateriasPage({super.key});

  @override
  State<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  final List<Map<String, dynamic>> materias = [
    {
      'nome': 'Matemática',
      'cor': const Color(0xFFFFFF00),
      'topicos': ['Tópico 1', 'Tópico 2', 'Tópico 3'],
    },
    {
      'nome': 'Português',
      'cor': const Color(0xFFFF3B30),
      'topicos': ['Tópico 1', 'Tópico 2', 'Tópico 3'],
    },
    {
      'nome': 'Biologia',
      'cor': const Color(0xFF00E676),
      'topicos': ['Tópico 1', 'Tópico 2', 'Tópico 3'],
    },
  ];

  // ADICIONAR MATÉRIA
  void _adicionarMateria() {
    final controller = TextEditingController();

    final List<Color> cores = [
      const Color(0xFF00E5EF), // Ciano
      const Color(0xFF00E676), // Verde
      const Color(0xFF7C3CFF), // Roxo
      const Color(0xFFFF453A), // Vermelho
      const Color(0xFFFFD600), // Amarelo
    ];

    Color corSelecionada = cores.first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, atualizarDialog) {
            return Dialog(
              backgroundColor: const Color(0xFF002D2B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: borda, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nova Matéria:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'Dê um nome e adicione uma cor para identificar melhor.',
                      style: TextStyle(
                        color: azul,
                        fontSize: 7,
                      ),
                    ),

                    const SizedBox(height: 17),

                    const Text(
                      'Nome da matéria:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    TextField(
                      controller: controller,
                      autofocus: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ex: português...',
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF001817),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: borda),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: azul),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Cor:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: cores.map((cor) {
                        final selecionada = corSelecionada == cor;

                        return GestureDetector(
                          onTap: () {
                            atualizarDialog(() {
                              corSelecionada = cor;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: cor,
                              shape: BoxShape.circle,
                              border: selecionada
                                  ? Border.all(
                                color: Colors.white,
                                width: 2,
                              )
                                  : null,
                            ),
                            child: selecionada
                                ? const Icon(
                              Icons.check,
                              color: Color(0xFF001817),
                              size: 17,
                            )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: const BorderSide(color: borda),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),

                        const SizedBox(width: 6),

                        TextButton(
                          onPressed: () {
                            final nome = controller.text.trim();

                            if (nome.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Digite o nome da matéria.',
                                  ),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              materias.add({
                                'nome': nome,
                                'cor': corSelecionada,
                                'topicos': <String>[],
                              });
                            });

                            Navigator.pop(dialogContext);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF001817),
                            backgroundColor: azul,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Concluir',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ADICIONAR TÓPICO
  void _adicionarTopico(int indiceMateria) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: fundoCard,
          title: const Text(
            'Adicionar tópico',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nome do tópico',
              hintStyle: const TextStyle(color: Colors.white54),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: borda),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: azul),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                final nome = controller.text.trim();

                if (nome.isNotEmpty) {
                  setState(() {
                    materias[indiceMateria]['topicos'].add(nome);
                  });

                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                'Adicionar',
                style: TextStyle(color: azul),
              ),
            ),
          ],
        );
      },
    );
  }

  // EXCLUIR MATÉRIA
  void _excluirMateria(int indice) {
    setState(() {
      materias.removeAt(indice);
    });
  }

  // EXCLUIR TÓPICO
  void _excluirTopico(int indiceMateria, int indiceTopico) {
    setState(() {
      materias[indiceMateria]['topicos'].removeAt(indiceTopico);
    });
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

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: azul,
                    ),
                  ),
                ],
              ),
            ),

            // TÍTULO E BOTÃO NOVA
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minhas matérias:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Divida em tópicos e marque o que já foi concluído',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  SizedBox(
                    width: 82,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: _adicionarMateria,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azul,
                        foregroundColor: const Color(0xFF001817),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Nova',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // LISTA DE MATÉRIAS
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: materias.length,
                itemBuilder: (context, index) {
                  final materia = materias[index];
                  final List<String> topicos =
                  List<String>.from(materia['topicos']);
                  final Color cor = materia['cor'] as Color;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.fromLTRB(11, 10, 11, 8),
                    decoration: BoxDecoration(
                      color: fundoCard,
                      border: Border.all(
                        color: cor,
                        width: 1.4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOME DA MATÉRIA E BOTÃO DE EXCLUIR
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${materia['nome']}:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () => _excluirMateria(index),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFF00A5A5),
                                size: 20,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          '${topicos.length} tópicos.',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 8,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // TÓPICOS DA MATÉRIA
                        ...List.generate(topicos.length, (topicoIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.radio_button_unchecked,
                                  color: azul,
                                  size: 12,
                                ),

                                const SizedBox(width: 6),

                                Expanded(
                                  child: Text(
                                    topicos[topicoIndex],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () => _excluirTopico(
                                    index,
                                    topicoIndex,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white38,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 3),

                        // ADICIONAR TÓPICO
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _adicionarTopico(index),
                                child: Container(
                                  height: 25,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: borda,
                                      width: 0.8,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Add um tópico',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 6),

                            SizedBox(
                              width: 28,
                              height: 25,
                              child: OutlinedButton(
                                onPressed: () => _adicionarTopico(index),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: const BorderSide(color: borda),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // MENU INFERIOR IGUAL AO DAS OUTRAS TELAS
      bottomNavigationBar: BottomMenu(
        selectedIndex: 3,
        onTap: (index) {
          if (index == 0) {
            // HOME
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          } else if (index == 1) {
            // TAREFAS
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const TarefasPage(),
              ),
            );
          } else if (index == 2) {
            // CRONOGRAMA
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CronogramaPage(),
              ),
            );
          }
          // Índice 3: já está na tela de Matérias.
        },
        onAdd: _adicionarMateria,
      ),
    );
  }
}