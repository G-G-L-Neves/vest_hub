// lib/models/formula_config.dart — fórmulas e pesos carregados do Firestore

class EnemFormulaConfig {
  final double pesoLinguagens;
  final double pesoHumanidades;
  final double pesoNatureza;
  final double pesoMatematica;
  final double pesoRedacao;
  final double notaMaxima;

  const EnemFormulaConfig({
    this.pesoLinguagens = 1,
    this.pesoHumanidades = 1,
    this.pesoNatureza = 1,
    this.pesoMatematica = 1,
    this.pesoRedacao = 1,
    this.notaMaxima = 1000,
  });

  double get totalPeso =>
      pesoLinguagens + pesoHumanidades + pesoNatureza + pesoMatematica + pesoRedacao;

  factory EnemFormulaConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const EnemFormulaConfig();
    return EnemFormulaConfig(
      pesoLinguagens: _num(json['pesoLinguagens'], 1),
      pesoHumanidades: _num(json['pesoHumanidades'], 1),
      pesoNatureza: _num(json['pesoNatureza'], 1),
      pesoMatematica: _num(json['pesoMatematica'], 1),
      pesoRedacao: _num(json['pesoRedacao'], 1),
      notaMaxima: _num(json['notaMaxima'], 1000),
    );
  }

  Map<String, dynamic> toJson() => {
        'pesoLinguagens': pesoLinguagens,
        'pesoHumanidades': pesoHumanidades,
        'pesoNatureza': pesoNatureza,
        'pesoMatematica': pesoMatematica,
        'pesoRedacao': pesoRedacao,
        'notaMaxima': notaMaxima,
      };
}

class PhasedFormulaConfig {
  final double pesoFase1;
  final double pesoFase2;
  final double pesoFase3;
  final double notaMaxima;

  const PhasedFormulaConfig({
    required this.pesoFase1,
    required this.pesoFase2,
    required this.pesoFase3,
    this.notaMaxima = 100,
  });

  double get totalPeso => pesoFase1 + pesoFase2 + pesoFase3;

  factory PhasedFormulaConfig.fromJson(Map<String, dynamic>? json, PhasedFormulaConfig fallback) {
    if (json == null) return fallback;
    return PhasedFormulaConfig(
      pesoFase1: _num(json['pesoFase1'], fallback.pesoFase1),
      pesoFase2: _num(json['pesoFase2'], fallback.pesoFase2),
      pesoFase3: _num(json['pesoFase3'], fallback.pesoFase3),
      notaMaxima: _num(json['notaMaxima'], fallback.notaMaxima),
    );
  }

  Map<String, dynamic> toJson() => {
        'pesoFase1': pesoFase1,
        'pesoFase2': pesoFase2,
        'pesoFase3': pesoFase3,
        'notaMaxima': notaMaxima,
      };
}

class FuvestFormulaConfig {
  final double questaoMax;
  final double fase1MaxTotal;
  final double pesoFase1;
  final double pesoFase2;
  final double fase2Max;
  final double redacaoMax;

  const FuvestFormulaConfig({
    this.questaoMax = 15,
    this.fase1MaxTotal = 60,
    this.pesoFase1 = 0.3,
    this.pesoFase2 = 0.7,
    this.fase2Max = 100,
    this.redacaoMax = 100,
  });

  factory FuvestFormulaConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FuvestFormulaConfig();
    return FuvestFormulaConfig(
      questaoMax: _num(json['questaoMax'], 15),
      fase1MaxTotal: _num(json['fase1MaxTotal'], 60),
      pesoFase1: _num(json['pesoFase1'], 0.3),
      pesoFase2: _num(json['pesoFase2'], 0.7),
      fase2Max: _num(json['fase2Max'], 100),
      redacaoMax: _num(json['redacaoMax'], 100),
    );
  }

  Map<String, dynamic> toJson() => {
        'questaoMax': questaoMax,
        'fase1MaxTotal': fase1MaxTotal,
        'pesoFase1': pesoFase1,
        'pesoFase2': pesoFase2,
        'fase2Max': fase2Max,
        'redacaoMax': redacaoMax,
      };
}

