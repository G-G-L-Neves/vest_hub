// lib/services/calc_service.dart
//
// Toda a lógica de cálculo das notas está aqui.
// Funções puras (sem estado) que recebem notas e devolvem resultados.
// Fácil de testar e manter separado da UI.

import '../models/models.dart';

class CalcService {
  // Instância singleton (padrão simples sem injeção de dependência)
  static const CalcService instance = CalcService._();
  const CalcService._();

  // ─── ENEM ──────────────────────────────────────────────────────────────────

  /// Retorna a média simples das 5 áreas do ENEM
  double calcEnemMedia(EnemScores scores) => scores.media;

  /// Calcula quanto o aluno precisa tirar em cada área para atingir a meta
  /// (distribui o déficit igualmente nas áreas que ainda não foram preenchidas)
  Map<String, double> calcEnemMeta({
    required EnemScores scores,
    required double metaMedia,
  }) {
    final total = metaMedia * 5;
    final atual = scores.linguagens +
        scores.humanidades +
        scores.natureza +
        scores.matematica +
        scores.redacao;
    final falta = (total - atual).clamp(0, 5000);
    return {
      'falta': falta.toDouble(),
      'mediaFalta': falta / 5,
      'atual': atual,
      'meta': total,
    };
  }

  // ─── SISU ──────────────────────────────────────────────────────────────────

  /// Calcula a nota ponderada SISU com os pesos do curso escolhido
  double calcSisuNota(EnemScores scores, SisuWeights pesos) {
    return pesos.calcularMedia(scores);
  }

  /// Simula se o aluno passaria no curso e retorna o resultado
  SimulationResult simularSisu({
    required EnemScores scores,
    required SisuCourse curso,
  }) {
    final notaCalc = calcSisuNota(scores, curso.pesos);
    final diferenca = notaCalc - curso.notaCorte;
    final percentual =
        (notaCalc / curso.notaCorte * 100).clamp(0, 200).toDouble();

    return SimulationResult(
      notaCalculada: notaCalc,
      notaCorte: curso.notaCorte,
      aprovado: notaCalc >= curso.notaCorte,
      diferenca: diferenca,
      percentualAtingido: percentual,
      mensagem: _gerarMensagem(diferenca, 'SISU', curso.nome),
    );
  }

  // ─── SSA (UPE) ─────────────────────────────────────────────────────────────

  /// Média ponderada SSA: SSA1×1 + SSA2×2 + SSA3×3 / 6
  double calcSsaMedia(SsaScores scores) => scores.mediaPonderada;

  SimulationResult simularSsa({
    required SsaScores scores,
    required Course curso,
  }) {
    final notaCalc = scores.mediaPonderada;
    final diferenca = notaCalc - curso.notaCorte;
    final percentual =
        (notaCalc / curso.notaCorte * 100).clamp(0, 200).toDouble();

    return SimulationResult(
      notaCalculada: notaCalc,
      notaCorte: curso.notaCorte,
      aprovado: notaCalc >= curso.notaCorte,
      diferenca: diferenca,
      percentualAtingido: percentual,
      mensagem: _gerarMensagem(diferenca, 'SSA/UPE', curso.nome),
    );
  }

  // ─── PAS UnB ───────────────────────────────────────────────────────────────

  /// Média ponderada PAS: SUB1×1 + SUB2×2 + SUB3×3 / 6
  double calcPasMedia(PasScores scores) => scores.mediaPonderada;

  SimulationResult simularPas({
    required PasScores scores,
    required Course curso,
  }) {
    final notaCalc = scores.mediaPonderada;
    final diferenca = notaCalc - curso.notaCorte;
    final percentual =
        (notaCalc / curso.notaCorte * 100).clamp(0, 200).toDouble();

    return SimulationResult(
      notaCalculada: notaCalc,
      notaCorte: curso.notaCorte,
      aprovado: notaCalc >= curso.notaCorte,
      diferenca: diferenca,
      percentualAtingido: percentual,
      mensagem: _gerarMensagem(diferenca, 'PAS UnB', curso.nome),
    );
  }

