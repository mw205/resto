import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_core/resto_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RestoLandingPageApp());
}

class RestoLandingPageApp extends StatelessWidget {
  const RestoLandingPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ريستو | تطبيق المطاعم والضيافة المصرية',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBF9F8),
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryCharcoal,
          secondary: AppColors.secondaryTerracotta,
          surface: AppColors.surfaceLight,
        ),
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const LandingPageScreen(),
    );
  }
}

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavBar(context),
            _buildHeroSection(context),
            _buildAppScreenshotsSection(context),
            _buildDishesSection(context),
            _buildGallerySection(context),
            _buildDownloadBanner(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.outlineLight)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RestoLogoWidget(size: isMobile ? 32 : 38, showText: !isMobile),
              if (!isMobile)
                Row(
                  children: [
                    _navLink('الرئيسية'),
                    const SizedBox(width: 28),
                    _navLink('مميزات التطبيق'),
                    const SizedBox(width: 28),
                    _navLink('أطباقنا المميزة'),
                    const SizedBox(width: 28),
                    _navLink('المعرض'),
                  ],
                ),
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryCharcoal,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                        vertical: 10,
                      ),
                      side: const BorderSide(color: AppColors.outlineLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.admin_panel_settings, size: 15),
                    label: Text(
                      'لوحة الإدارة',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => launchUrl(Uri.parse('https://resto-admin-f8712mdj5-mw205s-projects.vercel.app/'), mode: LaunchMode.externalApplication),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryTerracotta,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 14 : 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(RestoIcons.smartphone, size: 15),
                label: Text(
                  'حمل التطبيق',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => launchUrl(Uri.parse('https://drive.google.com/drive/folders/1FY4WpzYWaPibN1hgsEeguVwnmO0GabH5?usp=sharing'), mode: LaunchMode.externalApplication),
              ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _navLink(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryCharcoal,
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 960;

        final heroTextContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondaryTerracotta.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                border: Border.all(
                  color: AppColors.secondaryTerracotta.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    RestoIcons.flame,
                    color: AppColors.secondaryTerracotta,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'تطبيق المطاعم والضيافة الرقمية في مصر',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTerracotta,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ريستو (Resto)\nطعم الضيافة المصرية بين يديك',
              style: GoogleFonts.cairo(
                fontSize: isMobile ? 30 : 42,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryCharcoal,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'تطبيقك الذكي لطلب أشهى المأكولات المصرية والأطباق المشوية. تصفح الأصناف بصور عالية الجودة، اختر الإضافات المفضلة وتابع طلبك خطوة بخطوة حتى يصلك طازجاً وساخناً.',
              style: GoogleFonts.cairo(
                fontSize: isMobile ? 14 : 16,
                color: AppColors.onSurfaceVariantLight,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 14,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryTerracotta,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                    elevation: 3,
                  ),
                  icon: const Icon(RestoIcons.smartphone, size: 18),
                  label: Text(
                    'حمل التطبيق الآن',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => launchUrl(Uri.parse('https://drive.google.com/drive/folders/1FY4WpzYWaPibN1hgsEeguVwnmO0GabH5?usp=sharing'), mode: LaunchMode.externalApplication),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _heroStat('100%', 'طازج ومحضر يومياً'),
                _heroStatSpacer(),
                _heroStat('تتبع فوري', 'لحالة الطلب والتوصيل'),
                _heroStatSpacer(),
                _heroStat('45 دقيقة', 'متوسط وقت التوصيل'),
              ],
            ),
          ],
        );

        final heroMockupContent = SizedBox(
          height: isMobile ? 380 : 480,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clean Mobile Screenshots (NO borders, NO outlines, NO phone frames)
              _buildCleanScreenshotImage(
                imagePath: 'assets/images/screenshots/app_screen_1.png',
                width: isMobile ? 160 : 210,
                height: isMobile ? 340 : 440,
              ),
              const SizedBox(width: 16),
              _buildCleanScreenshotImage(
                imagePath: 'assets/images/screenshots/app_screen_2.png',
                width: isMobile ? 150 : 190,
                height: isMobile ? 310 : 400,
              ),
            ],
          ),
        );

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 36 : 64,
          ),
          constraints: const BoxConstraints(maxWidth: 1300),
          child: isMobile
              ? Column(
                  children: [
                    heroTextContent,
                    const SizedBox(height: 40),
                    heroMockupContent,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: heroTextContent),
                    const SizedBox(width: 48),
                    Expanded(flex: 6, child: heroMockupContent),
                  ],
                ),
        );
      },
    );
  }

  Widget _heroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.secondaryTerracotta,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: AppColors.onSurfaceVariantLight,
          ),
        ),
      ],
    );
  }

  Widget _heroStatSpacer() {
    return Container(height: 24, width: 1, color: AppColors.outlineLight);
  }

  // Full-fit Mobile Screenshot Image (Displays full Apple device border and outline)
  Widget _buildCleanScreenshotImage({
    required String imagePath,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          color: AppColors.surfaceLight,
          child: const Icon(
            Icons.smartphone,
            size: 40,
            color: AppColors.secondaryTerracotta,
          ),
        ),
      ),
    );
  }

  // App Screenshots Showcase Section (Borderless & Clean)
  Widget _buildAppScreenshotsSection(BuildContext context) {
    final appScreenshots = [
      {
        'title': 'الرئيسية والعروض',
        'desc':
            'واجهة أنيقة تبرز العروض اليومية، الأطباق الأكثر طلباً والتصنيفات.',
        'img': 'assets/images/screenshots/app_screen_1.png',
      },
      {
        'title': 'قائمة الطعام والوجبات',
        'desc': 'تصفح الأصناف بأسعارها الحية وصور عالية الدقة وتوفرها بالمطبخ.',
        'img': 'assets/images/screenshots/app_screen_2.png',
      },
      {
        'title': 'تفاصيل الطبق وسلة الطلب',
        'desc': 'إمكانية إضافة الملاحظات وتخصيص المكونات ومراجعة ملخص السلة.',
        'img': 'assets/images/screenshots/app_screen_3.png',
      },
      {
        'title': 'تتبع التوصيل والطلب',
        'desc': 'خريطة حية لتتبع خط سير مندوب التوصيل وحالة المطبخ خطوة بخطوة.',
        'img': 'assets/images/screenshots/app_screen_4.png',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 40 : 72,
          ),
          width: double.infinity,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1250),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTerracotta.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                    ),
                    child: Text(
                      'تجربة مستخدم استثنائية',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTerracotta,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تطبيق الجوال (Resto App)',
                    style: GoogleFonts.cairo(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryCharcoal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'شاشات حية ومصممة بعناية لتمنحك أسهل وأسرع تجربة طلب طعام',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariantLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  if (isMobile)
                    // Mobile Horizontal Scroll List with Borderless Clean Screenshots
                    SizedBox(
                      height: 470,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: appScreenshots.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 18),
                        itemBuilder: (context, idx) {
                          final screen = appScreenshots[idx];
                          return SizedBox(
                            width: 210,
                            child: Column(
                              children: [
                                _buildCleanScreenshotImage(
                                  imagePath: screen['img']!,
                                  width: 200,
                                  height: 390,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  screen['title']!,
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryCharcoal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  screen['desc']!,
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariantLight,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    // Desktop 4-Column Row of Clean Screenshots
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: appScreenshots.map((screen) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                _buildCleanScreenshotImage(
                                  imagePath: screen['img']!,
                                  width: double.infinity,
                                  height: 420,
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  screen['title']!,
                                  style: GoogleFonts.cairo(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryCharcoal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  screen['desc']!,
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariantLight,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Food Dishes Section
  Widget _buildDishesSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        final dishes = [
          {
            'title': 'كباب وكفتة مشوية على الفحم',
            'desc': 'لحم ضاني بلدي طازج مشوي على الفحم مع طحينة وخبر بلدي ساخن',
            'price': '280 ج.م',
            'img': 'assets/images/dish_kebab.jpg',
          },
          {
            'title': 'طاجن بامية باللحم الضاني',
            'desc':
                'طاجن فخار مصري في الفرن بتتبيلة الثوم والكزبرة والصلصة الغنية',
            'price': '235 ج.م',
            'img': 'assets/images/dish_tagine.jpg',
          },
          {
            'title': 'حمام محشي فريك بلدي',
            'desc': 'زوج حمام محشي بالفريك والمكسرات ومحمر بالسمن البلدي',
            'price': '260 ج.م',
            'img': 'assets/images/dish_pigeon.jpg',
          },
        ];

        return Container(
          color: AppColors.surfaceLight,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 40 : 76,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1250),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryTerracotta.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                    ),
                    child: Text(
                      'أصالة المذاق المصري',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTerracotta,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'أشهر أطباق مطبخ ريستو',
                    style: GoogleFonts.cairo(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCharcoal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مختارات من أطباق المطبخ المصري المتوفرة للطلب الفوري في التطبيق',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariantLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  if (isMobile)
                    Column(
                      children: dishes.map((dish) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _dishHighlightCardWidget(
                            dish['title']!,
                            dish['desc']!,
                            dish['price']!,
                            dish['img']!,
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Row(
                      children: dishes.map((dish) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _dishHighlightCardWidget(
                              dish['title']!,
                              dish['desc']!,
                              dish['price']!,
                              dish['img']!,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dishHighlightCardWidget(
    String title,
    String desc,
    String price,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceLight,
                child: const Icon(
                  Icons.restaurant,
                  size: 40,
                  color: AppColors.secondaryTerracotta,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryTerracotta.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'طبق مميز',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryTerracotta,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariantLight,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Text(
                  price,
                  style: GoogleFonts.cairo(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryTerracotta,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context) {
    final galleryImages = [
      {'title': 'مشويات وفحم بلدي', 'img': 'assets/images/dish_kebab.jpg'},
      {'title': 'طواجن فخار أصيلة', 'img': 'assets/images/dish_tagine.jpg'},
      {
        'title': 'حمام محشي بالسمن البلدي',
        'img': 'assets/images/dish_pigeon.jpg',
      },
      {
        'title': 'تطبيقات ريستو الذكية',
        'img': 'assets/images/resto_app_realistic.jpg',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 36 : 64,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1250),
              child: Column(
                children: [
                  Text(
                    'معرض الضيافة والثقافة الغذائية',
                    style: GoogleFonts.cairo(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryCharcoal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'لقطات من مطبخنا وأطباقنا الطازجة التي تحضر يومياً بحب وإتقان',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariantLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: galleryImages.length,
                    itemBuilder: (context, idx) {
                      final item = galleryImages[idx];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              item['img']!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.surfaceLight,
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 30,
                                  color: AppColors.secondaryTerracotta,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Text(
                                item['title']!,
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDownloadBanner(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          color: AppColors.primaryCharcoal,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: isMobile ? 40 : 64,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  Text(
                    'جاهز لتجربة المذاق المصري الأصيل؟',
                    style: GoogleFonts.cairo(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'حمل تطبيق ريستو الآن واستمتع بخصم 20% على طلبك الأول باستخدام كود RESTO20',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryTerracotta,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.apple, size: 22),
                        label: Text(
                          'App Store',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => launchUrl(Uri.parse('https://drive.google.com/drive/folders/1FY4WpzYWaPibN1hgsEeguVwnmO0GabH5?usp=sharing'), mode: LaunchMode.externalApplication),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryCharcoal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.android, size: 22),
                        label: Text(
                          'Google Play',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => launchUrl(Uri.parse('https://drive.google.com/drive/folders/1FY4WpzYWaPibN1hgsEeguVwnmO0GabH5?usp=sharing'), mode: LaunchMode.externalApplication),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Container(
          color: const Color(0xFF191919),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 48,
            vertical: 24,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1250),
              child: isMobile
                  ? Column(
                      children: [
                        Text(
                          '© 2026 ريستو (Resto). جميع الحقوق محفوظة.',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تطبيق طلب الطعام والضيافة الرقمية',
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '© 2026 ريستو (Resto). جميع الحقوق محفوظة.',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          'تطبيق طلب الطعام والضيافة الرقمية • Dart & Flutter',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

}