class UnicampFormulaConfig {
  final double fase1Max;
  final double redacaoMax;
  final double discMax;
  final double notaMaximaTotal;

  const UnicampFormulaConfig({
    this.fase1Max = 144,
    this.redacaoMax = 12,
    this.discMax = 72,
    this.notaMaximaTotal = 300,
  });

  factory UnicampFormulaConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const UnicampFormulaConfig();
    return UnicampFormulaConfig(
      fase1Max: _num(json['fase1Max'], 144),
      redacaoMax: _num(json['redacaoMax'], 12),
      discMax: _num(json['discMax'], 72),
      notaMaximaTotal: _num(json['notaMaximaTotal'], 300),
    );
  }

  Map<String, dynamic> toJson() => {
        'fase1Max': fase1Max,
        'redacaoMax': redacaoMax,
        'discMax': discMax,
        'notaMaximaTotal': notaMaximaTotal,
      };
}

class UnespFormulaConfig {
  final double fase1Max;
  final double redacaoMax;
  final double fase2DiscMax;
  final double notaMaxima;

  const UnespFormulaConfig({
    this.fase1Max = 72,
    this.redacaoMax = 30,
    this.fase2DiscMax = 96,
    this.notaMaxima = 198,
  });

  factory UnespFormulaConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const UnespFormulaConfig();
    return UnespFormulaConfig(
      fase1Max: _num(json['fase1Max'], 72),
      redacaoMax: _num(json['redacaoMax'], 30),
      fase2DiscMax: _num(json['fase2DiscMax'], 96),
      notaMaxima: _num(json['notaMaxima'], 198),
    );
  }

  Map<String, dynamic> toJson() => {
        'fase1Max': fase1Max,
        'redacaoMax': redacaoMax,
        'fase2DiscMax': fase2DiscMax,
        'notaMaxima': notaMaxima,
      };
}

class ExamFormulas {
  final EnemFormulaConfig enem;
  final PhasedFormulaConfig ssa;
  final PhasedFormulaConfig pas;
  final FuvestFormulaConfig fuvest;
  final UnicampFormulaConfig unicamp;
  final UnespFormulaConfig unesp;

  const ExamFormulas({
    required this.enem,
    required this.ssa,
    required this.pas,
    required this.fuvest,
    required this.unicamp,
    required this.unesp,
  });

  static const ExamFormulas defaults = ExamFormulas(
    enem: EnemFormulaConfig(),
    ssa: PhasedFormulaConfig(pesoFase1: 1, pesoFase2: 2, pesoFase3: 3),
    pas: PhasedFormulaConfig(pesoFase1: 1, pesoFase2: 2, pesoFase3: 3),
    fuvest: FuvestFormulaConfig(),
    unicamp: UnicampFormulaConfig(),
    unesp: UnespFormulaConfig(),
  );

  factory ExamFormulas.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ExamFormulas.defaults;
    return ExamFormulas(
      enem: EnemFormulaConfig.fromJson(json['enem'] as Map<String, dynamic>?),
      ssa: PhasedFormulaConfig.fromJson(
        json['ssa'] as Map<String, dynamic>?,
        ExamFormulas.defaults.ssa,
      ),
      pas: PhasedFormulaConfig.fromJson(
        json['pas'] as Map<String, dynamic>?,
        ExamFormulas.defaults.pas,
      ),
      fuvest: FuvestFormulaConfig.fromJson(json['fuvest'] as Map<String, dynamic>?),
      unicamp: UnicampFormulaConfig.fromJson(json['unicamp'] as Map<String, dynamic>?),
      unesp: UnespFormulaConfig.fromJson(json['unesp'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
        'enem': enem.toJson(),
        'ssa': ssa.toJson(),
        'pas': pas.toJson(),
        'fuvest': fuvest.toJson(),
        'unicamp': unicamp.toJson(),
        'unesp': unesp.toJson(),
      };
}

double _num(dynamic value, double fallback) =>
    value == null ? fallback : (value as num).toDouble();
