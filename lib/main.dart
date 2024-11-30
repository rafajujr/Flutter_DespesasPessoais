import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import './components/transaction_list.dart';
import './models/transactions.dart';
import './components/transaction_form.dart';
import 'components/chart.dart';

main() => runApp(DespesasApp());

class DespesasApp extends StatelessWidget {
  final ThemeData tema = ThemeData();
  DespesasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // PARA TRAVA A ORIENTAÇÃO EM RETRATO
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        home: const MyHomePage(),
        theme: tema.copyWith(
            colorScheme: tema.colorScheme.copyWith(
              primary: const Color.fromARGB(255, 146, 68, 160),
              secondary: Colors.amber,
            ),
            textTheme: tema.textTheme.copyWith(
                titleLarge: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ))));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> _transactions = [];
  bool _showChatr = false;

  List<Transactions> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transactions(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TransactionForm(
          _addTransaction,
          (title, value, date) {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        'Despesas Pessoais',
        style:
            //RESPONSIVIDADE DO TEXTO
            TextStyle(fontSize: 20 * MediaQuery.textScalerOf(context).scale(1)),
      ),
      actions: [
        if (isLandscape)
          IconButton(
            onPressed: () {
              setState(() {
                _showChatr = !_showChatr;
              });
            },
            icon: Icon(_showChatr ? Icons.list : Icons.show_chart),
          ),
        IconButton(
            color: Colors.blue,
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(
              Icons.add_circle_outline_sharp,
            )),
      ],
    );

    final availablelHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //const Text('Exibir gráfico'),
                  //Switch(
                  //   value: _showChatr,
                  // onChanged: (value) {
                  // setState(() {
                  // _showChatr = value;
                  // });
                  //},
                  // )
                ],
              ),
            if (_showChatr || !isLandscape)
              SizedBox(
                height: availablelHeight * (isLandscape ? 0.7 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_showChatr || !isLandscape)
              SizedBox(
                height: availablelHeight * 0.7,
                child: TransactionList(_transactions, _deleteTransaction),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _openTransactionFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
