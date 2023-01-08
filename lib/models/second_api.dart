import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:info_med/services/translator.dart';

class Get {
  List side = [];
  String description = '';
  String instruction = '';
  String name = '';
  Map<String,dynamic> map={};
  late Translation translate;
  Get() {
    translate = Translation();
  }
  getByName(String search) async {
    final url = Uri.parse(
        'https://connect.medlineplus.gov/application?mainSearchCriteria.v.cs=2.16.840.1.113883.6.69&mainSearchCriteria.v.dn=$search&informationRecipient.languageCode.c=en');

    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    String link = html
        .querySelectorAll(
            '#results-body > div > div:nth-child(1) > p > span > a')
        .map((e) => e.innerHtml)
        .first;
    await _getWebsiteData(link);
  }

  Future _getWebsiteData(String link) async {
    final url = Uri.parse(link);
    //a604028  -  a696015  -   a682878

    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    side = html
        .querySelectorAll('#section-side-effects > ul > li')
        .map((e) => e.innerHtml.trim())
        .toList();

    for (int i = 0; i < side.length; i++) {
      side[i] = await translate.translateKurdish(side[i]);
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

    description = await translate.translateKurdish(description);
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
    instruction = await translate.translateKurdish(instruction);
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

  }
}
