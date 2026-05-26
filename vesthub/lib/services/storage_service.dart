// lib/services/storage_service.dart
//
// Serviço de armazenamento local usando shared_preferences.
// Salva e carrega dados do dispositivo do usuário.
// Tudo é serializado como JSON string.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class StorageService {
  static const StorageService instance = StorageService._();
  const StorageService._();

  // Chaves usadas no shared_preferences
  static const _keyEnemScores = 'enem_scores';
  static const _keySavedSimulations = 'saved_simulations';

  final _uuid = const Uuid();

  // ─── ENEM ────────────────────────────────────────────────────────────────

  /// Salva as notas do ENEM localmente
  Future<void> saveEnemScores(EnemScores scores) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEnemScores, jsonEncode(scores.toJson()));
  }

  /// Carrega as notas do ENEM salvas (retorna zeros se não houver dados)
  Future<EnemScores> loadEnemScores() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyEnemScores);
    if (json == null) return const EnemScores();
    try {
      return EnemScores.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return const EnemScores();
    }
  }

  // ─── Simulações salvas ────────────────────────────────────────────────────

  /// Carrega todas as simulações salvas
  Future<List<SavedSimulation>> loadSimulations() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keySavedSimulations);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => SavedSimulation.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.criadoEm.compareTo(a.criadoEm)); // mais recente primeiro
    } catch (_) {
      return [];
    }
  }

  /// Salva uma nova simulação
  Future<SavedSimulation> saveSimulation({
    required String tipo,
    required String titulo,
    required Map<String, dynamic> dados,
  }) async {
    final sims = await loadSimulations();
    final nova = SavedSimulation(
      id: _uuid.v4(),
      tipo: tipo,
      titulo: titulo,
      criadoEm: DateTime.now(),
      dados: dados,
    );
    sims.insert(0, nova);
    await _persistSimulations(sims);
    return nova;
  }

  /// Remove uma simulação pelo ID
  Future<void> deleteSimulation(String id) async {
    final sims = await loadSimulations();
    sims.removeWhere((s) => s.id == id);
    await _persistSimulations(sims);
  }

  /// Limpa todas as simulações
  Future<void> clearAllSimulations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySavedSimulations);
  }

  /// Persiste a lista de simulações no disco
  Future<void> _persistSimulations(List<SavedSimulation> sims) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(sims.map((s) => s.toJson()).toList());
    await prefs.setString(_keySavedSimulations, json);
  }
}
