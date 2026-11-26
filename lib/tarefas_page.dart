import 'package:flutter/material.dart';
import 'widgets.dart';
import 'home_page.dart';
import 'dados.dart';
import 'nova_atividade_page.dart';
import 'cronograma_page.dart';
import 'materias_page.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final _buscaController = TextEditingController();

  String filtro = 'Pendentes';
  String busca = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _adicionar() async {
    final nova = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const NovaAtividadePage(),
      ),
    );

    if (nova != null) {
      setState(() {
        atividadesGlobais.insert(0, nova);
      });
    }
  }

  void _abrirCronograma() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CronogramaPage(),
      ),
    );
  }
  List<Map<String, dynamic>> _filtradas() {
    final lista = atividadesGlobais.where((a) {
      final concluida = a['concluida'] == true;

      if (filtro == 'Pendentes' && concluida) return false;
      if (filtro == 'Concluídas' && !concluida) return false;

      if (busca.isNotEmpty) {
        final texto =
        '${a['titulo']} ${(a['etiquetas'] as List).join(' ')}'
            .toLowerCase();

        if (!texto.contains(busca.toLowerCase())) return false;
      }

      return true;
    }).toList();

    lista.sort((a, b) {
      final da = a['data'] as DateTime?;
      final db = b['data'] as DateTime?;

      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;

      return da.compareTo(db);
    });

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final lista = _filtradas();

    final grupos = <String, List<Map<String, dynamic>>>{};

    for (final a in lista) {
      grupos.putIfAbsent(grupoDaAtividade(a), () => []).add(a);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF001817),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borda, width: 0.5),
                ),
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

                  const Icon(
                    Icons.notifications,
                    color: azul,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tarefas e avaliações:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Organizadas por data e horário.',
                                style: TextStyle(
                                  color: Color(0xFF9EADAC),
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: _adicionar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A8B5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Nova',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _buscaController,
                            onChanged: (v) {
                              setState(() {
                                busca = v.trim();
                              });
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            cursorColor: azul,
                            decoration: InputDecoration(
                              hintText: 'Buscar...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9EADAC),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 13,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: borda),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: azul),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borda),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: filtro,
                                isExpanded: true,
                                dropdownColor: fundoCard,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: azul,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF9EADAC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                items: ['Pendentes', 'Concluídas', 'Todas']
                                    .map(
                                      (opcao) => DropdownMenuItem(
                                    value: opcao,
                                    child: Text(opcao),
                                  ),
                                )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() {
                                      filtro = v;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    if (lista.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text(
                            'Nenhuma atividade encontrada.',
                            style: TextStyle(
                              color: Color(0xFF9EADAC),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                    for (final grupo in ordemGrupos)
                      if (grupos.containsKey(grupo)) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            top: 4,
                          ),
                          child: Text(
                            '$grupo:',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        for (final a in grupos[grupo]!)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _card(a),
                          ),

                        const SizedBox(height: 8),
                      ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomMenu(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            // HOME
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
                  (route) => false,
            );
          } else if (index == 2) {
            _abrirCronograma();
          } else if (index == 3) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MateriasPage(),
              ),
            );
          }

        },
        onAdd: _adicionar,
      ),
    );
  }

  Widget _card(Map<String, dynamic> a) {
    final concluida = a['concluida'] == true;
    final etiquetas = List<String>.from(a['etiquetas']);

    final horario = formatarHorario(
      a['data'] as DateTime?,
      a['temHora'] == true,
    );

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
                // ETIQUETAS + EDITAR + EXCLUIR
                Row(
                  children: [
                    Flexible(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: etiquetas.map(_etiqueta).toList(),
                      ),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edição em breve.'),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        color: azul,
                        size: 17,
                      ),
                    ),

                    const SizedBox(width: 6),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          atividadesGlobais.remove(a);
                        });
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFF00A5A5),
                        size: 17,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  a['titulo'],
                  style: TextStyle(
                    color: concluida
                        ? const Color(0xFF9EADAC)
                        : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration:
                    concluida ? TextDecoration.lineThrough : null,
                    decorationColor: const Color(0xFF9EADAC),
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

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () {
              setState(() {
                a['concluida'] = !concluida;
              });
            },
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: concluida ? azul : Colors.transparent,
                border: Border.all(
                  color: azul,
                  width: 1.5,
                ),
              ),
              child: concluida
                  ? const Icon(
                Icons.check,
                size: 16,
                color: Color(0xFF001817),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _etiqueta(String tag) {
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
  }
}