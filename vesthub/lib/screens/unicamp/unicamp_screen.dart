// lib/screens/unicamp/unicamp_screen.dart
//
// Simulador UNICAMP (COMVEST).
// Fase 1: objetiva (0-144)
// Fase 2: redação + 2 disciplinas específicas
// Nota total = Fase 1 + Fase 2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class UnicampScreen extends StatefulWidget {
  const UnicampScreen({super.key});

  @override
  State<UnicampScreen> createState() => _UnicampScreenState();
}

class _UnicampScreenState extends State<UnicampScreen> {
  UnicampScores _scores = const UnicampScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  void _simulate() {
    if (_selectedCourse == null) return;
    final result = CalcService.instance.simularUnicamp(
      scores: _scores,
      curso: _selectedCourse!,
    );
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final total = CalcService.instance.calcUnicampTotal(_scores);

    return Scaffold(
      appBar: AppBar(title: const Text('Simulador UNICAMP · COMVEST')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalCard(total),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Fase 1 — Objetiva'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: ScoreSlider(
                label: 'Total Fase 1 (0–144 pontos)',
                min: 0,
                max: 144,
                value: _scores.fase1,
                activeColor: const Color(0xFFf7971e),
                onChanged: (v) =>
                    setState(() => _scores = _scores.copyWith(fase1: v)),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Fase 2 — Discursiva'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ScoreSlider(
                    label: 'Redação (0–12)',
                    min: 0,
                    max: 12,
                    value: _scores.redacao,
                    activeColor: AppTheme.accentGreen,
                    onChanged: (v) =>
                        setState(() => _scores = _scores.copyWith(redacao: v)),
                  ),
                  const Divider(height: 24),
                  ScoreSlider(
                    label: 'Disciplina específica 1 (0–72)',
                    min: 0,
                    max: 72,
                    value: _scores.disc1,
                    activeColor: AppTheme.accent,
                    onChanged: (v) =>
                        setState(() => _scores = _scores.copyWith(disc1: v)),
                  ),
                  const Divider(height: 24),
                  ScoreSlider(
                    label: 'Disciplina específica 2 (0–72)',
                    min: 0,
                    max: 72,
                    value: _scores.disc2,
                    activeColor: const Color(0xFF8E54E9),
                    onChanged: (v) =>
                        setState(() => _scores = _scores.copyWith(disc2: v)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CourseSelector<Course>(
              label: 'Curso (UNICAMP)',
              courses: unicampCourses,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedCourse != null ? _simulate : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Simular aprovação'),
              ),
            ),
            const SizedBox(height: 24),
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
                  tipo: 'unicamp',
                  titulo: titulo,
                  dados: {
                    'scores': _scores.toJson(),
                    'curso': _selectedCourse!.toJson(),
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

  Widget _buildTotalCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf7971e), Color(0xFFffd200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PONTUAÇÃO TOTAL',
                  style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                Text(
                  total.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                    height: 1,
                  ),
                ),
                Text(
                  '/ ${144 + 12 + 72 + 72} pontos possíveis',
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _PhaseTag(label: 'F1', value: _scores.fase1, max: 144),
              const SizedBox(height: 6),
              _PhaseTag(label: 'F2', value: _scores.fase2Total, max: 156),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseTag extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  const _PhaseTag({required this.label, required this.value, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(0)}/$max',
        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
