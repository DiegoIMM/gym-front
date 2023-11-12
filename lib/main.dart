import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_front/views/main_layout.dart';
import 'package:gym_front/views/pages/auth/log_in_page.dart';
import 'package:gym_front/views/pages/auth/recovery_pass_page.dart';
import 'package:gym_front/views/pages/auth/set_new_password_page.dart';
import 'package:gym_front/views/pages/auth/sign_up_page.dart';
import 'package:gym_front/views/pages/auth/validate_account_page.dart';
import 'package:gym_front/views/pages/auth/validate_email_page.dart';
import 'package:gym_front/views/pages/clients_page.dart';
import 'package:gym_front/views/pages/home_page.dart';
import 'package:gym_front/views/pages/payment_page.dart';
import 'package:gym_front/views/pages/plans_page.dart';
import 'package:gym_front/views/widgets/not_found_widget.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/environments/environment.dart';
import 'services/auth_service.dart';
import 'services/scaffold_messenger_service.dart';

Future<void> main() async {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );

  Environment().initConfig(environment);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ScaffoldMessengerService()),
      ],
      child: MyApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/inicio',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => Material(child: NotFound()),

  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MainLayout(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/auth',
          builder: (context, state) =>
              const Material(child: Text("AuthLayout-noSeUtiliza")),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => Material(child: LogInPage()),
            ),
            GoRoute(
              path: 'register',
              builder: (context, state) => Material(child: SignUpPage()),
            ),
            GoRoute(
              path: 'recovery-password',
              builder: (context, state) =>
                  const Material(child: RecoveryPassPage()),
            ),
            GoRoute(
              path: 'validate-account/:token',
              builder: (context, state) => Material(
                  child: ValidateAccountPage(
                      token: state.pathParameters['token']!)),
            ),
            GoRoute(
              path: 'set-new-password/:token',
              builder: (context, state) => Material(
                  child: SetNewPasswordPage(
                      token: state.pathParameters['token']!)),
            ),
          ],
        ),
        GoRoute(
          path: '/inicio',
          builder: (context, state) => const Material(child: HomePage()),
        ),
        GoRoute(
          path: '/planes',
          builder: (context, state) => const Material(child: PlanPage()),
        ),
        GoRoute(
          path: '/clientes',
          builder: (context, state) => const Material(child: ClientsPage()),
        ),
        GoRoute(
          path: '/pagos',
          builder: (context, state) => const Material(child: PaymentPage()),
        ),

        //
        // GoRoute(
        //   path: '/perfil/:username',
        //   builder: (context, state) => Material(
        //       child: ProfilePage(
        //           key: UniqueKey(),
        //           username: state.pathParameters['username']!)),
        // ),
        GoRoute(
          path: '/validar-email/:token',
          builder: (context, state) => Material(
              child: ValidateEmail(token: state.pathParameters['token']!)),
        ),
      ],
    ),
  ],

  // GoRoute(
  //   path: '/',
  //   builder: (context, state) => MainLayout(),
  //   routes: [
  //     GoRoute(
  //       path: 'auth',
  //       builder: (context, state) => const AuthLayout(),
  //       routes: [
  //         GoRoute(
  //           path: 'login',
  //           builder: (context, state) => Material(child: LogInPage()),
  //         ),
  //         GoRoute(
  //           path: 'sign-up',
  //           builder: (context, state) => SignUpPage(),
  //         ),
  //         GoRoute(
  //           path: 'recovery-password',
  //           builder: (context, state) => const RecoveryPassPage(),
  //         ),
  //         GoRoute(
  //           path: 'validate-account/:token',
  //           builder: (context, state) =>
  //               ValidateAccountPage(token: state.params['token']!),
  //         ),
  //         GoRoute(
  //           path: 'set-new-password/:token',
  //           builder: (context, state) =>
  //               SetNewPassowrdPage(token: state.params['token']!),
  //         ),
  //       ],
  //     ),
  //     GoRoute(
  //       path: 'app',
  //       builder: (context, state) => const AppLayout(),
  //       routes: [
  //         GoRoute(
  //           path: 'home',
  //           builder: (context, state) => const HomePage(),
  //         ),
  //         GoRoute(
  //           path: 'questions',
  //           builder: (context, state) => const QuestionsPage(),
  //         ),
  //         GoRoute(
  //           path: 'question/:id',
  //           builder: (context, state) =>
  //               QuestionPage(id: state.params['userId']!),
  //         ),
  //         GoRoute(
  //           path: 'profile/:username',
  //           builder: (context, state) =>
  //               ProfilePage(username: state.params['username']!),
  //         ),
  //       ],
  //     ),
  //   ],
  // ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey:
          Provider.of<ScaffoldMessengerService>(context, listen: false)
              .rootScaffoldMessengerKey,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
