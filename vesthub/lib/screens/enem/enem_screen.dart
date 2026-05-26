// lib/screens/enem/enem_screen.dart
//
// Calculadora do ENEM.
// O usuário insere as notas das 5 áreas e vê a média,
// além de poder definir uma meta e ver o quanto falta.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class EnemScreen extends StatefulWidget {
  const EnemScreen({super.key});

  @override
  State<EnemScreen> createState() => _EnemScreenState();
}

class _EnemScreenState extends State<EnemScreen> {
  late EnemScores _scores;
  double _metaMedia = 750.0;
  bool _showMeta = false;

  @override
  void initState() {
    super.initState();
    // Inicia com as notas salvas no estado global
    _scores = context.read<AppState>().enemScores;
  }

  void _updateScore(EnemScores newScores) {
    setState(() => _scores = newScores);
    // Salva automaticamente ao digitar
    context.read<AppState>().updateEnemScores(newScores);
  }

  @override
  Widget build(BuildContext context) {
    final media = CalcService.instance.calcEnemMedia(_scores);
    final metaInfo = CalcService.instance.calcEnemMeta(
      scores: _scores,
      metaMedia: _metaMedia,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora ENEM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpar notas',
            onPressed: () {
              setState(() => _scores = const EnemScores());
              context.read<AppState>().updateEnemScores(const EnemScores());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card média geral ─────────────────────────────────────────────
            _buildMediaCard(media),
            const SizedBox(height: 24),

            // ── Inputs das notas ─────────────────────────────────────────────
            const SectionHeader(
              title: 'Notas por área',
              subtitle: 'Insira suas notas (0 a 1000)',
            ),
            const SizedBox(height: 16),
            _buildScoreInputs(),
            const SizedBox(height: 28),

            // ── Barra de progresso por área ──────────────────────────────────
            const SectionHeader(title: 'Distribuição das notas'),
            const SizedBox(height: 16),
            _buildAreaBars(media),
            const SizedBox(height: 28),

            // ── Meta de nota ─────────────────────────────────────────────────
            _buildMetaSection(metaInfo),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ─── Card com a média em destaque ──────────────────────────────────────────
  Widget _buildMediaCard(double media) {
    final color = media >= 700
        ? AppTheme.accentGreen
        : media >= 600
            ? AppTheme.accentAmber
            : AppTheme.accentRed;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('MÉDIA GERAL', style: AppTheme.label),
              const Spacer(),
              InfoChip(
                label: media >= 700
                    ? 'Ótima!'
                    : media >= 600
                        ? 'Razoável'
                        : 'Precisa melhorar',
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                media.toStringAsFixed(2),
                style: AppTheme.displayLarge.copyWith(color: color),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '/ 1000',
                  style: TextStyle(color: color.withOpacity(0.5), fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progresso da média
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (media / 1000).clamp(0, 1),
              backgroundColor: AppTheme.bgElevated,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Inputs de nota por área ───────────────────────────────────────────────
  Widget _buildScoreInputs() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAreaRow(
            emoji: '📖',
            label: 'Linguagens e Códigos',
            value: _scores.linguagens,
            onChanged: (v) => _updateScore(_scores.copyWith(linguagens: v)),
          ),
          const Divider(height: 24),
          _buildAreaRow(
            emoji: '🌍',
            label: 'Ciências Humanas',
            value: _scores.humanidades,
            onChanged: (v) => _updateScore(_scores.copyWith(humanidades: v)),
          ),
          const Divider(height: 24),
          _buildAreaRow(
            emoji: '⚗️',
            label: 'Ciências da Natureza',
            value: _scores.natureza,
            onChanged: (v) => _updateScore(_scores.copyWith(natureza: v)),
          ),
          const Divider(height: 24),
          _buildAreaRow(
            emoji: '📐',
            label: 'Matemática',
            value: _scores.matematica,
            onChanged: (v) => _updateScore(_scores.copyWith(matematica: v)),
          ),
          const Divider(height: 24),
          _buildAreaRow(
            emoji: '✍️',
            label: 'Redação',
            value: _scores.redacao,
            onChanged: (v) => _updateScore(_scores.copyWith(redacao: v)),
            note: 'Múltiplos de 40',
          ),
        ],
      ),
    );
  }

  Widget _buildAreaRow({
    required String emoji,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    String? note,
  }) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (note != null)
                Text(note, style: AppTheme.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 90,
          child: ScoreInputField(
            label: '',
            hint: '0.0',
            min: 0,
            max: 1000,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // ─── Barras de área ────────────────────────────────────────────────────────
  Widget _buildAreaBars(double media) {
    final areas = [
      ('Linguagens', _scores.linguagens, AppTheme.accent),
      ('Humanas', _scores.humanidades, AppTheme.accentGreen),
      ('Natureza', _scores.natureza, AppTheme.accentAmber),
      ('Matemática', _scores.matematica, AppTheme.accentRed),
      ('Redação', _scores.redacao, const Color(0xFF9B59B6)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: areas.map((area) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(area.$1, style: AppTheme.bodySmall),
                    Text(
                      area.$2.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (area.$2 / 1000).clamp(0, 1),
                    backgroundColor: AppTheme.bgElevated,
                    valueColor: AlwaysStoppedAnimation(area.$3),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Seção de meta ─────────────────────────────────────────────────────────
  Widget _buildMetaSection(Map<String, dynamic> metaInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeader(title: 'Simulador de meta'),
            Switch(
              value: _showMeta,
              onChanged: (v) => setState(() => _showMeta = v),
              activeColor: AppTheme.accent,
            ),
          ],
        ),
        if (_showMeta) ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ScoreSlider(
                  label: 'Meta de média: ${_metaMedia.toStringAsFixed(0)}',
                  min: 400,
                  max: 1000,
                  value: _metaMedia,
                  onChanged: (v) => setState(() => _metaMedia = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetaInfoBox(
                        label: 'Soma atual',
                        value: (metaInfo['atual'] as double).toStringAsFixed(1),
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetaInfoBox(
                        label: 'Precisa somar',
                        value: (metaInfo['meta'] as double).toStringAsFixed(1),
                        color: AppTheme.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetaInfoBox(
                        label: 'Faltam',
                        value: (metaInfo['falta'] as double) > 0
                            ? (metaInfo['falta'] as double).toStringAsFixed(1)
                            : '✓',
                        color: (metaInfo['falta'] as double) > 0
                            ? AppTheme.accentRed
                            : AppTheme.accentGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MetaInfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetaInfoBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.8),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
