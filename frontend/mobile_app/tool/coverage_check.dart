import 'dart:io';

/// Simple LCOV parser to enforce a minimum line coverage percentage.
///
/// Usage:
/// dart run tool/coverage_check.dart --min 70 coverage/lcov.info
void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run tool/coverage_check.dart --min 70 coverage/lcov.info');
    exit(1);
  }

  final minIndex = args.indexOf('--min');
  final minCoverage =
      minIndex != -1 && minIndex + 1 < args.length ? double.parse(args[minIndex + 1]) : 0;
  final coveragePath = args.lastWhere((arg) => !arg.startsWith('--'), orElse: () => '');

  if (coveragePath.isEmpty) {
    stderr.writeln('Coverage file path is required.');
    exit(1);
  }

  final file = File(coveragePath);
  if (!file.existsSync()) {
    stderr.writeln('Coverage file not found: $coveragePath');
    exit(1);
  }

  var linesFound = 0;
  var linesHit = 0;

  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('LF:')) {
      linesFound += int.tryParse(line.substring(3)) ?? 0;
    } else if (line.startsWith('LH:')) {
      linesHit += int.tryParse(line.substring(3)) ?? 0;
    }
  }

  final coverage = linesFound == 0 ? 0 : (linesHit / linesFound) * 100;
  stdout.writeln(
      'Coverage: ${coverage.toStringAsFixed(2)}% (min ${minCoverage.toStringAsFixed(0)}%)');

  if (coverage < minCoverage) {
    stderr.writeln('Coverage below target.');
    exit(1);
  }
}
