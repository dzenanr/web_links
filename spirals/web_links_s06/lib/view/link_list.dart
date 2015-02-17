import 'dart:convert';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_links/web_links.dart';

@CustomTag('link-list')
class LinkList extends PolymerElement {
  @published List<Link> links;
  
  LinkList.created() : super.created();
  
  add(Event e, var detail, Node target) {
    InputElement name = shadowRoot.querySelector("#name");
    InputElement url = shadowRoot.querySelector("#url");
    LabelElement message = shadowRoot.querySelector("#message");
    var error = false;
    message.text = '';
    if (name.value.trim() == '') {
      message.text = 'name is mandatory; ${message.text}';
      error = true;
    }
    if (url.value.trim() == '') {
      message.text = 'web link is mandatory; ${message.text}';
      error = true;
    }
    if (!error) {
      var link = new Link(name.value, url.value);
      if (find(link.name) == null) {
        links.add(link);
        save();
      } else {
        message.text = 'web link with that name already exists';
      }
    }
  }
  
  Link find(String name) {
    for (Link link in links) {
      if (link.name == name) {
        return link;
      }
    }
    return null;
  }
  
  delete(Event e, var detail, Node target) {
    InputElement name = shadowRoot.querySelector("#name");
    InputElement url = shadowRoot.querySelector("#url");
    LabelElement message = shadowRoot.querySelector("#message");
    message.text = '';
    Link link = find(name.value);
    if (link == null) {
      message.text = 'web link with this name does not exist';
    } else {
      url.value = link.url.toString();
      if (links.remove(link)) {
        save();
      }
    }
  }
  
  List<Map<String, Object>> toJson() {
    var linkList = new List<Map<String, Object>>();
    for (Link link in links) {
      linkList.add(link.toJson());
    }
    return linkList;
  }

  save() {
    window.localStorage['web_links'] = JSON.encode(toJson());
  }
}