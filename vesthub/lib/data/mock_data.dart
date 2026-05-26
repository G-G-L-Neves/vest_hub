// lib/data/mock_data.dart
//
// Dados mockados de universidades e cursos.
// Em produção, substitua por uma API ou banco de dados.
// Os pesos e notas de corte são aproximações baseadas em dados históricos.

import '../models/models.dart';

// ─── Cursos SISU ──────────────────────────────────────────────────────────────
// Pesos: cada área tem peso entre 1 e 3 dependendo do curso
final List<SisuCourse> sisuCourses = [
  // ── Medicina ──────────────────────────────────────────────────────────────
  SisuCourse(
    id: 'sisu_med_ufpe',
    nome: 'Medicina',
    universidade: 'UFPE',
    cidade: 'Recife',
    uf: 'PE',
    turno: 'Integral',
    vagas: 120,
    notaCorte: 843.5,
    pesos: const SisuWeights(
      linguagens: 2, humanidades: 1, natureza: 3, matematica: 2, redacao: 3,
    ),
  ),
  SisuCourse(
    id: 'sisu_med_ufmg',
    nome: 'Medicina',
    universidade: 'UFMG',
    cidade: 'Belo Horizonte',
    uf: 'MG',
    turno: 'Integral',
    vagas: 150,
    notaCorte: 851.2,
    pesos: const SisuWeights(
      linguagens: 2, humanidades: 1, natureza: 3, matematica: 2, redacao: 3,
    ),
  ),
  SisuCourse(
    id: 'sisu_med_usp_sp',
    nome: 'Medicina',
    universidade: 'USP',
    cidade: 'São Paulo',
    uf: 'SP',
    turno: 'Integral',
    vagas: 60,
    notaCorte: 862.7,
    pesos: const SisuWeights(
      linguagens: 2, humanidades: 1, natureza: 3, matematica: 2, redacao: 3,
    ),
  ),

  // ── Direito ────────────────────────────────────────────────────────────────
  SisuCourse(
    id: 'sisu_dir_unb',
    nome: 'Direito',
    universidade: 'UnB',
    cidade: 'Brasília',
    uf: 'DF',
    turno: 'Diurno',
    vagas: 80,
    notaCorte: 791.4,
    pesos: const SisuWeights(
      linguagens: 3, humanidades: 3, natureza: 1, matematica: 1, redacao: 3,
    ),
  ),
  SisuCourse(
    id: 'sisu_dir_ufpe',
    nome: 'Direito',
    universidade: 'UFPE',
    cidade: 'Recife',
    uf: 'PE',
    turno: 'Diurno',
    vagas: 100,
    notaCorte: 763.2,
    pesos: const SisuWeights(
      linguagens: 3, humanidades: 3, natureza: 1, matematica: 1, redacao: 3,
    ),
  ),

  // ── Engenharia ─────────────────────────────────────────────────────────────
  SisuCourse(
    id: 'sisu_eng_ita',
    nome: 'Engenharia Aeronáutica',
    universidade: 'ITA',
    cidade: 'São José dos Campos',
    uf: 'SP',
    turno: 'Integral',
    vagas: 30,
    notaCorte: 812.0,
    pesos: const SisuWeights(
      linguagens: 1, humanidades: 1, natureza: 3, matematica: 3, redacao: 2,
    ),
  ),
  SisuCourse(
    id: 'sisu_eng_ufmg',
    nome: 'Engenharia de Computação',
    universidade: 'UFMG',
    cidade: 'Belo Horizonte',
    uf: 'MG',
    turno: 'Integral',
    vagas: 80,
    notaCorte: 745.8,
    pesos: const SisuWeights(
      linguagens: 1, humanidades: 1, natureza: 2, matematica: 3, redacao: 2,
    ),
  ),

  // ── Psicologia ─────────────────────────────────────────────────────────────
  SisuCourse(
    id: 'sisu_psi_ufba',
    nome: 'Psicologia',
    universidade: 'UFBA',
    cidade: 'Salvador',
    uf: 'BA',
    turno: 'Integral',
    vagas: 60,
    notaCorte: 723.1,
    pesos: const SisuWeights(
      linguagens: 3, humanidades: 2, natureza: 1, matematica: 1, redacao: 3,
    ),
  ),

  // ── Arquitetura ────────────────────────────────────────────────────────────
  SisuCourse(
    id: 'sisu_arq_usp',
    nome: 'Arquitetura e Urbanismo',
    universidade: 'USP',
    cidade: 'São Paulo',
    uf: 'SP',
    turno: 'Integral',
    vagas: 90,
    notaCorte: 798.5,
    pesos: const SisuWeights(
      linguagens: 2, humanidades: 2, natureza: 2, matematica: 2, redacao: 3,
    ),
  ),

  // ── Administração ──────────────────────────────────────────────────────────
  SisuCourse(
    id: 'sisu_adm_ufrj',
    nome: 'Administração',
    universidade: 'UFRJ',
    cidade: 'Rio de Janeiro',
    uf: 'RJ',
    turno: 'Diurno',
    vagas: 100,
    notaCorte: 708.3,
    pesos: const SisuWeights(
      linguagens: 2, humanidades: 2, natureza: 1, matematica: 2, redacao: 2,
    ),
  ),
];

