import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm(
    this.onSubmit,
    Function(String title, double value, DateTime) addTransaction, {
    super.key,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _dateTime = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) return;
    widget.onSubmit(title, value, _dateTime);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  onSubmitted: (_) => _submitForm,
                  decoration: const InputDecoration(labelText: 'Titulo'),
                ),
                TextField(
                  controller: _valueController,
                  onSubmitted: (_) => _submitForm,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                            'Data selecionada: ${DateFormat('dd/MM/y').format(_dateTime).toString()}'),
                      ),
                      ElevatedButton(
                        onPressed: _showDatePicker,
                        child: const Text(
                          'Selecionar Data',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        minimumSize: const Size(88, 36),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        'Nova Transação',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
