// lib/main.dart — VestHub v0.0.3

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/widgets.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/calculator/calculator_screen.dart';
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
  runApp(ChangeNotifierProvider.value(value: appState, child: const VestHubApp()));
}

class VestHubApp extends StatelessWidget {
  const VestHubApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VestHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const _RootRouter(),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, state, __) {
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: AppTheme.bgTop,
            body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
          );
        }
        if (!state.onboardingCompleto) {
          return OnboardingScreen(
            onComplete: (nome, ano) => state.completarOnboarding(nome, ano),
          );
        }
        return const MainNavigation();
      },
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
    HomeScreen(),
    CalculatorScreen(),
    _SimulatorsTab(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgTop,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _GlassNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ─── Barra de navegação em vidro ──────────────────────────────────────────────
class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _GlassNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Inicio'),
    (Icons.list_alt_outlined, Icons.list_alt, 'Calculadora'),
    (Icons.school_outlined, Icons.school, 'Simuladores'),
    (Icons.bookmark_outline, Icons.bookmark, 'Salvos'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassWhite,
        border: const Border(top: BorderSide(color: AppTheme.glassBorder, width: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final active = currentIndex == i;
              final item = _items[i];
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(active ? item.$2 : item.$1,
                          color: active ? AppTheme.textPrimary : AppTheme.textMuted, size: 22),
                      const SizedBox(height: 2),
                      if (active)
                        Container(width: 4, height: 4, decoration: BoxDecoration(
                          color: AppTheme.accentGreen, borderRadius: BorderRadius.circular(2)))
                      else
                        const SizedBox(height: 4),
                      Text(item.$3, style: TextStyle(
                        fontSize: 10,
                        color: active ? AppTheme.textPrimary : AppTheme.textMuted,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      )),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Aba Simuladores ──────────────────────────────────────────────────────────
class _SimulatorsTab extends StatelessWidget {
  const _SimulatorsTab();

  static final _sims = [
    _S('SISU', 'Universidades Federais', Icons.school_outlined, AppTheme.accentGreen, const SisuScreen()),
    _S('SSA · UPE', 'Selecao Seriada UPE', Icons.trending_up_outlined, Color(0xFFF87171), const SsaScreen()),
    _S('PAS · UnB', 'Avaliacao Seriada UnB', Icons.timeline_outlined, Color(0xFF8B5CF6), const PasScreen()),
    _S('FUVEST · USP', 'Vestibular da USP', Icons.star_outline, Color(0xFF4ADE80), const FuvestScreen()),
    _S('UNICAMP', 'COMVEST', Icons.bar_chart_outlined, Color(0xFF38BDF8), const UnicampScreen()),
    _S('UNESP · VUNESP', 'Vestibular UNESP', Icons.emoji_events_outlined, Color(0xFFFBBF24), const UnespScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('VESTHUB', style: AppTheme.label),
                SizedBox(height: 3),
                Text('Simuladores', style: AppTheme.headingLarge),
              ]),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                itemCount: _sims.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _SimTile(s: _sims[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _S {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;
  const _S(this.title, this.subtitle, this.icon, this.color, this.screen);
}

class _SimTile extends StatelessWidget {
  final _S s;
  const _SimTile({super.key, required this.s});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => s.screen)),
      child: GlassBox(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: s.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: s.color.withOpacity(0.3)),
              ),
              child: Icon(s.icon, color: s.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(s.subtitle, style: AppTheme.bodySmall),
              ],
            )),
            const Icon(Icons.chevron_right, color: AppTheme.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
