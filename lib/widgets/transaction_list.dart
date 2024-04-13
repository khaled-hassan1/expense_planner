import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transcation_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transactions, this.deleteTx, {super.key});

  final List<Transaction> transactions;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    print('build() NewTransaction');

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // final isLandscape2 = MediaQuery.of(context).size.width > 360;
    return SizedBox(
      height: 450,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView(
              children: transactions
                  .map(
                    (tx) => TranscationItem(
                        key: ValueKey(tx.id),
                        transaction: tx,
                        isLandscape: isLandscape,
                        deleteTx: deleteTx),
                  )
                  .toList(),
            ),
    );
  }
}
