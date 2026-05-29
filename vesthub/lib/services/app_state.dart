// lib/services/app_state.dart — v0.0.4 com Firestore

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'storage_service.dart';
import 'firestore_service.dart';

class AppState extends ChangeNotifier {
  EnemScores _enemScores = const EnemScores();
  EnemScores get enemScores => _enemScores;

  List<SavedSimulation> _simulations = [];
  List<SavedSimulation> get simulations => _simulations;

  // ── Cursos carregados do Firestore ────────────────────────────────────────
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

  // ── Dados do usuário ──────────────────────────────────────────────────────
  String _nomeUsuario = '';
  int _anoNascimento = 0;
  bool _onboardingCompleto = false;

  String get nomeUsuario => _nomeUsuario;
  int get anoNascimento => _anoNascimento;
  bool get onboardingCompleto => _onboardingCompleto;
  String get primeiroNome =>
      _nomeUsuario.isNotEmpty ? _nomeUsuario.split(' ').first : '';

  bool _isLoading = false;
  bool _cursosCarregados = false;
  bool get isLoading => _isLoading;
  bool get cursosCarregados => _cursosCarregados;

  // ── Init ──────────────────────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    // Dados locais (rápido)
    final prefs = await SharedPreferences.getInstance();
    _nomeUsuario = prefs.getString('usuario_nome') ?? '';
    _anoNascimento = prefs.getInt('usuario_ano') ?? 0;
    _onboardingCompleto = prefs.getBool('onboarding_completo') ?? false;
    _enemScores = await StorageService.instance.loadEnemScores();
    _simulations = await StorageService.instance.loadSimulations();

    _isLoading = false;
    notifyListeners();

    // Cursos do Firestore (em paralelo, não bloqueia a UI)
    _loadCursosFirestore();
  }

  Future<void> _loadCursosFirestore() async {
    try {
      final results = await Future.wait([
        FirestoreService.instance.getSisuCourses(),
        FirestoreService.instance.getCourses('fuvest'),
        FirestoreService.instance.getCourses('unicamp'),
        FirestoreService.instance.getCourses('unesp'),
        FirestoreService.instance.getCourses('ssa'),
        FirestoreService.instance.getCourses('pas'),
      ]);

      _sisuCourses   = results[0] as List<SisuCourse>;
      _fuvestCourses = results[1] as List<Course>;
      _unicampCourses= results[2] as List<Course>;
      _unespCourses  = results[3] as List<Course>;
      _ssaCourses    = results[4] as List<Course>;
      _pasCourses    = results[5] as List<Course>;
      _cursosCarregados = true;
      notifyListeners();
    } catch (e) {
      // Silently fallback — dados locais já foram carregados
      _cursosCarregados = true;
      notifyListeners();
    }
  }

  // Força recarregar do Firestore (pull-to-refresh)
  Future<void> reloadCursos() async {
    _cursosCarregados = false;
    notifyListeners();
    await _loadCursosFirestore();
  }

  // ── Onboarding ────────────────────────────────────────────────────────────
  Future<void> completarOnboarding(String nome, int anoNascimento) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_nome', nome);
    await prefs.setInt('usuario_ano', anoNascimento);
    await prefs.setBool('onboarding_completo', true);
    _nomeUsuario = nome;
    _anoNascimento = anoNascimento;
    _onboardingCompleto = true;

    // Popula o Firestore na primeira vez (só roda se estiver vazio)
    FirestoreService.instance.seedDatabase();
    notifyListeners();
  }

  // ── ENEM ──────────────────────────────────────────────────────────────────
  Future<void> updateEnemScores(EnemScores scores) async {
    _enemScores = scores;
    notifyListeners();
    await StorageService.instance.saveEnemScores(scores);
  }

  // ── Simulações ────────────────────────────────────────────────────────────
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
}
