import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/formula_config.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class PasScreen extends StatefulWidget {
  final List<Course> courses;
  const PasScreen({super.key, required this.courses});
  @override
  State<PasScreen> createState() => _PasScreenState();
}

class _PasScreenState extends State<PasScreen> {
  PasScores _scores = const PasScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  void _simulate(ExamFormulas formulas) {
    if (_selectedCourse == null) return;
    setState(() => _result = CalcService.instance.simularPas(
          scores: _scores,
          curso: _selectedCourse!,
          formulas: formulas,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final formulas = context.watch<AppState>().formulas;
    final pas = formulas.pas;
    final media = CalcService.instance.calcPasMedia(_scores, formulas);

    return GlassScaffold(
      title: 'Calculadora PAS · UnB',
      body: RemoteCoursesGate(
        hasCourses: widget.courses.isNotEmpty,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 80, 18, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GlassBox(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ScoreSlider(
                  label: '1o Subprograma (peso ${pas.pesoFase1.toInt()})',
                  min: 0,
                  max: pas.notaMaxima,
                  value: _scores.sub1,
                  activeColor: const Color(0xFF4776E6),
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(sub1: v)),
                ),
                const Divider(height: 20),
                ScoreSlider(
                  label: '2o Subprograma (peso ${pas.pesoFase2.toInt()})',
                  min: 0,
                  max: pas.notaMaxima,
                  value: _scores.sub2,
                  activeColor: const Color(0xFF6B5DD3),
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(sub2: v)),
                ),
                const Divider(height: 20),
                ScoreSlider(
                  label: '3o Subprograma (peso ${pas.pesoFase3.toInt()})',
                  min: 0,
                  max: pas.notaMaxima,
                  value: _scores.sub3,
                  activeColor: const Color(0xFF8B5CF6),
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(sub3: v)),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            GlassBox(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('MEDIA PONDERADA PAS', style: AppTheme.label),
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
              label: 'Curso na UnB',
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
                  tipo: 'pas',
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
