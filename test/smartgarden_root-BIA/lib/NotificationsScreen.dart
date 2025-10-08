// lib/NotificationsScreen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/models/notification_item.dart';

enum FilterOption { all, unread, last7Days, last30Days }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // CORES - conforme solicitado
  static const Color colorAccent = Color(0xFFFDB94F); 
  static const Color colorSoftGreen = Color(0xFFD9E6D9); 
  static const Color colorDarkGreen = Color(0xFF0E520E); 

  final List<NotificationItem> _items = [];
  final Random _random = Random();
  FilterOption _filter = FilterOption.all;

  @override
  void initState() {
    super.initState();
    _seedMockData();
  }

  void _seedMockData() {
    final now = DateTime.now();
    final seeds = [
      NotificationItem(
        id: '1',
        title: 'Phalaenopsis',
        body: 'A umidade do solo está baixa. Regue em breve.',
        createdAt: now.subtract(const Duration(minutes: 1)),
        read: false,
        avatarUrl: null,
      ),
      NotificationItem(
        id: '2',
        title: 'Cacto',
        body: 'Sua aula de Fotografia Digital foi confirmada para amanhã às 14h',
        createdAt: now.subtract(const Duration(minutes: 5)),
        read: false,
        avatarUrl: null,
      ),
      NotificationItem(
        id: '3',
        title: 'Rosa',
        body: 'Recebeu muita luz solar direta. Mova para um local mais sombreado.',
        createdAt: now.subtract(const Duration(hours: 1)),
        read: true,
        avatarUrl: null,
      ),
      NotificationItem(
        id: '4',
        title: 'Gucca',
        body: 'A temperatura subiu para um nível muito alto.',
        createdAt: now.subtract(const Duration(hours: 6)),
        read: false,
        avatarUrl: null,
      ),
      NotificationItem(
        id: '5',
        title: 'Jiboia',
        body: 'A temperatura subiu para um nível muito alto.',
        createdAt: now.subtract(const Duration(days: 1, minutes: 5)),
        read: true,
        avatarUrl: null,
      ),
    ];

    setState(() {
      _items.addAll(seeds);
      _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  List<NotificationItem> get _filteredItems {
    final now = DateTime.now();
    switch (_filter) {
      case FilterOption.unread:
        return _items.where((i) => !i.read).toList();
      case FilterOption.last7Days:
        return _items.where((i) => now.difference(i.createdAt).inDays < 7).toList();
      case FilterOption.last30Days:
        return _items.where((i) => now.difference(i.createdAt).inDays < 30).toList();
      case FilterOption.all:
      default:
        return _items;
    }
  }

  void _markAllRead() {
    setState(() {
      for (var i in _items) i.read = true;
    });
  }

  void _simulateIncomingNotification() {
    final now = DateTime.now();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final titles = ['Monstera', 'Jiboia', 'Cacto', 'Rosa', 'Phalaenopsis'];
    final bodies = [
      'A umidade do solo está baixa. Regue em breve.',
      'Recebeu muita luz direta. Mova para um local mais sombreado.',
      'A temperatura subiu para um nível muito alto.',
    ];
    final item = NotificationItem(
      id: id,
      title: titles[_random.nextInt(titles.length)],
      body: bodies[_random.nextInt(bodies.length)],
      createdAt: now,
      read: false,
    );
    setState(() => _items.insert(0, item));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notificação simulada: ${item.title}')));
  }

  String _timeAgo(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 10) return 'agora mesmo';
    if (diff.inMinutes < 1) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return m == 1 ? '1 minuto atrás' : '$m minutos atrás';
    }
    if (diff.inHours < 24) {
      final h = diff.inHours;
      return h == 1 ? '1 hora atrás' : '$h horas atrás';
    }
    final d = diff.inDays;
    return d == 1 ? '1 dia atrás' : '$d dias atrás';
  }

  void _openDetail(NotificationItem it) {
    setState(() => it.read = true);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(it.title),
        content: Text('${it.body}\n\nRecebido: ${it.createdAt}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))],
      ),
    );
  }

  /// ✅ Correção: agora retorna PreferredSizeWidget
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
    backgroundColor: colorDarkGreen,
    elevation: 0,
    toolbarHeight: 80,
    automaticallyImplyLeading: false,
    title: Text(
      'Notificações',
      style: GoogleFonts.montserratAlternates(
        color: colorAccent,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
      centerTitle: false,
      actions: [
        TextButton.icon(
          onPressed: _markAllRead,
          icon: const Icon(Icons.done_all, color: Colors.white, size: 18),
          label: const Text('Ler todas', style: TextStyle(color: Colors.white)),
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, FilterOption option) {
    final selected = _filter == option;
    return InkWell(
      onTap: () => setState(() => _filter = option),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colorSoftGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? colorAccent.withOpacity(0.0) : Colors.grey.shade200),
          boxShadow: selected ? [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)] : null,
        ),
        child: Text(label, style: TextStyle(color: selected ? colorDarkGreen : Colors.grey.shade800)),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openDetail(item),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 92,
                decoration: BoxDecoration(
                  color: colorDarkGreen,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colorSoftGreen,
                      backgroundImage: item.avatarUrl != null ? NetworkImage(item.avatarUrl!) : null,
                      child: item.avatarUrl == null ? Text(_avatarInitials(item.title), style: const TextStyle(fontWeight: FontWeight.bold)) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.title, style: TextStyle(fontWeight: FontWeight.w700, color: item.read ? Colors.black87 : Colors.black)),
                      const SizedBox(height: 6),
                      Text(item.body, style: TextStyle(color: Colors.grey.shade700), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ])),
                    const SizedBox(width: 8),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(_timeAgo(item.createdAt), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      const SizedBox(height: 18),
                      item.read ? const SizedBox(width: 10, height: 10) : Container(width: 10, height: 10, decoration: BoxDecoration(color: colorDarkGreen, shape: BoxShape.circle)),
                    ]),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _avatarInitials(String title) {
    final parts = title.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _items.where((i) => !i.read).length;
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip('Todas', FilterOption.all),
                const SizedBox(width: 8),
                _buildFilterChip('Não Lidas', FilterOption.unread),
                const SizedBox(width: 8),
                _buildFilterChip('Últimos 7 dias', FilterOption.last7Days),
                const SizedBox(width: 8),
                _buildFilterChip('Últimos 30 dias', FilterOption.last30Days),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // lista
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 400));
                setState(() => _items.sort((a, b) => b.createdAt.compareTo(a.createdAt)));
              },
              child: items.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 80), Center(child: Text('Nenhuma notificação nesse filtro'))],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 6, bottom: 24),
                      itemCount: items.length,
                      itemBuilder: (context, index) => _buildNotificationCard(items[index]),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simulateIncomingNotification,
        icon: const Icon(Icons.add_alert, color: colorDarkGreen),
        label: const Text('Simular', style: TextStyle(color: colorDarkGreen)),
        backgroundColor: colorSoftGreen,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
