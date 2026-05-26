// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/enem/enem_screen.dart';
import 'screens/sisu/sisu_screen.dart';
import 'screens/ssa/ssa_screen.dart';
import 'screens/pas/pas_screen.dart';
import 'screens/fuvest/fuvest_screen.dart';
import 'screens/unicamp/unicamp_screen.dart';
import 'screens/unesp/unesp_screen.dart';
import 'screens/saved/saved_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  final appState = AppState();
  await appState.init();
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const VestHubApp(),
    ),
  );
}

class VestHubApp extends StatelessWidget {
  const VestHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VestHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    EnemScreen(),
    _SimulatorsTab(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'ENEM',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Simuladores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Salvos',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Aba Início ───────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

// ─── Aba Simuladores ──────────────────────────────────────────────────────────
class _SimulatorsTab extends StatelessWidget {
  const _SimulatorsTab();

  static final List<_SimItem> _simulators = [
    _SimItem(title: 'SISU', subtitle: 'Universidades Federais — pesos do ENEM', icon: Icons.school_outlined, color: AppTheme.accentGreen, screen: const SisuScreen()),
    _SimItem(title: 'SSA · UPE', subtitle: 'Seleção Seriada da Universidade de Pernambuco', icon: Icons.trending_up_outlined, color: Color(0xFFFF6B6B), screen: const SsaScreen()),
    _SimItem(title: 'PAS · UnB', subtitle: 'Programa de Avaliação Seriada da UnB', icon: Icons.timeline_outlined, color: Color(0xFF8E54E9), screen: const PasScreen()),
    _SimItem(title: 'FUVEST · USP', subtitle: 'Fundação Universitária para o Vestibular', icon: Icons.star_outline, color: Color(0xFF1D976C), screen: const FuvestScreen()),
    _SimItem(title: 'UNICAMP · COMVEST', subtitle: 'Vestibular da Universidade Estadual de Campinas', icon: Icons.bar_chart_outlined, color: Color(0xFFf7971e), screen: const UnicampScreen()),
    _SimItem(title: 'UNESP · VUNESP', subtitle: 'Vestibular da Universidade Estadual Paulista', icon: Icons.emoji_events_outlined, color: Color(0xFF0b8793), screen: const UnespScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simuladores')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _simulators.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => _SimulatorTile(item: _simulators[i]),
      ),
    );
  }
}

class _SimItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;
  const _SimItem({required this.title, required this.subtitle, required this.icon, required this.color, required this.screen});
}

class _SimulatorTile extends StatelessWidget {
  final _SimItem item;
  const _SimulatorTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(item.subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
