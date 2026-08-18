import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'package:waitless/Screens/splash_screen.dart';
import 'package:waitless/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  runApp(const WaitlessApp());
}

class WaitlessApp extends StatelessWidget {
  const WaitlessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(                         // **************************************
      create: (_) => AppState(),                           // **************************************
      child: MaterialApp(
        debugShowCheckedModeBanner: false,                 // Remove Debug Banner
        title: 'Waitless',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF303030), brightness: Brightness.light),
          scaffoldBackgroundColor: const Color(0xFFF7F4EF),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF7F4EF), foregroundColor: Color(0xFF303030), elevation: 0),
          cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
          filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFD84D), foregroundColor: const Color(0xFF303030), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14))),
          elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD84D), foregroundColor: const Color(0xFF303030), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Color(0xFF4C5562)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: Color(0xFFDFE3E6)),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
