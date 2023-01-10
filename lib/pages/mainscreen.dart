import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:info_med/services/shared_preference.dart';
import 'package:info_med/widgets/grid_draggable_sheet.dart';
import 'package:provider/provider.dart';

import '../models/box.dart';

// ignore: must_be_immutable
class Main extends StatefulWidget with ChangeNotifier {
  Main({super.key});

List<String> temp  = [
  'Accupril',
  'Aciphex',
  'Actos',
  'Adderall',
  'Allegra',
  'Allegra-D',
  'Allopurinol',
  'Alphagan',
  'Alprazolam',
  'Altace',
  'Amaryl',
  'Ambien',
  'Amitriptyline HCL',
  'Amphetamine',
  'Aricept',
  'Atenolol',
  'Atrovent',
  'Augmentin',
  'Avapro',
  'Cardura',
  'Carisoprodol',
  'Celebrex',
  'Celexa',
  'Cipro',
  'Claritin',
  'Climara',
  'Clonazepam',
  'Clonidine',
  'Combivent',
  'Coumadin',
  'Cozaar',
  'Cyclobenzaprine',
  'Depakote',
  'Detrol',
  'Diazepam',
  'Diflucan',
  'Dilantin',
  'Diovan',
  'Diovan HCT',
  'Flonase',
  'Flovent',
  'Folic Acid',
  'Furosemide',
  'Gemfibrozil',
  'Glyburide',
  'Hydrocodone',
  'Hyzaar',
  'Ibuprofen',
  'Imitrex',
  'Isosorbide Mononitrate',
  'Lanoxin',
  'Lescol',
  'Levoxyl',
  'Lipitor',
  'Lorazepam',
  'Lotensin',
  'Lotrel',
  'Macrobid',
  'Medroxyprogesterone',
  'Methamphetamine',
  'Methylphenidate',
  'Methylprednisolone',
  'Metoprolol Tartrate',
  'Miacalcin',
  'Naproxen',
  'Naproxen Sodium',
  'Nasonex',
  'Neurontin',
  'Norvasc',
  'Oxcarbazepine',
  'Oxycodone',
  'OxyContin',
  'Paxil',
  'Pepcid',
  'Phenergan',
  'Plavix',
  'Potassium Chloride',
  'Prednisone',
  'Premarin',
  'Prevacid',
  'Prilosec',
  'Promethazine',
  'Proventil HFA',
  'Prozac',
  'Relafen',
  'Risperdal',
  'Ritalin',
  'Serevent',
  'Singulair',
  'Synthroid',
  'Tamoxifen Citrate',
  'Temazepam',
  'Tiazac',
  'Tobradex',
  'Ultram',
  'Valtrex',
  'Vasotec',
  'Verapamil',
  'Viagra',
  'Warfarin Sodium',
  'Xalatan',
  'Zestoretic',
  'Zestril',
  'Ziac',
  'Zithromax',
  'Zocor',
  'Zoloft',
  'Zyprexa',
  'Zyrtec'
];
 List<String> drugs = [
  'Accupril',
  'Aciphex',
  'Actos',
  'Adderall',
  'Allegra',
  'Allegra-D',
  'Allopurinol',
  'Alphagan',
  'Alprazolam',
  'Altace',
  'Amaryl',
  'Ambien',
  'Amitriptyline HCL',
  'Amphetamine',
  'Aricept',
  'Atenolol',
  'Atrovent',
  'Augmentin',
  'Avapro',
  'Cardura',
  'Carisoprodol',
  'Celebrex',
  'Celexa',
  'Cipro',
  'Claritin',
  'Climara',
  'Clonazepam',
  'Clonidine',
  'Combivent',
  'Coumadin',
  'Cozaar',
  'Cyclobenzaprine',
  'Depakote',
  'Detrol',
  'Diazepam',
  'Diflucan',
  'Dilantin',
  'Diovan',
  'Diovan HCT',
  'Flonase',
  'Flovent',
  'Folic Acid',
  'Furosemide',
  'Gemfibrozil',
  'Glyburide',
  'Hydrocodone',
  'Hyzaar',
  'Ibuprofen',
  'Imitrex',
  'Isosorbide Mononitrate',
  'Lanoxin',
  'Lescol',
  'Levoxyl',
  'Lipitor',
  'Lorazepam',
  'Lotensin',
  'Lotrel',
  'Macrobid',
  'Medroxyprogesterone',
  'Methamphetamine',
  'Methylphenidate',
  'Methylprednisolone',
  'Metoprolol Tartrate',
  'Miacalcin',
  'Naproxen',
  'Naproxen Sodium',
  'Nasonex',
  'Neurontin',
  'Norvasc',
  'Oxcarbazepine',
  'Oxycodone',
  'OxyContin',
  'Paxil',
  'Pepcid',
  'Phenergan',
  'Plavix',
  'Potassium Chloride',
  'Prednisone',
  'Premarin',
  'Prevacid',
  'Prilosec',
  'Promethazine',
  'Proventil HFA',
  'Prozac',
  'Relafen',
  'Risperdal',
  'Ritalin',
  'Serevent',
  'Singulair',
  'Synthroid',
  'Tamoxifen Citrate',
  'Temazepam',
  'Tiazac',
  'Tobradex',
  'Ultram',
  'Valtrex',
  'Vasotec',
  'Verapamil',
  'Viagra',
  'Warfarin Sodium',
  'Xalatan',
  'Zestoretic',
  'Zestril',
  'Ziac',
  'Zithromax',
  'Zocor',
  'Zoloft',
  'Zyprexa',
  'Zyrtec'
];
List<String> heart = [
'Accupril',
'Altace',
'Atenolol',
'Avapro',
'Cozaar',
  'Cardura',
  'Clonidine',
  'Coumadin',
  'Diovan',
  'Diovan HCT',
  'Furosemide',
  'Gemfibrozil',
  'Hyzaar',
  'Isosorbide Mononitrate',
  'Lanoxin',
  'Lescol',
  'Lipitor',
  'Lotensin',
  'Lotrel',
  'Metoprolol Tartrate',
  'Miacalcin',
  'Norvasc',
  'Plavix',
  'Tiazac',
  'Vasotec',
  'Verapamil',
  'Warfarin Sodium',
  'Zestoretic',
  'Zestril',
  'Ziac',
  'Zocor'
];
List<String> stomach =[
  'Aciphex',
  'Pepcid',
  'Potassium Chloride',
  'Prednisone',
  'Prevacid',
  'Prilosec'];
List<String> diabetes =[
  "Actos","Amaryl","Glyburide"];
List<String> stimulants =[
  "Adderall",
  "Amaryl", 
  'Amphetamine',
  'Methamphetamine',
  'Methylphenidate',
  'Ritalin'];
List<String> antinflammatory =[ 
  'Allegra',
  'Allegra-D',
  'Celebrex',
  'Claritin',
  'Flonase',
  'Flovent',
  'Methylprednisolone',
  'Naproxen',
  'Naproxen Sodium',
  'Promethazine',
  'Relafen',
  'Singulair',
  'Zyrtec'];
List<String> antidepressants =[ 
    'Alprazolam',
  'Amitriptyline HCL',
  'Celexa',
  'Clonazepam',
  'Diazepam',
  'Paxil',
  'Prozac',
  'Zoloft'];
List<String> sleepDisorder =[
  'Ambien',
  'Lorazepam',
  'Phenergan',
  'Temazepam'];
List<String> antibiotec =[ 
  'Augmentin',
  'Cipro',
  'Diflucan',
  'Macrobid',
  'Zithromax'];
List<String> painKiller =[ 
   'Carisoprodol',
  'Cyclobenzaprine',
  'Hydrocodone',
  'Ibuprofen',
  'Oxycodone',
  'OxyContin',
  'Ultram'];
List<String> seizure =[ 
    'Depakote',
  'Dilantin',
  'Imitrex',
  'Neurontin',
  'Oxcarbazepine'];
List<String> hormons =[  
  'Levoxyl',
  'Premarin',
  'Synthroid',
  'Climara',
  'Medroxyprogesterone'];
List<String> eye =[
  "Alphagan","Tobradex","Xalatan"];
List<String> lungs =[
  "Atrovent","Combivent",'Proventil HFA',"Serevent"];
List<String> others =[ 
  'Aricept',
  'Allopurinol',
  'Folic Acid',
  'Detrol',
  'Tamoxifen Citrate',
  'Valtrex',
  'Nasonex',
  'Risperdal',
  'Viagra',
  'Zyprexa'];

