// lib/services/firestore_service.dart — cursos e notas de corte via Firestore

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/formula_config.dart';
import '../models/models.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._();
  FirestoreService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _items(String vestibular) =>
      _db.collection('cursos').doc(vestibular).collection('items');

  Future<List<SisuCourse>> getSisuCourses() async {
    final snap = await _items('sisu').orderBy('notaCorte', descending: true).get();
    return snap.docs.map(_parseSisuDoc).toList();
  }

  Future<List<Course>> getCourses(String tipo) async {
    final snap = await _items(tipo).orderBy('notaCorte', descending: true).get();
    return snap.docs.map(_parseCourseDoc).toList();
  }

  Stream<List<SisuCourse>> watchSisuCourses() {
    return _items('sisu')
        .orderBy('notaCorte', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_parseSisuDoc).toList());
  }

  Stream<List<Course>> watchCourses(String tipo) {
    return _items(tipo)
        .orderBy('notaCorte', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_parseCourseDoc).toList());
  }

  Future<ExamFormulas> getFormulas() async {
    final doc = await _db.collection('config').doc('formulas').get();
    return ExamFormulas.fromJson(doc.data());
  }

  Stream<ExamFormulas> watchFormulas() {
    return _db.collection('config').doc('formulas').snapshots().map(
          (doc) => ExamFormulas.fromJson(doc.data()),
        );
  }

  SisuCourse _parseSisuDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
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
  }

  Course _parseCourseDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Course(
      id: doc.id,
      nome: d['nome'] as String,
      universidade: d['universidade'] as String,
      turno: d['turno'] as String,
      notaCorte: (d['notaCorte'] as num).toDouble(),
      vagas: (d['vagas'] as num).toInt(),
    );
  }
}
