// lib/screens/onboarding/onboarding_screen.dart — v0.0.3

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function(String nome, int anoNascimento) onComplete;
  const OnboardingScreen({super.key, required this.onComplete});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nomeController = TextEditingController();
  double _anoNascimento = 2000;
  int _step = 0;

  @override
  void dispose() { _nomeController.dispose(); super.dispose(); }

  void _nextStep() {
    if (_step == 0) {
      if (_nomeController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Digite seu nome para continuar'),
          backgroundColor: AppTheme.redText.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
        return;
      }
      setState(() => _step = 1);
    } else {
      widget.onComplete(_nomeController.text.trim(), _anoNascimento.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                GlassBox(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  borderRadius: BorderRadius.circular(10),
                  child: const Text('VESTHUB', style: TextStyle(
                    color: AppTheme.textPrimary, fontWeight: FontWeight.w700,
                    fontSize: 14, letterSpacing: 2,
                  )),
                ),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _step == 0 ? _buildStepNome() : _buildStepAno(),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    child: Text(_step == 0 ? 'Continuar' : 'Entrar no VestHub'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StepDot(active: _step == 0),
                    const SizedBox(width: 8),
                    _StepDot(active: _step == 1),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepNome() {
    return Column(
      key: const ValueKey('nome'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ola', style: AppTheme.headingLarge),
        const SizedBox(height: 6),
        const Text('Como podemos te chamar?', style: AppTheme.bodyLarge),
        const SizedBox(height: 28),
        TextField(
          controller: _nomeController,
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'Seu nome...',
            prefixIcon: Icon(Icons.person_outline, color: AppTheme.textMuted),
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (_) => _nextStep(),
        ),
      ],
    );
  }

  Widget _buildStepAno() {
    final anoAtual = DateTime.now().year;
    final idade = anoAtual - _anoNascimento.toInt();
    final primeiroNome = _nomeController.text.trim().split(' ').first;

    return Column(
      key: const ValueKey('ano'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ola, $primeiroNome', style: AppTheme.headingLarge),
        const SizedBox(height: 6),
        const Text('Qual seu ano de nascimento?', style: AppTheme.bodyLarge),
        const SizedBox(height: 28),
        Center(
          child: GlassBox(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 22),
            child: Column(
              children: [
                Text(_anoNascimento.toInt().toString(), style: AppTheme.displayLarge),
                const SizedBox(height: 4),
                Text('$idade anos', style: AppTheme.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.accent,
            thumbColor: AppTheme.accent,
            inactiveTrackColor: AppTheme.glassWhite,
            trackHeight: 4,
          ),
          child: Slider(
            value: _anoNascimento,
            min: 1970,
            max: (anoAtual - 10).toDouble(),
            divisions: anoAtual - 10 - 1970,
            onChanged: (v) => setState(() => _anoNascimento = v),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('1970', style: AppTheme.bodySmall),
            Text('${anoAtual - 10}', style: AppTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  const _StepDot({required this.active});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 24 : 8, height: 8,
      decoration: BoxDecoration(
        color: active ? AppTheme.accent : AppTheme.glassWhite,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
