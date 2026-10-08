import 'package:renth_manager/widgets/web_image.dart';

import '../consts/consts.dart';
import '../model/withdraw_req_model.dart';
import '../page/withdraw_page/quick_tech_withdraw_page.dart';

// --- Components ---

Widget balanceCard() {
  final dashboardController = locator.get<DashboardController>();


  return Container(
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          mainColor,
          const Color(0xFFFFD700), // Gold gradient
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: mainColor.withValues(alpha: 0.35),
          blurRadius: 18,
          spreadRadius: -2,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Stack(
      children: [
        // Decorative background subtle circles for depth
        Positioned(
          right: -20.w,
          top: -20.h,
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.white.withValues(alpha: 0.12),
          ),
        ),


        // Background Taka Watermark Icon
        Positioned(
          right: 20,
          bottom: -25,
          child: Text(
            '৳',
            style: TextStyle(
              fontSize: 100.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black.withValues(alpha: 0.06), // Very subtle opacity
            ),
          ),
        ),

        // Main Card Content
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row: Wallet Icon + Label + Privacy Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 18.w,
                          color: Colors.black87,
                        ),
                      ),
                      10.horizontalSpace,
                      Text(
                        'Available Balance',
                        style: QuickTechAppTextStyle.bodyText2().copyWith(
                          color: Colors.black.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  // Hide/Show Balance Toggle Button
                  GestureDetector(
                    onTap: () => dashboardController.isBalanceVisible.toggle(),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() => Icon(
                        dashboardController.isBalanceVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 16.w,
                        color: Colors.black87,
                      )),
                    ),
                  ),
                ],
              ),

              14.verticalSpace,

              // Balance Display Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Obx(() {
                    final balance = dashboardController.dashboard.value.availableBalance ?? '0';
                    return Text(
                      dashboardController.isBalanceVisible.value ? '৳ $balance' : '৳ ••••••',
                      style: QuickTechAppTextStyle.headline1().copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 28.sp,
                        letterSpacing: 0.5,
                      ),
                    );
                  }),
                  8.horizontalSpace,

                  // BDT Tag
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'BDT',
                      style: QuickTechAppTextStyle.bodyText2().copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget withdrawActionCard({required VoidCallback onWithdraw}) {
  return Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Withdraw Funds',
                style: QuickTechAppTextStyle.headline4().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.verticalSpace,
              Text(
                'Request a payout to your account',
                style: QuickTechAppTextStyle.bodyText4().copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        customButton2(
          title: 'Withdraw',
          onTap: onWithdraw,
          height: 44.h,
          icon: Icons.arrow_outward,
          iconSize: 18.w,
          style: QuickTechAppTextStyle.bodyText3().copyWith(
            fontWeight: FontWeight.bold,
          ),
        ).box.width(130.w).make(),
      ],
    ),
  );
}

PaymentMethod parsePaymentMethod(Datum item) {
  final methodStr = (item.type ?? item.paymentType?.toString() ??
      item.bankName?.toString() ?? '').toLowerCase();
  if (methodStr.contains('bkash')) {
    return PaymentMethod.bkash;
  } else if (methodStr.contains('nagad')) {
    return PaymentMethod.nagad;
  } else if (methodStr.contains('rocket')) {
    return PaymentMethod.rocket;
  } else
  if (methodStr.contains('bank') || (item.bankName != null && item.bankName
      .toString()
      .isNotEmpty)) {
    return PaymentMethod.bank;
  }
  return PaymentMethod.bkash;
}

