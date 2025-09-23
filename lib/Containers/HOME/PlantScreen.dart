
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:smartgarden_root/models/plant.dart';
import 'package:smartgarden_root/Containers/HOME/plant_detail.dart';
import 'package:smartgarden_root/services/plant_repository.dart';

class PlantScreen extends StatefulWidget {
  const PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  int _selectedCategory = 0;
  final ImagePicker _picker = ImagePicker();
  final repo = PlantRepository.instance;

  final List<String> _categories = [
    "Todas",
    "Cactos",
    "Frutíferas",
    "Hortaliças",
    "Ornamental",
    "Suculentas",
  ];

  @override
  void initState() {
    super.initState();
    // Se estiver vazio, popula amostras (opcional)
    if (repo.plantsListenable.value.isEmpty) _initSample();
  }

  void _initSample() {
    final _uuid = const Uuid();
    repo.addPlant(Plant(
      id: _uuid.v4(),
      name: 'Phalaenopsis',
      category: 'Ornamental',
      imagePath: 'assets/images/orquidea.png',
      createdAt: DateTime.now(),
    ));
    repo.addPlant(Plant(
      id: _uuid.v4(),
      name: 'Cacto',
      category: 'Cactos',
      imagePath: 'assets/images/cactus.png',
      createdAt: DateTime.now(),
    ));
    repo.addPlant(Plant(
      id: _uuid.v4(),
      name: 'Jiboia',
      category: 'Ornamental',
      imagePath: 'assets/images/jiboia.png',
      createdAt: DateTime.now(),
    ));
  }

  ImageProvider _imageProviderFor(Plant p) {
    final path = p.imagePath;
    if (path == null || path.isEmpty) return const AssetImage('assets/images/orquidea.png');
    if (kIsWeb) {
      if (path.startsWith('http')) return NetworkImage(path);
      return AssetImage(path);
    } else {
      try {
        final f = File(path);
        if (f.existsSync()) return FileImage(f);
      } catch (_) {}
      return AssetImage(path);
    }
  }

  Future<void> _openAddEditDialog({Plant? editing}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEditPlantDialog(
        picker: _picker,
        categories: _categories.where((c) => c != 'Todas').toList(),
        initial: editing,
      ),
    );
    // garantir rebuild após possível alteração no repo
    setState(() {});
  }

  void _removePlant(String id) {
    repo.removePlant(id);
  }

  Future<void> _showPlantMenu(Offset globalPosition, Plant plant) async {
    final value = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(globalPosition.dx, globalPosition.dy, globalPosition.dx, 0),
      items: [
        const PopupMenuItem(value: 0, child: Text('Ver Planta')),
        const PopupMenuItem(value: 1, child: Text('Editar')),
        const PopupMenuItem(value: 2, child: Text('Excluir')),
      ],
    );

    if (value == 0) {
      repo.markViewed(plant.id);
      Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailScreen(plant: plant)));
    } else if (value == 1) {
      _openAddEditDialog(editing: plant);
    } else if (value == 2) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Remover planta?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Remover')),
          ],
        ),
      );
      if (ok == true) _removePlant(plant.id);
    }
  }

  Future<void> _onSearchPressed() async {
    final listSnapshot = repo.plantsListenable.value;
    final found = await showSearch<Plant?>(
      context: context,
      delegate: PlantSearchDelegate(listSnapshot),
    );
    if (found != null) {
      repo.markViewed(found.id);
      Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailScreen(plant: found)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E520E),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            
            Image.asset('assets/images/Logov1.1.png', height: 35),
            const SizedBox(width: 10),
             Text(
              "Minhas Plantas",
              style: GoogleFonts.montserratAlternates(color: Color(0xFFFDB94F), fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(width: 8),
            const Spacer(),
            GestureDetector(
              onTap: _onSearchPressed,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFEFEFE9), shape: BoxShape.circle),
                child: const Icon(BootstrapIcons.search, size: 22, color: Color(0xFF0E520E)),
              ),
            ),
            GestureDetector(
              onTap: () => _openAddEditDialog(),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFEFEFE9), shape: BoxShape.circle),
                child: const Icon(BootstrapIcons.plus, size: 22, color: Color(0xFF0E520E)),
              ),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<Plant>>(
        valueListenable: repo.plantsListenable,
        builder: (context, plants, _) {
          final filtered = _selectedCategory == 0
              ? plants
              : plants.where((p) => p.category == _categories[_selectedCategory]).toList();

          return Column(
            children: [
              // categorias
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_categories.length, (index) {
                      final selected = index == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF0E520E).withOpacity(0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _categories[index],
                            style: TextStyle(
                                color: selected ? const Color(0xFF0E520E) : Colors.grey, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // lista
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final plant = filtered[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundImage: _imageProviderFor(plant),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        title: Text(plant.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Atualizado há ${_timeAgo(plant.createdAt)}', style: const TextStyle(color: Colors.black54)),
                        trailing: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (details) => _showPlantMenu(details.globalPosition, plant),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.more_horiz),
                          ),
                        ),
                        onTap: () {
                          repo.markViewed(plant.id);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailScreen(plant: plant)));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inDays > 0) return '${d.inDays}d';
    if (d.inHours > 0) return '${d.inHours}h';
    if (d.inMinutes > 0) return '${d.inMinutes}m';
    return 'agora';
  }
}

/// SearchDelegate
class PlantSearchDelegate extends SearchDelegate<Plant?> {
  final List<Plant> plants;
  PlantSearchDelegate(this.plants) : super(searchFieldLabel: 'Buscar planta');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [if (query.isNotEmpty) IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final results = plants.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final p = results[i];
        return ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(p.imagePath ?? 'assets/images/orquidea.png')),
          title: Text(p.name),
          subtitle: Text(p.category),
          onTap: () => close(context, p),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ? plants.take(6).toList() : plants.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) {
        final p = suggestions[i];
        return ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(p.imagePath ?? 'assets/images/orquidea.png')),
          title: Text(p.name),
          subtitle: Text(p.category),
          onTap: () => close(context, p),
        );
      },
    );
  }
}

