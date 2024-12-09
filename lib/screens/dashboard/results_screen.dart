import 'package:flutter/material.dart';
import '../../services/results_service.dart';
import '../../models/result_model.dart';

class ResultsScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  ResultsScreen({required this.sessionId, required this.userId});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final ResultService _resultService = ResultService();
  PunchResult? _punchResult;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  // Fetch results when the screen is initialized
  Future<void> _fetchResults() async {
    try {
      PunchResult result = await _resultService.getPunchResult(widget.sessionId, widget.userId);
      setState(() {
        _punchResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show an error message if the request fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load results')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Session Results')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _punchResult == null
              ? Center(child: Text('No results found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Session ID: ${_punchResult!.sessionId}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text('User ID: ${_punchResult!.userId}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text('Correct Punches: ${_punchResult!.correctPunches}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Total Punches: ${_punchResult!.totalPunches}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Power Score: ${_punchResult!.powerScore.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Accuracy Score: ${_punchResult!.accuracyScore.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to the previous screen
                        },
                        child: Text('Back to Home'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
