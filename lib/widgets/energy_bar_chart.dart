import 'package:flutter/material.dart';

class EnergyBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBar('Energy', 0),
        SizedBox(height: 8),
        _buildBar('Accuracy', 0),
        SizedBox(height: 8),
        _buildBar('Power', 0),
      ],
    );
  }

  Widget _buildBar(String label, double value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(width: 10),
        Text('${(value * 100).toInt()}%'),
      ],
    );
  }
}