/// Dialog Add / Edit que grava diretamente no repo
class AddEditPlantDialog extends StatefulWidget {
  final ImagePicker picker;
  final List<String> categories;
  final Plant? initial;

  const AddEditPlantDialog({super.key, required this.picker, required this.categories, this.initial});

  @override
  State<AddEditPlantDialog> createState() => _AddEditPlantDialogState();
}

class _AddEditPlantDialogState extends State<AddEditPlantDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String? _category;
  XFile? _picked;
  bool _isPicking = false;
  final repo = PlantRepository.instance;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _nameCtrl.text = widget.initial!.name;
      _category = widget.initial!.category;
    } else {
      _category = widget.categories.isNotEmpty ? widget.categories.first : null;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isPicking = true);
    try {
      final XFile? f = await widget.picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (f != null) setState(() => _picked = f);
    } catch (e) {
      debugPrint('Erro pick image: $e');
    } finally {
      setState(() => _isPicking = false);
    }
  }

  Widget _preview() {
    if (_picked != null) {
      if (kIsWeb) {
        return FutureBuilder<Uint8List>(
          future: _picked!.readAsBytes(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.done && snap.hasData) {
              return Image.memory(snap.data!, width: 56, height: 56, fit: BoxFit.cover);
            } else {
              return Container(width: 56, height: 56, color: Colors.grey.shade200);
            }
          },
        );
      } else {
        return Image.file(File(_picked!.path), width: 56, height: 56, fit: BoxFit.cover);
      }
    }

    if (widget.initial?.imagePath != null) {
      final p = widget.initial!.imagePath!;
      if (kIsWeb) {
        if (p.startsWith('http')) return Image.network(p, width: 56, height: 56, fit: BoxFit.cover);
        return Image.asset(p, width: 56, height: 56, fit: BoxFit.cover);
      } else {
        try {
          final f = File(p);
          if (f.existsSync()) return Image.file(f, width: 56, height: 56, fit: BoxFit.cover);
        } catch (_) {}
        return Image.asset(p, width: 56, height: 56, fit: BoxFit.cover);
      }
    }
    return Container(width: 56, height: 56, color: Colors.grey.shade200);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id = widget.initial?.id ?? const Uuid().v4();
    final imagePath = _picked?.path ?? widget.initial?.imagePath;
    final plant = Plant(id: id, name: _nameCtrl.text.trim(), category: _category ?? 'Ornamental', imagePath: imagePath, createdAt: DateTime.now());

    final exists = repo.getById(id) != null;
    if (exists && widget.initial != null) {
      // substituir a planta editada (simples)
      repo.removePlant(widget.initial!.id);
      repo.addPlant(plant);
    } else {
      repo.addPlant(plant);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(width: 24),
                Text(widget.initial == null ? 'Cadastrar Planta' : 'Editar Planta', style: const TextStyle(fontWeight: FontWeight.w700)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ]),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(hintText: 'Nome da Planta', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14), border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Preencha o nome' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: widget.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v),
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(children: [
                ElevatedButton.icon(
                  onPressed: _isPicking ? null : _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Selecionar Imagem'),
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(width: 12),
                ClipRRect(borderRadius: BorderRadius.circular(8), child: _preview()),
              ]),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFDB94F), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(widget.initial == null ? 'Salvar Planta' : 'Salvar Alterações', style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
