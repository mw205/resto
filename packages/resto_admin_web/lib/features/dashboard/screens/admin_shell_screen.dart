import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:resto_core/resto_core.dart';
import '../../auth/cubit/admin_auth_cubit.dart';
import '../cubit/admin_dashboard_cubit.dart';
import 'admin_overview_page.dart';
import 'admin_orders_page.dart';
import 'admin_menu_page.dart';
import 'admin_staff_page.dart';

class AdminShellScreen extends StatelessWidget {
  const AdminShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            if (isDesktop) {
              return Scaffold(
                backgroundColor: AppColors.surfaceLight,
                body: Row(
                  children: [
                    _buildSidebar(context, state, isDrawer: false),
                    Expanded(
                      child: Column(
                        children: [
                          _buildTopBar(context, isDesktop: true, scaffoldKey: scaffoldKey),
                          Expanded(
                            child: _buildSelectedPage(state.selectedNavIndex),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Mobile / Tablet Responsive Mode
              return Scaffold(
                key: scaffoldKey,
                backgroundColor: AppColors.surfaceLight,
                drawer: _buildSidebar(context, state, isDrawer: true),
                appBar: AppBar(
                  backgroundColor: AppColors.primaryCharcoal,
                  foregroundColor: Colors.white,
                  title: Row(
                    children: [
                      const RestoLogoWidget(size: 28, showText: false),
                      const SizedBox(width: 10),
                      Text(
                        'لوحة الإدارة',
                        style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(RestoIcons.logOut, size: 20),
                      tooltip: 'تسجيل الخروج',
                      onPressed: () {
                        context.read<AdminAuthCubit>().logout();
                      },
                    ),
                  ],
                ),
                body: _buildSelectedPage(state.selectedNavIndex),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: state.selectedNavIndex,
                  selectedItemColor: AppColors.secondaryTerracotta,
                  unselectedItemColor: Colors.grey.shade600,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: GoogleFonts.cairo(fontSize: 10),
                  onTap: (index) {
                    context.read<AdminDashboardCubit>().selectNavIndex(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(RestoIcons.layoutDashboard),
                      label: 'المؤشرات',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(RestoIcons.shoppingBag),
                      label: 'الطلبات',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(RestoIcons.utensilsCrossed),
                      label: 'المنيو',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(RestoIcons.bike),
                      label: 'الكباتن',
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildSelectedPage(int index) {
    switch (index) {
      case 0:
        return const AdminOverviewPage();
      case 1:
        return const AdminOrdersPage();
      case 2:
        return const AdminMenuPage();
      case 3:
        return const AdminStaffPage();
      default:
        return const AdminOverviewPage();
    }
  }

  Widget _buildSidebar(BuildContext context, AdminDashboardState state, {required bool isDrawer}) {
    final navItems = [
      {'title': 'لوحة المؤشرات', 'icon': RestoIcons.layoutDashboard},
      {'title': 'إدارة الطلبات', 'icon': RestoIcons.shoppingBag},
      {'title': 'قائمة المأكولات', 'icon': RestoIcons.utensilsCrossed},
      {'title': 'كباتن التوصيل', 'icon': RestoIcons.bike},
    ];

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo & Brand
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              const RestoLogoWidget(size: 40, showText: false),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ريستو إداري',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'OPERATIONS PRO',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryTerracotta,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.white12),
        const SizedBox(height: 16),

        // Nav Items
        Expanded(
          child: ListView.builder(
            itemCount: navItems.length,
            itemBuilder: (context, index) {
              final item = navItems[index];
              final isSelected = state.selectedNavIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: InkWell(
                  onTap: () {
                    context.read<AdminDashboardCubit>().selectNavIndex(index);
                    if (isDrawer) {
                      Navigator.pop(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondaryTerracotta : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          item['title'] as String,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

          // Footer Info & Logout
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(RestoIcons.shieldCheck, color: AppColors.successGreen, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'جلسة محققة TOTP',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(RestoIcons.logOut, size: 16),
                      label: Text(
                        'خروج الإدارة',
                        style: GoogleFonts.cairo(fontSize: 12),
                      ),
                      onPressed: () {
                        context.read<AdminAuthCubit>().logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

    if (isDrawer) {
      return Drawer(
        backgroundColor: AppColors.primaryCharcoal,
        child: SafeArea(child: content),
      );
    }

    return Container(
      width: 260,
      color: AppColors.primaryCharcoal,
      child: content,
    );
  }

  Widget _buildTopBar(BuildContext context, {required bool isDesktop, required GlobalKey<ScaffoldState> scaffoldKey}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.outlineLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'فرع القاهرة الرئيسي - المعادي',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryCharcoal,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  'نشط ومستقر',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.successGreen,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(RestoIcons.bell, size: 20),
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.secondaryTerracotta,
                child: Text(
                  'AD',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
