import 'package:finetrack/core/provider/theme_provider.dart' show ThemeProvider;
import 'package:finetrack/core/providers/theme_provider.dart';
import 'package:finetrack/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(
    ChangeNotifierProvider(create: (_) => themeProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          themeMode: themeProvider.themeMode,

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          home: child,
        );
      },

      child: const SplashScreen(),
    );
  }
}
