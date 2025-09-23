
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:smartgarden_root/models/plant.dart';
import 'package:smartgarden_root/Containers/HOME/plant_detail.dart';
import 'package:smartgarden_root/services/plant_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = PlantRepository.instance;
  int _catIndex = 0;

  ImageProvider _img(String? path) {
    if (path == null || path.isEmpty) return const AssetImage('assets/images/orquidea.png');
    if (kIsWeb) {
      if (path.startsWith('http')) return NetworkImage(path);
      return AssetImage(path);
    } else {
      try {
        final f = File(path);
        if (f.existsSync()) return FileImage(f);
      } catch (_) {}
      if (path.startsWith('http')) return NetworkImage(path);
      return AssetImage(path);
    }
  }

  void _openDetail(Plant p) {
    repo.markViewed(p.id);
    Navigator.push(context, MaterialPageRoute(builder: (c) => PlantDetailScreen(plant: p)));
  }

  Future<void> _openSearch() async {
    final allPlants = repo.plants;
    final result = await showSearch<Plant?>(context: context, delegate: _PlantSearchDelegate(allPlants));
    if (result != null) _openDetail(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E520E),
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/Logov1.1.png', height: 35),
            const SizedBox(width: 20),
            Text('Visão Geral', style: GoogleFonts.montserratAlternates(color: const Color(0xFFFDB94F), fontWeight: FontWeight.w800)),
            const Spacer(),
            const CircleAvatar(radius: 18, backgroundImage: AssetImage('assets/images/jiboia.png')),
          ],
        ),
      ),

      body: ValueListenableBuilder<List<Plant>>(
        valueListenable: repo.plantsListenable,
        builder: (context, allPlants, _) {
          // usa o método central do repo (ordem consistente)
          final categories = repo.getCategoriesOrdered(includeAll: true);
          final activeIndex = (_catIndex >= 0 && _catIndex < categories.length) ? _catIndex : 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // BUSCA - altura fixa para evitar "empurrar" os chips para cima
              SizedBox(
                height: 56,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    readOnly: true,
                    onTap: _openSearch,
                    style: GoogleFonts.workSans(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      hintStyle: GoogleFonts.workSans(fontSize: 16, color: Colors.grey[600]),
                      border: InputBorder.none,
                      prefixIcon: const Icon(BootstrapIcons.search, color: Colors.grey),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 12),
// CATEGORIAS (derivadas)
SizedBox(
  height: 44, 
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.only(top: 6, bottom: 6),
    child: Row(
      children: List.generate(categories.length, (i) {
        final selected = i == activeIndex;
        return GestureDetector(
          onTap: () => setState(() => _catIndex = i),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF0E520E).withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              categories[i],
              style: GoogleFonts.workSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF0E520E)
                    : const Color(0xFF8A8A8A),
              ),
            ),
          ),
        );
      }),
    ),
  ),
),
const SizedBox(height: 16),

              // FAVORITOS (reactive)
              Text('Favoritos', style: GoogleFonts.montserratAlternates(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ValueListenableBuilder<List<String>>(
                valueListenable: repo.favoritesListenable,
                builder: (context, favIds, _) {
                  final favorites = favIds.map((id) => repo.getById(id)).whereType<Plant>().toList();
                  final filteredFavs = activeIndex == 0 ? favorites : favorites.where((p) => p.category == categories[activeIndex]).toList();

                  return SizedBox(
                    height: 180,
                    child: filteredFavs.isEmpty
                        ? const Center(child: Text('Sem favoritos nesta categoria'))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredFavs.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final p = filteredFavs[i];
                              return GestureDetector(
                                onTap: () => _openDetail(p),
                                child: Container(
                                  width: 160,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: DecorationImage(image: _img(p.imagePath), fit: BoxFit.cover)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(children: [
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [const Color(0xFF2A5A52).withOpacity(0.6), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                          ),
                                        ),
                                      ),
                                      Positioned(bottom: 8, left: 8, child: Text(p.name, style: GoogleFonts.montserratAlternates(color: Colors.white, fontWeight: FontWeight.w700))),
                                      Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () => repo.toggleFavorite(p.id),
                                          child: Container(decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), padding: const EdgeInsets.all(6), child: Icon(repo.isFavorite(p.id) ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 18)),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // VISTO RECENTE (reactive)
              Text('Visto Recente', style: GoogleFonts.montserratAlternates(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ValueListenableBuilder<List<String>>(
                valueListenable: repo.recentsListenable,
                builder: (context, recentsIds, _) {
                  final recents = recentsIds.map((id) => repo.getById(id)).whereType<Plant>().toList();
                  final filteredRecents = activeIndex == 0 ? recents : recents.where((p) => p.category == categories[activeIndex]).toList();

                  return SizedBox(
                    height: 150,
                    child: filteredRecents.isEmpty
                        ? const Center(child: Text('Sem itens recentes nesta categoria'))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredRecents.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final p = filteredRecents[i];
                              return GestureDetector(
                                onTap: () => _openDetail(p),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.62,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
                                  ]),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        right: 8,
                                        bottom: 48,
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF0E520E), width: 2)),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image(image: _img(p.imagePath), fit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned(
                                        left: 8,
                                        right: 8,
                                        bottom: 8,
                                        child: Container(
                                          height: 56,
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(color: const Color(0xFF0E520E), borderRadius: BorderRadius.circular(12)),
                                          child: Row(children: [
                                            Expanded(
                                              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Text(p.name, style: GoogleFonts.montserratAlternates(color: Colors.white, fontWeight: FontWeight.w700)),
                                                Text(p.category, style: GoogleFonts.workSans(color: Colors.white70, fontSize: 12)),
                                              ]),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(color: const Color(0xFF0E520E), borderRadius: BorderRadius.circular(20)),
                                              child: Row(children: const [
                                                Icon(Icons.water_drop, size: 16, color: Colors.white),
                                                SizedBox(width: 6),
                                                Text('60%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                              ]),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ]),
          );
        },
      ),
    );
  }
}

/// SearchDelegate (usa repo snapshot)
class _PlantSearchDelegate extends SearchDelegate<Plant?> {
  final List<Plant> plants;
  _PlantSearchDelegate(this.plants) : super(searchFieldLabel: 'Buscar planta');

  @override
  List<Widget>? buildActions(BuildContext context) => [if (query.isNotEmpty) IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final res = plants.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(itemCount: res.length, itemBuilder: (_, i) => ListTile(leading: CircleAvatar(backgroundImage: AssetImage(res[i].imagePath ?? 'assets/images/orquidea.png')), title: Text(res[i].name), subtitle: Text(res[i].category), onTap: () => close(context, res[i])));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ? plants.take(6).toList() : plants.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(itemCount: suggestions.length, itemBuilder: (_, i) => ListTile(leading: CircleAvatar(backgroundImage: AssetImage(suggestions[i].imagePath ?? 'assets/images/orquidea.png')), title: Text(suggestions[i].name), subtitle: Text(suggestions[i].category), onTap: () => close(context, suggestions[i])));
  }
}
