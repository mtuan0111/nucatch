import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  double _currentSliderValue = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Setting"),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: SizedBox(
                  width: 300,
                  child: Form(
                    key: _formKey,
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                        ),
                        Wrap(
                          children: [
                            Text("Font size"),
                            Slider(
                              max: 100,
                              divisions: 5,
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                              label: _currentSliderValue.round().toString(),
                              value: _currentSliderValue,
                            ),
                          ],
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
