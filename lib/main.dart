import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/providers/provider_exam.dart';
import 'package:playinsample/screens/screen_select.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderExam>(
            create: (context) => ProviderExam()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fetch Data Example',
          themeMode: ThemeMode.light,
          // Change it as you want
          theme: ThemeData(
              primaryColor: Colors.white,
              primaryColorBrightness: Brightness.light,
              brightness: Brightness.light,
              primaryColorDark: Colors.black,
              canvasColor: Colors.white,
              // next line is important!
              appBarTheme: AppBarTheme(brightness: Brightness.light)),
          darkTheme: ThemeData(
              primaryColor: Colors.black,
              primaryColorBrightness: Brightness.dark,
              primaryColorLight: Colors.black,
              brightness: Brightness.dark,
              primaryColorDark: Colors.black,
              indicatorColor: Colors.white,
              canvasColor: Colors.black,
              // next line is important!
              appBarTheme: AppBarTheme(brightness: Brightness.dark)),
          home: ScreenSelect()),
    );
  }
}
