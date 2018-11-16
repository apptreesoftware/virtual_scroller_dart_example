import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:virtual_scroller/virtual_scroller.dart';
import 'package:virtual_scroller/layout.dart';
import 'package:virtual_scroller_angulardart_example/contact.dart';
import 'package:virtual_scroller_angulardart_example/contact_component.dart';
import 'package:virtual_scroller_angulardart_example/contact_component.template.dart'
    as ngContactComponentTemplate;
import 'package:http/http.dart' as http;

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [
    coreDirectives,
    ContactComponent,
  ],
)
class AppComponent implements OnInit {
  final ComponentLoader _loader;

  @ViewChild('parentDiv')
  DivElement parentDiv;

  List<Contact> _contacts;

  VirtualScroller _scroller;

  List<Element> _pool = [];
  Map<Element, ComponentRef<ContactComponent>> _refs = {};

  AppComponent(this._loader);

  void ngOnInit() {
    _scroller = new VirtualScroller(
      layout: Layout(),
      container: parentDiv,
      createElement: (idx) {
        if (_pool.isNotEmpty) {
          return _pool.removeLast();
        }
        var ref = _loader
            .loadDetached(ngContactComponentTemplate.ContactComponentNgFactory);
        var elem = ref.location;
        _refs[elem] = ref;
        return elem;
      },
      updateElement: (child, idx) {
        var item = _contacts[idx];
        var ref = _refs[child];
        ref.instance.contact = item;
        ref.changeDetectorRef.detectChanges();
      },
      recycleElement: (child, idx) {
        var ref = _refs[child];
        ref.instance.contact = null;
        _pool.add(child);
      },
    );
    loadContacts();
  }

  Future<List<Contact>> loadContacts() async {
    var response = await http.get('./packages/virtual_scroller_angulardart_example/contacts.json');
    var body = response.body;
    var data = json.decode(body) as List;
    var contacts = data.map((d) => Contact.fromJson(d));
    var sorted = contacts.toList()..sort((a, b) => a.last.compareTo(b.last));
    _contacts = sorted;
    render();
  }

  void render() {
    _scroller.totalItems = _contacts.length;
  }
}
