// tool/seed_firestore.dart
//
// Popula o Firestore com cursos e notas de corte (execução única / manutenção).
// Uso: flutter run -t tool/seed_firestore.dart -d chrome
//
// Depois disso, atualize notas de corte direto no Firebase Console —
// o app recebe as mudanças sem nova versão na loja.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'package:vesthub/models/formula_config.dart';
import 'package:vesthub/firebase_options.dart';
import 'seed_firestore_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final db = FirebaseFirestore.instance;
  print('Iniciando seed do Firestore (projeto vesthub-e465f)...');

  await db.collection('config').doc('formulas').set(ExamFormulas.defaults.toJson());
  print('Formulas: config/formulas');

  final sisuBatch = db.batch();
  for (final curso in sisuCourses) {
    final ref = db.collection('cursos').doc('sisu').collection('items').doc(curso.id);
    sisuBatch.set(ref, {
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
  await sisuBatch.commit();
  print('SISU: ${sisuCourses.length} cursos');

  for (final entry in {
    'fuvest': fuvestCourses,
    'unicamp': unicampCourses,
    'unesp': unespCourses,
    'ssa': ssaCourses,
    'pas': pasCourses,
  }.entries) {
    final batch = db.batch();
    for (final curso in entry.value) {
      final ref = db.collection('cursos').doc(entry.key).collection('items').doc(curso.id);
      batch.set(ref, {
        'nome': curso.nome,
        'universidade': curso.universidade,
        'turno': curso.turno,
        'vagas': curso.vagas,
        'notaCorte': curso.notaCorte,
      });
    }
    await batch.commit();
    print('${entry.key}: ${entry.value.length} cursos');
  }

  print('Seed concluído. Atualize notaCorte no Console quando necessário.');
}
