import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/utils/is_dark_mode.dart';

class CupertinoModalPopupSheet extends StatefulWidget {
  final Widget child;
  final double height;
  const CupertinoModalPopupSheet(
      {super.key, required this.child, required this.height});

  @override
  State<CupertinoModalPopupSheet> createState() =>
      _CupertinoModalPopupSheetState();
}

class _CupertinoModalPopupSheetState extends State<CupertinoModalPopupSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: isDarkMode(context)
            ? darkModeBlack
            : CupertinoColors.systemGroupedBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: CustomDelegate(),
          ),
          SliverToBoxAdapter(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class CustomDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDarkMode(context)
          ? darkModeBlack
          : CupertinoColors.systemGroupedBackground,
      child: Align(
        alignment: Alignment.topRight,
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  HapticFeedback.lightImpact();
                }
                Navigator.pop(context);
              },
              child: const Text(
                "Done",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
