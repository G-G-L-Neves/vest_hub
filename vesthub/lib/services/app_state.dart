// lib/services/app_state.dart
// Estado global — inclui nome e ano de nascimento do usuário (v0.0.2)

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'storage_service.dart';

class AppState extends ChangeNotifier {
  EnemScores _enemScores = const EnemScores();
  EnemScores get enemScores => _enemScores;

  List<SavedSimulation> _simulations = [];
  List<SavedSimulation> get simulations => _simulations;

  // ── Dados do usuário (v0.0.2) ─────────────────────────────────────────────
  String _nomeUsuario = '';
  int _anoNascimento = 0;
  bool _onboardingCompleto = false;

  String get nomeUsuario => _nomeUsuario;
  int get anoNascimento => _anoNascimento;
  bool get onboardingCompleto => _onboardingCompleto;
  String get primeiroNome =>
      _nomeUsuario.isNotEmpty ? _nomeUsuario.split(' ').first : '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
  }

  // Salva dados do onboarding
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
      tipo: tipo,
      titulo: titulo,
      dados: dados,
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
