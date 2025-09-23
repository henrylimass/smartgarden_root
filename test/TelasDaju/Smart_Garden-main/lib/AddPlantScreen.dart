// lib/screens/add_plant_screen.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/plant.dart';
import '../services/plant_repository.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory;
  String? _imagePath; // pode ser null
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  final repo = PlantRepository.instance;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) {
        setState(() {
          _imagePath = file.path;
        });
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao selecionar imagem')),
      );
    }
  }

  void _savePlant() {
    if (!_formKey.currentState!.validate()) return;

    final categories = repo.plantsListenable.value
        .map((p) => p.category)
        .toSet()
        .toList();
    final categoryToUse =
        _selectedCategory ?? (categories.isNotEmpty ? categories.first : 'Outros');

    final newPlant = Plant(
      id: _uuid.v4(),
      name: _nameController.text.trim(),
      category: categoryToUse,
      imagePath: _imagePath, // pode ser null -> telas tratam fallback
    );

    repo.addPlant(newPlant);
    Navigator.pop(context, newPlant);
  }

  /// Função auxiliar para tratar imagens
  ImageProvider _getImageProvider() {
    if (_imagePath == null) {
      return const AssetImage('assets/images/placeholder.png');
    }
    if (kIsWeb) {
      return NetworkImage(_imagePath!);
    }
    return FileImage(File(_imagePath!));
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Outros',
      ...repo.plantsListenable.value.map((p) => p.category).toSet().toList()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Planta"),
        backgroundColor: const Color(0xFF014D1A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _getImageProvider(),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nome da Planta",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? "Digite o nome da planta"
                        : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text("Selecione a categoria"),
                items: categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePlant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF014D1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Salvar",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
