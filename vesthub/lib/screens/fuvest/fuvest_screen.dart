// lib/screens/fuvest/fuvest_screen.dart
//
// Simulador FUVEST (USP).
// Fase 1: objetiva (4 áreas × 15 questões)
// Fase 2: discursiva + redação
// Nota final = 30% Fase 1 + 70% Fase 2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class FuvestScreen extends StatefulWidget {
  const FuvestScreen({super.key});

  @override
  State<FuvestScreen> createState() => _FuvestScreenState();
}

class _FuvestScreenState extends State<FuvestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FuvestScores _scores = const FuvestScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulate() {
    if (_selectedCourse == null) return;
    final result = CalcService.instance.simularFuvest(
      scores: _scores,
      curso: _selectedCourse!,
    );
    setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final notaFinal = CalcService.instance.calcFuvestNota(_scores);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador FUVEST · USP'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'FASE 1'),
            Tab(text: 'FASE 2'),
          ],
          labelColor: AppTheme.accent,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.accent,
        ),
      ),
      body: Column(
        children: [
          // Nota em destaque fixada no topo
          _buildTopSummary(notaFinal),
          // Tabs das fases
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFase1Tab(),
                _buildFase2Tab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSummary(double notaFinal) {
    return Container(
      color: AppTheme.bgCard,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NOTA FINAL ESTIMADA', style: AppTheme.label),
                Text(
                  '${notaFinal.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'F1: ${_scores.fase1Total.toStringAsFixed(0)}/60 (30%)',
                style: AppTheme.bodySmall,
              ),
              Text(
                'F2: ${_scores.fase2Total.toStringAsFixed(1)}/100 (70%)',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFase1Tab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Fase 1 — Objetiva',
            subtitle: 'Máximo 15 acertos por área (questões de 0 a 1)',
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ScoreInputField(
                  label: 'Português e Redação',
                  hint: '0',
                  min: 0,
                  max: 15,
                  value: _scores.portugues,
                  onChanged: (v) =>
                      setState(() => _scores = _scores.copyWith(portugues: v)),
                  suffix: '/ 15',
                ),
                const SizedBox(height: 16),
                ScoreInputField(
                  label: 'Matemática',
                  hint: '0',
                  min: 0,
                  max: 15,
                  value: _scores.matematica,
                  onChanged: (v) =>
                      setState(() => _scores = _scores.copyWith(matematica: v)),
                  suffix: '/ 15',
                ),
                const SizedBox(height: 16),
                ScoreInputField(
                  label: 'Ciências (Bio, Fís, Quím)',
                  hint: '0',
                  min: 0,
                  max: 15,
                  value: _scores.ciencias,
                  onChanged: (v) =>
                      setState(() => _scores = _scores.copyWith(ciencias: v)),
                  suffix: '/ 15',
                ),
                const SizedBox(height: 16),
                ScoreInputField(
                  label: 'História e Geografia',
                  hint: '0',
                  min: 0,
                  max: 15,
                  value: _scores.historia,
                  onChanged: (v) =>
                      setState(() => _scores = _scores.copyWith(historia: v)),
                  suffix: '/ 15',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Fase 1', style: AppTheme.bodySmall),
                Text(
                  '${_scores.fase1Total.toStringAsFixed(0)} / 60',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFase2Tab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Fase 2 — Discursiva',
            subtitle: 'Redação + questões específicas (0 a 100)',
          ),
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
                  label: 'Redação (0–100)',
                  min: 0,
                  max: 100,
                  value: _scores.redacao,
                  activeColor: AppTheme.accentGreen,
                  onChanged: (v) =>
                      setState(() => _scores = _scores.copyWith(redacao: v)),
                ),
                const Divider(height: 24),
                ScoreSlider(
                  label: 'Questões discursivas (0–100)',
                  min: 0,
                  max: 100,
                  value: _scores.fase2Total,
                  activeColor: AppTheme.accent,
                  onChanged: (v) =>
                      setState(() => _scores = _scores.copyWith(fase2Total: v)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Curso
          CourseSelector<Course>(
            label: 'Curso (USP)',
            courses: fuvestCourses,
            selected: _selectedCourse,
            getName: (c) => c.nome,
            getUniversity: (c) => c.universidade,
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
                tipo: 'fuvest',
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
    );
  }
}
