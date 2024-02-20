import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TitleSearchDelegate extends SliverPersistentHeaderDelegate {
  void onMoreTap(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CupertinoListSection.insetGrouped(
          header: const Text("Section 1"),
          children: const [
            CupertinoListTile.notched(
              title: Text("open pull request"),
              trailing: CupertinoListTileChevron(),
            ),
          ],
        ),
      ),
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
          Row(
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
