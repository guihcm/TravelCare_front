import 'package:flutter/material.dart';
import 'package:travel_care/components/myAppBar.dart';
import 'package:travel_care/pages/profile.dart';

class CompletePage extends StatefulWidget {
  const CompletePage();
  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ProfilePage(),
    );
  }
}
