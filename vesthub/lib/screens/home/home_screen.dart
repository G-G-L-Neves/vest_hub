// lib/screens/home/home_screen.dart — v0.0.3 Frutiger Aero

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 18),
              _buildEnemCard(context),
              const SizedBox(height: 14),
              _buildStatsRow(context),
              const SizedBox(height: 18),
              _buildQuickAccess(),
              const SizedBox(height: 18),
              _buildTip(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, state, __) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VESTHUB · v0.0.3', style: AppTheme.label),
                const SizedBox(height: 4),
                Text(
                  state.primeiroNome.isNotEmpty
                      ? 'Ola, ${state.primeiroNome}'
                      : 'Bem-vindo',
                  style: AppTheme.headingLarge,
                ),
                const SizedBox(height: 2),
                Text('Veja suas chances de aprovacao', style: AppTheme.bodySmall),
              ],
            ),
          ),
          GlassBox(
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(50),
            child: Text(
              state.primeiroNome.isNotEmpty ? state.primeiroNome[0].toUpperCase() : 'V',
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnemCard(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, state, __) {
        final media = CalcService.instance.calcEnemMedia(state.enemScores);
        final hasScores = media > 0;
        return GlassBox(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MEDIA GERAL ENEM', style: AppTheme.label),
              const SizedBox(height: 8),
              hasScores
                  ? Text(media.toStringAsFixed(1), style: AppTheme.displayLarge)
                  : const Text('Insira suas notas na aba Calculadora',
                      style: AppTheme.bodyLarge),
              if (hasScores) ...[
                const SizedBox(height: 10),
                GlassProgressBar(value: media / 1000, aprovado: media >= 650 ? true : false),
                const SizedBox(height: 5),
                Text('${(media / 10).toStringAsFixed(1)}% do maximo',
                    style: AppTheme.label),
                const SizedBox(height: 12),
                _EnemMiniRow(scores: state.enemScores),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, state, __) {
        return Row(
          children: [
            Expanded(child: GlassStatusBox(
              aprovado: true,
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                Text('0', style: const TextStyle(color: AppTheme.greenText, fontSize: 26, fontWeight: FontWeight.w500)),
                Text('Aprovado', style: AppTheme.bodySmall),
              ]),
            )),
            const SizedBox(width: 10),
            Expanded(child: GlassStatusBox(
              aprovado: false,
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                Text('0', style: const TextStyle(color: AppTheme.redText, fontSize: 26, fontWeight: FontWeight.w500)),
                Text('Abaixo', style: AppTheme.bodySmall),
              ]),
            )),
            const SizedBox(width: 10),
            Expanded(child: GlassBox(
              padding: const EdgeInsets.all(14),
              child: Column(children: [
                Text('${state.simulations.length}',
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 26, fontWeight: FontWeight.w500)),
                Text('Salvos', style: AppTheme.bodySmall),
              ]),
            )),
          ],
        );
      },
    );
  }

  Widget _buildQuickAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Acesso rapido'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: [
            VestCard(title: 'Calculadora', subtitle: 'Compare faculdades', icon: Icons.list_alt_outlined,
                gradient: AppTheme.accentGradient, onTap: () {}),
            VestCard(title: 'SISU', subtitle: 'Federais com pesos', icon: Icons.school_outlined,
                gradient: AppTheme.greenGradient, onTap: () {}),
            VestCard(title: 'FUVEST', subtitle: 'USP · 2 fases', icon: Icons.star_outline,
                gradient: const LinearGradient(colors: [Color(0xFF1D976C), Color(0xFF38BDF8)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight), onTap: () {}),
            VestCard(title: 'UNICAMP', subtitle: 'COMVEST', icon: Icons.bar_chart_outlined,
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight), onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildTip() {
    return GlassBox(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppTheme.accentAmber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.accentAmber.withOpacity(0.3)),
            ),
            child: const Icon(Icons.lightbulb_outline, color: AppTheme.accentAmber, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Use a Calculadora para inserir sua nota e ver de uma vez quais cursos voce passaria.',
              style: AppTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnemMiniRow extends StatelessWidget {
  final dynamic scores;
  const _EnemMiniRow({required this.scores});

  @override
  Widget build(BuildContext context) {
    final areas = [
      ('LIN', scores.linguagens as double),
      ('HUM', scores.humanidades as double),
      ('NAT', scores.natureza as double),
      ('MAT', scores.matematica as double),
      ('RED', scores.redacao as double),
    ];
    return Wrap(
      spacing: 6, runSpacing: 6,
      children: areas.map((a) {
        return GlassBox(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              Text(a.$1, style: AppTheme.label),
              const SizedBox(height: 2),
              Text(a.$2.toStringAsFixed(0),
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
