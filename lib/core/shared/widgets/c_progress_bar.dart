import 'package:flutter/material.dart';

class CustomProgressBar extends StatefulWidget {
  const CustomProgressBar({super.key, required this.isShow});

  final bool isShow;

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  @override
  Widget build(BuildContext context) {
    return widget.isShow
        ? Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0x85cacaca)),
              ),
              const Center(child: CircularProgressIndicator()),
            ],
          )
        : Container();
  }
}
