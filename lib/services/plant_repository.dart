// lib/services/plant_repository.dart
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/plant.dart';

class PlantRepository {
  PlantRepository._internal() {
    _initSample();
  }

  // singleton
  static final PlantRepository instance = PlantRepository._internal();

  final Uuid _uuid = const Uuid();

  // internal storage
  final List<Plant> _plants = [];
  final ValueNotifier<List<Plant>> _plantsNotifier = ValueNotifier<List<Plant>>([]);
  ValueListenable<List<Plant>> get plantsListenable => _plantsNotifier;

  // favorites stored as list of ids (most recent first)
  final List<String> _favorites = [];
  final ValueNotifier<List<String>> _favoritesNotifier = ValueNotifier<List<String>>([]);
  ValueListenable<List<String>> get favoritesListenable => _favoritesNotifier;

  // recents stored as list of ids (most recent first)
  final List<String> _recents = [];
  final ValueNotifier<List<String>> _recentsNotifier = ValueNotifier<List<String>>([]);
  ValueListenable<List<String>> get recentsListenable => _recentsNotifier;


  void _initSample() {
    addPlant(Plant(
      id: _uuid.v4(),
      name: 'Orquídea',
      category: 'Ornamental',
      imagePath: 'assets/images/orquidea.png',
    ));
    addPlant(Plant(
      id: _uuid.v4(),
      name: 'Samambaia',
      category: 'Ornamental',
      imagePath: 'assets/images/samambaia.png',
    ));
    addPlant(Plant(
      id: _uuid.v4(),
      name: 'Jiboia',
      category: 'Ornamental',
      imagePath: 'assets/images/jiboia.png',
    ));
    addPlant(Plant(
      id: _uuid.v4(),
      name: 'Coroa de frade',
      category: 'Cactos',
      imagePath: 'assets/images/cactus.png',
    ));
  }

  // read-only view
  UnmodifiableListView<Plant> get plants => UnmodifiableListView(_plants);

  // safe getter by id
  Plant? getById(String id) {
    try {
      return _plants.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // add
  void addPlant(Plant p) {
    // insert at beginning for most-recent-first
    _plants.insert(0, p);
    _plantsNotifier.value = List.unmodifiable(_plants);
  }

  // update (replace existing by id)
  void updatePlant(Plant p) {
    final i = _plants.indexWhere((x) => x.id == p.id);
    if (i >= 0) {
      _plants[i] = p;
      _plantsNotifier.value = List.unmodifiable(_plants);
    }
  }

  // remove
  void removePlant(String id) {
    _plants.removeWhere((p) => p.id == id);
    _plantsNotifier.value = List.unmodifiable(_plants);

    // also remove from favorites and recents
    _favorites.removeWhere((fid) => fid == id);
    _favoritesNotifier.value = List.unmodifiable(_favorites);

    _recents.removeWhere((rid) => rid == id);
    _recentsNotifier.value = List.unmodifiable(_recents);
  }

  // favorites: toggle
  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.insert(0, id);
    }
    _favoritesNotifier.value = List.unmodifiable(_favorites);
  }

  bool isFavorite(String id) => _favorites.contains(id);

  // mark viewed (recents)
  void markViewed(String id) {
    _recents.remove(id);
    _recents.insert(0, id);
    if (_recents.length > 50) _recents.removeRange(50, _recents.length);
    _recentsNotifier.value = List.unmodifiable(_recents);
  }


  List<String> getCategoriesOrdered({bool includeAll = true}) {

    const base = <String>['Cactos', 'Frutíferas', 'Hortaliças', 'Ornamental', 'Suculentas'];


    final detected = _plants.map((p) => p.category).where((c) => c != null && c.isNotEmpty).toSet().toList();


    final extras = detected.where((c) => !base.contains(c)).toList();

    final result = <String>[];
    if (includeAll) result.add('Todas');


    result.addAll(base);


    result.addAll(extras);

    return result;
  }
}
