
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../models/plant.dart';
import '../services/plant_repository.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;
  const PlantDetailScreen({super.key, required this.plant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  final repo = PlantRepository.instance;

  @override
  void initState() {
    super.initState();
    // marca como visto assim que abrir a tela
    repo.markViewed(widget.plant.id);
  }

  ImageProvider _imageProvider(String? path) {
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

  void _toggleFavorite(String plantId) {
    repo.toggleFavorite(plantId);
    final fav = repo.isFavorite(plantId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(fav ? 'Adicionado aos favoritos' : 'Removido dos favoritos'),
      duration: const Duration(milliseconds: 1200),
    ));
  }

  Future<void> _openEditDialog(Plant current, List<String> categories) async {
    final ImagePicker picker = ImagePicker();
    final edited = await showDialog<Plant>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final _nameCtrl = TextEditingController(text: current.name);
        String _category = current.category;
        XFile? _picked;
        bool _isPicking = false;

        Future<void> _pickImage() async {
          try {
            _isPicking = true;
            final XFile? f = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
            if (f != null) {
              _picked = f;
            }
          } catch (e) {
            debugPrint('Erro ao selecionar imagem: $e');
          } finally {
            _isPicking = false;
          }
        }

        Widget _preview() {
          if (_picked != null) {
            if (kIsWeb) {
              return FutureBuilder<Uint8List>(
                future: _picked!.readAsBytes(),
                builder: (c, snap) {
                  if (snap.connectionState == ConnectionState.done && snap.hasData) return Image.memory(snap.data!, width: 80, height: 80, fit: BoxFit.cover);
                  return Container(width: 80, height: 80, color: Colors.grey.shade200);
                },
              );
            } else {
              return Image.file(File(_picked!.path), width: 80, height: 80, fit: BoxFit.cover);
            }
          }

          if (current.imagePath != null && current.imagePath!.isNotEmpty) {
            final p = current.imagePath!;
            if (kIsWeb) {
              if (p.startsWith('http')) return Image.network(p, width: 80, height: 80, fit: BoxFit.cover);
              return Image.asset(p, width: 80, height: 80, fit: BoxFit.cover);
            } else {
              try {
                final f = File(p);
                if (f.existsSync()) return Image.file(f, width: 80, height: 80, fit: BoxFit.cover);
              } catch (_) {}
              return Image.asset(p, width: 80, height: 80, fit: BoxFit.cover);
            }
          }

          return Container(width: 80, height: 80, color: Colors.grey.shade200);
        }

        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const SizedBox(width: 24),
                    Text('Editar Planta', style: const TextStyle(fontWeight: FontWeight.w700)),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ]),
                  const SizedBox(height: 8),
                  TextFormField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'Nome da planta'), validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha o nome' : null),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _category = v ?? _category),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    ElevatedButton.icon(onPressed: _isPicking ? null : () async { await _pickImage(); setState(() {}); }, icon: const Icon(Icons.image), label: const Text('Selecionar imagem')),
                    const SizedBox(width: 12),
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: _preview()),
                  ]),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final updated = Plant(
                            id: current.id,
                            name: _nameCtrl.text.trim().isEmpty ? current.name : _nameCtrl.text.trim(),
                            category: _category,
                            imagePath: _picked?.path ?? current.imagePath,
                          );
                          Navigator.pop(ctx, updated);
                        },
                        child: const Text('Salvar'),
                      ),
                    ),
                  ])
                ]),
              ),
            ),
          );
        });
      },
    );

    if (edited != null) {
      repo.updatePlant(edited);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Planta atualizada')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Plant>>(
      valueListenable: repo.plantsListenable,
      builder: (context, allPlants, _) {
        final plant = allPlants.firstWhere((p) => p.id == widget.plant.id, orElse: () => widget.plant);
        final categories = allPlants.map((p) => p.category).toSet().toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF2F1EB),
          body: SafeArea(
            child: Column(
              children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                    child: Image(image: _imageProvider(plant.imagePath), width: double.infinity, height: 320, fit: BoxFit.cover),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(padding: EdgeInsets.zero, icon: const Icon(Icons.arrow_back), color: Colors.black87, onPressed: () => Navigator.pop(context)),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black26,
                      child: PopupMenuButton<int>(
                        icon: const Icon(Icons.more_horiz, color: Colors.white),
                        color: Colors.white,
                        onSelected: (v) async {
                          if (v == 1) {
                            await _openEditDialog(plant, categories);
                          } else if (v == 2) {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                title: const Text('Excluir?'),
                                content: const Text('Deseja excluir esta planta?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
                                  TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Excluir')),
                                ],
                              ),
                            );
                            if (ok == true) {
                              repo.removePlant(plant.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Planta excluída')));
                            }
                          }
                        },
                        itemBuilder: (_) => const [PopupMenuItem(value: 1, child: Text('Editar')), PopupMenuItem(value: 2, child: Text('Excluir'))],
                      ),
                    ),
                  ),
                ]),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Row(children: [
                          Expanded(child: Text(plant.name, style: GoogleFonts.montserratAlternates(fontSize: 22, fontWeight: FontWeight.w800))),
                          ValueListenableBuilder<List<String>>(
                            valueListenable: repo.favoritesListenable,
                            builder: (context, favIds, _) {
                              final isFav = favIds.contains(plant.id);
                              return GestureDetector(
                                onTap: () => _toggleFavorite(plant.id),
                                child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red)),
                              );
                            },
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text(plant.category, style: GoogleFonts.workSans(color: Colors.black54, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Text('Esta planta prefere ambientes iluminados, mas sem exposição direta ao sol. Mantê-la levemente úmida e evitar encharcamento.', style: GoogleFonts.workSans(height: 1.4)),
                        const SizedBox(height: 18),
                        Text('Sensores', style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        Row(children: [
                          _sensorTile(Icons.water_drop, 'Umidade', '60%'),
                          const SizedBox(width: 8),
                          _sensorTile(Icons.wb_sunny, 'Luz', '30%'),
                          const SizedBox(width: 8),
                          _sensorTile(Icons.thermostat_outlined, 'Temp', '22°C'),
                          const SizedBox(width: 8),
                          _sensorTile(Icons.air, 'Ar', '45%'),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sensorTile(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [Icon(icon, size: 20, color: const Color(0xFF0E520E)), const SizedBox(height: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54))]),
      ),
    );
  }
}
