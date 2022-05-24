@PlatformDetector()
import 'package:flutter/material.dart';
import 'package:flutter_platform_code_demo/utils.p.dart';

import 'builder/platform_annotation.dart';
@PlatformSpec(platformType: PlatformType.mobile)
import 'messages/mobile.dart';
@PlatformSpec(platformType: PlatformType.desktop, renameTo: 'messages/desktop.dart')
// ignore: duplicate_import
import 'messages/mobile.dart';

@PlatformSpec(platformType: PlatformType.mobile)
const _title = 'Flutter Demo Mobile';

@PlatformSpec(platformType: PlatformType.desktop, renameTo: '_title')
// ignore: unused_element
const _titleDesktop = 'Flutter Demo Desktop';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @PlatformSpec(platformType: PlatformType.mobile)
  int _counter = 0;

  @PlatformSpec(platformType: PlatformType.desktop, renameTo: '_counter')
  // ignore: unused_field, prefer_final_fields
  int _counterDesktop = 9;

  @PlatformSpec(platformType: PlatformType.mobile, renameTo: '_incrementCounter')
  // ignore: unused_element
  void _incrementCounterMobile() {
    setState(() {
      _counter++;
    });
  }

  @PlatformSpec(platformType: PlatformType.desktop)
  void _incrementCounter() {
    setState(() {
      _counter *= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    Util().log('build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              const Message().msg,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
