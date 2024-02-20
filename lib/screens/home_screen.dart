import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unmissable/widgets/persistent_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List notes = [
    '1',
    '12',
    '2334',
    '343',
    '2',
    23,
    34,
    32,
    43,
    42,
    34,
    23,
    4,
    3,
    24,
    34,
    2,
    34,
    2,
    34,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: TitleSearchDelegate(),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -40),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: notes.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) => CupertinoListTile(
                      title: Text(
                        notes[index].toString(),
                      ),
                      additionalInfo: FaIcon(
                        FontAwesomeIcons.thumbtack,
                        color: Colors.blue.shade700,
                        size: 15,
                      ),
                      subtitle: const Text("subtitle"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
