import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoModalPopupSheet extends StatefulWidget {
  const CupertinoModalPopupSheet({super.key});

  @override
  State<CupertinoModalPopupSheet> createState() =>
      _CupertinoModalPopupSheetState();
}

class _CupertinoModalPopupSheetState extends State<CupertinoModalPopupSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
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
            CupertinoListSection.insetGrouped(
              header: const Opacity(
                opacity: 0.6,
                child: Text(
                  "SECTION 1",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              children: const [
                CupertinoListTile(
                  title: Text("open pull request"),
                  trailing: CupertinoListTileChevron(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
