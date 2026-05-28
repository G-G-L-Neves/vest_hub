// lib/main.dart — VestHub v0.0.3 (Atualizado com Firebase)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Importando o Core do Firebase
import 'firebase_options.dart';                   // Importando as opções geradas pelo CLI

import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/widgets.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/calculator/calculator_screen.dart';
import 'screens/sisu/sisu_screen.dart';
import 'screens/ssa/ssa_screen.dart';
import 'screens/pas/pas_screen.dart';
import 'screens/fuvest/fuvest_screen.dart';
import 'screens/unicamp/unicamp_screen.dart';
import 'screens/unesp/unesp_screen.dart';
import 'screens/saved/saved_screen.dart';

void main() async {
  // Garante que os bindings nativos estejam prontos antes de rodar código assíncrono
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialização oficial do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  final appState = AppState();
  await appState.init();
  runApp(ChangeNotifierProvider.value(value: appState, child: const VestHubApp()));
}

// ============================================================================
// ATENÇÃO: Mantenha o restante do seu arquivo exatamente como estava antes
// (a classe VestHubApp, as listas de telas e os widgets de navegação)
// ============================================================================