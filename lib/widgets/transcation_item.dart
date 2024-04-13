import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TranscationItem extends StatefulWidget {
  const TranscationItem({
    super.key,
    required this.transaction,
    required this.isLandscape,
    required this.deleteTx,
  });

  final Transaction transaction;
  final bool isLandscape;
  final Function deleteTx;

  @override
  State<TranscationItem> createState() => _TranscationItemState();
}

class _TranscationItemState extends State<TranscationItem> {
  late Color _bgColor;
  final List<Color> availableColor = [
    Colors.red,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.cyanAccent,
  ];
  @override
  void initState() {
    _bgColor = availableColor[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(widget.transaction.date),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: widget.isLandscape
            ? ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: const Text('Delete!'))
            : IconButton(
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