// ─── Cursos FUVEST (USP) ──────────────────────────────────────────────────────
final List<Course> fuvestCourses = [
  const Course(
    id: 'fuv_med',
    nome: 'Medicina',
    universidade: 'USP - FMUSP',
    turno: 'Integral',
    notaCorte: 91.5,  // percentual aproveitamento (0-100)
    vagas: 70,
  ),
  const Course(
    id: 'fuv_dir',
    nome: 'Direito (Largo São Francisco)',
    universidade: 'USP',
    turno: 'Diurno',
    notaCorte: 85.2,
    vagas: 100,
  ),
  const Course(
    id: 'fuv_poli',
    nome: 'Engenharia (Poli)',
    universidade: 'USP',
    turno: 'Integral',
    notaCorte: 78.6,
    vagas: 300,
  ),
  const Course(
    id: 'fuv_fea',
    nome: 'Economia (FEA)',
    universidade: 'USP',
    turno: 'Diurno',
    notaCorte: 74.8,
    vagas: 120,
  ),
  const Course(
    id: 'fuv_psico',
    nome: 'Psicologia',
    universidade: 'USP',
    turno: 'Integral',
    notaCorte: 72.3,
    vagas: 60,
  ),
  const Course(
    id: 'fuv_fau',
    nome: 'Arquitetura e Urbanismo (FAU)',
    universidade: 'USP',
    turno: 'Integral',
    notaCorte: 76.1,
    vagas: 70,
  ),
  const Course(
    id: 'fuv_comp',
    nome: 'Ciências da Computação',
    universidade: 'USP',
    turno: 'Diurno',
    notaCorte: 69.4,
    vagas: 80,
  ),
];

// ─── Cursos UNICAMP ───────────────────────────────────────────────────────────
final List<Course> unicampCourses = [
  const Course(
    id: 'uni_med',
    nome: 'Medicina',
    universidade: 'UNICAMP - FCM',
    turno: 'Integral',
    notaCorte: 292.4,  // soma das fases
    vagas: 80,
  ),
  const Course(
    id: 'uni_eng_comp',
    nome: 'Engenharia de Computação',
    universidade: 'UNICAMP - FEEC',
    turno: 'Integral',
    notaCorte: 241.7,
    vagas: 50,
  ),
  const Course(
    id: 'uni_dir',
    nome: 'Direito',
    universidade: 'UNICAMP - FD',
    turno: 'Diurno',
    notaCorte: 255.3,
    vagas: 60,
  ),
  const Course(
    id: 'uni_eco',
    nome: 'Ciências Econômicas',
    universidade: 'UNICAMP - IE',
    turno: 'Diurno',
    notaCorte: 234.8,
    vagas: 60,
  ),
  const Course(
    id: 'uni_mat',
    nome: 'Matemática',
    universidade: 'UNICAMP - IMECC',
    turno: 'Diurno',
    notaCorte: 218.9,
    vagas: 40,
  ),
];

