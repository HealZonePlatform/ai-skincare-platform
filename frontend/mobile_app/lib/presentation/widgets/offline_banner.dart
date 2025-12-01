import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/network/connectivity_service.dart';
import 'package:ai_skincare_platform/presentation/providers/connectivity_provider.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        final isOffline = connectivity.isOffline;
        return AnimatedSlide(
          duration: const Duration(milliseconds: 220),
          offset: isOffline ? Offset.zero : const Offset(0, -1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: isOffline ? 1 : 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl, vertical: AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.14),
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.warning.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: AppColors.warning),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Text(
                        'Offline mode: showing cached data when available.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          ConnectivityService.instance.runQueuedRetries(),
                      child: const Text('Retry queued'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
