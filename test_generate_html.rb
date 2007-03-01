require File.dirname(__FILE__) + '/yard'
include YARD

Namespace.load("Yardoc", true)
ac = File.open("doc/all-classes.html", "w") 
ac.puts <<-eof
<html>
  <head>
    <base target="main" />
  </head>
  <body>
  <h3>All Classes</h3>
eof
meths = []
Namespace.all.sort.each do |path|
  object = Namespace.at(path)
  if object.is_a?(MethodObject) && object.visibility == :public
    meths << [object.name, object]
  end
  
  next unless object.is_a? ClassObject
  ac.puts "<a href='" + path.gsub("::","_") + ".html'>" + path + "</a><br />"
  File.open("doc/#{path.gsub('::','_')}.html", "w") {|f| f.write(object.format) }
end
ac.puts "</body></html>"
ac.close

File.open("doc/all-methods.html", "w") do |f|
  f.puts <<-eof
    <html>
      <head>
        <base target="main" />
      </head>
      <body>
      <h3>All Methods</h3>
eof
  meths.sort {|a,b| a.first <=> b.first }.each do |name, object|
    f.puts "<a href='" + object.parent.path.gsub("::", "_") + ".html##{object.scope}_method-#{name}'>#{name}</a><br />"
  end
end
File.open("doc/index.html", "w") do |f|
  f.puts <<-eof
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
  <html>
    <head>
      <meta http-equiv="Content-type" content="text/html; charset=utf-8">
      <title>Ruby Classes</title>
    </head>
    <frameset cols="250,*">
      <frameset rows="*,40%">
        <frame src="all-classes.html">
        <frame src="all-methods.html">
      </frameset>
      <frame name="main" src="YARD_CodeObject.html">
    </frameset>
  </html>
eof
end