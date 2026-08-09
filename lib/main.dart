import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consome_plus/config/theme.dart';
import 'package:consome_plus/providers/user_provider.dart';
import 'package:consome_plus/providers/purchase_provider.dart';
import 'package:consome_plus/providers/stats_provider.dart';
import 'package:consome_plus/screens/app_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ConsomePlusApp());
}

class ConsomePlusApp extends StatelessWidget {
  const ConsomePlusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PurchaseProvider(),
        ),
        ChangeNotifierProxyProvider<UserProvider, StatsProvider>(
          create: (_) => StatsProvider(),
          update: (_, userProvider, statsProvider) {
            return statsProvider ?? StatsProvider();
          },
        ),
      ],
      child: MaterialApp(
        title: 'CONSOME+',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AppWrapper(),
      ),
    );
  }
}
