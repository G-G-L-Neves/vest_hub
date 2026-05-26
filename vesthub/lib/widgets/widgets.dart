// lib/widgets/widgets.dart — v0.0.3 Frutiger Aero

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

// ─── GlassBox — container de vidro base ──────────────────────────────────────
class GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final List<BoxShadow>? shadows;

  const GlassBox({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.fillColor,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: fillColor ?? AppTheme.glassWhite,
        borderRadius: borderRadius ?? BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? AppTheme.glassBorder, width: 1),
        boxShadow: shadows ?? [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4)),
          BoxShadow(color: Colors.white.withOpacity(0.05), blurRadius: 1, offset: const Offset(0, 1)),
        ],
      ),
      child: child,
    );
  }
}

// ─── GlassStatusBox — verde ou vermelho dependendo do status ──────────────────
class GlassStatusBox extends StatelessWidget {
  final Widget child;
  final bool? aprovado; // null = neutro
  final EdgeInsetsGeometry? padding;

  const GlassStatusBox({super.key, required this.child, this.aprovado, this.padding});

  @override
  Widget build(BuildContext context) {
    Color fill, border;
    if (aprovado == true) {
      fill = AppTheme.greenGlass;
      border = AppTheme.greenBorder;
    } else if (aprovado == false) {
      fill = AppTheme.redGlass;
      border = AppTheme.redBorder;
    } else {
      fill = AppTheme.glassWhite;
      border = AppTheme.glassBorder;
    }
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
        boxShadow: aprovado != null ? [
          BoxShadow(
            color: aprovado! ? AppTheme.greenGlow : AppTheme.redGlow,
            blurRadius: 12,
          ),
        ] : null,
      ),
      child: child,
    );
  }
}

// ─── AppBackground — fundo gradiente com orbes de luz ─────────────────────────
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
      child: child,
    );
  }
}

// ─── GlassScaffold — Scaffold com fundo Frutiger Aero ─────────────────────────
class GlassScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const GlassScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title),
        actions: actions,
      ),
      body: AppBackground(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}

// ─── StatusBadge ─────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final bool? aprovado; // null = N/A

  const StatusBadge({super.key, this.aprovado});

  @override
  Widget build(BuildContext context) {
    if (aprovado == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.glassWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.glassBorder),
        ),
        child: const Text('N/A',
            style: TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: aprovado! ? AppTheme.greenGlass : AppTheme.redGlass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: aprovado! ? AppTheme.greenBorder : AppTheme.redBorder),
      ),
      child: Text(
        aprovado! ? 'Aprovado' : 'Abaixo',
        style: TextStyle(
          fontSize: 10,
          color: aprovado! ? AppTheme.greenText : AppTheme.redText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── GlassProgressBar ────────────────────────────────────────────────────────
class GlassProgressBar extends StatelessWidget {
  final double value; // 0.0 a 1.0
  final bool? aprovado;

  const GlassProgressBar({super.key, required this.value, this.aprovado});

  @override
  Widget build(BuildContext context) {
    final color = aprovado == true
        ? AppTheme.greenText
        : aprovado == false
            ? AppTheme.redText
            : AppTheme.accent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        backgroundColor: AppTheme.glassWhite,
        valueColor: AlwaysStoppedAnimation(color),
        minHeight: 4,
      ),
    );
  }
}

// ─── ScoreInputField ─────────────────────────────────────────────────────────
class ScoreInputField extends StatelessWidget {
  final String label;
  final String hint;
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final String? suffix;

  const ScoreInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.bodySmall),
            Text('${min.toInt()} – ${max.toInt()}',
                style: AppTheme.label.copyWith(color: AppTheme.textHint)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value > 0 ? value.toStringAsFixed(1) : '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
          decoration: InputDecoration(hintText: hint, suffixText: suffix,
              suffixStyle: const TextStyle(color: AppTheme.textSecondary)),
          onChanged: (v) {
            final parsed = double.tryParse(v) ?? 0;
            onChanged(parsed.clamp(min, max).toDouble());
          },
        ),
      ],
    );
  }
}

// ─── ScoreSlider ─────────────────────────────────────────────────────────────
class ScoreSlider extends StatelessWidget {
  final String label;
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final Color? activeColor;

