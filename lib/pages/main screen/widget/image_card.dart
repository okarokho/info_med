
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.img,
    required this.name
  }) : super(key: key);

  final String img;
  final String name;
  

  @override
  Widget build(BuildContext context) {
    // image card
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Stack(
            children: [
              // using cashed network image 
              ClipRRect(
                borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),

                child: CachedNetworkImage(imageUrl: img, height: 154,width: 177,
                        placeholder: (context, url) =>const Center(child:CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        Image.asset('assets/images/drug_bottle.jpg', height: 154, width: 177, fit: BoxFit.cover,),
                        fit: BoxFit.cover,
                        key: UniqueKey(),),),
              // drugn name
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
                    padding: AppLocalizations.of(context)!.language == 'English' ? const EdgeInsets.only(left: 8.0,top: 2) : const EdgeInsets.only(right: 8.0,top: 2),
                    child: Text(name,
                        style:const TextStyle(
                          fontSize: 14,
                          letterSpacing:1,
                          color: Colors.black,),
                      ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}