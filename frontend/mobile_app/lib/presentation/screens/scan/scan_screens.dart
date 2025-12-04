import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_events.dart';
import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';
import 'package:ai_skincare_platform/core/error/global_error_notifier.dart';
import 'package:ai_skincare_platform/core/utils/haptics.dart';
import 'package:ai_skincare_platform/core/utils/share_helper.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/presentation/widgets/illustrated_message.dart';
import 'package:ai_skincare_platform/presentation/widgets/optimized_network_image.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_section_header.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_stat_chip.dart';
import 'package:ai_skincare_platform/presentation/widgets/ui_kit/hz_surface_card.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/utils/error_handler.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';
import 'package:ai_skincare_platform/presentation/widgets/confetti_overlay.dart';
import 'package:confetti/confetti.dart';

const _scanPlaceholderImageUrl =
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800';

class ScanPermissionScreen extends StatefulWidget {
  const ScanPermissionScreen({super.key});

  @override
  State<ScanPermissionScreen> createState() => _ScanPermissionScreenState();
}

class _ScanPermissionScreenState extends State<ScanPermissionScreen> {
  bool _isRequesting = false;

  Future<void> _requestPermission() async {
    if (_isRequesting) return;
    await Haptics.selection();
    setState(() {
      _isRequesting = true;
    });
    final status = await Permission.camera.request();
    if (!mounted) return;

    setState(() {
      _isRequesting = false;
    });

    if (status.isGranted) {
      context.go('/scan/prepare');
      return;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera permission is required to continue.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              const SkincareIllustration(
                type: IllustrationType.emptyScan,
                size: 220,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Camera access needed',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'We need camera access to capture your skin photo securely for AI analysis. Photos stay private and are only used for your scan.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.l),
              const _PermissionHighlights(),
              const Spacer(),
              HzPrimaryButton(
                label: 'Allow camera access',
                icon: Icons.check_circle,
                isLoading: _isRequesting,
                onPressed: _requestPermission,
              ),
              const SizedBox(height: AppSpacing.m),
              HzSecondaryButton(
                label: 'Not now',
                icon: Icons.close_rounded,
                onPressed: () async {
                  await Haptics.selection();
                  if (context.mounted) {
                    context.go('/home');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionHighlights extends StatelessWidget {
  const _PermissionHighlights();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const items = [
      (
        Icons.lock_outline,
        'Private by design',
        'Photos are only used for your scan and never shared.',
      ),
      (
        Icons.auto_awesome_rounded,
        'AI glow check',
        'Better lighting gives more accurate results.',
      ),
      (
        Icons.shield_moon_outlined,
        'Comfort mode',
        'You can stop anytime and retry when ready.',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      child: Icon(item.$1, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$2,
                            style: theme.textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            item.$3,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ScanPrepareScreen extends StatefulWidget {
  const ScanPrepareScreen({super.key});

  @override
  State<ScanPrepareScreen> createState() => _ScanPrepareScreenState();
}

class _ScanPrepareScreenState extends State<ScanPrepareScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        precacheImage(const NetworkImage(_scanPlaceholderImageUrl), context);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _controller.repeat();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _syncAnimationWithAccessibility(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prepare scan'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_controller.value * 0.05),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secondary.withValues(alpha: 0.1),
                            ),
                            child: const Icon(Icons.wb_sunny_rounded,
                                size: 80, color: AppColors.secondary),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Let\'s check your skin',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      'Ensure natural lighting and remove any makeup or glasses for the best result.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const _AnimatedInstructionList(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: HzPrimaryButton(
                label: 'I\'m ready',
                icon: Icons.camera_alt_rounded,
                onPressed: () => context.go('/scan/capture'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _syncAnimationWithAccessibility(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion && _controller.isAnimating) {
      _controller.stop();
    } else if (!reduceMotion && !_controller.isAnimating) {
      _controller.repeat();
    }
  }
}

class _AnimatedInstructionList extends StatelessWidget {
  const _AnimatedInstructionList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InstructionItem(
          icon: Icons.brightness_low_rounded,
          label: 'Use soft, even lighting (no backlight)',
        ),
        SizedBox(height: AppSpacing.m),
        _InstructionItem(
          icon: Icons.visibility_off,
          label: 'Remove glasses/makeup for accurate reading',
        ),
        SizedBox(height: AppSpacing.m),
        _InstructionItem(
          icon: Icons.center_focus_strong_rounded,
          label: 'Keep camera 20-30cm away, neutral face',
        ),
      ],
    );
  }
}

class _InstructionItem extends StatelessWidget {
  const _InstructionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: theme.dividerColor),
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class ScanCaptureScreen extends StatefulWidget {
  const ScanCaptureScreen({super.key});

  @override
  State<ScanCaptureScreen> createState() => _ScanCaptureScreenState();
}

class _ScanCaptureScreenState extends State<ScanCaptureScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isCapturing = false;
  final ImagePicker _picker = ImagePicker();
  String? _capturedImagePath;
  String? _lastError;
  int _countdown = 0;
  Timer? _countdownTimer;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed && !_isCapturing) {
      _controller.repeat(reverse: true);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _confirmExit() async {
    if (!_isCapturing) {
      _cancelCountdown();
      return true;
    }
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel scan?'),
        content: const Text('Your scan progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continue'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel scan'),
          ),
        ],
      ),
    );
    if (shouldExit == true) {
      _cancelCountdown();
    }
    return shouldExit ?? false;
  }

  Future<void> _capturePhoto() async {
    if (_isCapturing) return;
    setState(() {
      _isCapturing = true;
      _lastError = null;
    });
    _controller.stop();
    _cancelCountdown();

    try {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        const message = 'Camera permission is required to capture.';
        GlobalErrorNotifier.report(message);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(message),
              action: SnackBarAction(
                label: 'Grant',
                onPressed: () => context.go('/scan/permission'),
              ),
            ),
          );
        }
        return;
      }

