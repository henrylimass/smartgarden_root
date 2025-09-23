// lib/screens/scan_result.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/plant.dart';
import 'plant_detail.dart';

class ScanResultScreen extends StatelessWidget {
  final String imagePath;
  const ScanResultScreen({super.key, required this.imagePath});

  ImageProvider _img() {
    if (kIsWeb) return NetworkImage(imagePath);
    return File(imagePath).existsSync() ? FileImage(File(imagePath)) : const AssetImage('assets/images/orquidea.png') as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    // MOCK: resultado "identificado"
    final Plant mockPlant = Plant(id: 'mock-1', name: 'Phalaenopsis', category: 'Ornamentais', imagePath: imagePath, createdAt: DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF2F1EB),
      appBar: AppBar(backgroundColor: const Color(0xFF0E520E), title: Text('Resultado', style: GoogleFonts.montserratAlternates())),
      body: SafeArea(
        child: Column(
          children: [
            // preview
            Container(
              margin: const EdgeInsets.all(16),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: DecorationImage(image: _img(), fit: BoxFit.cover)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Planta identificada com sucesso!', style: GoogleFonts.montserratAlternates(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 8),
                Text('Phalaenopsis', style: GoogleFonts.montserratAlternates(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Ornamental', style: GoogleFonts.workSans(color: Colors.black54)),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFDB94F), foregroundColor: Colors.black),
                  onPressed: () {
                    // abre detalhe com o plant mock (você poderá enviar o resultado real quando tiver backend)
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PlantDetailScreen(plant: mockPlant)));
                  },
                  child: Text('Abrir detalhes', style: GoogleFonts.workSans(fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
