import 'package:despesas/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final void Function(String) onRemove;
  const TransactionList(
    this.transactions,
    this.onRemove, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Nenhuma transação cadastrada!',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text('R\$${tr.value.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    tr.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? ElevatedButton.icon(
                          onPressed: () => onRemove(tr.id),
                          icon: const Icon(
                            Icons.delete_forever_sharp,
                            color: Color.fromARGB(255, 247, 10, 10),
                          ),
                          label: const Text(
                            'Excluir',
                            style: TextStyle(
                              color: Color.fromARGB(255, 247, 10, 10),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () => onRemove(tr.id),
                          icon: const Icon(Icons.delete_forever_sharp),
                          color: const Color.fromARGB(255, 247, 10, 10),
                        ),
                  subtitle: Text(DateFormat('d MMM y').format(tr.date)),
                ),
              );
            });
  }
}
