import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:info_med/util/scan%20util/translator.dart';

class Get with ChangeNotifier {
  // side effect
  List side = [];
  // description
  String description = '';
  // instruction
  String instruction = '';
  // deug name
  String name = '';
  // map of medicine data
  Map<String, dynamic> map = {};
  // translation object
  late Translation translate;
  // http client
  final client = http.Client();
  Get() {
    translate = Translation();
  }

  // get the link of the drug page
  getByName(String search, String language) async {
    final url = Uri.parse(
        'https://connect.medlineplus.gov/application?mainSearchCriteria.v.cs=2.16.840.1.113883.6.69&mainSearchCriteria.v.dn=$search&informationRecipient.languageCode.c=en');

    final response = await client.get(url);
    dom.Document html = dom.Document.html(response.body);

    String link = html
        .querySelectorAll(
            '#results-body > div > div:nth-child(1) > p > span > a')
        .map((e) => e.innerHtml)
        .first;
    await _getWebsiteData(link, language);
  }

  // get the information in the drug page & translate
  Future _getWebsiteData(String link, String language) async {
    final url = Uri.parse(link);
    //a604028  -  a696015  -   a682878

    final response = await client.get(url);
    dom.Document html = dom.Document.html(response.body);

    side = html
        .querySelectorAll('#section-side-effects > ul > li')
        .map((e) => e.innerHtml.trim())
        .toList();

    for (int i = 0; i < side.length; i++) {
      if (language != 'en') {
        side[i] = language == 'ku'
            ? await translate.translateKurdish(side[i])
            : await translate.translateArabic(side[i]);
      }
    }

    map.putIfAbsent('side', () => side.toString());

    description = html
        .querySelectorAll('#section-1 > p')
        .map((e) => e.innerHtml)
        .toString()
        .substring(
            1,
            html
                    .querySelectorAll('#section-1 > p')
                    .map((e) => e.innerHtml)
                    .toString()
                    .length -
                1);

    if (language != 'en') {
      description = language == 'ku'
          ? await translate.translateKurdish(description)
          : await translate.translateArabic(description);
    }

    map.putIfAbsent('description', () => description);

    instruction = html
        .querySelectorAll('#section-2 > p:nth-child(1)')
        .map((e) => e.innerHtml)
        .toString()
        .substring(
            1,
            html
                    .querySelectorAll('#section-2 > p:nth-child(1)')
                    .map((e) => e.innerHtml)
                    .toString()
                    .length -
                1);
    if (language != 'en') {
      instruction = language == 'ku'
          ? await translate.translateKurdish(instruction)
          : await translate.translateArabic(instruction);
    }

    map.putIfAbsent('instruction', () => instruction);

    name = html
        .querySelectorAll(
            '#mplus-content > article > div.page-info > div.page-title > h1')
        .map((e) => e.innerHtml)
        .toString()
        .substring(
            1,
            html
                    .querySelectorAll(
                        '#mplus-content > article > div.page-info > div.page-title > h1')
                    .map((e) => e.innerHtml)
                    .toString()
                    .length -
                1);
    map.putIfAbsent('name', () => name);
    map.putIfAbsent('language', () => language);
  }
}
