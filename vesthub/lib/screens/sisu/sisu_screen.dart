// lib/screens/sisu/sisu_screen.dart
//
// Simulador SISU.
// Usa as notas do ENEM salvas + pesos do curso selecionado
// para calcular se o aluno seria aprovado.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/calc_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class SisuScreen extends StatefulWidget {
  const SisuScreen({super.key});

  @override
  State<SisuScreen> createState() => _SisuScreenState();
}

class _SisuScreenState extends State<SisuScreen> {
  SisuCourse? _selectedCourse;
  SimulationResult? _result;
  String _searchQuery = '';
  List<SisuCourse> _filteredCourses = sisuCourses;

  void _simulate() {
    if (_selectedCourse == null) return;
    final scores = context.read<AppState>().enemScores;
    final result = CalcService.instance.simularSisu(
      scores: scores,
      curso: _selectedCourse!,
    );
    setState(() => _result = result);
  }

  void _onSearch(String q) {
    setState(() {
      _searchQuery = q;
      _filteredCourses = searchSisuCourses(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulador SISU')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Banner informativo ────────────────────────────────────────────
            _buildInfoBanner(context),
            const SizedBox(height: 24),

            // ── Busca de curso ────────────────────────────────────────────────
            const SectionHeader(
              title: 'Escolha o curso',
              subtitle: 'Busque por nome ou universidade',
            ),
            const SizedBox(height: 12),
            _buildSearchField(),
            const SizedBox(height: 12),
            _buildCourseList(),
            const SizedBox(height: 24),

            // ── Pesos do curso selecionado ────────────────────────────────────
            if (_selectedCourse != null) ...[
              _buildWeightsCard(_selectedCourse!),
              const SizedBox(height: 24),
            ],

            // ── Botão simular ─────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedCourse != null ? _simulate : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Simular aprovação'),
              ),
            ),
            const SizedBox(height: 24),

            // ── Resultado ─────────────────────────────────────────────────────
            if (_result != null) ...[
              ResultCard(
                notaCalculada: _result!.notaCalculada,
                notaCorte: _result!.notaCorte,
                aprovado: _result!.aprovado,
                diferenca: _result!.diferenca,
                percentual: _result!.percentualAtingido,
                mensagem: _result!.mensagem,
                cursoNome: _selectedCourse!.nome,
              ),
              const SizedBox(height: 16),
              // Botão salvar
              SaveButton(
                onSave: (titulo) async {
                  await context.read<AppState>().saveSimulation(
                    tipo: 'sisu',
                    titulo: titulo,
                    dados: {
                      'curso': _selectedCourse!.toJson(),
                      'resultado': {
                        'notaCalculada': _result!.notaCalculada,
                        'notaCorte': _result!.notaCorte,
                        'aprovado': _result!.aprovado,
                      },
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    final scores = context.watch<AppState>().enemScores;
    final media = scores.media;
    final hasScores = media > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hasScores
            ? AppTheme.accent.withOpacity(0.1)
            : AppTheme.accentAmber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasScores
              ? AppTheme.accent.withOpacity(0.3)
              : AppTheme.accentAmber.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasScores ? Icons.check_circle_outline : Icons.info_outline,
            color: hasScores ? AppTheme.accent : AppTheme.accentAmber,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasScores
                  ? 'Usando suas notas do ENEM (média: ${media.toStringAsFixed(1)}). Os pesos variam por curso.'
                  : 'Insira suas notas do ENEM na aba "ENEM" para simular com seus dados reais.',
              style: AppTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: const InputDecoration(
        hintText: 'Buscar curso ou universidade...',
        prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
      ),
      onChanged: _onSearch,
    );
  }

  Widget _buildCourseList() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: _filteredCourses.asMap().entries.map((entry) {
          final i = entry.key;
          final course = entry.value;
          final isSelected = _selectedCourse?.id == course.id;

          return Column(
            children: [
              if (i > 0) const Divider(height: 1),
              ListTile(
                onTap: () => setState(() {
                  _selectedCourse = course;
                  _result = null;
                }),
                selected: isSelected,
                selectedTileColor: AppTheme.accent.withOpacity(0.08),
                shape: i == 0
                    ? const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      )
                    : i == _filteredCourses.length - 1
                        ? const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                          )
                        : null,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accent.withOpacity(0.15)
                        : AppTheme.bgElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.school_outlined,
                    size: 18,
                    color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
                  ),
                ),
                title: Text(
                  course.nome,
                  style: TextStyle(
                    color:
                        isSelected ? AppTheme.accent : AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${course.universidade} · ${course.cidade}/${course.uf} · ${course.turno}',
                  style: AppTheme.bodySmall.copyWith(fontSize: 11),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      course.notaCorte.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      'corte',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeightsCard(SisuCourse course) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PESOS DO CURSO', style: AppTheme.label),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _WeightChip(label: 'LIN', peso: course.pesos.linguagens),
              _WeightChip(label: 'HUM', peso: course.pesos.humanidades),
              _WeightChip(label: 'NAT', peso: course.pesos.natureza),
              _WeightChip(label: 'MAT', peso: course.pesos.matematica),
              _WeightChip(label: 'RED', peso: course.pesos.redacao),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InfoChip(
                label: '${course.vagas} vagas',
                icon: Icons.people_outline,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              InfoChip(
                label: course.turno,
                icon: Icons.access_time,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightChip extends StatelessWidget {
  final String label;
  final double peso;

  const _WeightChip({required this.label, required this.peso});

  Color get _color {
    if (peso >= 3) return AppTheme.accentGreen;
    if (peso >= 2) return AppTheme.accentAmber;
    return AppTheme.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: _color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${peso.toInt()}x',
            style: TextStyle(
              color: _color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
