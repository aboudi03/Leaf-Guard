import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.eco, color: Colors.greenAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(result,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
