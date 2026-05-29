// lib/services/calc_service.dart — cálculos usando fórmulas do Firestore

import '../models/formula_config.dart';
import '../models/models.dart';

class CalcService {
  static const CalcService instance = CalcService._();
  const CalcService._();

  double calcEnemMedia(EnemScores scores, ExamFormulas formulas) {
    final e = formulas.enem;
    final numerador = (scores.linguagens * e.pesoLinguagens) +
        (scores.humanidades * e.pesoHumanidades) +
        (scores.natureza * e.pesoNatureza) +
        (scores.matematica * e.pesoMatematica) +
        (scores.redacao * e.pesoRedacao);
    return numerador / e.totalPeso;
  }

  Map<String, double> calcEnemMeta({
    required EnemScores scores,
    required double metaMedia,
    required ExamFormulas formulas,
  }) {
    final e = formulas.enem;
    final total = metaMedia * e.totalPeso;
    final atual = (scores.linguagens * e.pesoLinguagens) +
        (scores.humanidades * e.pesoHumanidades) +
        (scores.natureza * e.pesoNatureza) +
        (scores.matematica * e.pesoMatematica) +
        (scores.redacao * e.pesoRedacao);
    final falta = (total - atual).clamp(0, e.notaMaxima * e.totalPeso);
    return {
      'falta': falta.toDouble(),
      'mediaFalta': falta / e.totalPeso,
      'atual': atual,
      'meta': total,
    };
  }

  double calcSisuNota(EnemScores scores, SisuWeights pesos) =>
      pesos.calcularMedia(scores);

  SimulationResult simularSisu({
    required EnemScores scores,
    required SisuCourse curso,
  }) {
    final notaCalc = calcSisuNota(scores, curso.pesos);
    return _resultado(notaCalc, curso.notaCorte, 'SISU', curso.nome);
  }

  double calcSsaMedia(SsaScores scores, ExamFormulas formulas) {
    final s = formulas.ssa;
    return (scores.ssa1 * s.pesoFase1 +
            scores.ssa2 * s.pesoFase2 +
            scores.ssa3 * s.pesoFase3) /
        s.totalPeso;
  }

  SimulationResult simularSsa({
    required SsaScores scores,
    required Course curso,
    required ExamFormulas formulas,
  }) {
    final notaCalc = calcSsaMedia(scores, formulas);
    return _resultado(notaCalc, curso.notaCorte, 'SSA/UPE', curso.nome);
  }

  double calcPasMedia(PasScores scores, ExamFormulas formulas) {
    final p = formulas.pas;
    return (scores.sub1 * p.pesoFase1 +
            scores.sub2 * p.pesoFase2 +
            scores.sub3 * p.pesoFase3) /
        p.totalPeso;
  }

  SimulationResult simularPas({
    required PasScores scores,
    required Course curso,
    required ExamFormulas formulas,
  }) {
    final notaCalc = calcPasMedia(scores, formulas);
    return _resultado(notaCalc, curso.notaCorte, 'PAS UnB', curso.nome);
  }

  double calcFuvestNota(FuvestScores scores, ExamFormulas formulas) {
    final f = formulas.fuvest;
    final fase1Pct = (scores.fase1Total / f.fase1MaxTotal) * 100;
    return fase1Pct * f.pesoFase1 + scores.fase2Total * f.pesoFase2;
  }

  SimulationResult simularFuvest({
    required FuvestScores scores,
    required Course curso,
    required ExamFormulas formulas,
  }) {
    final notaCalc = calcFuvestNota(scores, formulas);
    return _resultado(notaCalc, curso.notaCorte, 'FUVEST', curso.nome);
  }

  double calcUnicampTotal(UnicampScores scores) =>
      scores.fase1 + scores.fase2Total;

  SimulationResult simularUnicamp({
    required UnicampScores scores,
    required Course curso,
  }) {
    final notaCalc = calcUnicampTotal(scores);
    return _resultado(notaCalc, curso.notaCorte, 'UNICAMP', curso.nome);
  }

  double calcUnespTotal(UnespScores scores) =>
      scores.fase1 + scores.redacao + scores.fase2Disc;

  SimulationResult simularUnesp({
    required UnespScores scores,
    required Course curso,
  }) {
    final notaCalc = calcUnespTotal(scores);
    return _resultado(notaCalc, curso.notaCorte, 'UNESP', curso.nome);
  }

  SimulationResult _resultado(
    double notaCalc,
    double notaCorte,
    String vestibular,
    String curso,
  ) {
    final diferenca = notaCalc - notaCorte;
    final percentual =
        (notaCalc / notaCorte * 100).clamp(0, 200).toDouble();
    return SimulationResult(
      notaCalculada: notaCalc,
      notaCorte: notaCorte,
      aprovado: notaCalc >= notaCorte,
      diferenca: diferenca,
      percentualAtingido: percentual,
      mensagem: _gerarMensagem(diferenca, vestibular, curso),
    );
  }

  String _gerarMensagem(double diferenca, String vestibular, String curso) {
    if (diferenca >= 20) {
      return 'Excelente! Você estaria bem acima da nota de corte para $curso ($vestibular).';
    } else if (diferenca >= 5) {
      return 'Aprovado! Sua nota está acima da nota de corte para $curso ($vestibular).';
    } else if (diferenca >= 0) {
      return 'Muito próximo! Você passaria em $curso ($vestibular), mas com margem pequena.';
    } else if (diferenca >= -15) {
      return 'Quase lá! Faltam ${diferenca.abs().toStringAsFixed(1)} pontos para $curso ($vestibular).';
    } else {
      return 'Ainda há caminho! Você precisa de ${diferenca.abs().toStringAsFixed(1)} pontos a mais para $curso ($vestibular).';
    }
  }

  String statusColor(double percentual) {
    if (percentual >= 100) return 'green';
    if (percentual >= 90) return 'amber';
    return 'red';
  }

  String formatarNota(double nota, {int decimais = 1}) =>
      nota.toStringAsFixed(decimais);
}
