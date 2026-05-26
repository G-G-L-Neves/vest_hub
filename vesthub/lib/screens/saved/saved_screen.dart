// lib/screens/saved/saved_screen.dart — v0.0.3

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                children: [
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('VESTHUB', style: AppTheme.label),
                    SizedBox(height: 3),
                    Text('Salvos', style: AppTheme.headingLarge),
                  ])),
                  Consumer<AppState>(builder: (_, state, __) {
                    if (state.simulations.isEmpty) return const SizedBox.shrink();
                    return GlassBox(
                      padding: const EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => _confirmClear(context),
                        child: const Icon(Icons.delete_sweep_outlined, color: AppTheme.redText, size: 20),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              child: Consumer<AppState>(
                builder: (_, state, __) {
                  if (state.simulations.isEmpty) {
                    return const EmptyState(
                      icon: Icons.bookmark_border,
                      title: 'Nenhuma simulacao salva',
                      subtitle: 'Faca uma simulacao e toque em Salvar',
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    itemCount: state.simulations.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SimCard(sim: state.simulations[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0B5A5A),
        title: const Text('Limpar tudo?', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('Todas as simulacoes serao removidas.', style: AppTheme.bodySmall),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed),
            onPressed: () { context.read<AppState>().clearSimulations(); Navigator.pop(ctx); },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
}

class _SimCard extends StatelessWidget {
  final SavedSimulation sim;
  const _SimCard({required this.sim});

  Color get _typeColor {
    switch (sim.tipo) {
      case 'sisu': return AppTheme.accentGreen;
      case 'ssa': return AppTheme.accentRed;
      case 'pas': return const Color(0xFF8B5CF6);
      case 'fuvest': return const Color(0xFF4ADE80);
      case 'unicamp': return AppTheme.accent;
      case 'unesp': return AppTheme.accentAmber;
      default: return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultado = sim.dados['resultado'] as Map<String, dynamic>?;
    final aprovado = resultado?['aprovado'] as bool?;
    final notaCalc = (resultado?['notaCalculada'] as num?)?.toDouble();
    final notaCorte = (resultado?['notaCorte'] as num?)?.toDouble();

    return Dismissible(
      key: Key(sim.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.redGlass,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.redBorder),
        ),
        child: const Icon(Icons.delete_outline, color: AppTheme.redText),
      ),
      onDismissed: (_) => context.read<AppState>().deleteSimulation(sim.id),
      child: GlassStatusBox(
        aprovado: aprovado,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: _typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: _typeColor.withOpacity(0.4)),
                  ),
                  child: Text(sim.tipo.toUpperCase(),
                      style: TextStyle(color: _typeColor, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Text(
                  '${sim.criadoEm.day.toString().padLeft(2,'0')}/${sim.criadoEm.month.toString().padLeft(2,'0')}/${sim.criadoEm.year}',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(sim.titulo, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            if (notaCalc != null && notaCorte != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  GlassBox(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text('${notaCalc.toStringAsFixed(1)}', style: TextStyle(
                        color: aprovado == true ? AppTheme.greenText : AppTheme.redText,
                        fontWeight: FontWeight.w700, fontSize: 13))),
                  const SizedBox(width: 8),
                  Text('/ ${notaCorte.toStringAsFixed(1)}', style: AppTheme.bodySmall),
                  const Spacer(),
                  StatusBadge(aprovado: aprovado),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
