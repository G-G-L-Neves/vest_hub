import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class SsaScreen extends StatefulWidget {
  final List<Course> courses;
  const SsaScreen({super.key, required this.courses});
  @override
  State<SsaScreen> createState() => _SsaScreenState();
}

class _SsaScreenState extends State<SsaScreen> {
  SsaScores _scores = const SsaScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  void _simulate() {
    if (_selectedCourse == null) return;
    setState(() => _result = CalcService.instance.simularSsa(scores: _scores, curso: _selectedCourse!));
  }

  @override
  Widget build(BuildContext context) {
    final media = CalcService.instance.calcSsaMedia(_scores);
    return GlassScaffold(
      title: 'Calculadora SSA · UPE',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 80, 18, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GlassBox(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('FORMULA: (SSA1x1 + SSA2x2 + SSA3x3) / 6', style: AppTheme.label),
            const SizedBox(height: 8),
            const Text('A SSA3 tem peso maior por ser a etapa mais recente.', style: AppTheme.bodySmall),
          ])),
          const SizedBox(height: 16),
          GlassBox(padding: const EdgeInsets.all(16), child: Column(children: [
            ScoreSlider(label: 'SSA 1 (peso 1)', min: 0, max: 100, value: _scores.ssa1,
                activeColor: AppTheme.textMuted, onChanged: (v) => setState(() => _scores = _scores.copyWith(ssa1: v))),
            const Divider(height: 20),
            ScoreSlider(label: 'SSA 2 (peso 2)', min: 0, max: 100, value: _scores.ssa2,
                activeColor: AppTheme.accentAmber, onChanged: (v) => setState(() => _scores = _scores.copyWith(ssa2: v))),
            const Divider(height: 20),
            ScoreSlider(label: 'SSA 3 (peso 3)', min: 0, max: 100, value: _scores.ssa3,
                activeColor: AppTheme.accentGreen, onChanged: (v) => setState(() => _scores = _scores.copyWith(ssa3: v))),
          ])),
          const SizedBox(height: 14),
          GlassBox(padding: const EdgeInsets.all(16), child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('MEDIA PONDERADA', style: AppTheme.label),
              Text(media.toStringAsFixed(2), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 36, fontWeight: FontWeight.w500)),
            ])),
          ])),
          const SizedBox(height: 16),
          CourseSelector<Course>(label: 'Curso da UPE', courses: widget.courses, selected: _selectedCourse,
              getName: (c) => c.nome, getUniversity: (c) => '${c.universidade} · ${c.turno}',
              getCutoff: (c) => c.notaCorte, onChanged: (c) => setState(() { _selectedCourse = c; _result = null; })),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(
              onPressed: _selectedCourse != null ? _simulate : null,
              icon: const Icon(Icons.play_arrow), label: const Text('Simular aprovacao'))),
          if (_result != null) ...[
            const SizedBox(height: 20),
            ResultCard(notaCalculada: _result!.notaCalculada, notaCorte: _result!.notaCorte,
                aprovado: _result!.aprovado, diferenca: _result!.diferenca,
                percentual: _result!.percentualAtingido, mensagem: _result!.mensagem),
            const SizedBox(height: 12),
            SaveButton(onSave: (titulo) => context.read<AppState>().saveSimulation(
                tipo: 'ssa', titulo: titulo,
                dados: {'scores': _scores.toJson(), 'curso': _selectedCourse!.toJson()})),
          ],
        ]),
      ),
    );
  }
}
