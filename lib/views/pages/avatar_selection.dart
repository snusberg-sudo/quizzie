import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzie/data/providers/user_data_state.dart';
import 'package:quizzie/views/widgets/my_action_icon_button.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:skeletonizer/skeletonizer.dart';

class AvatarSelection extends ConsumerStatefulWidget {
  final String? currentAvatar;
  const AvatarSelection({super.key, required this.currentAvatar});

  @override
  ConsumerState<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends ConsumerState<AvatarSelection> {
  List<String> avatarList = [];

  Future<void> loadAvatarList() async {
    final String jsonString = await rootBundle.loadString(
      'assets/avatars/avatars.json',
    );
    final List<dynamic> data = json.decode(jsonString);
    setState(() {
      avatarList = data.cast<String>();
    });
  }

  @override
  void initState() {
    super.initState();
    loadAvatarList();
  }

  @override
  Widget build(BuildContext context) {
    final userDataState = ref.watch(userDataProvider);
    final changeDataState = ref.read(userDataProvider.notifier);
    final avatar = userDataState.user?.avatar;
    var avatarChanged = false;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!avatarChanged) {
          changeDataState.selectNewAvatar(widget.currentAvatar ?? '');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          automaticallyImplyLeading: false,
          actionsPadding: EdgeInsets.only(right: 20.0),
          actions: [
            MyActionIconButton(
              icon: FaIcon(
                FontAwesomeIcons.xmark,
                color: Colors.white,
                size: 20,
              ),
              borderRadiusGeometry: BorderRadiusGeometry.circular(30.0),
              borderSide: BorderSide(color: Colors.white, width: 1),
              onPressed: () {
                Navigator.maybePop(context);
              },
              minS: Size(55, 55),
              backgroundColor: Colors.grey.shade100.withValues(alpha: 0.2),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    "お好きなアバターを選んでください",
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 70.0),
                  Container(
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/avatars/$avatar'),
                    ),
                  ),
                  SizedBox(height: 70.0),
                ],
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.amberAccent.shade400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "アバター",
                          style: GoogleFonts.inter(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          height: 100.0,
                          child: Skeletonizer(
                            enabled: avatarList.isEmpty,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  avatarList.isEmpty ? 4 : avatarList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    changeDataState.selectNewAvatar(
                                      avatarList[index],
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child:
                                        avatarList.isEmpty
                                            ? Bone.circle(size: 40.0)
                                            : Container(
                                              padding: EdgeInsets.all(1.5),
                                              decoration: BoxDecoration(
                                                color:
                                                    avatar == avatarList[index]
                                                        ? Colors.black87
                                                        : Colors.transparent,
                                                shape: BoxShape.circle,
                                              ),
                                              child: CircleAvatar(
                                                radius: 40.0,
                                                backgroundImage: AssetImage(
                                                  "assets/avatars/${avatarList[index]}",
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              avatarChanged = true;
                              changeDataState.updateAvatar();
                            },
                            child: Text(
                              "保存",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
