import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatefulWidget {
  final dynamic index;
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
          widget.index['name'],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
