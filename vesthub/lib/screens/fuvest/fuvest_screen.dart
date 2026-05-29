import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class FuvestScreen extends StatefulWidget {
  final List<Course> courses;
  const FuvestScreen({super.key, required this.courses});
  @override
  State<FuvestScreen> createState() => _FuvestScreenState();
}

class _FuvestScreenState extends State<FuvestScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FuvestScores _scores = const FuvestScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  @override
  void initState() { super.initState(); _tabController = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  void _simulate() {
    if (_selectedCourse == null) return;
    setState(() => _result = CalcService.instance.simularFuvest(scores: _scores, curso: _selectedCourse!));
  }

  @override
  Widget build(BuildContext context) {
    final notaFinal = CalcService.instance.calcFuvestNota(_scores);
    return GlassScaffold(
      title: 'FUVEST · USP',
      body: Column(children: [
        const SizedBox(height: 80),
        GlassBox(margin: const EdgeInsets.symmetric(horizontal: 18), padding: const EdgeInsets.all(14), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('NOTA FINAL ESTIMADA', style: AppTheme.label),
            Text('${notaFinal.toStringAsFixed(1)}%', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 32, fontWeight: FontWeight.w500)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('F1: ${_scores.fase1Total.toStringAsFixed(0)}/60', style: AppTheme.bodySmall),
            Text('F2: ${_scores.fase2Total.toStringAsFixed(1)}/100', style: AppTheme.bodySmall),
          ]),
        ])),
        const SizedBox(height: 8),
        TabBar(controller: _tabController, tabs: const [Tab(text: 'FASE 1'), Tab(text: 'FASE 2')],
            labelColor: AppTheme.accent, unselectedLabelColor: AppTheme.textMuted, indicatorColor: AppTheme.accent),
        Expanded(child: TabBarView(controller: _tabController, children: [
          SingleChildScrollView(padding: const EdgeInsets.all(18), child: GlassBox(padding: const EdgeInsets.all(16), child: Column(children: [
            ScoreInputField(label: 'Portugues', hint: '0', min: 0, max: 15, value: _scores.portugues, suffix: '/15',
                onChanged: (v) => setState(() => _scores = _scores.copyWith(portugues: v))),
            const SizedBox(height: 14),
            ScoreInputField(label: 'Matematica', hint: '0', min: 0, max: 15, value: _scores.matematica, suffix: '/15',
                onChanged: (v) => setState(() => _scores = _scores.copyWith(matematica: v))),
            const SizedBox(height: 14),
            ScoreInputField(label: 'Ciencias', hint: '0', min: 0, max: 15, value: _scores.ciencias, suffix: '/15',
                onChanged: (v) => setState(() => _scores = _scores.copyWith(ciencias: v))),
            const SizedBox(height: 14),
            ScoreInputField(label: 'Historia e Geografia', hint: '0', min: 0, max: 15, value: _scores.historia, suffix: '/15',
                onChanged: (v) => setState(() => _scores = _scores.copyWith(historia: v))),
          ]))),
          SingleChildScrollView(padding: const EdgeInsets.all(18), child: Column(children: [
            GlassBox(padding: const EdgeInsets.all(16), child: Column(children: [
              ScoreSlider(label: 'Redacao (0-100)', min: 0, max: 100, value: _scores.redacao,
                  activeColor: AppTheme.accentGreen, onChanged: (v) => setState(() => _scores = _scores.copyWith(redacao: v))),
              const Divider(height: 20),
              ScoreSlider(label: 'Discursivas (0-100)', min: 0, max: 100, value: _scores.fase2Total,
                  activeColor: AppTheme.accent, onChanged: (v) => setState(() => _scores = _scores.copyWith(fase2Total: v))),
            ])),
            const SizedBox(height: 14),
            CourseSelector<Course>(label: 'Curso (USP)', courses: widget.courses, selected: _selectedCourse,
                getName: (c) => c.nome, getUniversity: (c) => c.universidade,
                getCutoff: (c) => c.notaCorte, onChanged: (c) => setState(() { _selectedCourse = c; _result = null; })),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(
                onPressed: _selectedCourse != null ? _simulate : null,
                icon: const Icon(Icons.play_arrow), label: const Text('Simular aprovacao'))),
            if (_result != null) ...[
              const SizedBox(height: 16),
              ResultCard(notaCalculada: _result!.notaCalculada, notaCorte: _result!.notaCorte,
                  aprovado: _result!.aprovado, diferenca: _result!.diferenca,
                  percentual: _result!.percentualAtingido, mensagem: _result!.mensagem),
              const SizedBox(height: 12),
              SaveButton(onSave: (titulo) => context.read<AppState>().saveSimulation(
                  tipo: 'fuvest', titulo: titulo,
                  dados: {'scores': _scores.toJson(), 'curso': _selectedCourse!.toJson()})),
            ],
          ])),
        ])),
      ]),
    );
  }
}
