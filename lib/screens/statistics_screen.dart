import 'package:flutter/material.dart';
import '../models/violation.dart';
import '../services/api_service.dart';

class StatisticsScreen extends StatefulWidget {
  final String userId;

  const StatisticsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final ApiService _apiService = ApiService();
  List<Violation> _violations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadViolations();
  }

  Future<void> _loadViolations() async {
    try {
      //  final violations = await _apiService.getViolationsForUser(widget.userId);
      final violations =
          await _apiService.getViolationsForCitizen(widget.userId);
      setState(() {
        _violations = violations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, int> _getViolationTypeStats() {
    final stats = <String, int>{};
    for (final violation in _violations) {
      stats[violation.type] = (stats[violation.type] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> _getMonthlyStats() {
    final stats = <String, int>{};
    for (final violation in _violations) {
      final monthKey =
          '${violation.timestamp.year}-${violation.timestamp.month.toString().padLeft(2, '0')}';
      stats[monthKey] = (stats[monthKey] ?? 0) + 1;
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final totalViolations = _violations.length;
    final paidViolations = _violations.where((v) => v.isPaid).length;
    final unpaidViolations = totalViolations - paidViolations;
    final violationTypeStats = _getViolationTypeStats();
    final monthlyStats = _getMonthlyStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إحصائيات المخالفات'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات عامة
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'إجمالي المخالفات',
                    totalViolations.toString(),
                    Icons.warning,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'المخالفات المدفوعة',
                    paidViolations.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'المخالفات غير المدفوعة',
                    unpaidViolations.toString(),
                    Icons.error,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'نسبة السداد',
                    totalViolations > 0
                        ? '${((paidViolations / totalViolations) * 100).toStringAsFixed(1)}%'
                        : '0%',
                    Icons.pie_chart,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // إحصائيات حسب نوع المخالفة
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المخالفات حسب النوع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...violationTypeStats.entries.map((entry) {
                      final percentage = totalViolations > 0
                          ? (entry.value / totalViolations) * 100
                          : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(entry.key)),
                                Text(
                                    '${entry.value} (${percentage.toStringAsFixed(1)}%)'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue[800]!),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // إحصائيات شهرية
            if (monthlyStats.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المخالفات الشهرية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...monthlyStats.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
