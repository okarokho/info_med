import 'package:flutter/material.dart';
import 'package:info_med/pages/main%20screen/widget/chip.dart';
import 'package:info_med/util/provider.dart';
import 'package:info_med/util/shared_preference.dart';
import 'package:info_med/widgets/grid_draggable_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/drugs.dart';
import '../../models/box.dart';
import 'widget/image_card.dart';

// ignore: must_be_immutable
class Main extends StatefulWidget with ChangeNotifier {
  Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // name of drug
  String _name = '';
  // a list used when searching though drugs
  List<String> _filtered = [];
  // 
  Image? defaultImage;

  final TextEditingController controller = TextEditingController();

@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
              return Consumer2<SharedPreference,DataProvider>(
                builder: (context, value, data ,child) => 
                CustomScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // search bar
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: 40.7 + kToolbarHeight,
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        title: Padding(
                          padding: const EdgeInsets.only(
                              left: 45, right: 45, bottom: 15),
                          // adding border to textField
                          child: Container(
                            height: 47,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[600]!),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0)),

                            child: TextField(
                              maxLines: 1,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[600],
                                ),
                                contentPadding: const EdgeInsets.only(top: 10),
                                hintText:AppLocalizations.of(context)!.search,
                                hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                                border: InputBorder.none,
                              ),
                              
                              controller: controller,
                              onChanged: (text) {
                                
                                if(text != ''){
                                  final drugsearch = _capitalize(text);
                                  setState(() {
                                  _filtered = drugs
                                      .where(
                                          (element) => element.contains(drugsearch))
                                      .toList();
                                });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      // body with filter chps & drug grid view
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                          // filter chips 
                          Container(
                            color:  Colors.white,
                            margin: const EdgeInsets.only(bottom: 15),
                            height: 196,
                            width: double.infinity,
                            child: Wrap(
                              children: [
                                CategoryChip(currentIndex: 1,padding: 10,text:AppLocalizations.of(context)!.all,temp:drugs,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 2,padding: 6,text:AppLocalizations.of(context)!.antiInflammatory,temp:antinflammatory,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 3,padding: 6,text:AppLocalizations.of(context)!.antibiotec,temp:antibiotec,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 4,padding: 6,text:AppLocalizations.of(context)!.heart,temp:heart,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 5,padding: 10,text:AppLocalizations.of(context)!.stimulants,temp:stimulants,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 6,padding: 6,text:AppLocalizations.of(context)!.lungs,temp:lungs,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 7,padding: 6,text:AppLocalizations.of(context)!.sleepDisorder,temp:sleepDisorder,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 8,padding: 6,text:AppLocalizations.of(context)!.eye,temp:eye,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 9,padding: AppLocalizations.of(context)!.language == 'عربي' ?6:10,text:AppLocalizations.of(context)!.stomach,temp:stomach,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 10,padding: AppLocalizations.of(context)!.language == 'کوردی' ?6:10,text:AppLocalizations.of(context)!.antiDepressant,temp:antidepressants,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 11,padding: 6,text:AppLocalizations.of(context)!.seizure,temp:seizure,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 12,padding: AppLocalizations.of(context)!.language == 'کوردی' ?6:10,text:AppLocalizations.of(context)!.painKiller,temp:painKiller,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 13,padding: 6,text:AppLocalizations.of(context)!.diabetes,temp:diabetes,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 14,padding: 10,text:AppLocalizations.of(context)!.hormons,temp:hormons,selectedIndex: data.listIndex),
                                CategoryChip(currentIndex: 15,padding: 6,text:AppLocalizations.of(context)!.others,temp:others,selectedIndex: data.listIndex),
                              ],
                            )
                          ),
                          // drug grid view
                          Container(
                                    color: Colors.white, // TODO color
                                    // unfiltered drug grid view
                                    child: _filtered.isEmpty && controller.text.isEmpty || controller.text==''
                                        ? SizedBox(
                                            height: data.listIndex==3 ||  data.listIndex==9 || data.listIndex==11 || data.listIndex==14? data.tempList.length * 146: data.listIndex==2 || data.listIndex==15 || data.listIndex==10 ? data.tempList.length * 116: data.listIndex==8 || data.listIndex==13? data.tempList.length * 180: data.listIndex==12? data.tempList.length * 132: data.listIndex==1? data.tempList.length * 39.9: data.listIndex==4? data.tempList.length * 104.5: data.listIndex==5 ? data.tempList.length * 125: data.tempList.length * 135,
                                          // show categories
                                          child: data.listIndex!=1?GridView.count(
                                              physics: const NeverScrollableScrollPhysics(),
                                              crossAxisCount: 2,
                                              padding: const EdgeInsets.only(left: 4,right: 4,top: 8),
                                              children: List.generate(
                                                data.tempList.length,
                                                (index) {
                                                 final boxInstance = AppLocalizations.of(context)!.language == 'کوردی'?Boxes.getBoxKurdish().values.where((element) => element.name==data.tempList[index]):AppLocalizations.of(context)!.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==data.tempList[index]):Boxes.getBoxArabic().values.where((element) => element.name==data.tempList[index]);
                                                  // final boxInstance = Boxes.getBoxKurdish().values.where((element) => element.name==data.tempList[index]);
                                                  return Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _name = data.tempList[index];
                                                      _modalBottomSheet();
                                                    },
                                                    child: ImageCard(img:boxInstance.first.image.toString(),name:data.tempList[index])
                                                  ),
                                                );
                                               }, 
                                              ),
                                            )
                                          // show all drugs
                                          :Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                            child: GridView.builder(  
                                              physics: const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.only(top: 24),
                                              itemCount: data.tempList.length,  
                                              gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(  
                                                  crossAxisCount: 2,  
                                                  mainAxisExtent: 60, 
                                                  mainAxisSpacing: 16.0,
                                                  crossAxisSpacing: 12
                                              ),  
                                              itemBuilder: (BuildContext context, int index){  
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Container(
                                                    color: Colors.grey[200],
                                                    child: ListTile(
                                                     leading: const Icon(Icons.medication_liquid_rounded,color:purple),
                                                     horizontalTitleGap: 0,
                                                     // when taping open bottom sheet
                                                     onTap: () {
                                                       setState(() {
                                                         _name=data.tempList[index];
                                                         _modalBottomSheet();
                                                       });
                                                     },
                                                      title: Text(data.tempList[index],style: const TextStyle(fontSize:14.2 )),)),
                                                );  
                                              },  
                                            ),
                                          ))  
                                    // filtered drug grid view
                                        : SizedBox(
                                            height: controller.text ==''
                                                ? data.tempList.length * 135
                                                : data.tempList.length * 22,
                                            child: GridView.count(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              crossAxisCount: 2,
                                              children: List.generate(
                                                _filtered.length,
                                                (index) {
                                                  // final boxInstance = value.language == 'Kurdish'?Boxes.getBoxKurdish().values.where((element) => element.name==widget.temp[index]):value.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==widget.temp[index]):Boxes.getBoxArabic().values.where((element) => element.name==widget.temp[index]);
                                                  final boxInstance = Boxes.getBoxKurdish().values.where((element) => element.name==data.tempList[index]);
                                                  return Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _name =
                                                          _filtered[index];
                                                      _modalBottomSheet();
                                                    },
                                                      child:ImageCard(img:boxInstance.first.image.toString(),name:data.tempList[index])
                                                  ),
                                                );
                                                }
                                              ),
                                            ),
                                          ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
              );
  }

// showing draggable bottom sheet when taping drug card 
  Future<dynamic> _modalBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MyDraggableSCrollableSheet(name: _name),
    );
  }

// capitilze first letter of string 
String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

