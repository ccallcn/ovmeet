
//fl.enableImmediateUpdates();
fl.outputPanel.clear();
fl.openDocument("file:///zlchatOA_rebuild.fla");
var doc=fl.getDocumentDOM();
var tl=doc.getTimeline();
var lib=doc.library;
var newSel=new Array();
var si,li,ci,pi,tx,r0,nr,cx,cy;

//movie properties
doc.width=882;
doc.height=590;
doc.frameRate=30;
doc.backgroundColor="#FFFFFF";

