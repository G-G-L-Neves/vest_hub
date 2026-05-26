// lib/models/models.dart
//
// Todos os modelos de dados do VestHub em um único arquivo.
// Cada classe representa um conceito do domínio do app.
// Usamos fromJson/toJson para salvar e carregar do armazenamento local.

/// Notas do ENEM (5 áreas + redação)
class EnemScores {
  final double linguagens;       // Linguagens e Códigos
  final double humanidades;      // Ciências Humanas
  final double natureza;         // Ciências da Natureza
  final double matematica;       // Matemática
  final double redacao;          // Redação (0-1000)

  const EnemScores({
    this.linguagens = 0,
    this.humanidades = 0,
    this.natureza = 0,
    this.matematica = 0,
    this.redacao = 0,
  });

  /// Média simples das 5 áreas
  double get media =>
      (linguagens + humanidades + natureza + matematica + redacao) / 5;

  /// Cria uma cópia com campos atualizados
  EnemScores copyWith({
    double? linguagens,
    double? humanidades,
    double? natureza,
    double? matematica,
    double? redacao,
  }) {
    return EnemScores(
      linguagens: linguagens ?? this.linguagens,
      humanidades: humanidades ?? this.humanidades,
      natureza: natureza ?? this.natureza,
      matematica: matematica ?? this.matematica,
      redacao: redacao ?? this.redacao,
    );
  }

  Map<String, dynamic> toJson() => {
        'linguagens': linguagens,
        'humanidades': humanidades,
        'natureza': natureza,
        'matematica': matematica,
        'redacao': redacao,
      };

  factory EnemScores.fromJson(Map<String, dynamic> json) => EnemScores(
        linguagens: (json['linguagens'] as num?)?.toDouble() ?? 0,
        humanidades: (json['humanidades'] as num?)?.toDouble() ?? 0,
        natureza: (json['natureza'] as num?)?.toDouble() ?? 0,
        matematica: (json['matematica'] as num?)?.toDouble() ?? 0,
        redacao: (json['redacao'] as num?)?.toDouble() ?? 0,
      );
}

/// Pesos das áreas do ENEM para um curso específico no SISU
class SisuWeights {
  final double linguagens;
  final double humanidades;
  final double natureza;
  final double matematica;
  final double redacao;

  const SisuWeights({
    this.linguagens = 1.0,
    this.humanidades = 1.0,
    this.natureza = 1.0,
    this.matematica = 1.0,
    this.redacao = 1.0,
  });

  double get totalPeso =>
      linguagens + humanidades + natureza + matematica + redacao;

  /// Calcula a média ponderada com os pesos deste curso
  double calcularMedia(EnemScores notas) {
    final numerador = (notas.linguagens * linguagens) +
        (notas.humanidades * humanidades) +
        (notas.natureza * natureza) +
        (notas.matematica * matematica) +
        (notas.redacao * redacao);
    return numerador / totalPeso;
  }

  Map<String, dynamic> toJson() => {
        'linguagens': linguagens,
        'humanidades': humanidades,
        'natureza': natureza,
        'matematica': matematica,
        'redacao': redacao,
      };

  factory SisuWeights.fromJson(Map<String, dynamic> json) => SisuWeights(
        linguagens: (json['linguagens'] as num?)?.toDouble() ?? 1.0,
        humanidades: (json['humanidades'] as num?)?.toDouble() ?? 1.0,
        natureza: (json['natureza'] as num?)?.toDouble() ?? 1.0,
        matematica: (json['matematica'] as num?)?.toDouble() ?? 1.0,
        redacao: (json['redacao'] as num?)?.toDouble() ?? 1.0,
      );
}

/// Um curso disponível no SISU com a nota de corte histórica
class SisuCourse {
  final String id;
  final String nome;
  final String universidade;
  final String cidade;
  final String uf;
  final String turno;
  final int vagas;
  final double notaCorte;       // nota de corte do último SISU
  final SisuWeights pesos;
  final String modalidade;      // 'ampla_concorrencia', 'cotas'

  const SisuCourse({
    required this.id,
    required this.nome,
    required this.universidade,
    required this.cidade,
    required this.uf,
    required this.turno,
    required this.vagas,
    required this.notaCorte,
    required this.pesos,
    this.modalidade = 'ampla_concorrencia',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'universidade': universidade,
        'cidade': cidade,
        'uf': uf,
        'turno': turno,
        'vagas': vagas,
        'notaCorte': notaCorte,
        'pesos': pesos.toJson(),
        'modalidade': modalidade,
      };

  factory SisuCourse.fromJson(Map<String, dynamic> json) => SisuCourse(
        id: json['id'] as String,
        nome: json['nome'] as String,
        universidade: json['universidade'] as String,
        cidade: json['cidade'] as String,
        uf: json['uf'] as String,
        turno: json['turno'] as String,
        vagas: json['vagas'] as int,
        notaCorte: (json['notaCorte'] as num).toDouble(),
        pesos: SisuWeights.fromJson(json['pesos'] as Map<String, dynamic>),
        modalidade: json['modalidade'] as String? ?? 'ampla_concorrencia',
      );
}

/// Notas da SSA (Seleção Seriada da UPE) — 3 fases
class SsaScores {
  final double ssa1;  // 1ª fase (0-100)
  final double ssa2;  // 2ª fase (0-100)
  final double ssa3;  // 3ª fase (0-100)

