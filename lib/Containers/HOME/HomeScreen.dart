import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _catIndex = 0; 

  final List<String> _categories = [
    "Todas",
    "Cactos",
    "Frutíferas",
    "Hortaliças",
    "Ornamentais",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFF014D1A),
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/Logov1.2.png',
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              "Visão Geral",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/jiboia.png'),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de busca
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Buscar",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                _categories.length,
                (i) {
                  final selected = _catIndex == i;
                  return ChoiceChip(
                    label: Text(_categories[i]),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _catIndex = i);
                    },
                    selectedColor: const Color(0xFF014D1A), // verde sólido
                    backgroundColor: const Color(0xFFEFEFE9),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF3A544F),
                      fontWeight: FontWeight.w600,
                    ),
                    showCheckmark: false,
                    shape: const StadiumBorder(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Favoritos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFavoriteCard("assets/images/orquidea.png", "Orquídea"),
                  _buildFavoriteCard("assets/images/samambaia.png", "Samambaia"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Visto Recente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRecentCard(
                    "assets/images/jiboia.png",
                    "Jiboia",
                    "Ornamental",
                    0.6,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildRecentCard(
                    "assets/images/cactus.png",
                    "Coroa de frade",
                    "Cacto",
                    0.25,
                    Colors.brown,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

     
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF014D1A),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.house, size: 26),
            label: 'Início',
          ),
          const BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.flower1, size: 26),
            label: 'Plantas',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Scan.png',
              width: 28,
              height: 28,
              color: Colors.white,
            ),
            label: 'Scan',
          ),
          const BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.bell, size: 26),
            label: 'Notificações',
          ),
          const BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.person_circle, size: 26),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }


  Widget _buildFavoriteCard(String image, String title) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentCard(String image, String title, String subtitle, double progress, Color color) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("${(progress * 100).toInt()}%"),
            ),
          ),
        ],
      ),
    );
  }
}