  String name = '';
  int listIndex = 1;
  List<String> filtered = [];
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  var controller = TextEditingController();
  Image? image;
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
              return Consumer<SharedPreference>(
                builder: (context, value, child) => Container(
                  color: Colors.lightGreen,
                  child: CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: 60.7 + kToolbarHeight,
                        centerTitle: true,
                        // flexibleSpace: RotatedBox(
                        //   quarterTurns: 3,
                        //   child: Container(
                        //     decoration: const BoxDecoration(
                        //       image: DecorationImage(
                        //         image: AssetImage('assets/images/download.png'),
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        backgroundColor: Colors.lightGreen,
                        title: Padding(
                          padding: const EdgeInsets.only(
                              left: 45, right: 45, bottom: 45),
                          child: Container(
                            height: 46,
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
                                hintTextDirection: TextDirection.ltr,
                                hintText:value.language == 'English' ?'Search Medicine...' : value.language == 'Kurdish' ?'گەڕان بەدوای دەرمان...':'بحث الطب...',
                                hintStyle: const TextStyle(
                                  
                                    color: Colors.grey, fontSize: 15),
                                border: InputBorder.none,
                              ),
                              
                              controller: controller,
                              onChanged: (text) {
                                
                                if(text != ''){
                                  final drugsearch = capitalize(text);
                                  setState(() {
                                  widget.filtered = widget.drugs
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
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                             Container(
                              color:  Colors.lightGreen,
                      height: 196,
                      width: double.infinity,
                      child: Wrap(
                        textDirection: value.language == 'English' ?TextDirection.ltr:TextDirection.rtl,
                        children: [
                          chip(1,10,value.language == 'Kurdish' ?'هەموو دەرمانەکان':value.language == 'Arabic' ?'الجميع':'All',widget.drugs,value.language == 'English' ?'English':'KA'),
                          chip(2,6,value.language == 'Kurdish' ?'دژە هەوکردن':value.language == 'Arabic' ?'مضاد الالتهاب':'Anti-inflammatory',widget.antinflammatory,value.language == 'English' ?'English':'KA'),
                          chip(3,6,value.language == 'Kurdish' ?'دژە بەکتریا':value.language == 'Arabic' ?'مضاد حیوي':'Antibiotec',widget.antibiotec,value.language == 'English' ?'English':'KA'),
                          chip(4,6,value.language == 'Kurdish' ?'دڵ':value.language == 'Arabic' ?'قلب':'Heart',widget.heart,value.language == 'English' ?'English':'KA'),
                          chip(5,10,value.language == 'Kurdish' ?'وریاکەرەوەکان':value.language == 'Arabic' ?'المنشطات':'Stimulants',widget.stimulants,value.language == 'English' ?'English':'KA'),
                          chip(6,6,value.language == 'Kurdish' ?'سییەکان':value.language == 'Arabic' ?'رئتين':'Lungs',widget.lungs,value.language == 'English' ?'English':'KA'),
                          chip(7,6,value.language == 'Kurdish' ?'تێکچوونی خەو':value.language == 'Arabic' ?'إختلال النوم':'Sleep Disorder',widget.sleepDisorder,value.language == 'English' ?'English':'KA'),
                          chip(8,6,value.language == 'Kurdish' ?'چاو':value.language == 'Arabic' ?'‌‌‌‌‌‌‌‌‌عین':'Eye',widget.eye,value.language == 'English' ?'English':'KA'),
                          chip(9,value.language == 'Arabic' ?6:10,value.language == 'Kurdish' ?'گەدە':value.language == 'Arabic' ?'معدة':'Stomach',widget.stomach,value.language == 'English' ?'English':'KA'),
                          chip(10,value.language == 'Kurdish' ?6:10,value.language == 'Kurdish' ?'دژە خەمؤکی':value.language == 'Arabic' ?'مضاد الاکتئاب':'Anti-depressant',widget.antidepressants,value.language == 'English' ?'English':'KA'),
                          chip(11,6,value.language == 'Kurdish' ?'پەرکەم':value.language == 'Arabic' ?'اِنتِزاع':'Seizure',widget.seizure,value.language == 'English' ?'English':'KA'),
                          chip(12,value.language == 'Kurdish' ?6:10,value.language == 'Kurdish' ?'ئازارشکێن':value.language == 'Arabic' ?'قاتل الآلام':'Pain Killer',widget.painKiller,value.language == 'English' ?'English':'KA'),
                          chip(13,6,value.language == 'Kurdish' ?'شەکرە':value.language == 'Arabic' ?'السکري':'Diabetes',widget.diabetes,value.language == 'English' ?'English':'KA'),
                          chip(14,10,value.language == 'Kurdish' ?'هۆرمۆنەکان':value.language == 'Arabic' ?'الهرمونات':'Hormons',widget.hormons,value.language == 'English' ?'English':'KA'),
                          chip(15,6,value.language == 'Kurdish' ?'زیاتر':value.language == 'Arabic' ?'آخرون':'Others',widget.others,value.language == 'English' ?'English':'KA'),
                        const SizedBox(
                              width: 15,
                            )
                        ],
                      )
                    ),
                            Stack(
                              children: [
                                
                                    Container(
                                    color: Colors.lightGreen,
                                    child: widget.filtered.isEmpty &&
                                            controller.text.isEmpty || controller.text==''
                                        ? SizedBox(
                                            height: widget.listIndex==3 ||  widget.listIndex==9 || widget.listIndex==11?widget.temp.length * 146:widget.listIndex==2 || widget.listIndex==15 || widget.listIndex==10 ?widget.temp.length * 116: widget.listIndex==8 || widget.listIndex==13?widget.temp.length * 180:widget.listIndex==12?widget.temp.length * 132:widget.listIndex==1?widget.temp.length * 39.9:widget.listIndex==4?widget.temp.length * 104.5:widget.listIndex==5 || widget.listIndex==14 ?widget.temp.length * 125:widget.temp.length * 135,
                                            child: widget.listIndex!=1?GridView.count(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              crossAxisCount: 2,
                                              padding: const EdgeInsets.only(left: 4,right: 4,top: 8),
                                              children: List.generate(
                                                widget.temp.length,
                                                (index) {
                                                //  final boxInstance = value.language == 'Kurdish'?Boxes.getBoxKurdish().values.where((element) => element.name==widget.temp[index]):value.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==widget.temp[index]):Boxes.getBoxArabic().values.where((element) => element.name==widget.temp[index]);
                                                  final boxInstance = Boxes.getBoxKurdish().values.where((element) => element.name==widget.temp[index]);
                                                  return Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      widget.name = widget.temp[index];
                                                    
                                                      mymodalBottomSheet();
                                                    },
                                                    child: MyCard(img:boxInstance.first.image.toString(),name:widget.temp[index])
                                                  ),
                                                );
                                              
                                                }, ),
                                            )
                                          :Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                            child: GridView.builder(  
                                              physics: const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.only(top: 24),
                                              itemCount: widget.temp.length,  
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
                                                    color: Colors.white,
                                                    child: ListTile(
                                                     leading:  const Icon(Icons.medication_liquid_rounded,color:Color( 0xff8F00FF)),
                                                     horizontalTitleGap: 0,
                                
                                                     onTap: () {
                                                       setState(() {
                                                         widget.name=widget.temp[index];
                                                         mymodalBottomSheet();
                                                       });
                                                     },
                                                      title: Text(widget.temp[index],style: const TextStyle(fontSize:14.2 )),)),
                                                );  
                                              },  
                                            ),
                                          ))  
                                        : SizedBox(
                                            height: controller.text ==''
                                                ? widget.temp.length * 135
                                                : widget.temp.length * 22,
                                            child: GridView.count(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              crossAxisCount: 2,
                                              children: List.generate(
                                                widget.filtered.length,
                                                (index) {
                                                  // final boxInstance = value.language == 'Kurdish'?Boxes.getBoxKurdish().values.where((element) => element.name==widget.temp[index]):value.language == 'English'?Boxes.getBoxEnglish().values.where((element) => element.name==widget.temp[index]):Boxes.getBoxArabic().values.where((element) => element.name==widget.temp[index]);
                                                  final boxInstance = Boxes.getBoxKurdish().values.where((element) => element.name==widget.temp[index]);
                                                  return     Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      widget.name =
                                                          widget.filtered[index];
                                                      mymodalBottomSheet();
                                                    },
                                                      child:MyCard(img:boxInstance.first.image.toString(),name:widget.temp[index])
                                                     
                                                  ),
                                                );
                                            
                                                }
                                
                                              ),
                                            ),
                                          ),
                                  ),
                              
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  Padding chip(int index,double padding,String text,List<String> x,String l) {
    return Padding(
                       padding: l=='English'?EdgeInsets.only(left: padding):EdgeInsets.only(right: padding) ,
                       child: FilterChip(label:  Text(text), 
                       checkmarkColor: const Color( 0xff8F00FF),
                       elevation: 7,
                      
                    selected: widget.listIndex==index,
                    backgroundColor: Colors.white,selectedColor: Colors.grey[300],
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0), ),
                    onSelected: (value) {
                                  setState(() {
                                    widget.listIndex=index;
                                    widget.temp=x;
                                        });
                                  },
                                  ),
                     );
  }

  Future<dynamic> mymodalBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,

      builder: (context) => MyDraggableSCrollableSheet(name: widget.name),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({
    Key? key,
    required this.img,
    required this.name
  }) : super(key: key);

  final String img;
  final String name;
  

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                child:  CachedNetworkImage(imageUrl: img,  height: 154,width: 200,
                        placeholder: (context, url) =>const Center(child:CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>Image.asset('assets/images/drug_bottle.jpg', 
                        height: 157,
                        width: 200,
                        fit: BoxFit.cover,),
                        fit: BoxFit.cover,
                        key: UniqueKey(),),),
              Baseline(
                baseline: 169,
                baselineType: TextBaseline.alphabetic,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)
                  ),
                  child: Container(
                    color: Colors.grey[300]!.withOpacity(0.5),
                    height: 22.3,
                    width: 185,
                    child: Padding(
                      padding:const EdgeInsets.only(left: 8.0,top: 2),
                      child: Text(name,
                        style:const TextStyle(
                          fontSize: 14,
                          letterSpacing:1,
                          color: Colors.black,),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