  const SsaScores({
    this.ssa1 = 0,
    this.ssa2 = 0,
    this.ssa3 = 0,
  });

  /// Fórmula oficial: SSA1×1 + SSA2×2 + SSA3×3 / 6
  double get mediaPonderada => (ssa1 * 1 + ssa2 * 2 + ssa3 * 3) / 6;

  SsaScores copyWith({double? ssa1, double? ssa2, double? ssa3}) {
    return SsaScores(
      ssa1: ssa1 ?? this.ssa1,
      ssa2: ssa2 ?? this.ssa2,
      ssa3: ssa3 ?? this.ssa3,
    );
  }

  Map<String, dynamic> toJson() => {
        'ssa1': ssa1,
        'ssa2': ssa2,
        'ssa3': ssa3,
      };

  factory SsaScores.fromJson(Map<String, dynamic> json) => SsaScores(
        ssa1: (json['ssa1'] as num?)?.toDouble() ?? 0,
        ssa2: (json['ssa2'] as num?)?.toDouble() ?? 0,
        ssa3: (json['ssa3'] as num?)?.toDouble() ?? 0,
      );
}

/// Notas do PAS UnB — 3 subprogramas
class PasScores {
  final double sub1;   // 1º Subprograma (0-100)
  final double sub2;   // 2º Subprograma (0-100)
  final double sub3;   // 3º Subprograma (0-100)

  const PasScores({
    this.sub1 = 0,
    this.sub2 = 0,
    this.sub3 = 0,
  });

  /// Fórmula oficial: SUB1×1 + SUB2×2 + SUB3×3 / 6
  double get mediaPonderada => (sub1 * 1 + sub2 * 2 + sub3 * 3) / 6;

  PasScores copyWith({double? sub1, double? sub2, double? sub3}) {
    return PasScores(
      sub1: sub1 ?? this.sub1,
      sub2: sub2 ?? this.sub2,
      sub3: sub3 ?? this.sub3,
    );
  }

  Map<String, dynamic> toJson() => {
        'sub1': sub1,
        'sub2': sub2,
        'sub3': sub3,
      };

  factory PasScores.fromJson(Map<String, dynamic> json) => PasScores(
        sub1: (json['sub1'] as num?)?.toDouble() ?? 0,
        sub2: (json['sub2'] as num?)?.toDouble() ?? 0,
        sub3: (json['sub3'] as num?)?.toDouble() ?? 0,
      );
}

/// Notas da FUVEST (2 fases)
class FuvestScores {
  final double portugues;       // Fase 1 - Português (0-15)
  final double matematica;      // Fase 1 - Matemática (0-15)
  final double ciencias;        // Fase 1 - Ciências (0-15)
  final double historia;        // Fase 1 - História/Geo (0-15)
  final double fase2Total;      // Fase 2 - Total (0-100)
  final double redacao;         // Redação Fase 2 (0-100)

  const FuvestScores({
    this.portugues = 0,
    this.matematica = 0,
    this.ciencias = 0,
    this.historia = 0,
    this.fase2Total = 0,
    this.redacao = 0,
  });

  double get fase1Total => portugues + matematica + ciencias + historia;
  // Nota final FUVEST: Fase 1 convertida + Fase 2
  double get notaFinal => (fase1Total / 60) * 100 * 0.3 + fase2Total * 0.7;

  FuvestScores copyWith({
    double? portugues,
    double? matematica,
    double? ciencias,
    double? historia,
    double? fase2Total,
    double? redacao,
  }) {
    return FuvestScores(
      portugues: portugues ?? this.portugues,
      matematica: matematica ?? this.matematica,
      ciencias: ciencias ?? this.ciencias,
      historia: historia ?? this.historia,
      fase2Total: fase2Total ?? this.fase2Total,
      redacao: redacao ?? this.redacao,
    );
  }

  Map<String, dynamic> toJson() => {
        'portugues': portugues,
        'matematica': matematica,
        'ciencias': ciencias,
        'historia': historia,
        'fase2Total': fase2Total,
        'redacao': redacao,
      };

  factory FuvestScores.fromJson(Map<String, dynamic> json) => FuvestScores(
        portugues: (json['portugues'] as num?)?.toDouble() ?? 0,
        matematica: (json['matematica'] as num?)?.toDouble() ?? 0,
        ciencias: (json['ciencias'] as num?)?.toDouble() ?? 0,
        historia: (json['historia'] as num?)?.toDouble() ?? 0,
        fase2Total: (json['fase2Total'] as num?)?.toDouble() ?? 0,
        redacao: (json['redacao'] as num?)?.toDouble() ?? 0,
      );
}

/// Notas da UNICAMP (COMVEST)
class UnicampScores {
  final double fase1;     // Fase 1 (0-144 pontos, 72 questões)
  final double redacao;   // Redação (0-12)
  final double disc1;     // Disciplina específica 1 (0-72)
  final double disc2;     // Disciplina específica 2 (0-72)