Widget withdrawHistoryItem(Datum item, {VoidCallback? onTap}) {
  final method = parsePaymentMethod(item);
  final statusStr = item.status ?? 'Pending';
  final statusColor = getStatusColor(statusStr);
  final methodColor = getWithdrawMethodColor(method);
  final amountVal = double.tryParse(item.totalAmount?.toString() ?? '0') ?? 0.0;
  final date = item.createdAtDhaka;
  final hasEvidence = item.evidencePhoto != null &&
      item.evidencePhoto!.trim().isNotEmpty;

  final payTypeStr = item.paymentType?.toString().trim();
  final effectivePaymentType = (payTypeStr != null && payTypeStr.isNotEmpty)
      ? payTypeStr
      : (item.type?.isNotEmpty == true ? item.type! : getWithdrawMethodName(
      method));

  final holder = item.accountHolderName?.toString().trim();
  final bName = item.bankName?.toString().trim();
  final aNum = item.accountNumber?.toString().trim();
  final phone = item.phoneNumber?.toString().trim();
  final branch = item.branchOrRoutingNumber?.toString().trim();
  final subj = item.subject?.trim();

  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap ?? () => showWithdrawDetailDialog(Get.context!, item),
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 42.h,
                  width: 42.h,
                  decoration: BoxDecoration(
                    color: methodColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    getWithdrawMethodIcon(method),
                    color: methodColor,
                    size: 22.w,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        effectivePaymentType,
                        style: QuickTechAppTextStyle.bodyText2().copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        'ID: REQ-${item.id ?? ''}',
                        style: QuickTechAppTextStyle.bodyText4().copyWith(
                          color: Colors.grey.shade500,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    statusStr,
                    style: QuickTechAppTextStyle.bodyText3().copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
            12.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 10.sp,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      '৳${amountVal.toStringAsFixed(2)}',
                      style: QuickTechAppTextStyle.headline4().copyWith(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date',
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 10.sp,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      '$date',
                      style: QuickTechAppTextStyle.bodyText3().copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            10.verticalSpace,

            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  if (holder != null && holder.isNotEmpty)
                    _buildMiniDetailRow(Icons.person_outline, 'Holder', holder),
                  if (bName != null && bName.isNotEmpty)
                    _buildMiniDetailRow(
                        Icons.account_balance_outlined, 'Bank', bName),
                  if (aNum != null && aNum.isNotEmpty)
                    _buildMiniDetailRow(
                        Icons.credit_card_outlined, 'Account No', aNum),
                  if (phone != null && phone.isNotEmpty && phone != aNum)
                    _buildMiniDetailRow(Icons.phone_iphone, 'Phone', phone),
                  if (branch != null && branch.isNotEmpty)
                    _buildMiniDetailRow(
                        Icons.location_on_outlined, 'Branch/Routing', branch),
                  if (subj != null && subj.isNotEmpty)
                    _buildMiniDetailRow(Icons.notes_outlined, 'Subject', subj),
                ],
              ),
            ),

            10.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasEvidence)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                          color: Colors.blue.shade200, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 12.w,
                          color: Colors.blue.shade700,
                        ),
                        4.horizontalSpace,
                        Text(
                          'Evidence Photo',
                          style: QuickTechAppTextStyle.bodyText4().copyWith(
                            color: Colors.blue.shade700,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: [
                    Text(
                      'Tap for details',
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                    2.horizontalSpace,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10.w,
                      color: mainColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMiniDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(
      children: [
        Icon(icon, size: 14.w, color: Colors.grey.shade600),
        6.horizontalSpace,
        Text(
          '$label: ',
          style: QuickTechAppTextStyle.bodyText4().copyWith(
            color: Colors.grey.shade600,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: QuickTechAppTextStyle.bodyText4().copyWith(
              color: Colors.black87,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

void showWithdrawDetailDialog(BuildContext context, Datum item) {
  final method = parsePaymentMethod(item);
  final statusStr = item.status ?? 'Pending';
  final statusColor = getStatusColor(statusStr);
  final methodColor = getWithdrawMethodColor(method);
  final amountVal = double.tryParse(item.totalAmount?.toString() ?? '0') ?? 0.0;
  final date = item.createdAtDhaka;
  final hasEvidence = item.evidencePhoto != null &&
      item.evidencePhoto!.trim().isNotEmpty;

  final payTypeStr = item.paymentType?.toString().trim();
  final effectivePaymentType = (payTypeStr != null && payTypeStr.isNotEmpty)
      ? payTypeStr
      : (item.type?.isNotEmpty == true ? item.type! : getWithdrawMethodName(
      method));

  final holder = item.accountHolderName?.toString().trim();
  final bName = item.bankName?.toString().trim();
  final aNum = item.accountNumber?.toString().trim();
  final phone = item.phoneNumber?.toString().trim();
  final branch = item.branchOrRoutingNumber?.toString().trim();
  final subj = item.subject?.trim();

  String? fullImageUrl;
  if (hasEvidence) {
    final photo = item.evidencePhoto!.trim();
    if (photo.startsWith('http://') || photo.startsWith('https://')) {
      fullImageUrl = photo;
    } else {
      final cleanPath = photo.startsWith('/') ? photo.substring(1) : photo;
      fullImageUrl = "${Api.imageUrl}$cleanPath";
    }
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.all(16.w),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery
              .of(context)
              .size
              .height * 0.85,
        ),
        padding: EdgeInsets.all(18.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: methodColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        getWithdrawMethodIcon(method),
                        color: methodColor,
                        size: 20.w,
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      'Withdrawal Details',
                      style: QuickTechAppTextStyle.headline3().copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            16.verticalSpace,

            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            statusColor.withValues(alpha: 0.15),
                            statusColor.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Request Amount',
                                style: QuickTechAppTextStyle
                                    .bodyText4()
                                    .copyWith(
                                  color: Colors.grey.shade700,
                                  fontSize: 11.sp,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                '৳${amountVal.toStringAsFixed(2)}',
                                style: QuickTechAppTextStyle
                                    .headline1()
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 24.sp,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              statusStr.toUpperCase(),
                              style: QuickTechAppTextStyle.bodyText3().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,

                    Text(
                      'Transaction Details',
                      style: QuickTechAppTextStyle.bodyText2().copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    12.verticalSpace,

                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildDialogDetailRow('Request ID', 'REQ-${item.id ??
                              ''}'),
                          _buildDialogDetailRow(
                            'Payment Type',
                            effectivePaymentType,
                            valueColor: methodColor,
                            isBold: true,
                          ),
                          if (holder != null && holder.isNotEmpty)
                            _buildDialogDetailRow('Account Holder', holder),
                          if (bName != null && bName.isNotEmpty)
                            _buildDialogDetailRow('Bank Name', bName),
                          if (aNum != null && aNum.isNotEmpty)
                            _buildDialogDetailRow('Account Number', aNum),
                          if (phone != null && phone.isNotEmpty)
                            _buildDialogDetailRow('Phone Number', phone),
                          if (branch != null && branch.isNotEmpty)
                            _buildDialogDetailRow('Branch / Routing', branch),
                          if (subj != null && subj.isNotEmpty)
                            _buildDialogDetailRow('Subject', subj),
                          if (item.type != null && item.type!.trim().isNotEmpty)
                            _buildDialogDetailRow('Type', item.type!),
                          _buildDialogDetailRow(
                            'Requested Date',
                            date??'',
                          ),
                          if (item.updatedAt != null)
                            _buildDialogDetailRow(
                              'Last Updated',
                              item.updatedAtDhaka??'',
                              isLast: true,
                            ),
                        ],
                      ),
                    ),
                    20.verticalSpace,

                    Text(
                      'Evidence Photo',
                      style: QuickTechAppTextStyle.bodyText2().copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    10.verticalSpace,

                    if (fullImageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _showFullScreenImageDialog(
                                        context, fullImageUrl!),
                                child:
                                WebSafeNetworkImage(imageUrl: fullImageUrl, width: double.infinity, height: 200.h, fit: BoxFit.cover),
                                //  Image.network(
                                //   fullImageUrl,
                                //   width: double.infinity,
                                //   height: 200.h,
                                //   fit: BoxFit.cover,
                                //   loadingBuilder: (context, child,
                                //       loadingProgress) {
                                //     if (loadingProgress == null) return child;
                                //     return Container(
                                //       height: 200.h,
                                //       color: Colors.grey.shade100,
                                //       child: const Center(
                                //         child: CircularProgressIndicator(),
                                //       ),
                                //     );
                                //   },
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Container(
                                //       height: 140.h,
                                //       color: Colors.grey.shade100,
                                //       padding: EdgeInsets.all(16.w),
                                //       child: Column(
                                //         mainAxisAlignment: MainAxisAlignment
                                //             .center,
                                //         children: [
                                //           Icon(
                                //             Icons.broken_image_outlined,
                                //             size: 40.w,
                                //             color: Colors.grey.shade400,
                                //           ),
                                //           8.verticalSpace,
                                //           Text(
                                //             'Unable to load evidence photo',
                                //             style: QuickTechAppTextStyle
                                //                 .bodyText4().copyWith(
                                //               color: Colors.grey.shade600,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _showFullScreenImageDialog(
                                        context, fullImageUrl!),
                                child: Container(
                                  margin: EdgeInsets.all(10.w),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.zoom_in,
                                        color: Colors.white,
                                        size: 16.w,
                                      ),
                                      6.horizontalSpace,
                                      Text(
                                        'Tap to zoom',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey.shade400,
                              size: 32.w,
                            ),
                            8.verticalSpace,
                            Text(
                              'No evidence photo attached',
                              style: QuickTechAppTextStyle.bodyText4().copyWith(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,

            SizedBox(
              width: double.infinity,
              child: customButton2(
                title: 'Close',
                onTap: () => Get.back(),
                height: 46.h,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDialogDetailRow(String label,
    String value, {
      Color? valueColor,
      bool isBold = false,
      bool isLast = false,
    }) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: QuickTechAppTextStyle.bodyText4().copyWith(
                color: Colors.grey.shade600,
                fontSize: 12.sp,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: QuickTechAppTextStyle.bodyText3().copyWith(
                  color: valueColor ?? Colors.black87,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
      if (!isLast)
        Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
    ],
  );
}

void _showFullScreenImageDialog(BuildContext context, String imageUrl) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.all(10.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child:
              WebSafeNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              )
              //  Image.network(
              //   imageUrl,
              //   fit: BoxFit.contain,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return const Center(
              //       child: CircularProgressIndicator(color: Colors.white),
              //     );
              //   },
              //   errorBuilder: (context, error, stackTrace) {
              //     return Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(Icons.broken_image, color: Colors.white, size: 48.w),
              //         12.verticalSpace,
              //         const Text(
              //           'Failed to load full image',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ],
              //     );
              //   },
              // ),
            ),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    ),
  );
}



Widget withdrawDialogBody({
  required PaymentMethod selectedMethod,
  required Function(PaymentMethod) onMethodChanged,
  required TextEditingController amountController,
  required TextEditingController bankNameController,
  required TextEditingController accountHolderController,
  required TextEditingController accountNumberController,
  required TextEditingController branchNameController,
  required double minimumWithdraw,
  required VoidCallback onSubmit,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Withdraw Funds',
            style: QuickTechAppTextStyle.headline3().copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
      16.verticalSpace,
      Text(
        'Select Payout Method',
        style: QuickTechAppTextStyle.bodyText3().copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      12.verticalSpace,
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children:
          PaymentMethod.values.map((method) {
            final isSelected = selectedMethod == method;
            final color = getWithdrawMethodColor(method);
            return GestureDetector(
              onTap: () => onMethodChanged(method),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color:
                  isSelected
                      ? color.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      getWithdrawMethodIcon(method),
                      size: 16.w,
                      color: isSelected ? color : Colors.grey.shade600,
                    ),
                    8.horizontalSpace,
                    Text(
                      getWithdrawMethodName(method),
                      style: QuickTechAppTextStyle.bodyText4().copyWith(
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? color : Colors.black87,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      20.verticalSpace,
      withdrawInfoRow(
        Icons.info_outline,
        "Minimum withdrawal is ৳$minimumWithdraw",
      ),
      16.verticalSpace,
      customTextField(
        controller: amountController,
        keyboard: const TextInputType.numberWithOptions(decimal: true),
        hint: 'Amount (৳)',
        isSuffix: false,
        isVisible: true,
        icon: Icons.payments_outlined,
      ),
      16.verticalSpace,
      if (selectedMethod == PaymentMethod.bank) ...[
        customTextField(
          controller: bankNameController,
          hint: 'Bank Name',
          isSuffix: false,
          isVisible: true,
          icon: Icons.account_balance,
        ),
        12.verticalSpace,
        customTextField(
          controller: accountHolderController,
          hint: 'Account Holder Name',
          isSuffix: false,
          isVisible: true,
          icon: Icons.person_outline,
        ),
        12.verticalSpace,
        customTextField(
          controller: accountNumberController,
          keyboard: TextInputType.number,
          hint: 'Account Number',
          isSuffix: false,
          isVisible: true,
          icon: Icons.numbers,
        ),
        12.verticalSpace,
        customTextField(
          controller: branchNameController,
          hint: 'Branch / Routing Number',
          isSuffix: false,
          isVisible: true,
          icon: Icons.location_on_outlined,
        ),
      ] else
        ...[
          customTextField(
            controller: accountNumberController,
            keyboard: TextInputType.phone,
            hint: '${getWithdrawMethodName(selectedMethod)} Number',
            isSuffix: false,
            isVisible: true,
            icon: Icons.phone_iphone,
          ),
        ],
      24.verticalSpace,
      customButton2(title: 'Submit Request', onTap: onSubmit, height: 50.h),
    ],
  );
}

// --- Helpers ---

String getWithdrawMethodName(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.bkash:
      return 'bKash';
    case PaymentMethod.nagad:
      return 'Nagad';
    case PaymentMethod.rocket:
      return 'Rocket';
    case PaymentMethod.bank:
      return 'Bank';
  }
}

IconData getWithdrawMethodIcon(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.bank:
      return Icons.account_balance;
    default:
      return Icons.account_balance_wallet_outlined;
  }
}

Color getWithdrawMethodColor(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.bkash:
      return const Color(0xFFD12053);
    case PaymentMethod.nagad:
      return const Color(0xFFF16522);
    case PaymentMethod.rocket:
      return const Color(0xFF8C3494);
    case PaymentMethod.bank:
      return Colors.blue.shade700;
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return Colors.green.shade600;
    case 'pending':
      return Colors.orange.shade600;
    case 'rejected':
      return Colors.red.shade600;
    default:
      return Colors.grey;
  }
}

String getWithdrawMonth(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

Widget withdrawInfoRow(IconData icon, String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      children: [
        Icon(icon, size: 16.w, color: Colors.blue.shade700),
        8.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: QuickTechAppTextStyle.bodyText4().copyWith(
              color: Colors.blue.shade800,
              fontSize: 11.sp,
            ),
          ),
        ),
      ],
    ),
  );
}
