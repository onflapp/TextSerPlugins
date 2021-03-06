JsOsaDAS1.001.00bplist00�Vscript_�app = Application.currentApplication();
app.includeStandardAdditions = true;

ObjC.import('stdlib');
ObjC.import("Cocoa");

HOME = get_env("HOME");
DEFAULT_TEMPLATES = HOME+"/Documents/Templates";

//path = app.pathTo(this).toString()

function quotedForm(s) { 
  return "'" + s.replace(/'/g, "'\\''") + "'"
}

function prompt(text, defaultAnswer) {
  var options = { defaultAnswer: defaultAnswer || '' };
  try {
    return app.displayDialog(text, options).textReturned;
  } 
  catch (e) {
    return null;
  }
}

function alert(text, informationalText) {
  var options = {};
  if (informationalText) options.message = informationalText;
  app.displayAlert(text, options);
}

function get_env(n) {
	var v = $.NSProcessInfo.processInfo.environment.objectForKey(n);
	return ObjC.unwrap(v);
}

function path_dirname(p) {
	var a = p.split('/');
	a.pop();
	var rv = a.join('/');
	if (!rv) return "/";
	else return rv;
}

function path_basename(p) {
	var a = p.split('/');
	if (a.length > 1) return a.pop();
	else return p;
}

function path_basename_ext(p) {
	var n = path_basename(p);
	var x = n.lastIndexOf('.');
	if (x > 0) return n.substr(x+1);
	else return "";
}

function path_basename_noext(p) {
	var n = path_basename(p);
	var x = n.lastIndexOf('.');
	if (x > 0) return n.substr(0, x);
	else return n;
}

function path_is_package(p) {
	return $.NSWorkspace.sharedWorkspace.isFilePackageAtPath(p);
}

function file_exists(p) {
	var isdir = Ref();
	var rv = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(p, isdir);

	return (!isdir[0] && rv);
}

function directory_exists(p) {
	var isdir = Ref();
	var rv = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(p, isdir);
	return (isdir[0] && rv);
}

function path_exists(p) {
	var isdir = false;
	var rv = $.NSFileManager.defaultManager.fileExistsAtPathIsDirectory(p, isdir);
	return rv;
}

function open_file(p) {
  //Application("Finder").open(p);
	$.NSWorkspace.sharedWorkspace.openFile(p);
	//app.doShellScript("open " + quotedForm(p));
}

function cp_file(from, to) {
	$.NSFileManager.defaultManager.copyItemAtPathToPathError(from, to, null);
}

function ls_dir(p) {
	var a = $.NSFileManager.defaultManager.contentsOfDirectoryAtPathError(p, null);
	var rv = [];
	for (var i = 0; i < a.count; i++) {
		var name = ObjC.unwrap(a.objectAtIndex(i));
		if (name.charAt(0) !== '.') {
			rv.push(p + "/" + name);
		}
	}
	return rv;
}

function template_paths(path) {
  var templates = [];
  var data = {};

  while(path && path != "/") {
	templates.push(path + "/Templates");
    path = path_dirname(path);
  }
  
  if (templates.indexOf(DEFAULT_TEMPLATES) === -1) templates.push(DEFAULT_TEMPLATES);
	
  for (var x = templates.length-1; x >= 0; x--) {
    path = templates[x];
    rv = ls_dir(path);
    for (var i = 0; i < rv.length; i++) {
	  //if (file_exists(rv[i]) || path_is_package(rv[i])) { 
      n = path_basename_noext(rv[i]);
      data[n] = rv[i];
    }
  }

  var list = [];
  for(var key in data) {
    var it = data[key];
    list.push(Path(it));
  }
  
  return list;
}

function URL2Path(u) {
	var u = $.NSURL.alloc.initWithString(u);
	return ObjC.unwrap(u.path);
}

function run() {
  sys = Application("System Events");
  proc = sys.processes.whose({frontmost: true})[0];

  if (proc.name() === "Finder") {
    finder = Application("Finder");
    url = finder.insertionLocation().url();//finder.windows[0].target().url();
	path = URL2Path(url);
  }
  else {
    bm = Application("BookMarkable");
    bm.bookmarkForemostApplication({hidePanel:true});

    while (bm.working()) {
      delay(0.1);
    }
    url = bm.currentUrl();
		path = bm.currentPath();
		if (!path && url && url.indexOf("terminal-") === 0) {
	  	path = URL2Path(url);
		}
  }
  
  if (!path) {
  	alert("unable get current document location");
	return;
  }

  original = path;
  dest = path;

  if(file_exists(dest) || path_is_package(dest)) dest = path_dirname(dest);

  var list = template_paths(path);
  
  tx = Application("TextSer");
  tx.includeStandardAdditions = true;
  tx.createFromTemplate({templateFiles:list, destination:Path(dest), selectOnly:true});
	while(tx.templatePanel.visible()) {
		delay(0.3);
	}
	var src = tx.selectedTemplateFile();
	if (src) {
		try {
			src = src.toString();
			name = path_basename_noext(src);
			ext = path_basename_ext(src);
			name = tx.displayDialog('New Name', {defaultAnswer:name}).textReturned;
		
			dest += '/' + name;
			if (name.indexOf('.') == -1) dest += "." + ext;
			
			cp_file(src, dest);
			open_file(dest);
		}
		catch(ex) {
		}
	}
}
                              �jscr  ��ޭ