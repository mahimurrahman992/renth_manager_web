import '../../consts/consts.dart';
import '../../controller/quick_tech_withdraw_controller.dart';

import '../../widgets/withdraw_widgets.dart';

enum PaymentMethod { bkash, nagad, rocket, bank }

class WalletWithdrawPage extends StatefulWidget {
  const WalletWithdrawPage({super.key});

  @override
  State<WalletWithdrawPage> createState() => _WalletWithdrawPageState();
}

class _WalletWithdrawPageState extends State<WalletWithdrawPage> {
  final controller = locator.get<WithdrawController>();
  final double minimumWithdraw = 500.0;
  PaymentMethod selectedMethod = PaymentMethod.bkash;

  final _amountController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _accountHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      controller.getWithdraw();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  Future<void> _submitWithdrawalRequest() async {
    final amountText = _amountController.text.trim();
    final accountNumberText = _accountNumberController.text.trim();

    if (amountText.isEmpty) {
      showErrorToast("Please enter an amount");
      return;
    }

    final double? withdrawAmount = double.tryParse(amountText);
    if (withdrawAmount == null || withdrawAmount <= 0) {
      showErrorToast("Enter a valid positive amount");
      return;
    }

    String bankName = '';
    String accountHolderName = '';
    String accountNumber = '';
    String phoneNumber = '';
    String branchOrRoutingNumber = '';
    String paymentType = getWithdrawMethodName(selectedMethod);
    String totalAmount = amountText;

    if (selectedMethod == PaymentMethod.bank) {
      if (_bankNameController.text.trim().isEmpty) {
        showErrorToast("Enter bank name");
        return;
      }
      if (_accountHolderController.text.trim().isEmpty) {
        showErrorToast("Enter account holder name");
        return;
      }
      if (accountNumberText.isEmpty) {
        showErrorToast("Enter account number");
        return;
      }
      if (_branchNameController.text.trim().isEmpty) {
        showErrorToast("Enter branch name or routing number");
        return;
      }
      bankName = _bankNameController.text.trim();
      accountHolderName = _accountHolderController.text.trim();
      accountNumber = accountNumberText;
      branchOrRoutingNumber = _branchNameController.text.trim();
    } else {
      if (accountNumberText.isEmpty) {
        showErrorToast("Please enter mobile number");
        return;
      }
      if (accountNumberText.length < 11) {
        showErrorToast("Enter a valid 11-digit mobile number");
        return;
      }
      phoneNumber = accountNumberText;
      accountNumber = accountNumberText;
    }

    await controller.saveWithdrawRequest(
      bankName: bankName,
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      phoneNumber: phoneNumber,
      branchOrRoutingNumber: branchOrRoutingNumber,
      paymentType: paymentType,
      totalAmount: totalAmount,
    );

    _amountController.clear();
    _accountNumberController.clear();
    _bankNameController.clear();
    _branchNameController.clear();
    _accountHolderController.clear();

    Get.back();
  }

  void _showWithdrawDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        insetPadding: EdgeInsets.all(16.w),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: withdrawDialogBody(
                  selectedMethod: selectedMethod,
                  onMethodChanged: (method) =>
                      setDialogState(() => selectedMethod = method),
                  amountController: _amountController,
                  bankNameController: _bankNameController,
                  accountHolderController: _accountHolderController,
                  accountNumberController: _accountNumberController,
                  branchNameController: _branchNameController,
                  minimumWithdraw: minimumWithdraw,
                  onSubmit: _submitWithdrawalRequest,
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return WithdrawMobileView(
              controller: controller,
              onWithdraw: _showWithdrawDialog,
            );
          } else if (width < 1024) {
            return WithdrawTabletView(
              controller: controller,
              onWithdraw: _showWithdrawDialog,
            );
          } else {
            return WithdrawDesktopView(
              controller: controller,
              onWithdraw: _showWithdrawDialog,
            );
          }
        },
      ),
    );
  }
}

class WithdrawMobileView extends StatelessWidget {
  final WithdrawController controller;
  final VoidCallback onWithdraw;