  const ScoreSlider({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: AppTheme.bodySmall)),
            GlassBox(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              borderRadius: BorderRadius.circular(8),
              child: Text(value.toStringAsFixed(1),
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor ?? AppTheme.accent,
            thumbColor: activeColor ?? AppTheme.accent,
          ),
          child: Slider(
            value: value, min: min, max: max,
            divisions: ((max - min) * 10).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ─── ResultCard ──────────────────────────────────────────────────────────────
class ResultCard extends StatelessWidget {
  final double notaCalculada;
  final double notaCorte;
  final bool aprovado;
  final double diferenca;
  final double percentual;
  final String mensagem;
  final String? cursoNome;

  const ResultCard({
    super.key,
    required this.notaCalculada,
    required this.notaCorte,
    required this.aprovado,
    required this.diferenca,
    required this.percentual,
    required this.mensagem,
    this.cursoNome,
  });

  @override
  Widget build(BuildContext context) {
    return GlassStatusBox(
      aprovado: aprovado,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(aprovado: aprovado),
              const Spacer(),
              Text(
                diferenca >= 0 ? '+${diferenca.toStringAsFixed(1)}' : diferenca.toStringAsFixed(1),
                style: TextStyle(
                  color: aprovado ? AppTheme.greenText : AppTheme.redText,
                  fontWeight: FontWeight.w600, fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _ScorePill(label: 'Sua nota', valor: notaCalculada, aprovado: aprovado)),
              const SizedBox(width: 10),
              Expanded(child: _ScorePill(label: 'Corte', valor: notaCorte, aprovado: null)),
            ],
          ),
          const SizedBox(height: 14),
          GlassProgressBar(value: percentual / 100, aprovado: aprovado),
          const SizedBox(height: 5),
          Text('${percentual.toStringAsFixed(1)}% da nota de corte',
              style: AppTheme.label.copyWith(
                  color: aprovado ? AppTheme.greenText : AppTheme.redText)),
          const SizedBox(height: 12),
          GlassBox(
            padding: const EdgeInsets.all(12),
            child: Text(mensagem, style: AppTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  final String label;
  final double valor;
  final bool? aprovado;
  const _ScorePill({required this.label, required this.valor, required this.aprovado});

  @override
  Widget build(BuildContext context) {
    final color = aprovado == true ? AppTheme.greenText : aprovado == false ? AppTheme.redText : AppTheme.textSecondary;
    return GlassBox(
      padding: const EdgeInsets.all(12),
      fillColor: aprovado != null ? (aprovado! ? AppTheme.greenGlass : AppTheme.redGlass) : AppTheme.glassWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTheme.label.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(valor.toStringAsFixed(1),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: color, letterSpacing: -0.5)),
        ],
      ),
    );
  }
}

// ─── SectionHeader ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const SectionHeader({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.headingMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle!, style: AppTheme.bodySmall),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ─── VestCard ────────────────────────────────────────────────────────────────
class VestCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const VestCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.glassWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.glassBorder),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12)],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTheme.bodySmall.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ─── SaveButton ──────────────────────────────────────────────────────────────
class SaveButton extends StatelessWidget {
  final Future<void> Function(String titulo) onSave;
  const SaveButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final ctrl = TextEditingController();
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF0B5A5A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: const Text('Salvar simulacao', style: TextStyle(color: AppTheme.textPrimary)),
            content: TextField(controller: ctrl, autofocus: true,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(hintText: 'Ex: Medicina UFPE')),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salvar')),
            ],
          ),
        );
        if (confirm == true && ctrl.text.isNotEmpty) {
          await onSave(ctrl.text);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Simulacao salva!'),
              backgroundColor: AppTheme.greenText.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ));
          }
        }
      },
      icon: const Icon(Icons.bookmark_outline, size: 18),
      label: const Text('Salvar'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.accent,
        side: const BorderSide(color: AppTheme.accent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ─── CourseSelector ──────────────────────────────────────────────────────────
class CourseSelector<T> extends StatelessWidget {
  final String label;
  final List<T> courses;
  final T? selected;
  final String Function(T) getName;
  final String Function(T) getUniversity;
  final double Function(T) getCutoff;
  final ValueChanged<T?> onChanged;

  const CourseSelector({
    super.key, required this.label, required this.courses,
    required this.selected, required this.getName,
    required this.getUniversity, required this.getCutoff, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.bodySmall),
        const SizedBox(height: 8),
        GlassBox(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: selected,
              isExpanded: true,
              dropdownColor: const Color(0xFF0B5A5A),
              hint: const Text('Selecione um curso...', style: TextStyle(color: AppTheme.textHint)),
              items: courses.map((c) {
                return DropdownMenuItem<T>(
                  value: c,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(getName(c), style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                      Text('${getUniversity(c)} · Corte: ${getCutoff(c).toStringAsFixed(1)}',
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── InfoChip ────────────────────────────────────────────────────────────────
class InfoChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  const InfoChip({super.key, required this.label, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: c), const SizedBox(width: 4)],
          Text(label, style: TextStyle(fontSize: 11, color: c, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── EmptyState ──────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppTheme.textHint),
            const SizedBox(height: 16),
            Text(title, style: AppTheme.headingMedium, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(subtitle, style: AppTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