      final file = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
        maxWidth: 1600,
      );

      if (!mounted) return;
      if (file == null) {
        _controller.repeat(reverse: true);
        return;
      }

      _capturedImagePath = file.path;
      context.go('/scan/processing', extra: {'imagePath': file.path});
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      final message = ErrorHandler.getUserMessage(error);
      _lastError = message;
      GlobalErrorNotifier.report(message);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _capturePhoto,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
        _controller.repeat(reverse: true);
      }
    }
  }

  void _startAutoCaptureCountdown() {
    if (_isCapturing || _countdownTimer != null) return;
    setState(() {
      _countdown = 3;
      _lastError = null;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        _countdownTimer = null;
        setState(() => _countdown = 0);
        _capturePhoto();
        return;
      }
      setState(() => _countdown -= 1);
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    if (_countdown != 0) {
      setState(() => _countdown = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncAnimationWithAccessibility(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Align your face'),
          leading: const BackButton(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final scale = 1 + (_controller.value * 0.05);
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(280),
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.15),
                                  AppColors.primary.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.6),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.12),
                                  blurRadius: 18,
                                  spreadRadius: 6,
                                )
                              ],
                            ),
                          ),
                          if (_capturedImagePath != null)
                            ClipOval(
                              child: Image.file(
                                File(_capturedImagePath!),
                                width: 230,
                                height: 230,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            const Icon(
                              Icons.face_retouching_natural,
                              size: 120,
                              color: AppColors.primary,
                            ),
                          if (_countdown > 0)
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$_countdown',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                LinearProgressIndicator(
                  value: _controller.value,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                const SizedBox(height: AppSpacing.xl),
                HzPrimaryButton(
                  label: _isCapturing ? 'Capturing...' : 'Capture photo',
                  icon: Icons.camera_alt_outlined,
                  isLoading: _isCapturing,
                  onPressed: _capturePhoto,
                ),
                const SizedBox(height: AppSpacing.s),
                HzSecondaryButton(
                  label: _countdown > 0
                      ? 'Auto capture in $_countdown'
                      : 'Auto capture (3s)',
                  icon: Icons.timer_outlined,
                  onPressed: _countdownTimer == null
                      ? _startAutoCaptureCountdown
                      : null,
                ),
                const SizedBox(height: AppSpacing.s),
                HzSecondaryButton(
                  label: 'View sample result',
                  icon: Icons.visibility_outlined,
                  onPressed: () => context.go('/scan/result'),
                ),
                if (_lastError != null) ...[
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    _lastError!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.danger),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _syncAnimationWithAccessibility(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion && _controller.isAnimating) {
      _controller.stop();
    } else if (!reduceMotion &&
        !_controller.isAnimating &&
        !_isCapturing &&
        _countdownTimer == null) {
      _controller.repeat(reverse: true);
    }
  }
}

