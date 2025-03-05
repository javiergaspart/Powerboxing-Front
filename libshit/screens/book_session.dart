Future<void> _fetchAvailableSessions(String date) async {
  setState(() => selectedDate = date);

  final response = await http.get(
    Uri.parse("http://localhost:10000/api/sessions?date=$date"),
    headers: {'Authorization': 'Bearer ${widget.token}'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    setState(() {
      availableSessions[date] = List<String>.from(data.map((session) => session["timeSlot"]));
    });
  } else {
    print("❌ Failed to fetch sessions: ${response.body}");
  }
}

Future<void> _bookSession(String time) async {
  final response = await http.post(
    Uri.parse("http://localhost:10000/api/book-session"),
    headers: {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'date': selectedDate, 'time': time}),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Session booked successfully!")),
    );

    _fetchAvailableSessions(selectedDate);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Failed to book session.")),
    );
  }
}
