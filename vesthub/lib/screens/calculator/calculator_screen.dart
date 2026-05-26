// lib/screens/calculator/calculator_screen.dart — v0.0.3 Frutiger Aero

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class _FaculdadeNota {
  final String faculdade;
  final String curso;
  final String tipo;
  final double notaCorte;
  String? notaUsuario;

  _FaculdadeNota({required this.faculdade, required this.curso, required this.tipo, required this.notaCorte, this.notaUsuario});

  bool get preenchida => notaUsuario != null && notaUsuario!.isNotEmpty;
  double? get notaDouble => double.tryParse(notaUsuario ?? '');
  bool? get aprovadoStatus => preenchida ? (notaDouble != null && notaDouble! >= notaCorte) : null;
}

final List<_FaculdadeNota> _baseFaculdades = [
  _FaculdadeNota(faculdade: 'UFPE', curso: 'Medicina', tipo: 'SISU', notaCorte: 843.5),
  _FaculdadeNota(faculdade: 'UFPE', curso: 'Direito', tipo: 'SISU', notaCorte: 763.2),
  _FaculdadeNota(faculdade: 'UFPE', curso: 'Engenharia Civil', tipo: 'SISU', notaCorte: 698.4),
  _FaculdadeNota(faculdade: 'UFMG', curso: 'Medicina', tipo: 'SISU', notaCorte: 851.2),
  _FaculdadeNota(faculdade: 'UFMG', curso: 'Eng. de Computacao', tipo: 'SISU', notaCorte: 745.8),
  _FaculdadeNota(faculdade: 'UnB', curso: 'Direito', tipo: 'SISU', notaCorte: 791.4),
  _FaculdadeNota(faculdade: 'UnB', curso: 'Ciencia da Computacao', tipo: 'PAS', notaCorte: 72.8),
  _FaculdadeNota(faculdade: 'USP', curso: 'Medicina', tipo: 'FUVEST', notaCorte: 91.5),
  _FaculdadeNota(faculdade: 'USP', curso: 'Direito', tipo: 'FUVEST', notaCorte: 85.2),
  _FaculdadeNota(faculdade: 'USP', curso: 'Engenharia (Poli)', tipo: 'FUVEST', notaCorte: 78.6),
  _FaculdadeNota(faculdade: 'UNICAMP', curso: 'Medicina', tipo: 'UNICAMP', notaCorte: 292.4),
  _FaculdadeNota(faculdade: 'UNICAMP', curso: 'Eng. de Computacao', tipo: 'UNICAMP', notaCorte: 241.7),
  _FaculdadeNota(faculdade: 'UNESP', curso: 'Medicina (Botucatu)', tipo: 'UNESP', notaCorte: 155.8),
  _FaculdadeNota(faculdade: 'UPE', curso: 'Medicina', tipo: 'SSA', notaCorte: 86.4),
  _FaculdadeNota(faculdade: 'UPE', curso: 'Odontologia', tipo: 'SSA', notaCorte: 79.6),
  _FaculdadeNota(faculdade: 'UPE', curso: 'Enfermagem', tipo: 'SSA', notaCorte: 71.2),
  _FaculdadeNota(faculdade: 'UFRJ', curso: 'Medicina', tipo: 'SISU', notaCorte: 845.0),
  _FaculdadeNota(faculdade: 'UFRJ', curso: 'Administracao', tipo: 'SISU', notaCorte: 708.3),
  _FaculdadeNota(faculdade: 'UFBA', curso: 'Medicina', tipo: 'SISU', notaCorte: 838.7),
  _FaculdadeNota(faculdade: 'UFBA', curso: 'Psicologia', tipo: 'SISU', notaCorte: 723.1),
];

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final List<_FaculdadeNota> _lista = List.from(_baseFaculdades);
  String _filtroTipo = 'Todos';
  String _busca = '';

  static const _tipos = ['Todos', 'SISU', 'FUVEST', 'UNICAMP', 'UNESP', 'SSA', 'PAS'];

  List<_FaculdadeNota> get _listaFiltrada => _lista.where((f) {
    final matchTipo = _filtroTipo == 'Todos' || f.tipo == _filtroTipo;
    final matchBusca = _busca.isEmpty ||
        f.faculdade.toLowerCase().contains(_busca.toLowerCase()) ||
        f.curso.toLowerCase().contains(_busca.toLowerCase());
    return matchTipo && matchBusca;
  }).toList();

  int get _aprovadas => _lista.where((f) => f.aprovadoStatus == true).length;
  int get _abaixo => _lista.where((f) => f.aprovadoStatus == false).length;
  int get _preenchidas => _lista.where((f) => f.preenchida).length;

  @override
  Widget build(BuildContext context) {
    final lista = _listaFiltrada;
    return AppBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Row(
                children: [
                  const Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VESTHUB', style: AppTheme.label),
                      SizedBox(height: 3),
                      Text('Calculadora', style: AppTheme.headingLarge),
                    ],
                  )),
                  GlassBox(
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => setState(() { for (final f in _lista) f.notaUsuario = null; }),
                      child: const Icon(Icons.refresh, color: AppTheme.textSecondary, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_preenchidas > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(child: GlassStatusBox(aprovado: true, padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: Column(children: [
                        Text('$_aprovadas', style: const TextStyle(color: AppTheme.greenText, fontSize: 20, fontWeight: FontWeight.w600)),
                        Text('Aprovado', style: AppTheme.bodySmall),
                      ])),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: GlassStatusBox(aprovado: false, padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: Column(children: [
                        Text('$_abaixo', style: const TextStyle(color: AppTheme.redText, fontSize: 20, fontWeight: FontWeight.w600)),
                        Text('Abaixo', style: AppTheme.bodySmall),
                      ])),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: GlassBox(padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: Column(children: [
                        Text('$_preenchidas', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
                        Text('Notas', style: AppTheme.bodySmall),
                      ])),
                    )),
                  ],
                ),
              ),
            if (_preenchidas > 0) const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GlassBox(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppTheme.textMuted, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Buscar faculdade ou curso...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          filled: false,
                        ),
                        onChanged: (v) => setState(() => _busca = v),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                children: _tipos.map((tipo) {
                  final ativo = _filtroTipo == tipo;
                  return GestureDetector(
                    onTap: () => setState(() => _filtroTipo = tipo),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: ativo ? Colors.white.withOpacity(0.9) : AppTheme.glassWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ativo ? Colors.white : AppTheme.glassBorder),
                      ),
                      child: Text(tipo, style: TextStyle(
                        color: ativo ? const Color(0xFF0A3D5C) : AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: ativo ? FontWeight.w600 : FontWeight.w400,
                      )),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: lista.isEmpty
                  ? const EmptyState(icon: Icons.search_off, title: 'Nenhum resultado', subtitle: 'Tente outro termo de busca')
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                      itemCount: lista.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _FaculdadeCard(
                          item: lista[i],
                          onNotaChanged: (nota) => setState(() => lista[i].notaUsuario = nota),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaculdadeCard extends StatefulWidget {
  final _FaculdadeNota item;
  final ValueChanged<String> onNotaChanged;
  const _FaculdadeCard({required this.item, required this.onNotaChanged});
  @override
  State<_FaculdadeCard> createState() => _FaculdadeCardState();
}

class _FaculdadeCardState extends State<_FaculdadeCard> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.item.notaUsuario ?? '');
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final status = widget.item.aprovadoStatus;
    return GlassStatusBox(
      aprovado: status,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.item.faculdade,
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.glassWhite,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.glassBorder),
                      ),
                      child: Text(widget.item.tipo,
                          style: const TextStyle(color: AppTheme.accent, fontSize: 9, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(widget.item.curso, style: AppTheme.bodySmall),
                const SizedBox(height: 3),
                Text('Corte: ${widget.item.notaCorte}',
                    style: const TextStyle(color: AppTheme.textHint, fontSize: 10)),
                if (widget.item.preenchida) ...[
                  const SizedBox(height: 8),
                  GlassProgressBar(
                    value: ((widget.item.notaDouble ?? 0) / widget.item.notaCorte).clamp(0, 1.2),
                    aprovado: status,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(aprovado: status),
              const SizedBox(height: 8),
              SizedBox(
                width: 82,
                child: TextField(
                  controller: _ctrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: status == true ? AppTheme.greenText : status == false ? AppTheme.redText : AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'N/A',
                    hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    filled: true,
                    fillColor: AppTheme.glassWhite,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.glassBorder)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.glassBorder)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.accent, width: 1.5)),
                  ),
                  onChanged: (v) { setState(() {}); widget.onNotaChanged(v); },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
