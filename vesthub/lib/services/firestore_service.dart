// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._();
  FirestoreService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Future<List<SisuCourse>> getSisuCourses() async {
    try {
      final snap = await _db
          .collection('cursos')
          .doc('sisu')
          .collection('items')
          .orderBy('notaCorte', descending: true)
          .get();

      if (snap.docs.isEmpty) return sisuCourses;

      return snap.docs.map((doc) {
        final d = doc.data();
        return SisuCourse(
          id: doc.id,
          nome: d['nome'] as String,
          universidade: d['universidade'] as String,
          cidade: d['cidade'] as String,
          uf: d['uf'] as String,
          turno: d['turno'] as String,
          vagas: (d['vagas'] as num).toInt(),
          notaCorte: (d['notaCorte'] as num).toDouble(),
          modalidade: d['modalidade'] as String? ?? 'ampla_concorrencia',
          pesos: SisuWeights(
            linguagens: (d['pesoLinguagens'] as num?)?.toDouble() ?? 1,
            humanidades: (d['pesoHumanidades'] as num?)?.toDouble() ?? 1,
            natureza: (d['pesoNatureza'] as num?)?.toDouble() ?? 1,
            matematica: (d['pesoMatematica'] as num?)?.toDouble() ?? 1,
            redacao: (d['pesoRedacao'] as num?)?.toDouble() ?? 1,
          ),
        );
      }).toList();
    } catch (e) {
      return sisuCourses;
    }
  }

  Future<List<Course>> getCourses(String tipo) async {
    try {
      final snap = await _db
          .collection('cursos')
          .doc(tipo)
          .collection('items')
          .orderBy('notaCorte', descending: true)
          .get();

      if (snap.docs.isEmpty) return _fallback(tipo);

      return snap.docs.map((doc) {
        final d = doc.data();
        return Course(
          id: doc.id,
          nome: d['nome'] as String,
          universidade: d['universidade'] as String,
          turno: d['turno'] as String,
          notaCorte: (d['notaCorte'] as num).toDouble(),
          vagas: (d['vagas'] as num).toInt(),
        );
      }).toList();
    } catch (e) {
      return _fallback(tipo);
    }
  }

  List<Course> _fallback(String tipo) {
    switch (tipo) {
      case 'fuvest': return fuvestCourses;
      case 'unicamp': return unicampCourses;
      case 'unesp': return unespCourses;
      case 'ssa': return ssaCourses;
      case 'pas': return pasCourses;
      default: return [];
    }
  }

  Future<void> seedDatabase() async {
    try {
      final batch1 = _db.batch();
      for (final curso in sisuCourses) {
        final ref = _db.collection('cursos').doc('sisu').collection('items').doc(curso.id);
        batch1.set(ref, {
          'nome': curso.nome,
          'universidade': curso.universidade,
          'cidade': curso.cidade,
          'uf': curso.uf,
          'turno': curso.turno,
          'vagas': curso.vagas,
          'notaCorte': curso.notaCorte,
          'modalidade': curso.modalidade,
          'pesoLinguagens': curso.pesos.linguagens,
          'pesoHumanidades': curso.pesos.humanidades,
          'pesoNatureza': curso.pesos.natureza,
          'pesoMatematica': curso.pesos.matematica,
          'pesoRedacao': curso.pesos.redacao,
        });
      }
      await batch1.commit();

      for (final entry in {
        'fuvest': fuvestCourses,
        'unicamp': unicampCourses,
        'unesp': unespCourses,
        'ssa': ssaCourses,
        'pas': pasCourses,
      }.entries) {
        final batch = _db.batch();
        for (final curso in entry.value) {
          final ref = _db.collection('cursos').doc(entry.key).collection('items').doc(curso.id);
          batch.set(ref, {
            'nome': curso.nome,
            'universidade': curso.universidade,
            'turno': curso.turno,
            'vagas': curso.vagas,
            'notaCorte': curso.notaCorte,
          });
        }
        await batch.commit();
      }
    } catch (e) {
      // ignore seed errors silently
    }
  }
}
