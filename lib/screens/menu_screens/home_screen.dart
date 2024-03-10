import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:pinput/pinput.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double get screenWidth => MediaQuery.of(context).size.width;
  double get buttonSpace => 20;
  String inputtedValue = "";

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = Theme.of(context).textTheme.headlineMedium!;

    return Scaffold(
        body: Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.green,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Level: "),
                        Text("Point: "),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          inputtedValue,
                          style: buttonStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: buttonSpace,
                  runSpacing: buttonSpace,
                  children: keyboardArray.entries.map((e) {
                    return SizedBox(
                      width: (screenWidth / 3) - buttonSpace * 2,
                      height: (screenWidth / 3) - buttonSpace * 2,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            inputtedValue += e.value.toString();
                          });
                        },
                        child: Builder(builder: (context) {
                          if (e.value == 10) {
                            return Icon(
                              FontAwesomeIcons.arrowsRotate,
                              size: buttonStyle.fontSize,
                              color: buttonStyle.color,
                            );
                          }

                          if (e.value == 11) {
                            return Icon(
                              FontAwesomeIcons.bars,
                              size: buttonStyle.fontSize,
                              color: buttonStyle.color,
                            );
                          }

                          return Text(
                            e.value.toString(),
                            style: buttonStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