  // ─── FUVEST ────────────────────────────────────────────────────────────────

  /// Nota final FUVEST (percentual de aproveitamento 0-100)
  double calcFuvestNota(FuvestScores scores) => scores.notaFinal;

  SimulationResult simularFuvest({
    required FuvestScores scores,
    required Course curso,
  }) {
    final notaCalc = scores.notaFinal;
    final diferenca = notaCalc - curso.notaCorte;
    final percentual =
        (notaCalc / curso.notaCorte * 100).clamp(0, 200).toDouble();

    return SimulationResult(
      notaCalculada: notaCalc,
      notaCorte: curso.notaCorte,
      aprovado: notaCalc >= curso.notaCorte,
      diferenca: diferenca,
      percentualAtingido: percentual,
      mensagem: _gerarMensagem(diferenca, 'FUVEST', curso.nome),
    );
  }

  // ─── UNICAMP ───────────────────────────────────────────────────────────────

  /// Total UNICAMP = Fase 1 + Fase 2
  double calcUnicampTotal(UnicampScores scores) => scores.total;

  SimulationResult simularUnicamp({
    required UnicampScores scores,
    required Course curso,
  }) {
    final notaCalc = scores.total;
    final diferenca = notaCalc - curso.notaCorte;
    final percentual =
        (notaCalc / curso.notaCorte * 100).clamp(0, 200).toDouble();

    return SimulationResult(
      notaCalculada: notaCalc,
      notaCorte: curso.notaCorte,
      aprovado: notaCalc >= curso.notaCorte,
      diferenca: diferenca,
      percentualAtingido: percentual,
      mensagem: _gerarMensagem(diferenca, 'UNICAMP', curso.nome),
    );
  }

  // ─── UNESP ─────────────────────────────────────────────────────────────────

  /// Nota final UNESP = Fase1 + Redação + Discursiva
  double calcUnespTotal(UnespScores scores) => scores.notaFinal;

  SimulationResult simularUnesp({
    required UnespScores scores,
    required Course curso,
  }) {
    final notaCalc = scores.notaFinal;
    final diferenca = notaCalc - curso.notaCorte;
    final percentual =
        (notaCalc / curso.notaCorte * 100).clamp(0, 200).toDouble();

    return SimulationResult(
      notaCalculada: notaCalc,
      notaCorte: curso.notaCorte,
      aprovado: notaCalc >= curso.notaCorte,
      diferenca: diferenca,
      percentualAtingido: percentual,
      mensagem: _gerarMensagem(diferenca, 'UNESP', curso.nome),
    );
  }

  // ─── Funções utilitárias ────────────────────────────────────────────────────

  /// Retorna uma mensagem amigável baseada na diferença
  String _gerarMensagem(double diferenca, String vestibular, String curso) {
    if (diferenca >= 20) {
      return '🏆 Excelente! Você estaria bem acima da nota de corte para $curso ($vestibular).';
    } else if (diferenca >= 5) {
      return '✅ Aprovado! Sua nota está acima da nota de corte para $curso ($vestibular).';
    } else if (diferenca >= 0) {
      return '⚠️ Muito próximo! Você passaria em $curso ($vestibular), mas com margem pequena.';
    } else if (diferenca >= -15) {
      return '📚 Quase lá! Faltam ${diferenca.abs().toStringAsFixed(1)} pontos para $curso ($vestibular).';
    } else {
      return '💪 Ainda há caminho! Você precisa de ${diferenca.abs().toStringAsFixed(1)} pontos a mais para $curso ($vestibular).';
    }
  }

  /// Retorna a cor de status baseada no percentual atingido
  /// Use com AppTheme.accentGreen, .accentAmber, .accentRed
  String statusColor(double percentual) {
    if (percentual >= 100) return 'green';
    if (percentual >= 90) return 'amber';
    return 'red';
  }

  /// Formata uma nota com casas decimais configuráveis
  String formatarNota(double nota, {int decimais = 1}) {
    return nota.toStringAsFixed(decimais);
  }
}
