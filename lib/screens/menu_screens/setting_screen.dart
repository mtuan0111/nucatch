import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Setting"),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 50,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Form(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 20,
                      spacing: 20,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Font size"),
                            Slider(
                              value: 0,
                              min: 0,
                              max: 20,
                              onChanged: (val) {},
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Volume"),
                            Slider(
                              value: 0,
                              min: 0,
                              max: 20,
                              onChanged: (val) {},
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Number of top turn"),
                            Slider(
                              value: 0,
                              min: 0,
                              max: 20,
                              onChanged: (val) {},
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
