import 'dart:convert';

import 'package:flutter/material.dart';

import 'spec_store.dart';

typedef ActionHandler = void Function(String action);

class WidgetFactory {
  WidgetFactory(this.context, {required this.values, required this.onAction});
  final BuildContext context;
  final Map<String, dynamic> values;
  final ActionHandler onAction;

  // Helpers to read tokens
  Color _color(String key, {Color fallback = const Color(0xFF222222)}) {
    final tokens = SpecStore.instance.tokens;
    final hex = tokens?['colors']?[key] as String?;
    if (hex == null) return fallback;
    return _parseHexColor(hex) ?? fallback;
  }

  double _spacing(String key, {double fallback = 8}) {
    final tokens = SpecStore.instance.tokens;
    final v = tokens?['spacing']?[key];
    if (v is num) return v.toDouble();
    return fallback;
  }

  double _radius(String key, {double fallback = 12}) {
    final tokens = SpecStore.instance.tokens;
    final v = tokens?['radius']?[key];
    if (v is num) return v.toDouble();
    return fallback;
  }

  static Color? _parseHexColor(String hex) {
    var h = hex.replaceAll('#', '').toUpperCase();
    if (h.length == 6) h = 'FF$h';
    if (h.length != 8) return null;
    return Color(int.parse(h, radix: 16));
  }

  Widget buildFromSpec(Map<String, dynamic> spec) {
    final type = spec['type'] as String? ?? '';
    switch (type) {
      case 'Greeting':
        return _greeting(spec);
      case 'TextField':
        return _textField(spec, obscure: false);
      case 'PasswordField':
        return _textField(spec, obscure: true);
      case 'PrimaryButton':
        return _primaryButton(spec);
      case 'OAuthButton':
        return _oauthButton(spec);
      case 'SkinScoreCard':
        return _skinScoreCard(spec);
      case 'RoutineStrip':
        return _routineStrip(spec);
      case 'SkinTypeSelector':
        return _skinTypeSelector(spec);
      case 'ConcernChecklist':
        return _concernChecklist(spec);
      case 'NewsSection':
        return _sectionHeader(spec['title'] ?? 'Tin tức');
      case 'ProductSection':
        return _sectionHeader(spec['title'] ?? 'Sản phẩm');
      case 'BottomTabBar':
        // Shell provides it; just spacer
        return const SizedBox(height: 24);
      case 'SearchBar':
        return _searchBar();
      case 'Section':
        return _section(spec);
      case 'ProductHeader':
        return _productHeader(spec);
      case 'Tabs':
        return _tabs(spec);
      case 'SecondaryButton':
        return _secondaryButton(spec);
      case 'PostList':
        return _postList(spec);
      case 'Fab':
        return _inlineFab(spec);
      case 'IconInfo':
        return _iconInfo(spec);
      case 'CameraPreview':
        return _cameraPreview();
      case 'LargeProgress':
        return _largeProgress(spec);
      case 'ScoreBadge':
        return _scoreBadge(spec);
      case 'MetricGrid':
        return _metricGrid(spec);
      case 'RoutineStepList':
        return _routineStepList(spec);
      case 'RoutineList':
        return _routineList(spec);
      case 'PlanSummary':
        return _planSummary(spec);
      case 'PaymentMethodList':
        return _paymentMethodList(spec);
      case 'CardForm':
        return _cardForm(spec);
      case 'QrBlock':
        return _qrBlock(spec);
      case 'TextButton':
        return _textButton(spec);
      case 'SuccessIcon':
        return _successIcon();
      default:
        return _unknown(type, spec);
    }
  }

  String _keyFromLabel(String? label) {
    final l = (label ?? '').trim().toLowerCase();
    if (l.contains('email')) return 'email';
    if (l.contains('mật') || l.contains('pass')) return 'password';
    return l.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  }

