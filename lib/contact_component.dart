import 'package:angular/angular.dart';
import 'package:virtual_scroller_angulardart_example/contact.dart';

@Component(
  selector: 'contact-component',
  templateUrl: 'contact_component.html',
  styleUrls: [
    'contact_component.css',
  ],
  directives: [
    coreDirectives,
  ],
)
class ContactComponent {
  @Input()
  Contact contact;
}
