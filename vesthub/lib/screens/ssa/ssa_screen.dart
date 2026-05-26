// lib/screens/ssa/ssa_screen.dart
//
// Calculadora SSA da UPE (Universidade de Pernambuco).
// Fórmula: SSA1×1 + SSA2×2 + SSA3×3 / 6

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class SsaScreen extends StatefulWidget {
  const SsaScreen({super.key});

  @override
  State<SsaScreen> createState() => _SsaScreenState();
}

class _SsaScreenState extends State<SsaScreen> {
  SsaScores _scores = const SsaScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  void _simulate() {
    if (_selectedCourse == null) return;
    final result = CalcService.instance.simularSsa(
      scores: _scores,
      curso: _selectedCourse!,
    );
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final media = CalcService.instance.calcSsaMedia(_scores);

    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora SSA · UPE')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Explicação da fórmula ────────────────────────────────────────
            _buildFormulaCard(),
            const SizedBox(height: 24),

            // ── Notas das 3 fases ────────────────────────────────────────────
            const SectionHeader(
              title: 'Notas das fases',
              subtitle: 'Insira suas notas (0 a 100)',
            ),
            const SizedBox(height: 16),
            _buildScoreInputs(),
            const SizedBox(height: 24),

            // ── Média calculada ──────────────────────────────────────────────
            _buildMediaDisplay(media),
            const SizedBox(height: 24),

            // ── Seleção de curso ─────────────────────────────────────────────
            CourseSelector<Course>(
              label: 'Curso da UPE',
              courses: ssaCourses,
              selected: _selectedCourse,
              getName: (c) => c.nome,
              getUniversity: (c) => '${c.universidade} · ${c.turno}',
              getCutoff: (c) => c.notaCorte,
              onChanged: (c) => setState(() {
                _selectedCourse = c;
                _result = null;
              }),
            ),
            const SizedBox(height: 24),

            // ── Botão simular ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedCourse != null ? _simulate : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Simular aprovação'),
              ),
            ),
            const SizedBox(height: 24),

            // ── Resultado ────────────────────────────────────────────────────
            if (_result != null) ...[
              ResultCard(
                notaCalculada: _result!.notaCalculada,
                notaCorte: _result!.notaCorte,
                aprovado: _result!.aprovado,
                diferenca: _result!.diferenca,
                percentual: _result!.percentualAtingido,
                mensagem: _result!.mensagem,
              ),
              const SizedBox(height: 16),
              SaveButton(
                onSave: (titulo) => context.read<AppState>().saveSimulation(
                  tipo: 'ssa',
                  titulo: titulo,
                  dados: {
                    'scores': _scores.toJson(),
                    'curso': _selectedCourse!.toJson(),
                    'media': media,
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FÓRMULA DE CÁLCULO', style: AppTheme.label),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.bgElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Média = (SSA1 × 1 + SSA2 × 2 + SSA3 × 3) ÷ 6',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'A SSA3 tem peso 3 (maior), pois é a etapa mais próxima do ingresso.',
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreInputs() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ScoreSlider(
            label: 'SSA 1 (peso 1)',
            min: 0,
            max: 100,
            value: _scores.ssa1,
            activeColor: AppTheme.textSecondary,
            onChanged: (v) => setState(
              () => _scores = _scores.copyWith(ssa1: v),
            ),
          ),
          const Divider(height: 20),
          ScoreSlider(
            label: 'SSA 2 (peso 2)',
            min: 0,
            max: 100,
            value: _scores.ssa2,
            activeColor: AppTheme.accentAmber,
            onChanged: (v) => setState(
              () => _scores = _scores.copyWith(ssa2: v),
            ),
          ),
          const Divider(height: 20),
          ScoreSlider(
            label: 'SSA 3 (peso 3)',
            min: 0,
            max: 100,
            value: _scores.ssa3,
            activeColor: AppTheme.accentGreen,
            onChanged: (v) => setState(
              () => _scores = _scores.copyWith(ssa3: v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaDisplay(double media) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MÉDIA PONDERADA',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  media.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                  ),
                ),
                const Text(
                  '(de 0 a 100)',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _PhaseCircle(label: 'S1', value: _scores.ssa1, peso: 1),
              const SizedBox(height: 8),
              _PhaseCircle(label: 'S2', value: _scores.ssa2, peso: 2),
              const SizedBox(height: 8),
              _PhaseCircle(label: 'S3', value: _scores.ssa3, peso: 3),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseCircle extends StatelessWidget {
  final String label;
  final double value;
  final int peso;

  const _PhaseCircle({required this.label, required this.value, required this.peso});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value.toStringAsFixed(0),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '×$peso',
            style: const TextStyle(color: Colors.white60, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
