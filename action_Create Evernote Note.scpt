JsOsaDAS1.001.00bplist00�Vscript_�var app = Application("TextSer");
app.includeStandardAdditions = true;

// should be configured to embed any image datavar htmlBody = app.convert({destinationName:"Copy HTML Source"});

// this prevents Evernote from inserting hard coded margins
htmlBody = htmlBody.replace(/<p>/g, '<div>');
htmlBody = htmlBody.replace(/<\/p>/g, '</div>');

app = Application("Evernote");
app.activate();
var note = app.createNote({withHtml:htmlBody});
app.openNoteWindow({with:note});                              � jscr  ��ޭ