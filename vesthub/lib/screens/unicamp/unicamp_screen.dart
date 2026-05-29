import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class UnicampScreen extends StatefulWidget {
  final List<Course> courses;
  const UnicampScreen({super.key, required this.courses});
  @override
  State<UnicampScreen> createState() => _UnicampScreenState();
}

class _UnicampScreenState extends State<UnicampScreen> {
  UnicampScores _scores = const UnicampScores();
  Course? _selectedCourse;
  SimulationResult? _result;

  void _simulate() {
    if (_selectedCourse == null) return;
    setState(() => _result = CalcService.instance.simularUnicamp(scores: _scores, curso: _selectedCourse!));
  }

  @override
  Widget build(BuildContext context) {
    final uni = context.watch<AppState>().formulas.unicamp;
    final total = CalcService.instance.calcUnicampTotal(_scores);

    return GlassScaffold(
      title: 'UNICAMP · COMVEST',
      body: RemoteCoursesGate(
        hasCourses: widget.courses.isNotEmpty,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 80, 18, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GlassBox(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('PONTUACAO TOTAL', style: AppTheme.label),
                Text(
                  total.toStringAsFixed(1),
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 40, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GlassProgressBar(
                  value: total / uni.notaMaximaTotal,
                  aprovado: total >= uni.notaMaximaTotal * 0.67,
                ),
              ]),
            ),
            const SizedBox(height: 14),
            GlassBox(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ScoreSlider(
                  label: 'Fase 1 (0-${uni.fase1Max.toInt()})',
                  min: 0,
                  max: uni.fase1Max,
                  value: _scores.fase1,
                  activeColor: AppTheme.accent,
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(fase1: v)),
                ),
                const Divider(height: 20),
                ScoreSlider(
                  label: 'Redacao (0-${uni.redacaoMax.toInt()})',
                  min: 0,
                  max: uni.redacaoMax,
                  value: _scores.redacao,
                  activeColor: AppTheme.accentGreen,
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(redacao: v)),
                ),
                const Divider(height: 20),
                ScoreSlider(
                  label: 'Disciplina 1 (0-${uni.discMax.toInt()})',
                  min: 0,
                  max: uni.discMax,
                  value: _scores.disc1,
                  activeColor: AppTheme.accentAmber,
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(disc1: v)),
                ),
                const Divider(height: 20),
                ScoreSlider(
                  label: 'Disciplina 2 (0-${uni.discMax.toInt()})',
                  min: 0,
                  max: uni.discMax,
                  value: _scores.disc2,
                  activeColor: const Color(0xFF8B5CF6),
                  onChanged: (v) => setState(() => _scores = _scores.copyWith(disc2: v)),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            CourseSelector<Course>(
              label: 'Curso (UNICAMP)',
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
                onPressed: _selectedCourse != null ? _simulate : null,
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
                  tipo: 'unicamp',
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
