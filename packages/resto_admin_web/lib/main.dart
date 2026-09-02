import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_core/resto_core.dart';
import 'features/auth/cubit/admin_auth_cubit.dart';
import 'features/auth/cubit/admin_auth_state.dart';
import 'features/auth/screens/admin_login_screen.dart';
import 'features/dashboard/cubit/admin_dashboard_cubit.dart';
import 'features/dashboard/screens/admin_shell_screen.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  DateFormatter.init();
  runApp(const RestoAdminWebApp());
}

class RestoAdminWebApp extends StatelessWidget {
  const RestoAdminWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminAuthCubit>(create: (_) => AdminAuthCubit()),
        BlocProvider<AdminDashboardCubit>(create: (_) => AdminDashboardCubit()),
      ],
      child: MaterialApp(
        title: 'ريستو - لوحة إدارة العمليات والمطعم',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.surfaceLight,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryCharcoal,
            secondary: AppColors.secondaryTerracotta,
            surface: AppColors.surfaceLight,
          ),
          textTheme: GoogleFonts.cairoTextTheme(),
        ),
        builder: (context, child) {
          // Egyptian Arabic RTL Layout
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: BlocBuilder<AdminAuthCubit, AdminAuthState>(
          builder: (context, state) {
            if (state.step == AdminAuthStep.authenticated) {
              return const AdminShellScreen();
            }
            return const AdminLoginScreen();
          },
        ),
      ),
    );
  }
}
