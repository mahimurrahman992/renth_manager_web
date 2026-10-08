import 'package:flutter_html/flutter_html.dart';

import '../../consts/consts.dart';

class QuickTechCustomHtmlTextView extends StatelessWidget {
  final String title;
  final String desc;

  const QuickTechCustomHtmlTextView({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          if (width < 600) {
            return HtmlMobileView(title: title, desc: desc);
          } else if (width < 1024) {
            return HtmlTabletView(title: title, desc: desc);
          } else {
            return HtmlDesktopView(title: title, desc: desc);
          }
        },
      ),
    );
  }
}

class HtmlMobileView extends StatelessWidget {
  final String title;
  final String desc;

  const HtmlMobileView({super.key, required this.title, required this.desc});

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
                  const HtmlBackButton(light: true),
                  14.horizontalSpace,
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32.r)),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 32.h),
                    child: HtmlContentBody(desc: desc, fontSize: 15),
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

class HtmlTabletView extends StatelessWidget {
  final String title;
  final String desc;

  const HtmlTabletView({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          HtmlTopBar(title: title, horizontalPadding: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: HtmlCard(
                    padding: 32,
                    child: HtmlContentBody(desc: desc, fontSize: 16),
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

class HtmlDesktopView extends StatelessWidget {
  final String title;
  final String desc;

  const HtmlDesktopView({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          HtmlTopBar(title: title, horizontalPadding: 40),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 36.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: HtmlCard(
                    padding: 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        16.verticalSpace,
                        Container(
                          width: 56,
                          height: 4,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        28.verticalSpace,
                        HtmlContentBody(desc: desc, fontSize: 17),
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

class HtmlContentBody extends StatelessWidget {
  final String desc;
  final double fontSize;

  const HtmlContentBody({super.key, required this.desc, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    if (desc.trim().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.article_outlined,
                size: 48,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                'No content available',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Html(
      data: desc,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(fontSize),
          lineHeight: LineHeight.number(1.7),
          color: const Color(0xFF374151),
        ),
        'h1': Style(
          fontSize: FontSize(fontSize + 9),
          fontWeight: FontWeight.w800,
          color: const Color(0xFF111827),
        ),
        'h2': Style(
          fontSize: FontSize(fontSize + 6),
          fontWeight: FontWeight.w700,
          color: const Color(0xFF111827),
        ),
        'h3': Style(
          fontSize: FontSize(fontSize + 3),
          fontWeight: FontWeight.w700,
          color: const Color(0xFF111827),
        ),
        'a': Style(color: mainColor, fontWeight: FontWeight.w600),
      },
    );
  }
}

class HtmlCard extends StatelessWidget {
  final double padding;
  final Widget child;

  const HtmlCard({super.key, required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class HtmlTopBar extends StatelessWidget {
  final String title;
  final double horizontalPadding;

  const HtmlTopBar({
    super.key,
    required this.title,
    required this.horizontalPadding,
  });

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
          const HtmlBackButton(light: false),
          16.horizontalSpace,
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HtmlBackButton extends StatelessWidget {
  final bool light;

  const HtmlBackButton({super.key, required this.light});

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
            color: light ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}