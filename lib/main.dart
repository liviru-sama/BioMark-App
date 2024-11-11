import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'utils/theme.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BiomarkApp());
}

class BiomarkApp extends StatelessWidget {
  const BiomarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Biomark App',
        theme: AppTheme.lightTheme,
        initialRoute: Routes.login, // Starting route
        onGenerateRoute: Routes.generateRoute, // Route generator
      ),
    );
  }
}