  Widget _textField(Map<String, dynamic> spec, {required bool obscure}) {
    final label = spec['label']?.toString() ?? '';
    final key = _keyFromLabel(label);
    final initial = values[key]?.toString() ?? '';
    final border = const OutlineInputBorder();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing('xl', fallback: 24),
        vertical: _spacing('s', fallback: 8),
      ),
      child: TextFormField(
        initialValue: initial,
        obscureText: obscure,
        keyboardType: obscure ? TextInputType.text : (key == 'email' ? TextInputType.emailAddress : TextInputType.text),
        decoration: InputDecoration(
          labelText: label.isEmpty ? (obscure ? 'Password' : 'Text') : label,
          border: border,
        ),
        onChanged: (v) => values[key] = v,
      ),
    );
  }

  Widget _primaryButton(Map<String, dynamic> spec) {
    final text = spec['text']?.toString() ?? 'Tiếp tục';
    final action = spec['action']?.toString() ?? 'next';
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _spacing('xl', fallback: 24),
        _spacing('m', fallback: 12),
        _spacing('xl', fallback: 24),
        _spacing('xl', fallback: 24),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => onAction(action),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: _spacing('m', fallback: 12)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
            ),
            backgroundColor: _color('secondary', fallback: Colors.orange),
            foregroundColor: Colors.white,
          ),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _oauthButton(Map<String, dynamic> spec) {
    final provider = (spec['provider']?.toString() ?? 'google').toLowerCase();
    final text = 'Tiếp tục với ${provider[0].toUpperCase()}${provider.substring(1)}';
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _spacing('xl', fallback: 24),
        _spacing('xl', fallback: 24),
        _spacing('xl', fallback: 24),
        _spacing('s', fallback: 8),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => onAction('oauth:$provider'),
          icon: const Icon(Icons.account_circle_outlined),
          label: Text(text),
        ),
      ),
    );
  }

  Widget _greeting(Map<String, dynamic> spec) {
    final text = spec['text'] as String? ?? 'Xin chào!';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _color('textPrimary', fallback: Colors.black87),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _skinScoreCard(Map<String, dynamic> spec) {
    final metrics = (spec['metrics'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final lastCheck = spec['lastCheck']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing('xl', fallback: 24),
        vertical: _spacing('m', fallback: 12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _color('surface', fallback: const Color(0xFFF7F7F7)),
          borderRadius: BorderRadius.circular(_radius('xl', fallback: 20)),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 2)),
          ],
        ),
        padding: EdgeInsets.all(_spacing('l', fallback: 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Skin score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _color('textPrimary'),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (lastCheck.isNotEmpty)
                  Text(
                    lastCheck,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: _color('textSecondary', fallback: Colors.grey[700]!),
                        ),
                  ),
              ],
            ),
            SizedBox(height: _spacing('m', fallback: 12)),
            Wrap(
              spacing: _spacing('s', fallback: 8),
              runSpacing: _spacing('s', fallback: 8),
              children: [
                for (final m in metrics)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _spacing('m', fallback: 12),
                      vertical: _spacing('s', fallback: 8),
                    ),
                    decoration: BoxDecoration(
                      color: _color('chipBg', fallback: const Color(0xFFEFEFEF)),
                      borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
                    ),
                    child: Text(
                      m,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _routineStrip(Map<String, dynamic> spec) {
    final period = spec['period']?.toString() ?? '';
    final steps = (spec['steps'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing('xl', fallback: 24),
        vertical: _spacing('s', fallback: 8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _color('textPrimary'),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: _spacing('s', fallback: 8)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final s in steps)
                  Container(
                    margin: EdgeInsets.only(right: _spacing('s', fallback: 8)),
                    padding: EdgeInsets.symmetric(
                      horizontal: _spacing('m', fallback: 12),
                      vertical: _spacing('s', fallback: 8),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
                      border: Border.all(color: _color('textSecondary', fallback: Colors.grey.shade400).withOpacity(0.3)),
                    ),
                    child: Text(s),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _skinTypeSelector(Map<String, dynamic> spec) {
    final options = (spec['options'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final String current = (values['skinType']?.toString() ?? '');
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing('xl', fallback: 24),
        vertical: _spacing('m', fallback: 12),
      ),
      child: Wrap(
        spacing: _spacing('s', fallback: 8),
        runSpacing: _spacing('s', fallback: 8),
        children: [
          for (final o in options)
            ChoiceChip(
              label: Text(o),
              selected: current == o,
              onSelected: (_) => onAction('select:skinType:$o'),
            ),
        ],
      ),
    );
  }

  Widget _concernChecklist(Map<String, dynamic> spec) {
    final items = (spec['items'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final List<String> selected = (values['concerns'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _spacing('xl', fallback: 24),
        vertical: _spacing('m', fallback: 12),
      ),
      child: Wrap(
        spacing: _spacing('s', fallback: 8),
        runSpacing: _spacing('s', fallback: 8),
        children: [
          for (final it in items)
            FilterChip(
              label: Text(it),
              selected: selected.contains(it),
              onSelected: (s) => onAction('toggle:concerns:$it'),
            ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _spacing('xl', fallback: 24),
        _spacing('xl', fallback: 24),
        _spacing('xl', fallback: 24),
        _spacing('s', fallback: 8),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _color('textPrimary'),
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Tìm kiếm',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (v) => values['search'] = v,
      ),
    );
  }

  Widget _section(Map<String, dynamic> spec) {
    final title = spec['title']?.toString() ?? '';
    final listType = spec['listType']?.toString() ?? 'generic';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title),
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: _spacing('xl', fallback: 24)),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
                  boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                padding: EdgeInsets.all(_spacing('m', fallback: 12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${listType == 'product' ? 'Sản phẩm' : 'Mục'} #${index + 1}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text('Mô tả ngắn gọn...', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(width: _spacing('m', fallback: 12)),
            itemCount: 5,
          ),
        ),
      ],
    );
  }

  Widget _productHeader(Map<String, dynamic> spec) {
    final title = spec['title']?.toString() ?? '';
    final store = spec['store']?.toString() ?? '';
    final price = spec['price']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: _spacing('s', fallback: 8)),
          Text(store, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _color('textSecondary', fallback: Colors.grey))),
          SizedBox(height: _spacing('m', fallback: 12)),
          Text(price, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: _color('primary'))),
        ],
      ),
    );
  }

  Widget _tabs(Map<String, dynamic> spec) {
    final items = (spec['items'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _spacing('xl', fallback: 24)),
      child: Wrap(
        spacing: _spacing('s', fallback: 8),
        children: [
          for (final t in items)
            ChoiceChip(
              label: Text(t),
              selected: values['tab'] == t,
              onSelected: (_) => onAction('select:tab:$t'),
            ),
        ],
      ),
    );
  }

  Widget _secondaryButton(Map<String, dynamic> spec) {
    final text = spec['text']?.toString() ?? 'Khác';
    final action = spec['action']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _spacing('xl', fallback: 24),
        _spacing('s', fallback: 8),
        _spacing('xl', fallback: 24),
        _spacing('xl', fallback: 24),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => onAction(action.isEmpty ? 'next' : action),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _postList(Map<String, dynamic> spec) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person))
            ,
        title: const Text('Skincare everyday'),
        subtitle: const Text('Explore the benefits...'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.favorite_border), SizedBox(width: 4), Text('10')]),
      ),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: 6,
    );
  }

  Widget _inlineFab(Map<String, dynamic> spec) {
    final text = spec['text']?.toString() ?? 'Tạo mới';
    final action = spec['action']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Align(
        alignment: Alignment.centerRight,
        child: FloatingActionButton.extended(
          onPressed: () => onAction(action.isEmpty ? 'next' : action),
          icon: const Icon(Icons.add),
          label: Text(text),
        ),
      ),
    );
  }

  Widget _iconInfo(Map<String, dynamic> spec) {
    final text = spec['text']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _cameraPreview() {
    return Container(
      height: 240,
      margin: EdgeInsets.all(_spacing('xl', fallback: 24)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
      ),
      child: const Icon(Icons.camera_alt_outlined, size: 64),
    );
  }

  Widget _largeProgress(Map<String, dynamic> spec) {
    final text = spec['text']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _scoreBadge(Map<String, dynamic> spec) {
    final label = spec['label']?.toString() ?? 'Score';
    final score = values['overall'] ?? 86;
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _color('success', fallback: Colors.green),
            child: Text('$score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _metricGrid(Map<String, dynamic> spec) {
    final items = (spec['items'] as List<dynamic>? ?? const []).cast<Map>().map((e) => e.cast<String, dynamic>()).toList();
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.6),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final it = items[index];
          final label = it['label']?.toString() ?? '';
          final key = it['key']?.toString() ?? '';
          final value = values[key] ?? (60 + (index * 7));
          return Container(
            margin: EdgeInsets.all(_spacing('s', fallback: 8)),
            padding: EdgeInsets.all(_spacing('m', fallback: 12)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _routineStepList(Map<String, dynamic> spec) {
    final title = spec['for']?.toString() ?? '';
    final steps = (spec['steps'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList();
    final alt = spec['altButton']?.toString() ?? 'Sản phẩm khác';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final s in steps) ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(s)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => onAction('altProducts'), child: Text(alt)),
          )
        ],
      ),
    );
  }

  Widget _routineList(Map<String, dynamic> spec) {
    final title = spec['title']?.toString() ?? '';
    final steps = (spec['steps'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList();
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final s in steps) ListTile(leading: const Icon(Icons.spa_outlined), title: Text(s)),
        ],
      ),
    );
  }

  Widget _planSummary(Map<String, dynamic> spec) {
    final name = spec['name']?.toString() ?? '';
    final price = spec['price']?.toString() ?? '';
    final period = spec['period']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(_spacing('l', fallback: 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name.replaceAll('|', ' | '), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: _spacing('s', fallback: 8)),
            Text('${price.replaceAll('|', ' | ')} / $period', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodList(Map<String, dynamic> spec) {
    final methods = (spec['methods'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList();
    final selected = (spec['selected']?.toString()) ?? values['paymentMethod']?.toString();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _spacing('xl', fallback: 24)),
      child: Wrap(
        spacing: _spacing('s', fallback: 8),
        children: [
          for (final m in methods)
            ChoiceChip(
              label: Text(_labelForMethod(m)),
              selected: selected == m,
              onSelected: (_) {
                values['paymentMethod'] = m;
                onAction('select:paymentMethod:$m');
              },
            ),
        ],
      ),
    );
  }

  String _labelForMethod(String m) {
    switch (m) {
      case 'card_international':
        return 'Thẻ quốc tế';
      case 'e_wallet':
        return 'Ví điện tử';
      case 'bank_card':
        return 'Thẻ ngân hàng';
      default:
        return m;
    }
  }

  Widget _cardForm(Map<String, dynamic> spec) {
    final fields = (spec['fields'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList();
    String labelFor(String f) {
      switch (f) {
        case 'cardHolder':
          return 'Tên chủ thẻ';
        case 'cardNumber':
          return 'Số thẻ';
        case 'exp':
          return 'Ngày hết hạn (MM/YY)';
        case 'cvc':
          return 'CVC';
        case 'country':
          return 'Quốc gia';
        default:
          return f;
      }
    }

    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Column(
        children: [
          for (final f in fields)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                initialValue: values[f]?.toString() ?? '',
                decoration: InputDecoration(
                  labelText: labelFor(f),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: f == 'cardNumber' ? TextInputType.number : TextInputType.text,
                obscureText: f == 'cvc',
                onChanged: (v) => values[f] = v,
              ),
            ),
        ],
      ),
    );
  }

  Widget _qrBlock(Map<String, dynamic> spec) {
    final provider = spec['provider']?.toString() ?? 'QR';
    final caption = spec['caption']?.toString() ?? '';
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Container(
        width: double.infinity,
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius('l', fallback: 16)),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_2, size: 96),
            const SizedBox(height: 8),
            Text(provider),
            if (caption.isNotEmpty) Text(caption, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _textButton(Map<String, dynamic> spec) {
    final text = spec['text']?.toString() ?? 'Hủy';
    final action = spec['action']?.toString() ?? 'next';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _spacing('xl', fallback: 24)),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(onPressed: () => onAction(action), child: Text(text)),
      ),
    );
  }

  Widget _successIcon() {
    return Padding(
      padding: EdgeInsets.all(_spacing('xl', fallback: 24)),
      child: Center(
        child: CircleAvatar(
          radius: 42,
          backgroundColor: _color('success', fallback: Colors.green),
          child: const Icon(Icons.check, color: Colors.white, size: 42),
        ),
      ),
    );
  }

  Widget _unknown(String type, Map<String, dynamic> spec) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text('Unknown widget "$type"\n${const JsonEncoder.withIndent('  ').convert(spec)}'),
      ),
    );
  }
}
