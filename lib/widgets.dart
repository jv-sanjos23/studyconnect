import 'package:flutter/material.dart';

const Color azul = Color(0xFF00E5EF);
const Color fundoCard = Color(0xFF001D1C);
const Color borda = Color(0xFF008B89);


class InfoCard extends StatelessWidget {
  final String titulo;
  final String numero;
  final String descricao;

  const InfoCard({
    super.key,
    required this.titulo,
    required this.numero,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fundoCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            numero,
            style: const TextStyle(
              color: azul,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            descricao,
            style: const TextStyle(
              color: Color(0xFF9EADAC),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// MENU INFERIOR
class BottomMenu extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final VoidCallback onAdd;

  const BottomMenu({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.onAdd,
  });

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final icones = [
      Icons.home_filled,
      Icons.checklist,
      Icons.calendar_month,
      Icons.school_outlined,
    ];

    return Container(
      height: 57,
      decoration: const BoxDecoration(
        color: Color(0xFF001211),
        border: Border(
          top: BorderSide(color: borda, width: 0.6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < 2; i++)
            _itemMenu(icones[i], i),

          // BOTÃO DE ADICIONAR COM ANIMAÇÃO
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                _hover = true;
              });
            },
            onExit: (_) {
              setState(() {
                _hover = false;
              });
            },
            child: GestureDetector(
              onTap: widget.onAdd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                  0,
                  _hover ? -35 : -27,
                  0,
                ),
                width: _hover ? 56 : 48,
                height: _hover ? 56 : 48,
                decoration: const BoxDecoration(
                  color: azul,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF001817),
                  size: 32,
                ),
              ),
            ),
          ),

          for (int i = 2; i < 4; i++)
            _itemMenu(icones[i], i),
        ],
      ),
    );
  }

  Widget _itemMenu(IconData icone, int index) {
    return IconButton(
      onPressed: () => widget.onTap(index),
      icon: Icon(
        icone,
        size: 24,
        color: widget.selectedIndex == index
            ? azul
            : const Color(0xFF008D8D),
      ),
    );
  }
}