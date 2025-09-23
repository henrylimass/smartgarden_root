import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// --- Modelo de Dados para o Resultado ---
class PlantData {
  final String name;
  final String family;
  final String description;
  final Map<String, String> idealConditions;
  final Map<String, String> problems;

  PlantData({
    required this.name,
    required this.family,
    required this.description,
    required this.idealConditions,
    required this.problems,
  });
}

// --- Simulação de um Serviço de API ---
class PlantApiService {
  Future<PlantData> identifyPlant(String imagePath) async {
    // Simula um tempo de espera de rede
    await Future.delayed(const Duration(seconds: 3));

    // Em um app real, aqui você faria uma chamada HTTP POST com a imagem
    // para uma API de identificação de plantas (ex: Plant.id, Pl@ntNet)
    // e processaria o JSON retornado.

    // Para este exemplo, retornamos dados fixos da orquídea do mockup.
    return PlantData(
      name: "Phalaenopsis",
      family: "Orquídeas",
      description:
          "A Phalaenopsis, comumente conhecida como orquídea borboleta, é um gênero de plantas tropicais e epífitas da família Orchidaceae...",
      idealConditions: {
        "Água": "diária",
        "Luz": "Moderada",
        "Temperatura": "25°C",
        "Umidade do Ar": "50%+",
      },
      problems: {
        "Folhas amareladas": "Falta de nutrientes",
        "Excesso de Água": "Risco de fungos",
        "Pouca Luz": "Crescimento fraco",
      },
    );
  }
}

// --- A Tela Principal de Scan ---
class ScanScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ScanScreen({super.key, required this.cameras});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final PlantApiService _apiService = PlantApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializa a câmera traseira
    _cameraController = CameraController(widget.cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _processImage(String imagePath) async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final plantData = await _apiService.identifyPlant(imagePath);
      _showResultSheet(plantData);
    } catch (e) {
      // Tratar erro de API aqui
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao identificar a planta: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      _processImage(image.path);
    } catch (e) {
      // Tratar erro de câmera aqui
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _processImage(pickedFile.path);
    }
  }
  
  void _showResultSheet(PlantData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => PlantResultSheet(
          scrollController: controller,
          plantData: data,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Câmera Preview
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          
          // Overlay UI
          _buildOverlayUI(),

          // Indicador de Carregamento
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CircularProgressIndicator(color: Colors.white),
                     SizedBox(height: 16),
                     Text("Identificando planta...", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                )
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayUI() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.flash_on, color: Colors.white),
                 Text("Identifique a planta", style: GoogleFonts.montserratAlternates(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
                  onPressed: _pickFromGallery,
                ),
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 4),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
                  onPressed: () {
                    // Lógica para trocar de câmera
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// --- Widget para o Bottom Sheet de Resultados ---
class PlantResultSheet extends StatelessWidget {
  final ScrollController scrollController;
  final PlantData plantData;

  const PlantResultSheet({super.key, required this.scrollController, required this.plantData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(20.0),
        children: [
          // Indicador de "puxar"
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Header do Resultado
          const ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white),
            ),
            title: Text("Planta identificada com sucesso!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          Text(plantData.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(plantData.family, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 16),
          
          // Descrição
          Text("Descrição", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(plantData.description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),

          // Condições Ideais
          Text("Condições Ideais", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConditionChip(Icons.water_drop_outlined, "Água", plantData.idealConditions["Água"]!),
              _buildConditionChip(Icons.wb_sunny_outlined, "Luz", plantData.idealConditions["Luz"]!),
              _buildConditionChip(Icons.thermostat_outlined, "Temperatura", plantData.idealConditions["Temperatura"]!),
              _buildConditionChip(Icons.air, "Umidade do Ar", plantData.idealConditions["Umidade do Ar"]!),
            ],
          ),
          const SizedBox(height: 24),
          
          // Diagnóstico
          Text("Diagnóstico de Problemas", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...plantData.problems.entries.map((entry) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(entry.key),
            subtitle: Text(entry.value),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildConditionChip(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}