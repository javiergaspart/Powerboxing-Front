import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fl_chart/fl_chart.dart'; // For graph

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsApp() async {
    final url = 'https://wa.me/919030023185';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchCall() async {
    final url = 'tel:+919030023185';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF151718);
    final Color cardColor = const Color(0xFF1F2123); // Slightly lighter

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Contact Us', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Contact buttons
            Row(
              children: [
                _buildContactButton(
                  context,
                  'WhatsApp',
                  FontAwesome.whatsapp,
                  Colors.green,
                  _launchWhatsApp,
                  cardColor,
                ),
                const SizedBox(width: 15),
                _buildContactButton(
                  context,
                  'Call',
                  Icons.phone,
                  Colors.blue,
                  _launchCall,
                  cardColor,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white38),
            const SizedBox(height: 20),

            // Contact Info
            _buildContactInfo(Icons.email, 'Email', 'support@powerboxing.fun'),
            _buildContactInfo(Icons.phone_android, 'Phone', '+91-9030023185'),
            _buildContactInfo(
              Icons.location_on,
              'Address',
              'Excelting Experience Private Limited\n8-2-644/I/205, Flat N 205, Hiline Complex,\nRoad No. 12, Banjara Hills,\nKhairatabad, Hyderabad – 500034, Telangana, India',
            ),

            const SizedBox(height: 30),

            // Graph
            const Text(
              'Support Requests Overview',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  backgroundColor: bgColor,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Email', style: TextStyle(color: Colors.white));
                            case 1:
                              return const Text('Call', style: TextStyle(color: Colors.white));
                            case 2:
                              return const Text('WhatsApp', style: TextStyle(color: Colors.white));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 7, color: Colors.orangeAccent, width: 18)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.blueAccent, width: 18)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: Colors.greenAccent, width: 18)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton(BuildContext context, String title, IconData icon, Color iconColor, Function onTap, Color bgColor) {
    return Expanded(
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 40),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(info, style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