/*
      primaryTextTheme: const TextTheme(
        bodySmall: TextStyle(
          color: Colors.white,
          fontSize: 4,
          fontWeight: FontWeight.w900,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 6,
          fontWeight: FontWeight.w900,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
        labelMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w100,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w200,
        ),
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
*/
        textTheme: TextTheme(
          bodySmall: const TextStyle(
            color: Colors.black,
          ),
          bodyMedium: const TextStyle(
            color: Colors.black,
          ),
          bodyLarge: const TextStyle(
            color: Colors.black,
          ),
          labelSmall: TextStyle(
            color: Colors.grey.shade600,
          ),
          labelMedium: TextStyle(
            color: Colors.grey.shade700,
          ),
          labelLarge: TextStyle(
            color: Colors.grey.shade800,
          ),
          displaySmall: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          displayLarge: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: const TextStyle(
            color: Colors.black,
          ),
          headlineMedium: const TextStyle(
            color: Colors.black,
          ),
          headlineLarge: const TextStyle(
            color: Colors.black,
          ),
          titleSmall: const TextStyle(
            color: Colors.black,
          ),
          titleMedium: const TextStyle(
            color: Colors.black,
          ),
          titleLarge: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        cardColor: Colors.grey.shade200,
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade200,
          disabledColor: Colors.grey.shade300,
          selectedColor: Colors.grey.shade400,
          secondarySelectedColor: Colors.grey.shade500,
          padding: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          secondaryLabelStyle: const TextStyle(
            color: Colors.black,
          ),
          brightness: Brightness.light,
        ),
        primaryColor: Colors.purple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // iconTheme: const IconThemeData(
        //   color: Colors.red,
        //   shadows: [
        //     Shadow(
        //       color: Colors.blue,
        //       offset: Offset(0, 0),
        //       blurRadius: 0,
        //     ),
        //   ],
        // ),
        // primaryIconTheme: const IconThemeData(
        //   opacity: 1,
        //   shadows: [
        //     Shadow(
        //       color: Colors.blue,
        //       offset: Offset(0, 0),
        //       blurRadius: 0,
        //     ),
        //   ],
        //   color: Colors.green,
        // ),

        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          filled: true,
          fillColor: Colors.white,
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          constraints: BoxConstraints(
            minHeight: 90,
          ),
          isDense: false,
          isCollapsed: false,
          contentPadding: EdgeInsets.all(20),
        ),
        // primarySwatch: Colors.purple,
        primarySwatch: Colors.green,
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          scrimColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        scaffoldBackgroundColor: Colors.purple.shade50,
        canvasColor: Colors.purple.shade50,
        listTileTheme: ListTileThemeData(
          selectedColor: Colors.green.shade700,
          selectedTileColor: Colors.green.shade50,
          tileColor: Colors.white,
          enableFeedback: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          minVerticalPadding: 20,
          dense: false,
          textColor: Colors.black,
        ),
        dialogBackgroundColor: Colors.white,
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        primaryColorLight: Colors.orange,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              elevation: 8,
              backgroundColor: Colors.green.shade50,
              enableFeedback: true,
              minimumSize: const Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                color: Colors.black,
              )),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            elevation: 8,
            enableFeedback: true,
            backgroundColor: Colors.white,
            minimumSize: const Size(50, 40),
            textStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            elevation: 8,
            shadowColor: Colors.black,
            enableFeedback: true,
            minimumSize: const Size(50, 40),
            backgroundColor: Colors.green.shade50,
            // backgroundColor: Colors.lightGreen.shade100,
            textStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
