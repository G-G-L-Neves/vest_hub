// lib/screens/pas/pas_screen.dart
//
// Calculadora PAS (Programa de Avaliação Seriada) da UnB.
// Fórmula: SUB1×1 + SUB2×2 + SUB3×3 / 6

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class PasScreen extends StatefulWidget {
  const PasScreen({super.key});

  @override
  State<PasScreen> createState() => _PasScreenState();
}

class _PasScreenState extends State<PasScreen> {
  PasScores _scores = const PasScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  void _simulate() {
    if (_selectedCourse == null) return;
    final result = CalcService.instance.simularPas(
      scores: _scores,
      curso: _selectedCourse!,
    );
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final media = CalcService.instance.calcPasMedia(_scores);

    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora PAS · UnB')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            const SectionHeader(
              title: 'Notas por subprograma',
              subtitle: 'Insira suas notas (0 a 100)',
            ),
            const SizedBox(height: 16),
            _buildScoreInputs(),
            const SizedBox(height: 24),
            _buildMediaCard(media),
            const SizedBox(height: 24),
            CourseSelector<Course>(
              label: 'Curso na UnB',
              courses: pasCourses,
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
                  tipo: 'pas',
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4776E6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF4776E6), size: 18),
              const SizedBox(width: 8),
              const Text(
                'Sobre o PAS UnB',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'O PAS é feito em 3 etapas ao longo do Ensino Médio.\n'
            'Fórmula: (SUB1 × 1 + SUB2 × 2 + SUB3 × 3) ÷ 6',
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
            label: '1º Subprograma · 1º Ano EM (peso 1)',
            min: 0,
            max: 100,
            value: _scores.sub1,
            activeColor: const Color(0xFF4776E6),
            onChanged: (v) => setState(() => _scores = _scores.copyWith(sub1: v)),
          ),
          const Divider(height: 20),
          ScoreSlider(
            label: '2º Subprograma · 2º Ano EM (peso 2)',
            min: 0,
            max: 100,
            value: _scores.sub2,
            activeColor: const Color(0xFF6B5DD3),
            onChanged: (v) => setState(() => _scores = _scores.copyWith(sub2: v)),
          ),
          const Divider(height: 20),
          ScoreSlider(
            label: '3º Subprograma · 3º Ano EM (peso 3)',
            min: 0,
            max: 100,
            value: _scores.sub3,
            activeColor: const Color(0xFF8E54E9),
            onChanged: (v) => setState(() => _scores = _scores.copyWith(sub3: v)),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaCard(double media) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MÉDIA PONDERADA PAS',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            media.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w800,
              letterSpacing: -2,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _SubInfo(label: 'SUB1', value: _scores.sub1),
              const SizedBox(width: 12),
              _SubInfo(label: 'SUB2', value: _scores.sub2),
              const SizedBox(width: 12),
              _SubInfo(label: 'SUB3', value: _scores.sub3),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubInfo extends StatelessWidget {
  final String label;
  final double value;
  const _SubInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        Text(
          value.toStringAsFixed(0),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ],
    );
  }
}
