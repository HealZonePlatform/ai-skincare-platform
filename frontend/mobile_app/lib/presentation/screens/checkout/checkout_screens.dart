import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';

class CheckoutMethodScreen extends StatefulWidget {
  const CheckoutMethodScreen({super.key});

  @override
  State<CheckoutMethodScreen> createState() => _CheckoutMethodScreenState();
}

class _CheckoutMethodScreenState extends State<CheckoutMethodScreen> {
  String _selected = 'card_international';
  final _methods = const [
    _Method(id: 'card_international', label: 'Thẻ quốc tế (Visa/Master)'),
    _Method(id: 'e_wallet', label: 'Ví điện tử (MoMo, ZaloPay)'),
    _Method(id: 'bank_card', label: 'Thẻ ngân hàng nội địa'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn phương thức thanh toán')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const _PlanSummary(),
              const SizedBox(height: AppSpacing.xl),
              ..._methods.map(
                (method) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.s),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.m),
                    border: Border.all(
                      color: method.id == _selected ? AppColors.primary : AppColors.chipBg,
                    ),
                  ),
                  child: RadioListTile<String>(
                    value: method.id,
                    groupValue: _selected,
                    title: Text(method.label),
                    onChanged: (value) => setState(() => _selected = value ?? _selected),
                  ),
                ),
              ),
              const Spacer(),
              HzPrimaryButton(
                label: 'Tiếp tục thanh toán',
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (_selected == 'e_wallet') {
                    context.push('/checkout/qr');
                  } else {
                    context.push('/checkout/card');
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

class CheckoutCardScreen extends StatefulWidget {
  const CheckoutCardScreen({super.key});

  @override
  State<CheckoutCardScreen> createState() => _CheckoutCardScreenState();
}

class _CheckoutCardScreenState extends State<CheckoutCardScreen> {
  final _holderController = TextEditingController();
  final _numberController = TextEditingController();
  final _expController = TextEditingController();
  final _cvcController = TextEditingController();

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán bằng thẻ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              TextField(
                controller: _holderController,
                decoration: const InputDecoration(labelText: 'Tên chủ thẻ'),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số thẻ'),
              ),
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expController,
                      decoration: const InputDecoration(labelText: 'MM/YY'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: TextField(
                      controller: _cvcController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'CVC'),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              HzPrimaryButton(
                label: 'Thanh toán',
                icon: Icons.lock_outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang xử lý thanh toán thẻ...')),
                  );
                  context.push('/checkout/success');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutQrScreen extends StatelessWidget {
  const CheckoutQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét QR để thanh toán')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.l),
                  boxShadow: AppShadows.mild,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.qr_code_2, size: 120),
              ),
              const SizedBox(height: AppSpacing.l),
              const Text('Mở ứng dụng ngân hàng hoặc ví điện tử để quét mã VNPAY.'),
              const Spacer(),
              HzPrimaryButton(
                label: 'Tôi đã thanh toán',
                icon: Icons.check,
                onPressed: () => context.push('/checkout/success'),
              ),
              const SizedBox(height: AppSpacing.s),
              HzSecondaryButton(
                label: 'Huỷ và quay lại',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutSuccessScreen extends StatelessWidget {
  const CheckoutSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán thành công')), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.success.withOpacityFraction(0.15),
              child: const Icon(Icons.check_circle, color: AppColors.success, size: 48),
            ),
            const SizedBox(height: AppSpacing.l),
            const Text('Chúc mừng!'),
            const SizedBox(height: AppSpacing.s),
            const Text('Bạn đã trở thành hội viên HealZone Premium.'),
            const SizedBox(height: AppSpacing.xl),
            HzPrimaryButton(
              label: 'Quay lại trang chủ',
              icon: Icons.home_outlined,
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanSummary extends StatelessWidget {
  const _PlanSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: AppShadows.mild,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Gói Chuyên Gia', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: AppSpacing.s),
          Text('99.000đ / tháng'),
          SizedBox(height: AppSpacing.s),
          Text('Bao gồm: Routine cá nhân, chuyên gia đồng hành, ưu đãi sản phẩm'),
        ],
      ),
    );
  }
}

class _Method {
  final String id;
  final String label;
  const _Method({required this.id, required this.label});
}