class ScanProcessingScreen extends StatefulWidget {
  const ScanProcessingScreen({
    super.key,
    this.imagePath,
  });

  final String? imagePath;

  @override
  State<ScanProcessingScreen> createState() => _ScanProcessingScreenState();
}

class _ScanProcessingScreenState extends State<ScanProcessingScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isProcessing = true;
  String? _processingError;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _simulateProcessing();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed && _isProcessing) {
      _controller.repeat(reverse: true);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _simulateProcessing() async {
    try {
      if (widget.imagePath == null || widget.imagePath!.isEmpty) {
        throw ValidationException(
            message: 'No captured photo was provided for analysis.');
      }
      await Future<void>.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      AnalyticsService.logScanCompleted(
        source: 'camera',
        parameters: {'has_image': true},
      );
      if (!mounted) return;
      context.go('/scan/result', extra: {'imagePath': widget.imagePath});
    } catch (error, stackTrace) {
      _handleProcessingError(error, stackTrace);
    }
  }

  Future<bool> _confirmExit() async {
    if (!_isProcessing) {
      return true;
    }
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel scan?'),
        content:
            const Text('Processing will stop and your scan will be discarded.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  void _handleProcessingError(Object error, StackTrace stackTrace) {
    ErrorHandler.logError(error, stackTrace);
    final message = ErrorHandler.getUserMessage(error);
    AnalyticsService.logError(message, surface: 'scan_processing');
    setState(() {
      _processingError = message;
      _isProcessing = false;
    });
    GlobalErrorNotifier.report(message);
  }

  Future<void> _retryProcessing() async {
    setState(() {
      _processingError = null;
      _isProcessing = true;
    });
    _controller.repeat(reverse: true);
    await _simulateProcessing();
  }

  void _syncAnimationWithAccessibility(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion && _controller.isAnimating) {
      _controller.stop();
    } else if (!reduceMotion && !_controller.isAnimating && _isProcessing) {
      _controller.repeat(reverse: true);
    }
  }

  Widget _buildPreview() {
    final path = widget.imagePath;
    if (path == null || path.isEmpty) {
      return const SizedBox.shrink();
    }
    final borderRadius = BorderRadius.circular(AppRadius.m);
    final isLocal = !path.startsWith('http');
    if (isLocal) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(path),
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: borderRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image_outlined),
          ),
        ),
      );
    }
    return OptimizedNetworkImage(
      imageUrl: path,
      height: 140,
      borderRadius: AppRadius.m,
    );
  }

  @override
  Widget build(BuildContext context) {
    _syncAnimationWithAccessibility(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && context.mounted) {
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analyzing...'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Expanded(
                  child: _processingError != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 72, color: AppColors.danger),
                            const SizedBox(height: AppSpacing.l),
                            Text(
                              _processingError!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.m),
                            Text(
                              'Try again or go back to start a new scan.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            HzPrimaryButton(
                              label: 'Retry processing',
                              icon: Icons.refresh_rounded,
                              onPressed: _retryProcessing,
                            ),
                            const SizedBox(height: AppSpacing.s),
                            HzSecondaryButton(
                              label: 'Back to home',
                              icon: Icons.home_outlined,
                              onPressed: () => context.go('/home'),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                const size = 140.0;
                                final progress = _controller.value;
                                final percent = (progress * 100).round();
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer glow
                                    Container(
                                      width: size + 20,
                                      height: size + 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                                alpha: 0.2 + (progress * 0.1)),
                                            blurRadius: 30,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Progress ring
                                    SizedBox(
                                      height: size,
                                      width: size,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 8,
                                        backgroundColor: AppColors.primary
                                            .withValues(alpha: 0.15),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          AppColors.primary,
                                        ),
                                        value: progress,
                                      ),
                                    ),
                                    // Percentage text
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$percent%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                        ),
                                        Text(
                                          'Analyzing',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              'AI is analyzing your scan',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: AppSpacing.s),
                            const Text(
                              'Detecting skin conditions...\nThis usually takes 5-10 seconds.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _buildPreview(),
                          ],
                        ),
                ),
                if (_processingError == null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Stay still while we process your scan.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      IconButton(
                        tooltip: 'Cancel',
                        onPressed: () async {
                          final shouldExit = await _confirmExit();
                          if (!context.mounted) return;
                          if (shouldExit) {
                            context.go('/home');
                          }
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScanResultScreen extends StatefulWidget {
  const ScanResultScreen({
    super.key,
    this.imagePath,
  });

  final String? imagePath;

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final ConfettiController _confettiController;
  static const int _score = 86;
  bool _hasPlayedCelebration = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    _controller.forward();
  }

  void _onScoreAnimationComplete() {
    if (_hasPlayedCelebration) return;
    _hasPlayedCelebration = true;
    if (_score > 80) {
      Haptics.success();
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest scan result'),
        actions: [
          IconButton(
            tooltip: 'Share result',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              await Haptics.selection();
              AnalyticsService.logEvent(
                AnalyticsEvent.scanShared,
                parameters: {'surface': 'result_appbar'},
              );
              await ShareHelper.shareText(
                'Skin score: $_score - Routine is on track! #HealZone',
              );
            },
          )
        ],
      ),
      body: ConfettiOverlay(
        controller: _confettiController,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value,
                      child: HzSurfaceCard(
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success.withValues(alpha: 0.1),
                                border: Border.all(
                                  color:
                                      AppColors.success.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: _score),
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeOutQuart,
                                onEnd: _onScoreAnimationComplete,
                                builder: (context, score, _) {
                                  return Text(
                                    '$score',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: AppColors.success,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.l),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Excellent!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Skin barrier is stable. Keep your current routine to improve T-zone balance.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HzSectionHeader(
                        title: 'Key metrics',
                        subtitle: 'Updated from the most recent scan',
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      const _StaggeredChips(
                        children: [
                          HzStatChip(
                              label: 'Hydration',
                              value: '72',
                              icon: Icons.water_drop),
                          HzStatChip(
                              label: 'Elasticity',
                              value: '80',
                              icon: Icons.auto_graph),
                          HzStatChip(
                              label: 'Spots', value: '65', icon: Icons.blur_on),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const HzSectionHeader(
                        title: 'Reference photo',
                        padding: EdgeInsets.only(bottom: AppSpacing.m),
                      ),
                      _buildResultImage(),
                      const SizedBox(height: AppSpacing.xl),
                      HzPrimaryButton(
                        label: 'View detailed analysis',
                        icon: Icons.analytics_outlined,
                        onPressed: () => context.go('/advice'),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      HzSecondaryButton(
                        label: 'Scan again',
                        icon: Icons.refresh_rounded,
                        onPressed: () => context.go('/scan/prepare'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultImage() {
    final path = widget.imagePath;
    if (path == null || path.isEmpty) {
      return const OptimizedNetworkImage(
        imageUrl: _scanPlaceholderImageUrl,
        height: 220,
        borderRadius: AppRadius.l,
      );
    }
    final isLocal = !path.startsWith('http');
    if (isLocal) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.l),
        child: Image.file(
          File(path),
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const OptimizedNetworkImage(
            imageUrl: _scanPlaceholderImageUrl,
            height: 220,
            borderRadius: AppRadius.l,
          ),
        ),
      );
    }
    return OptimizedNetworkImage(
      imageUrl: path,
      height: 220,
      borderRadius: AppRadius.l,
    );
  }
}

class _StaggeredChips extends StatefulWidget {
  const _StaggeredChips({required this.children});

  final List<Widget> children;

  @override
  State<_StaggeredChips> createState() => _StaggeredChipsState();
}

class _StaggeredChipsState extends State<_StaggeredChips>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (widget.children.length * 100)),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final delay = index * 0.15;
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, (delay + 0.5).clamp(0.0, 1.0),
              curve: Curves.easeOutBack),
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      }).toList(),
    );
  }
}
