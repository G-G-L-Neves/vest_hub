import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/formula_config.dart';
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

  void _simulate(ExamFormulas formulas) {
    if (_selectedCourse == null) return;
    setState(() => _result = CalcService.instance.simularSsa(
          scores: _scores,
          curso: _selectedCourse!,
          formulas: formulas,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final formulas = context.watch<AppState>().formulas;
    final ssa = formulas.ssa;
    final media = CalcService.instance.calcSsaMedia(_scores, formulas);

    return GlassScaffold(
      title: 'Calculadora SSA · UPE',
      body: RemoteCoursesGate(
        hasCourses: widget.courses.isNotEmpty,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 80, 18, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GlassBox(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'FORMULA: (SSA1×${ssa.pesoFase1.toInt()} + SSA2×${ssa.pesoFase2.toInt()} + SSA3×${ssa.pesoFase3.toInt()}) / ${ssa.totalPeso.toInt()}',
                  style: AppTheme.label,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pesos e limites vêm do Firebase e podem ser atualizados sem nova versão do app.',
                  style: AppTheme.bodySmall,
                ),
              ]),
            ),
            const SizedBox(height: 16),
            GlassBox(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ScoreSlider(
                  label: 'SSA 1 (peso ${ssa.pesoFase1.toInt()})',
                  min: 0,
                  max: ssa.notaMaxima,
                  value: _scores.ssa1,
                  activeColor: AppTheme.textMuted,
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(ssa1: v)),
                ),
                const Divider(height: 20),
                ScoreSlider(
                  label: 'SSA 2 (peso ${ssa.pesoFase2.toInt()})',
                  min: 0,
                  max: ssa.notaMaxima,
                  value: _scores.ssa2,
                  activeColor: AppTheme.accentAmber,
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(ssa2: v)),
                ),
                const Divider(height: 20),
                ScoreSlider(
                  label: 'SSA 3 (peso ${ssa.pesoFase3.toInt()})',
                  min: 0,
                  max: ssa.notaMaxima,
                  value: _scores.ssa3,
                  activeColor: AppTheme.accentGreen,
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(ssa3: v)),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            GlassBox(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('MEDIA PONDERADA', style: AppTheme.label),
                    Text(
                      media.toStringAsFixed(2),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            CourseSelector<Course>(
              label: 'Curso da UPE',
              courses: widget.courses,
              selected: _selectedCourse,
              getName: (c) => c.nome,
              getUniversity: (c) => '${c.universidade} · ${c.turno}',
              getCutoff: (c) => c.notaCorte,
              onChanged: (c) => setState(() {
                _selectedCourse = c;
                _result = null;
              }),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedCourse != null ? () => _simulate(formulas) : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Simular aprovacao'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 20),
              ResultCard(
                notaCalculada: _result!.notaCalculada,
                notaCorte: _result!.notaCorte,
                aprovado: _result!.aprovado,
                diferenca: _result!.diferenca,
                percentual: _result!.percentualAtingido,
                mensagem: _result!.mensagem,
              ),
              const SizedBox(height: 12),
              SaveButton(
                onSave: (titulo) => context.read<AppState>().saveSimulation(
                  tipo: 'ssa',
                  titulo: titulo,
                  dados: {'scores': _scores.toJson(), 'curso': _selectedCourse!.toJson()},
                ),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}