  const WithdrawMobileView({
    super.key,
    required this.controller,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [mainColor, mainColor.withValues(alpha: 0.75)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 24.w, 20.h),
              child: Row(
                children: [
                  const WithdrawBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet & Withdraw',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        2.verticalSpace,
                        Text(
                          'Manage your balance and payouts',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                  child: RefreshIndicator(
                    onRefresh: () => controller.getWithdraw(page: 1),
                    child: ListView(
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                      children: [
                        balanceCard()
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1),
                        20.verticalSpace,
                        withdrawActionCard(
                          onWithdraw: onWithdraw,
                        ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                        24.verticalSpace,
                        WithdrawHistoryCard(
                          controller: controller,
                          scrollable: false,
                          showRefresh: false,
                        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WithdrawTabletView extends StatelessWidget {
  final WithdrawController controller;
  final VoidCallback onWithdraw;

  const WithdrawTabletView({
    super.key,
    required this.controller,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const WithdrawTopBar(horizontalPadding: 24),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.getWithdraw(page: 1),
              child: SingleChildScrollView(
                controller: controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      children: [
                        balanceCard()
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.1),
                        20.verticalSpace,
                        withdrawActionCard(
                          onWithdraw: onWithdraw,
                        ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                        24.verticalSpace,
                        WithdrawHistoryCard(
                          controller: controller,
                          scrollable: false,
                          showRefresh: false,
                        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawDesktopView extends StatelessWidget {
  final WithdrawController controller;
  final VoidCallback onWithdraw;

  const WithdrawDesktopView({
    super.key,
    required this.controller,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const WithdrawTopBar(horizontalPadding: 40),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 28.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              balanceCard()
                                  .animate()
                                  .fadeIn(duration: 400.ms)
                                  .slideY(begin: 0.1),
                              20.verticalSpace,
                              withdrawActionCard(
                                onWithdraw: onWithdraw,
                              ).animate().fadeIn(
                                duration: 500.ms,
                                delay: 100.ms,
                              ),
                            ],
                          ),
                        ),
                      ),
                      24.horizontalSpace,
                      Expanded(
                        flex: 6,
                        child: WithdrawHistoryCard(
                          controller: controller,
                          scrollable: true,
                          showRefresh: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawHistoryCard extends StatelessWidget {
  final WithdrawController controller;
  final bool scrollable;
  final bool showRefresh;

  const WithdrawHistoryCard({
    super.key,
    required this.controller,
    required this.scrollable,
    required this.showRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final header = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.history_rounded, color: mainColor, size: 20),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            'Withdrawal History',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        if (showRefresh)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              tooltip: 'Refresh',
              onPressed: () => controller.getWithdraw(page: 1),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          16.verticalSpace,
          if (scrollable)
            Expanded(
              child: WithdrawHistoryList(
                controller: controller,
                scrollable: true,
              ),
            )
          else
            WithdrawHistoryList(controller: controller, scrollable: false),
        ],
      ),
    );
  }
}

class WithdrawHistoryList extends StatelessWidget {
  final WithdrawController controller;
  final bool scrollable;

  const WithdrawHistoryList({
    super.key,
    required this.controller,
    required this.scrollable,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.withdrawList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: CircularProgressIndicator(color: mainColor),
          ),
        );
      }

      final dataList = controller.withdrawList;

      if (dataList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey.shade300),
                12.verticalSpace,
                Text(
                  'No transactions yet',
                  style: QuickTechAppTextStyle.bodyText3().copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final bool more = controller.isMoreLoading.value;

      return ListView.separated(
        controller: scrollable ? controller.scrollController : null,
        shrinkWrap: !scrollable,
        physics: scrollable ? null : const NeverScrollableScrollPhysics(),
        itemCount: dataList.length + (more ? 1 : 0),
        separatorBuilder: (context, index) => 12.verticalSpace,
        itemBuilder: (context, index) {
          if (index >= dataList.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: CircularProgressIndicator(color: mainColor),
              ),
            );
          }

          final datum = dataList[index];
          return withdrawHistoryItem(
            datum,
            onTap: () => showWithdrawDetailDialog(context, datum),
          );
        },
      );
    });
  }
}

class WithdrawTopBar extends StatelessWidget {
  final double horizontalPadding;

  const WithdrawTopBar({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          const WithdrawBackButton(light: false),
          16.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet & Withdraw',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              2.verticalSpace,
              Text(
                'Manage your balance and payouts',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WithdrawBackButton extends StatelessWidget {
  final bool light;

  const WithdrawBackButton({super.key, required this.light});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: light
                ? Colors.white.withValues(alpha: 0.18)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: light ? textColor : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}