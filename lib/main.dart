import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunasea/core.dart';

/// LunaSea Entry Point: Initialize & Run Application
/// Runs app in guarded zone to attempt to capture fatal (crashing) errors
void main() async {
    await _init();
    runZonedGuarded<void>(
        () => runApp(LunaBIOS()),
        (Object error, StackTrace stack) => LunaLogger.fatal(error, stack),
    );
}

Future<void> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    //Set system UI style (navbar, statusbar)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.black,
        statusBarColor: Colors.transparent,
    ));
    //LunaSea initialization
    LunaNetworking.initialize();
    LunaLogger.initialize();
    LunaImageCache.initialize();
    LunaRouter.intialize();
    await LunaInAppPurchases.initialize();
    await Database.initialize();
}

class LunaBIOS extends StatefulWidget {
    static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    @override
    State<StatefulWidget> createState() => _State();
}

class _State extends State<LunaBIOS> {
    @override
    Widget build(BuildContext context) => LunaProvider.providers(
        child: ValueListenableBuilder(
            valueListenable: Database.lunaSeaBox.listenable(keys: [LunaSeaDatabaseValue.THEME_AMOLED.key]),
            builder: (context, box, _) {
                return MaterialApp(
                    navigatorKey: LunaBIOS.navigatorKey,
                    routes: LunaRouter.routes,
                    onGenerateRoute: LunaRouter.router.generator,
                    darkTheme: LunaTheme.darkTheme,
                    theme: LunaTheme.darkTheme,
                    title: Constants.APPLICATION_NAME,
                );
            }
        ),
    );

    @override
    void dispose() {
        Database.deinitialize()
        .whenComplete(() => LunaInAppPurchases.deinitialize())
        .whenComplete(() => super.dispose());
    }
}
