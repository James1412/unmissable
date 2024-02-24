import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:unmissable/models/note_model.dart';
import 'package:unmissable/repos/firebase_auth.dart';
import 'package:unmissable/repos/notes_repository.dart';
import 'package:unmissable/screens/edit_screen.dart';
import 'package:unmissable/utils/ad_helper.dart';
import 'package:unmissable/utils/hive_box_names.dart';
import 'package:unmissable/utils/themes.dart';
import 'package:unmissable/view_models/font_size_view_model.dart';
import 'package:unmissable/view_models/notes_view_model.dart';
import 'package:unmissable/widgets/app_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String appGroupId = 'group.unmissable_app_group';
  String iOSWidgetName = 'HomeScreenWidget';
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    FirebaseAuthentication().initAuth();
    HomeWidget.setAppGroupId(appGroupId);
    _initGoogleMobileAds();
    BannerAd(
      adUnitId: AdHelper.banner1AdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Ad load failed (code=${error.code} message=${error.message})')));
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _ad?.dispose();
    super.dispose();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  Widget? infoWidget(int index, List<NoteModel> infoNotes) {
    return infoNotes[index].isPinned && infoNotes[index].isUnmissable
        ? Row(
            children: [
              Icon(
                Icons.notifications,
                color: Colors.yellow.shade700,
                size: 19,
              ),
              const SizedBox(
                width: 5,
              ),
              FaIcon(
                FontAwesomeIcons.thumbtack,
                color: Colors.blue.shade700,
                size: 15,
              ),
            ],
          )
        : infoNotes[index].isUnmissable
            ? Icon(
                Icons.notifications,
                color: Colors.yellow.shade700,
                size: 19,
              )
            : infoNotes[index].isPinned
                ? FaIcon(
                    FontAwesomeIcons.thumbtack,
                    color: Colors.blue.shade700,
                    size: 15,
                  )
                : null;
  }

  FocusNode focusNode = FocusNode();
  bool isSearch = false;
  List<NoteModel> searchNotes = [];
  final TextEditingController _controller = TextEditingController();

  void isSearchFalse() {
    isSearch = false;
    _controller.clear();
    if (FocusManager.instance.primaryFocus != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<NoteModel> notes = context.watch<NotesViewModel>().notes;
    double fontSize = context.watch<FontSizeViewModel>().fontSize;
    if (notes.isNotEmpty) {
      HomeWidget.saveWidgetData<String>('title', notes.first.title);
      HomeWidget.saveWidgetData<String>('description', notes.first.body);
      HomeWidget.updateWidget(iOSName: iOSWidgetName);
    }
    return GestureDetector(
      onTap: () async {
        if (FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 20,
            ),
            const AppBarWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : darkModeBlack),
                controller: _controller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    isSearch = true;
                    searchNotes = notes
                        .where((element) => (element.title + element.body)
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    setState(() {});
                  } else {
                    isSearchFalse();
                  }
                },
              ),
            ),
            // Ad Widget
            if (_ad != null)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 72,
                alignment: Alignment.center,
                child: AdWidget(ad: _ad!),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        notes = HiveNoteRepository().getNotes(context);
                      } else if (snapshot.hasData) {
                        context
                            .read<NotesViewModel>()
                            .notificationOnHelper(context);
                      }
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(notesBoxName)
                              .snapshots(),
                          builder: (context, snapshot) {
                            // If user exists and firebase data exists
                            if (snapshot.hasData &&
                                FirebaseAuth.instance.currentUser != null) {
                              List<NoteModel> streamNotes = [];
                              snapshot.data!.docs
                                  .where((element) =>
                                      element['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid)
                                  .forEach((element) {
                                NoteModel note = NoteModel.fromJson(
                                    element.data() as Map<String, dynamic>);
                                streamNotes.add(note);
                              });
                              notes = sortNotes(context, streamNotes);
                              context.watch<NotesViewModel>().notes = notes;
                            } else {
                              notes = HiveNoteRepository().getNotes(context);
                              context.watch<NotesViewModel>().notes = notes;
                            }
                            return ListView.separated(
                              controller: _scrollController,
                              itemCount:
                                  isSearch ? searchNotes.length : notes.length,
                              separatorBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  height: 1,
                                  color: isDarkMode(context)
                                      ? darkModeGrey
                                      : Colors.black12,
                                  width: double.maxFinite,
                                ),
                              ),
                              itemBuilder: (context, index) => Slidable(
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }
                                        context
                                            .read<NotesViewModel>()
                                            .toggleUnmissable(
                                                isSearch
                                                    ? searchNotes[index]
                                                    : notes[index],
                                                context);
                                        isSearchFalse();
                                      },
                                      backgroundColor: Colors.amber,
                                      icon: CupertinoIcons.bell_fill,
                                      foregroundColor: Colors.white,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }
                                        context
                                            .read<NotesViewModel>()
                                            .togglePin(
                                                isSearch
                                                    ? searchNotes[index]
                                                    : notes[index],
                                                context);
                                        isSearchFalse();
                                      },
                                      backgroundColor: Colors.blue,
                                      icon: FontAwesomeIcons.thumbtack,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (Platform.isIOS) {
                                          HapticFeedback.lightImpact();
                                        }
                                        NoteModel note = isSearch
                                            ? searchNotes[index]
                                            : notes[index];
                                        context
                                            .read<NotesViewModel>()
                                            .deleteNote(note, context);
                                        isSearchFalse();
                                      },
                                      backgroundColor: Colors.red,
                                      icon: FontAwesomeIcons.trash,
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScreen(
                                          note: isSearch
                                              ? searchNotes[index]
                                              : notes[index],
                                          isSearchFalse: isSearchFalse,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 5,
                                      ),
                                      title: Text(
                                        isSearch
                                            ? searchNotes[index].title
                                            : notes[index].title,
                                        style: TextStyle(
                                          color: isDarkMode(context)
                                              ? Colors.white
                                              : darkModeBlack,
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      additionalInfo: isSearch
                                          ? infoWidget(index, searchNotes)
                                          : infoWidget(index, notes),
                                      subtitle: Text(
                                        isSearch
                                            ? searchNotes[index]
                                                .body
                                                .replaceAll('\n', '')
                                            : notes[index]
                                                .body
                                                .replaceAll('\n', ''),
                                        style: TextStyle(
                                          color: darkModeGrey,
                                          fontSize: fontSize - 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
