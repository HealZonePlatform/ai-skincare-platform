// lib/screens/profile/skin_analysis_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';

class SkinAnalysisDetailScreen extends StatelessWidget {
  final SkinAnalysisHistory analysisItem;

  const SkinAnalysisDetailScreen({
    Key? key,
    required this.analysisItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết phân tích da'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display analysis image
            _buildAnalysisImage(),
            const SizedBox(height: 16),

            // Basic information
            _buildBasicInfoCard(context),
            const SizedBox(height: 16),

            // Analysis results (if available)
            _buildAnalysisResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: analysisItem.imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50),
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.error, size: 50),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phân tích #${analysisItem.id.substring(0, 8)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Ngày: ${analysisItem.createdAt.toString().split(' ')[0]}',
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Thời gian: ${analysisItem.createdAt.toString().split(' ')[1].substring(0, 8)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (analysisItem.status != null) _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    switch (analysisItem.status) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        analysisItem.status!,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildAnalysisResultCard() {
    if (analysisItem.analysisResult == null ||
        analysisItem.analysisResult!.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Chưa có kết quả phân tích chi tiết'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kết quả phân tích',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // ✅ FIXED: Removed spread operator and kept .toList()
            // Display analysis results
            ...analysisItem.analysisResult!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${entry.key}:'),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
