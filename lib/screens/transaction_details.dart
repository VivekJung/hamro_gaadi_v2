import 'package:flutter/material.dart';
import 'package:hamro_gaadi/services/models.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Entries index;
  const TransactionDetailScreen({Key? key, required this.index})
      : super(key: key);

  @override
  State<TransactionDetailScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Text(
          widget.index.details!.remarks ?? "no data received",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
