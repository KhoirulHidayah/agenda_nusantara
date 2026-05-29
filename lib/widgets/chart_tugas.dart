// lib/widgets/chart_tugas.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';

class ChartTugas extends StatelessWidget {
  final Map<String, int> data;
  const ChartTugas({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data tugas selesai.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      );
    }

    // Buat 7 hari terakhir
    final days = List.generate(7, (i) {
      final d = DateTime.now().subtract(Duration(days: 6 - i));
      return DateFormat('yyyy-MM-dd').format(d);
    });

    final bars = days.asMap().entries.map((e) {
      final val = data[e.value] ?? 0;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: val.toDouble(),
            color: AppTheme.primary,
            width: 18,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    final maxY = (data.values.isEmpty ? 1 : data.values.reduce((a, b) => a > b ? a : b))
        .toDouble()
        .clamp(1, double.infinity);

    final dayLabels = days.map((d) {
      try {
        final dt = DateTime.parse(d);
        return DateFormat('E', 'id_ID').format(dt).substring(0, 3);
      } catch (_) {
        return '';
      }
    }).toList();

    return BarChart(
      BarChartData(
        maxY: maxY + 1,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                final idx = val.toInt();
                if (idx < 0 || idx >= dayLabels.length) return const SizedBox();
                return Text(dayLabels[idx],
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: bars,
      ),
    );
  }
}
