import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:camera/camera.dart';

// Importe suas telas
import 'ScanScreen.dart';
import 'NotificationsScreen.dart';
import 'HomeScreen.dart';
import 'PlantScreen.dart';
import 'ProfileScreen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  late List<CameraDescription> _cameras;
  bool _camerasInitialized = false;

  final List<Widget> _pages = const [
    HomeScreen(),
    PlantScreen(),
    SizedBox.shrink(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      setState(() {
        _camerasInitialized = true;
      });
    } catch (e) {
      print("Erro ao inicializar câmeras: $e");
    }
  }

  void _onTap(int index) {
    if (index == 2 && _camerasInitialized) {
      _openScanScreen();
      return;
    }
    if (index != 2) {
      setState(() => _selectedIndex = index);
    }
  }

  void _openScanScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ScanScreen(cameras: _cameras)),
    );
  }

  Widget _navIcon(
      {required IconData icon,
      required IconData activeIcon,
      required int index}) {
    final bool isSelected = _selectedIndex == index;
    const Color selectedColor = Color(0xFFEFEBE0);

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 26,
              color: isSelected ? selectedColor : Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: isSelected ? 40 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            )
          ],
        ),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0E520E),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navIcon(
                  icon: BootstrapIcons.house,
                  activeIcon: BootstrapIcons.house_fill,
                  index: 0,
                ),
                _navIcon(
                  icon: BootstrapIcons.flower1,
                  activeIcon: BootstrapIcons.flower1,
                  index: 1,
                ),
                _navIcon(
                  icon: BootstrapIcons.hr,
                  activeIcon: BootstrapIcons.hr,
                  index: 2,
                ),
                _navIcon(
                  icon: BootstrapIcons.bell,
                  activeIcon: BootstrapIcons.bell_fill,
                  index: 3,
                ),
                _navIcon(
                  icon: BootstrapIcons.person,
                  activeIcon: BootstrapIcons.person_fill,
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}