// lib/screens/unesp/unesp_screen.dart
//
// Simulador UNESP (VUNESP).
// Nota final = Fase1 (0-72) + Redação (0-30) + Discursiva (0-96)
// Máximo = 198 pontos

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class UnespScreen extends StatefulWidget {
  const UnespScreen({super.key});

  @override
  State<UnespScreen> createState() => _UnespScreenState();
}

class _UnespScreenState extends State<UnespScreen> {
  UnespScores _scores = const UnespScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  void _simulate() {
    if (_selectedCourse == null) return;
    final result = CalcService.instance.simularUnesp(
      scores: _scores,
      curso: _selectedCourse!,
    );
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final total = CalcService.instance.calcUnespTotal(_scores);
    final percentual = (total / _scores.notaMaxima * 100).clamp(0, 100);

    return Scaffold(
      appBar: AppBar(title: const Text('Simulador UNESP · VUNESP')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalCard(total, percentual.toDouble()),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Fase 1 — Objetiva'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: ScoreSlider(
                label: 'Total Fase 1 (72 questões, 0–72)',
                min: 0,
                max: 72,
                value: _scores.fase1,
                activeColor: const Color(0xFF0b8793),
                onChanged: (v) => setState(() => _scores = _scores.copyWith(fase1: v)),
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Fase 2 — Discursiva'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ScoreSlider(
                    label: 'Redação (0–30)',
                    min: 0,
                    max: 30,
                    value: _scores.redacao,
                    activeColor: AppTheme.accentGreen,
                    onChanged: (v) => setState(() => _scores = _scores.copyWith(redacao: v)),
                  ),
                  const Divider(height: 24),
                  ScoreSlider(
                    label: 'Questões discursivas (4 questões × 24, total 0–96)',
                    min: 0,
                    max: 96,
                    value: _scores.fase2Disc,
                    activeColor: AppTheme.accent,
                    onChanged: (v) => setState(() => _scores = _scores.copyWith(fase2Disc: v)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CourseSelector<Course>(
              label: 'Curso (UNESP)',
              courses: unespCourses,
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
                  tipo: 'unesp',
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

  Widget _buildTotalCard(double total, double percentual) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF360033), Color(0xFF0b8793)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PONTUAÇÃO TOTAL UNESP',
            style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                total.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w800, letterSpacing: -2, height: 1),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8),
                child: Text('/ 198', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentual / 100,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('F1: ${_scores.fase1.toStringAsFixed(0)}/72', style: const TextStyle(color: Colors.white60, fontSize: 12)),
              Text('Red: ${_scores.redacao.toStringAsFixed(0)}/30', style: const TextStyle(color: Colors.white60, fontSize: 12)),
              Text('Disc: ${_scores.fase2Disc.toStringAsFixed(0)}/96', style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
