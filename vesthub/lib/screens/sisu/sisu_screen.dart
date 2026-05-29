// lib/screens/sisu/sisu_screen.dart — v0.0.4 Firestore

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class SisuScreen extends StatefulWidget {
  final List<SisuCourse> courses;
  const SisuScreen({super.key, required this.courses});

  @override
  State<SisuScreen> createState() => _SisuScreenState();
}

class _SisuScreenState extends State<SisuScreen> {
  SisuCourse? _selectedCourse;
  SimulationResult? _result;
  String _searchQuery = '';

  List<SisuCourse> get _filtered {
    if (_searchQuery.isEmpty) return widget.courses;
    final q = _searchQuery.toLowerCase();
    return widget.courses.where((c) =>
        c.nome.toLowerCase().contains(q) ||
        c.universidade.toLowerCase().contains(q) ||
        c.cidade.toLowerCase().contains(q)).toList();
  }

  void _simulate() {
    if (_selectedCourse == null) return;
    final scores = context.read<AppState>().enemScores;
    final formulas = context.read<AppState>().formulas;
    setState(() => _result = CalcService.instance.simularSisu(scores: scores, curso: _selectedCourse!));
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: 'Simulador SISU',
      body: RemoteCoursesGate(
        hasCourses: widget.courses.isNotEmpty,
        child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 80, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBanner(context),
                  const SizedBox(height: 16),
                  const SectionHeader(title: 'Escolha o curso'),
                  const SizedBox(height: 10),
                  GlassBox(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(children: [
                      const Icon(Icons.search, color: AppTheme.textMuted, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Buscar curso ou universidade...',
                          border: InputBorder.none, enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none, isDense: true,
                          contentPadding: EdgeInsets.zero, filled: false,
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  GlassBox(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: _filtered.asMap().entries.map((entry) {
                        final i = entry.key;
                        final course = entry.value;
                        final isSelected = _selectedCourse?.id == course.id;
                        return Column(children: [
                          if (i > 0) const Divider(height: 1),
                          ListTile(
                            onTap: () => setState(() { _selectedCourse = course; _result = null; }),
                            selected: isSelected,
                            selectedTileColor: AppTheme.accent.withOpacity(0.1),
                            title: Text(course.nome, style: TextStyle(
                              color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
                              fontWeight: FontWeight.w500, fontSize: 14)),
                            subtitle: Text('${course.universidade} · ${course.cidade}/${course.uf}',
                                style: AppTheme.bodySmall),
                            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(course.notaCorte.toStringAsFixed(1),
                                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                              const Text('corte', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                            ]),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedCourse != null) ...[
                    _buildWeightsCard(_selectedCourse!),
                    const SizedBox(height: 16),
                  ],
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
                    SaveButton(onSave: (titulo) => context.read<AppState>().saveSimulation(
                      tipo: 'sisu', titulo: titulo,
                      dados: {'curso': _selectedCourse!.toJson(), 'resultado': {
                        'notaCalculada': _result!.notaCalculada,
                        'notaCorte': _result!.notaCorte,
                        'aprovado': _result!.aprovado,
                      }},
                    )),
                  ],
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    final scores = context.watch<AppState>().enemScores;
    final formulas = context.watch<AppState>().formulas;
    final media = CalcService.instance.calcEnemMedia(scores, formulas);
    final hasScores = media > 0;
    return GlassBox(
      fillColor: hasScores ? AppTheme.accent.withOpacity(0.1) : AppTheme.accentAmber.withOpacity(0.1),
      borderColor: hasScores ? AppTheme.accent.withOpacity(0.3) : AppTheme.accentAmber.withOpacity(0.3),
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Icon(hasScores ? Icons.check_circle_outline : Icons.info_outline,
            color: hasScores ? AppTheme.accent : AppTheme.accentAmber),
        const SizedBox(width: 10),
        Expanded(child: Text(
          hasScores
              ? 'Usando suas notas do ENEM (media: ${media.toStringAsFixed(1)})'
              : 'Insira suas notas na aba Calculadora para simular com seus dados.',
          style: AppTheme.bodySmall,
        )),
      ]),
    );
  }

  Widget _buildWeightsCard(SisuCourse course) {
    return GlassBox(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PESOS DO CURSO', style: AppTheme.label),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _WeightChip(label: 'LIN', peso: course.pesos.linguagens),
            _WeightChip(label: 'HUM', peso: course.pesos.humanidades),
            _WeightChip(label: 'NAT', peso: course.pesos.natureza),
            _WeightChip(label: 'MAT', peso: course.pesos.matematica),
            _WeightChip(label: 'RED', peso: course.pesos.redacao),
          ]),
        ],
      ),
    );
  }
}

class _WeightChip extends StatelessWidget {
  final String label;
  final double peso;
  const _WeightChip({required this.label, required this.peso});

  Color get _color => peso >= 3 ? AppTheme.accentGreen : peso >= 2 ? AppTheme.accentAmber : AppTheme.textMuted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(label, style: TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text('${peso.toInt()}x', style: TextStyle(color: _color, fontSize: 16, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