// ─── Cursos UNESP (VUNESP) ────────────────────────────────────────────────────
final List<Course> unespCourses = [
  const Course(
    id: 'une_med_bot',
    nome: 'Medicina',
    universidade: 'UNESP - Botucatu',
    turno: 'Integral',
    notaCorte: 155.8,  // sobre 198
    vagas: 90,
  ),
  const Course(
    id: 'une_dir_fri',
    nome: 'Direito',
    universidade: 'UNESP - Franca',
    turno: 'Diurno',
    notaCorte: 138.2,
    vagas: 80,
  ),
  const Course(
    id: 'une_arq',
    nome: 'Arquitetura e Urbanismo',
    universidade: 'UNESP - Bauru',
    turno: 'Integral',
    notaCorte: 129.7,
    vagas: 50,
  ),
  const Course(
    id: 'une_comp',
    nome: 'Ciências da Computação',
    universidade: 'UNESP - São José do Rio Preto',
    turno: 'Diurno',
    notaCorte: 118.5,
    vagas: 60,
  ),
  const Course(
    id: 'une_agr',
    nome: 'Agronomia',
    universidade: 'UNESP - Jaboticabal',
    turno: 'Integral',
    notaCorte: 109.3,
    vagas: 70,
  ),
];

// ─── Cursos SSA (UPE) ─────────────────────────────────────────────────────────
final List<Course> ssaCourses = [
  const Course(
    id: 'ssa_med',
    nome: 'Medicina',
    universidade: 'UPE - Campus Recife',
    turno: 'Integral',
    notaCorte: 86.4,   // sobre 100
    vagas: 60,
  ),
  const Course(
    id: 'ssa_enf',
    nome: 'Enfermagem',
    universidade: 'UPE - Campus Recife',
    turno: 'Integral',
    notaCorte: 71.2,
    vagas: 40,
  ),
  const Course(
    id: 'ssa_sis',
    nome: 'Sistemas de Informação',
    universidade: 'UPE - Campus Caruaru',
    turno: 'Noturno',
    notaCorte: 65.8,
    vagas: 50,
  ),
  const Course(
    id: 'ssa_edu',
    nome: 'Pedagogia',
    universidade: 'UPE - Campus Petrolina',
    turno: 'Noturno',
    notaCorte: 58.3,
    vagas: 45,
  ),
  const Course(
    id: 'ssa_odi',
    nome: 'Odontologia',
    universidade: 'UPE - Campus Recife',
    turno: 'Integral',
    notaCorte: 79.6,
    vagas: 55,
  ),
];

// ─── Cursos PAS UnB ───────────────────────────────────────────────────────────
final List<Course> pasCourses = [
  const Course(
    id: 'pas_med',
    nome: 'Medicina',
    universidade: 'UnB',
    turno: 'Integral',
    notaCorte: 88.7,   // sobre 100
    vagas: 30,
  ),
  const Course(
    id: 'pas_dir',
    nome: 'Direito',
    universidade: 'UnB',
    turno: 'Diurno',
    notaCorte: 79.2,
    vagas: 40,
  ),
  const Course(
    id: 'pas_comp',
    nome: 'Ciência da Computação',
    universidade: 'UnB',
    turno: 'Diurno',
    notaCorte: 72.8,
    vagas: 50,
  ),
  const Course(
    id: 'pas_arq',
    nome: 'Arquitetura e Urbanismo',
    universidade: 'UnB',
    turno: 'Integral',
    notaCorte: 75.4,
    vagas: 40,
  ),
  const Course(
    id: 'pas_adm',
    nome: 'Administração',
    universidade: 'UnB',
    turno: 'Diurno',
    notaCorte: 68.1,
    vagas: 60,
  ),
  const Course(
    id: 'pas_eng_elet',
    nome: 'Engenharia Elétrica',
    universidade: 'UnB',
    turno: 'Integral',
    notaCorte: 74.6,
    vagas: 50,
  ),
];

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Retorna a lista de cursos para cada tipo de vestibular
List<Course> getCoursesByType(String tipo) {
  switch (tipo) {
    case 'fuvest': return fuvestCourses;
    case 'unicamp': return unicampCourses;
    case 'unesp': return unespCourses;
    case 'ssa': return ssaCourses;
    case 'pas': return pasCourses;
    default: return [];
  }
}

/// Filtra cursos SISU por nome ou universidade
List<SisuCourse> searchSisuCourses(String query) {
  if (query.isEmpty) return sisuCourses;
  final q = query.toLowerCase();
  return sisuCourses.where((c) {
    return c.nome.toLowerCase().contains(q) ||
        c.universidade.toLowerCase().contains(q) ||
        c.cidade.toLowerCase().contains(q);
  }).toList();
}
