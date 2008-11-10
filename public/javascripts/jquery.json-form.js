/**
 * jQuery.form_to_json 
 * Serializes a forms into json. Requies jquery.form
 *
 * Copyright (c) 2008 Ho-Sheng Hsiao, derived from Blair Mitchelmore's jquery.query.js
 * http://plugins.jquery.com/files/jquery.query-2.0.1.js.txt
 * Distributed under the WTFPL http://sam.zoy.org/wtfpl/
 **/

 (function($) {

   var keys = {};

   /* Ripped from jquery.query */
   var parse = function(path) {
     var m, rx = /\[([^[]*)\]/g, match = /^(\S+?)(\[\S*\])?$/.exec(path), base = match[1], tokens = [];
     while (m = rx.exec(match[2])) tokens.push(m[1]);
     return [base, tokens];
   };

   var is = function(o, t) {
     return o != undefined && o !== null && (!!t ? o.constructor == t : true);
   };
   var set = function(target, tokens, value) {
     var o, token = tokens.shift();
     if (typeof target != 'object') target = null;
     if (token === "") {
       if (!target) target = [];
       if (is(target, Array)) {
         target.push(tokens.length == 0 ? value : set(null, tokens.slice(0), value));
       } else if (is(target, Object)) {
         var i = 0;
         while (target[i++] != null);
         target[--i] = tokens.length == 0 ? value : set(target[i], tokens.slice(0), value);
       } else {
         target = [];
         target.push(tokens.length == 0 ? value : set(null, tokens.slice(0), value));
       }
     } else if (token && token.match(/^\s*[0-9]+\s*$/)) {
       var index = parseInt(token, 10);
       if (!target) target = [];
       target[index] = tokens.length == 0 ? value : set(target[index], tokens.slice(0), value);
     } else if (token) {
       var index = token.replace(/^\s*|\s*$/g, "");
       if (!target) target = {};
       if (is(target, Array)) {
         var temp = {};
         for (var i = 0; i < target.length; ++i) {
           temp[i] = target[i];
         }
         target = temp;
       }
       target[index] = tokens.length == 0 ? value : set(target[index], tokens.slice(0), value);
     } else {
       return value;
     }
     return target;
   };

   var set_key = function(doc, key, val) {
     var value = !is(val) ? null : val;
     var parsed = parse(key), base = parsed[0], tokens = parsed[1];
     // var target = keys[base];
     doc[base] = set(doc[base], tokens.slice(0), value);
     return doc;
   }

   /* Ripped and modified from CouchDB's jquery.form */
   $.fn.form_to_json = function(semantic) {
    var doc = {}; 
    if (this.length == 0) return doc;

    var form = this[0];
    var els = semantic ? form.getElementsByTagName('*') : form.elements;
    if (!els) return '{}';
    for(var i=0, max=els.length; i < max; i++) {
        var el = els[i];
        var n = el.name;
        if (!n) continue;

        if (semantic && form.clk && el.type == "image") {
          // handle image inputs on the fly when semantic == true
          if(!el.disabled && form.clk == el) {
            doc = set_key(doc, n+'.x', form.clk_x);
            doc = set_key(doc, n+'.y', form.clk_y);
          }
          continue;
        }

        var v = $.fieldValue(el, true);
        if (v !== null && typeof v != 'undefined') {
          doc = set_key(doc, n, v);
        }
    }

    if (!semantic && form.clk) {
        // input type=='image' are not found in elements array! handle them here
        var inputs = form.getElementsByTagName("input");
        for(var i=0, max=inputs.length; i < max; i++) {
          var input = inputs[i];
          var n = input.name;
          if(n && !input.disabled && input.type == "image" && form.clk == input) {
            set_key(doc, n+'.x', form.clk_x);
            set_key(doc, n+'.y', form.clk_y);
	  }
        }
    }
    return JSON.stringify(doc);
   }
 })(jQuery);
