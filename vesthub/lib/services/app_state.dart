// lib/services/app_state.dart — v0.0.6 Firestore remoto

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/formula_config.dart';
import '../models/models.dart';
import 'firestore_service.dart';
import 'storage_service.dart';

class AppState extends ChangeNotifier {
  EnemScores _enemScores = const EnemScores();
  EnemScores get enemScores => _enemScores;

  List<SavedSimulation> _simulations = [];
  List<SavedSimulation> get simulations => _simulations;

  List<SisuCourse> _sisuCourses = [];
  List<Course> _fuvestCourses = [];
  List<Course> _unicampCourses = [];
  List<Course> _unespCourses = [];
  List<Course> _ssaCourses = [];
  List<Course> _pasCourses = [];

  List<SisuCourse> get sisuCourses => _sisuCourses;
  List<Course> get fuvestCourses => _fuvestCourses;
  List<Course> get unicampCourses => _unicampCourses;
  List<Course> get unespCourses => _unespCourses;
  List<Course> get ssaCourses => _ssaCourses;
  List<Course> get pasCourses => _pasCourses;

  ExamFormulas _formulas = ExamFormulas.defaults;
  ExamFormulas get formulas => _formulas;

  String _nomeUsuario = '';
  int _anoNascimento = 0;
  bool _onboardingCompleto = false;

  String get nomeUsuario => _nomeUsuario;
  int get anoNascimento => _anoNascimento;
  bool get onboardingCompleto => _onboardingCompleto;
  String get primeiroNome =>
      _nomeUsuario.isNotEmpty ? _nomeUsuario.split(' ').first : '';

  bool _cursosCarregados = false;
  String? _cursosErro;

  bool get cursosCarregados => _cursosCarregados;
  String? get cursosErro => _cursosErro;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<StreamSubscription<dynamic>> _courseSubscriptions = [];

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _nomeUsuario = prefs.getString('usuario_nome') ?? '';
    _anoNascimento = prefs.getInt('usuario_ano') ?? 0;
    _onboardingCompleto = prefs.getBool('onboarding_completo') ?? false;
    _enemScores = await StorageService.instance.loadEnemScores();
    _simulations = await StorageService.instance.loadSimulations();

    _isLoading = false;
    notifyListeners();

    await _loadCursosFirestore();
    _watchCursosFirestore();
    await _loadFormulas();
    _watchFormulas();
  }

  Future<void> _loadCursosFirestore() async {
    _cursosCarregados = false;
    _cursosErro = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        FirestoreService.instance.getSisuCourses(),
        FirestoreService.instance.getCourses('fuvest'),
        FirestoreService.instance.getCourses('unicamp'),
        FirestoreService.instance.getCourses('unesp'),
        FirestoreService.instance.getCourses('ssa'),
        FirestoreService.instance.getCourses('pas'),
      ]);

      _sisuCourses = results[0] as List<SisuCourse>;
      _fuvestCourses = results[1] as List<Course>;
      _unicampCourses = results[2] as List<Course>;
      _unespCourses = results[3] as List<Course>;
      _ssaCourses = results[4] as List<Course>;
      _pasCourses = results[5] as List<Course>;
      _cursosErro = null;
    } catch (e) {
      _cursosErro = 'Não foi possível carregar os cursos do Firebase.';
    } finally {
      _cursosCarregados = true;
      notifyListeners();
    }
  }

  void _watchCursosFirestore() {
    _cancelCourseSubscriptions();

    void onStreamError(Object _) {
      _cursosErro = 'Não foi possível sincronizar os cursos do Firebase.';
      notifyListeners();
    }

    _courseSubscriptions.addAll([
      FirestoreService.instance.watchSisuCourses().listen(
        (courses) {
          _sisuCourses = courses;
          _cursosErro = null;
          notifyListeners();
        },
        onError: onStreamError,
      ),
      FirestoreService.instance.watchCourses('fuvest').listen(
        (courses) {
          _fuvestCourses = courses;
          _cursosErro = null;
          notifyListeners();
        },
        onError: onStreamError,
      ),
      FirestoreService.instance.watchCourses('unicamp').listen(
        (courses) {
          _unicampCourses = courses;
          _cursosErro = null;
          notifyListeners();
        },
        onError: onStreamError,
      ),
      FirestoreService.instance.watchCourses('unesp').listen(
        (courses) {
          _unespCourses = courses;
          _cursosErro = null;
          notifyListeners();
        },
        onError: onStreamError,
      ),
      FirestoreService.instance.watchCourses('ssa').listen(
        (courses) {
          _ssaCourses = courses;
          _cursosErro = null;
          notifyListeners();
        },
        onError: onStreamError,
      ),
      FirestoreService.instance.watchCourses('pas').listen(
        (courses) {
          _pasCourses = courses;
          _cursosErro = null;
          notifyListeners();
        },
        onError: onStreamError,
      ),
    ]);
  }

  void _cancelCourseSubscriptions() {
    for (final sub in _courseSubscriptions) {
      sub.cancel();
    }
    _courseSubscriptions.clear();
  }

  Future<void> reloadCursos() => _loadCursosFirestore();

  Future<void> _loadFormulas() async {
    try {
      _formulas = await FirestoreService.instance.getFormulas();
    } catch (_) {
      _formulas = ExamFormulas.defaults;
    }
    notifyListeners();
  }

  void _watchFormulas() {
    _courseSubscriptions.add(
      FirestoreService.instance.watchFormulas().listen(
        (formulas) {
          _formulas = formulas;
          notifyListeners();
        },
        onError: (_) {},
      ),
    );
  }

  Future<void> completarOnboarding(String nome, int anoNascimento) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_nome', nome);
    await prefs.setInt('usuario_ano', anoNascimento);
    await prefs.setBool('onboarding_completo', true);
    _nomeUsuario = nome;
    _anoNascimento = anoNascimento;
    _onboardingCompleto = true;
    notifyListeners();
  }

  Future<void> updateEnemScores(EnemScores scores) async {
    _enemScores = scores;
    notifyListeners();
    await StorageService.instance.saveEnemScores(scores);
  }

  Future<void> saveSimulation({
    required String tipo,
    required String titulo,
    required Map<String, dynamic> dados,
  }) async {
    final nova = await StorageService.instance.saveSimulation(
      tipo: tipo, titulo: titulo, dados: dados,
    );
    _simulations.insert(0, nova);
    notifyListeners();
  }

  Future<void> deleteSimulation(String id) async {
    await StorageService.instance.deleteSimulation(id);
    _simulations.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  Future<void> clearSimulations() async {
    await StorageService.instance.clearAllSimulations();
    _simulations = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelCourseSubscriptions();
    super.dispose();
  }
}
