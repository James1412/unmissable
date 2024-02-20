import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmissable/widgets/cupertino_modal_sheet.dart';

class TitleSearchDelegate extends SliverPersistentHeaderDelegate {
  void onMoreTap(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const CupertinoModalPopupSheet(),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => onMoreTap(context),
                  child: const Icon(FontAwesomeIcons.ellipsis),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const CupertinoSearchTextField(),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
