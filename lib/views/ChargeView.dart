import 'package:dam2_2627_a/DataHolder.dart';
import 'package:dam2_2627_a/insLib/bot_bars/InsBotBarStyle1.dart';
import 'package:flutter/material.dart';

/// Pantalla inicial de la prueba de cobro.
class ChargeView extends StatefulWidget {
  const ChargeView({super.key});

  @override
  State<ChargeView> createState() => _ChargeViewState();
}

class _ChargeViewState extends State<ChargeView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _paying = false;

  @override
  void initState() {
    super.initState();
    Dataholder.instance.iBotBarIndex = 4;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    final amount = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      return 'Introduce un importe mayor que cero';
    }
    if (!RegExp(r'^\d+([,.]\d{1,2})?$').hasMatch(value!.trim())) {
      return 'Usa como máximo dos decimales';
    }
    return null;
  }

  Future<void> _pay() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _paying = true);
    try {
      final amount = double.parse(
        _amountController.text.trim().replaceAll(',', '.'),
      );
      await Dataholder.instance.stripeadmin.cobrar(amount);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pago completado')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo completar el pago: $error')),
      );
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cobro')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Importe',
                      suffixText: '€',
                    ),
                    validator: _validateAmount,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _paying ? null : _pay,
                    child: Text(_paying ? 'Procesando...' : 'Pagar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Insbotbarstyle1(
        blBadge1: Dataholder.instance.blNotificacionesBadge,
        sBadge2: Dataholder.instance.sMessagesBadgeText,
        iBarIndex: Dataholder.instance.iBotBarIndex,
      ),
    );
  }
}