  const UnicampScores({
    this.fase1 = 0,
    this.redacao = 0,
    this.disc1 = 0,
    this.disc2 = 0,
  });

  /// Nota fase 2 = redação + disc1 + disc2
  double get fase2Total => redacao + disc1 + disc2;

  /// Total geral
  double get total => fase1 + fase2Total;

  UnicampScores copyWith({
    double? fase1,
    double? redacao,
    double? disc1,
    double? disc2,
  }) {
    return UnicampScores(
      fase1: fase1 ?? this.fase1,
      redacao: redacao ?? this.redacao,
      disc1: disc1 ?? this.disc1,
      disc2: disc2 ?? this.disc2,
    );
  }

  Map<String, dynamic> toJson() => {
        'fase1': fase1,
        'redacao': redacao,
        'disc1': disc1,
        'disc2': disc2,
      };

  factory UnicampScores.fromJson(Map<String, dynamic> json) => UnicampScores(
        fase1: (json['fase1'] as num?)?.toDouble() ?? 0,
        redacao: (json['redacao'] as num?)?.toDouble() ?? 0,
        disc1: (json['disc1'] as num?)?.toDouble() ?? 0,
        disc2: (json['disc2'] as num?)?.toDouble() ?? 0,
      );
}

/// Notas da UNESP (VUNESP)
class UnespScores {
  final double fase1;       // Fase 1 objetiva (0-72)
  final double redacao;     // Redação (0-30)
  final double fase2Disc;   // Fase 2 discursiva (0-96, 4 questões × 24)

  const UnespScores({
    this.fase1 = 0,
    this.redacao = 0,
    this.fase2Disc = 0,
  });

  /// Nota final (fase1 + redação + discursiva)
  double get notaFinal => fase1 + redacao + fase2Disc;
  double get notaMaxima => 72 + 30 + 96; // 198

  UnespScores copyWith({
    double? fase1,
    double? redacao,
    double? fase2Disc,
  }) {
    return UnespScores(
      fase1: fase1 ?? this.fase1,
      redacao: redacao ?? this.redacao,
      fase2Disc: fase2Disc ?? this.fase2Disc,
    );
  }

  Map<String, dynamic> toJson() => {
        'fase1': fase1,
        'redacao': redacao,
        'fase2Disc': fase2Disc,
      };

  factory UnespScores.fromJson(Map<String, dynamic> json) => UnespScores(
        fase1: (json['fase1'] as num?)?.toDouble() ?? 0,
        redacao: (json['redacao'] as num?)?.toDouble() ?? 0,
        fase2Disc: (json['fase2Disc'] as num?)?.toDouble() ?? 0,
      );
}

/// Um curso com nota de corte (usado em FUVEST, UNICAMP, UNESP, SSA, PAS)
class Course {
  final String id;
  final String nome;
  final String universidade;
  final String turno;
  final double notaCorte;    // nota de corte histórica
  final int vagas;

  const Course({
    required this.id,
    required this.nome,
    required this.universidade,
    required this.turno,
    required this.notaCorte,
    required this.vagas,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'universidade': universidade,
        'turno': turno,
        'notaCorte': notaCorte,
        'vagas': vagas,
      };

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'] as String,
        nome: json['nome'] as String,
        universidade: json['universidade'] as String,
        turno: json['turno'] as String,
        notaCorte: (json['notaCorte'] as num).toDouble(),
        vagas: json['vagas'] as int,
      );
}

/// Resultado de uma simulação salva pelo usuário
class SavedSimulation {
  final String id;
  final String tipo;        // 'enem', 'sisu', 'ssa', 'pas', 'fuvest', 'unicamp', 'unesp'
  final String titulo;      // nome amigável dado pelo usuário
  final DateTime criadoEm;
  final Map<String, dynamic> dados;  // dados específicos de cada simulação

  const SavedSimulation({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.criadoEm,
    required this.dados,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'titulo': titulo,
        'criadoEm': criadoEm.toIso8601String(),
        'dados': dados,
      };

  factory SavedSimulation.fromJson(Map<String, dynamic> json) =>
      SavedSimulation(
        id: json['id'] as String,
        tipo: json['tipo'] as String,
        titulo: json['titulo'] as String,
        criadoEm: DateTime.parse(json['criadoEm'] as String),
        dados: json['dados'] as Map<String, dynamic>,
      );
}

/// Resultado da simulação (para exibir na tela)
class SimulationResult {
  final double notaCalculada;
  final double notaCorte;
  final bool aprovado;
  final double diferenca;       // notaCalculada - notaCorte
  final double percentualAtingido;  // notaCalculada / notaCorte * 100
  final String mensagem;

  const SimulationResult({
    required this.notaCalculada,
    required this.notaCorte,
    required this.aprovado,
    required this.diferenca,
    required this.percentualAtingido,
    required this.mensagem,
  });
}
