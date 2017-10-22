////////////////////////////////////////////////////////////////////////////////
// // HTML // HTML // HTML // HTML // HTML // HTML // HTML // HTML // HTML // //
////////////////////////////////////////////////////////////////////////////////

procedure InsertTag(const Pre, Post: String);
var
  start, len: Integer;
begin
  start := Editor.SelStart;
  len := Editor.SelLength;
  Editor.SelText := Pre + Editor.SelText + Post;
  Editor.SelStart := start + Length(Pre);
  Editor.SelLength := len;
end;

function GetIndent: Integer;
var
  len: Integer;
  Zeile: String;
begin
  Result := 0;
  Zeile := Editor.CurLine;
  len := Length(Zeile);
  while (Copy(Zeile, Result + 1, 1) = ' ') and (Result < len) do
    Inc(Result);
end;

procedure UserTag;
var
  Tag, Attribute: String;
begin
  if Tools.InputDlg('Tag einfügen...', Tag) then
  begin
    if Copy(Tag, 1, 1) = '<' then
      Delete(Tag, 1, 1);
    if Copy(Tag, Length(Tag), 1) = '>' then
      Delete(Tag, Length(Tag), 1);
    if Pos(' ', Tag) > 0 then
    begin
      Attribute := Copy(Tag, Pos(' ', Tag), Length(Tag));
      Tag := Copy(Tag, 1, Pos(' ', Tag) - 1);
    end
    else
      Attribute := '';
    InsertTag('<' + Tag + Attribute + '>', '</' + Tag + '>');
  end; 
end;

procedure FormatText;
var
  s: String;
begin
  with Editor do
  begin
    if SelLength = 0 then
      InsertTag('<p>', '</p>')
    else
    begin
      s := SelText;
      s := Tools.StringReplace(s, #13#10#13#10#13#10, #13#10#13#10, False);
      s := Tools.StringReplace(s, #13#10#13#10, '</p>#13#10#13#10<p>', False);
      s := Tools.StringReplace(s, #13#10, '<br>#13#10', False);
      s := Tools.StringReplace(s, '#13#10', #13#10, False);
      s := Tools.StringReplace(s, '  ', ' &nbsp;', False);
      s := Tools.StringReplace(s, '(c)', '&copy;', False);
      s := Tools.StringReplace(s, '‘', '&lsquo;', False);
      s := Tools.StringReplace(s, '’', '&rsquo;', False);
      s := Tools.StringReplace(s, '‚', '&sbquo;', False);
      s := Tools.StringReplace(s, '“', '&ldquo;', False);
      s := Tools.StringReplace(s, '”', '&rdquo;', False);
      s := Tools.StringReplace(s, '„', '&bdquo;', False);
      s := Tools.StringReplace(s, '«', '&laquo;', False);
      s := Tools.StringReplace(s, '»', '&raquo;', False);
      s := '<p>' + s + '</p>';
      SelText := s;
    end;
  end;
end;

procedure DummyText;
begin
  Editor.SelText := '<h1>Header Level 1</h1>'
     + #13#10 + '<p><strong>Auf dem letzten Hause eines kleinen Dörfchens</strong> befand sich ein <abbr title="Behausung eines langbeinigen Vogels">Storchnest</abbr>. Die Storchmutter saß im Neste bei ihren vier Jungen, welche den Kopf mit dem kleinen <em>schwarzen Schnabel</em>, denn er war noch nicht rot geworden, hervorstreckten. Ein Stückchen davon stand auf der Dachfirste starr und steif der Storchvater <code>syntax</code>. Man hätte meinen können, er wäre aus Holz gedrechselt, so stille stand er. „Gewiss sieht es recht vornehm aus, dass meine Frau eine Schildwache bei dem Neste hat!“ dachte er. Und er stand unermüdlich auf <a href="#nirgendwo" title="Title für einem Bein">einem Beine</a>.</p>'
     + #13#10
     + #13#10 + '<h2>Header Level 2</h2>'
     + #13#10 + '<ol>'
     + #13#10 + '  <li>Und was dann? fragten die Storchkinder.</li>'
     + #13#10 + '  <li>Dann werden wir aber doch gepfählt, wie die Knaben behaupteten, und höre nur, jetzt sagen sie es schon wieder!</li>'
     + #13#10 + '</ol>'
     + #13#10
     + #13#10 + '<p>Unten auf der Straße spielte eine Schar Kinder und als sie die Störche erblickten, sang einer der dreistesten Knaben und allmählich alle <acronym title="zusammen">zus.</acronym> einen Vers aus einem alten Storchliede, so gut sie sich dessen erinnern konnten:</p>'
     + #13#10
     + #13#10 + '<blockquote cite="Hans Andersen">'
     + #13#10 + '  <p>Störchlein, Störchlein, fliege, <br>Damit ich dich nicht kriege, <br>Deine Frau, die liegt im Neste dein Bei deinen lieben Kindelein: Das eine wird gepfählt, Das andere wird abgekehlt, Das dritte wird verbrannt, Das vierte dir entwandt!</p>'
     + #13#10 + '  <p><cite>Hans Andersen</cite></p>'
     + #13#10 + '</blockquote>'
     + #13#10
     + #13#10 + '<p>Höre nur, was die Jungen singen! sagten die kleinen Storchkinder. Sie sagen, wir sollen gebraten und verbrannt werden!</p>'
     + #13#10
     + #13#10 + '<h3>Header Level 3</h3>'
     + #13#10 + '<ul>'
     + #13#10 + '  <li>Das eine wird gepfählt</li>'
     + #13#10 + '  <li>Das andere wird abgekehlt!</li>'
     + #13#10 + '</ul>'
     + #13#10
     + #13#10 + '<dl>'
     + #13#10 + '  <dt>Definitionsliste</dt>'
     + #13#10 + '  <dd>Ja, das habe ich gesehen! riefen beide Kinder, und nun wussten sie, dass es Wahrheit wäre.</dd>'
     + #13#10 + '  <dt>Kann die Schneekönigin hereinkommen? fragte das kleine Mädchen.</dt>'
     + #13#10 + '  <dd>Lass sie nur kommen, sagte der Knabe, dann setze ich sie auf den warmen Kachelofen und sie muss zerschmelzen!</dd>'
     + #13#10 + '</dl>';
end;

procedure List;
var
  start: Integer;
  Zeilen: TStringList;
  i: Integer;
begin
  with Editor do
  begin
    if SelLength = 0 then
    begin
      start := SelStart;
      SelText := '<ul>'#13#10' <li></li>'#13#10'</ul>';
      SelStart := start + 11;
    end
    else
    begin
      Zeilen := TStringList.Create;
      try
        Zeilen.Text := SelText + #13#10; //s. zeilenumbruch.txt
        start := 0;
        while Zeilen.Strings[0][start + 1] = ' ' do
          inc(start);
        for i := 0 to Zeilen.Count - 1 do
          Zeilen.Strings[i] := StringOfChar(' ', start) +  ' <li>' + Tools.TrimLeft(Zeilen.Strings[i]) + '</li>';
        Zeilen.Add(StringOfChar(' ', start) +  '<ul>');
        Zeilen.Move(Zeilen.Count - 1, 0);
        Zeilen.Add(StringOfChar(' ', start) +  '</ul>');
        SelText := Zeilen.Text;
      finally
        Zeilen.Free;
      end;
    end;
  end;
end;

procedure Table;
var
  start: Integer;
  Zeilen: TStringList;
  i: Integer;
begin
  with Editor do
  begin
    if SelLength = 0 then
    begin
      start := SelStart;
      SelText := '<table>'#13#10'<tr>'#13#10' <td></td>'#13#10' <td></td>'#13#10'</tr>'#13#10'<tr>'#13#10' <td></td>'#13#10' <td></td>'#13#10'</tr>'#13#10'</table>';
      SelStart := start + 20;
    end
    else
    begin
      Zeilen := TStringList.Create;
      try
        Zeilen.Text := SelText + #13#10; //s. zeilenumbruch.txt
        start := 0;
        while Zeilen.Strings[0][start + 1] = ' ' do
          inc(start);
        Zeilen.Strings[0] := StringOfChar(' ', start) +  '<tr>'#13#10 + StringOfChar(' ', start) + ' <th>' + Tools.StringReplace(Tools.TrimLeft(Zeilen.Strings[0]), '|', '</th>'#13#10 + StringOfChar(' ', start) + ' <th>', False) + '</th>'#13#10 + StringOfChar(' ', start) +'</tr>';
        for i := 1 to Zeilen.Count - 1 do
          Zeilen.Strings[i] := StringOfChar(' ', start) +  '<tr>'#13#10 + StringOfChar(' ', start) + ' <td>' + Tools.StringReplace(Tools.TrimLeft(Zeilen.Strings[i]), '|', '</td>'#13#10 + StringOfChar(' ', start) + ' <td>', False) + '</td>'#13#10 + StringOfChar(' ', start) +'</tr>';
        Zeilen.Add(StringOfChar(' ', start) +  '<table>');
        Zeilen.Move(Zeilen.Count - 1, 0);
        Zeilen.Add(StringOfChar(' ', start) +  '</table>');
        SelText := Zeilen.Text;
        SelStart := SelStart - 2;
        SelLength := 2;
        SelText := '';
      finally
        Zeilen.Free;
      end;
    end;
  end;
end;

procedure Image;
var
  FileName: String;
  Width, Height: Integer;
begin
  if Editor.SelLength <> 0 then
    FileName := Editor.SelText
  else
    FileName := Tools.OpenPictureDialog('Bild...');
  if FileName <> '' then
  begin
    Tools.GetImageDimensions(FileName, Width, Height);
    FileName := Tools.CreateLink(FileName, Editor.FileName);
    Editor.SelText := Tools.Format('<img src="%s" width="%d" height="%d" alt="">', [FileName, Width, Height]);
  end;
end;

procedure LinkSimple;
var
  start: Integer;
begin
  start := Editor.SelStart;
  Editor.SelText := '<a href="">' + Editor.SelText + '</a>';
  Editor.SelStart := start + Length('<a href="');
  Editor.SelLength := 0;  
end;

procedure LinkSimpleHttp;
var
  start: Integer;
begin
  start := Editor.SelStart;
  Editor.SelText := '<a href="http://" target="_blank">' + Editor.SelText + '</a>';
  Editor.SelStart := start + Length('<a href="http://');
  Editor.SelLength := 0;  
end;

procedure LinkSimpleMailto;
var
  start: Integer;
begin
  start := Editor.SelStart;
  Editor.SelText := '<a href="mailto:">' + Editor.SelText + '</a>';
  Editor.SelStart := start + Length('<a href=mailto:"');
  Editor.SelLength := 0;  
end;

procedure LinkFile;
var
  FileName: String;
begin
  FileName := Tools.OpenFileDialog('Link...');
  if FileName <> '' then
  begin
    FileName := Tools.CreateLink(FileName, Editor.FileName);
    InsertTag('<a href="' + FileName + '">', '</a>');
  end;
end;

procedure ParagraphSimple;
begin
  InsertTag('<p>', '</p>');
end;

procedure LineBreak;
begin
  Editor.SelText := '<br>' + #13#10 + StringOfChar(' ', GetIndent);
end;

procedure ImageSimple;
var
  start: Integer;
begin
  start := Editor.SelStart;
  Editor.SelText := '<img src="" width="" height="" alt="">';
  Editor.SelStart := start + Length('<img src="');
end;

procedure DecoEm;
begin
  InsertTag('<em>', '</em>');
end;

procedure DecoStrong;
begin
  InsertTag('<strong>', '</strong>');
end;

procedure DecoVar;
begin
  InsertTag('<var>', '</var>');
end;

procedure DecoCode;
begin
  InsertTag('<code>', '</code>');
end;

procedure DecoB;
begin
  InsertTag('<b>', '</b>');
end;

procedure DecoI;
begin
  InsertTag('<i>', '</i>');
end;

procedure Head1;
begin
  InsertTag('<h1>', '</h1>');
end;

procedure Head2;
begin
  InsertTag('<h2>', '</h2>');
end;

procedure Head3;
begin
  InsertTag('<h3>', '</h3>');
end;

procedure Head4;
begin
  InsertTag('<h4>', '</h4>');
end;

procedure Head5;
begin
  InsertTag('<h5>', '</h5>');
end;

procedure Head6;
begin
  InsertTag('<h6>', '</h6>');
end;

procedure ListElement;
begin
  InsertTag('<li>', '</li>');
end;

procedure HeaderLoose;
begin
  Editor.SelText := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
end;

procedure HeaderStrict;
begin
  Editor.SelText := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
end;

procedure HeaderMeta;
begin
  Editor.SelText := '<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">'
    + #13#10 + '<meta http-equiv="content-script-type" content="text/javascript">'
    + #13#10 + '<meta http-equiv="content-style-type" content="text/css">';
end;

procedure ScriptJsIntern;
begin
  InsertTag('<script type="text/javascript">' + #13#10 + '<!--' + #13#10, #13#10 + '-->' + #13#10 + '</script>');
end;

procedure ScriptJsExtern;
begin
  InsertTag('<script type="text/javascript" src="', '"></script>');
end;

procedure ScriptCssIntern;
begin
  InsertTag('<style type="text/css">' + #13#10 + '<!--' + #13#10, #13#10 + '-->' + #13#10 + '</style>');
end;

procedure ScriptCssExtern;
begin
  InsertTag('<link rel="stylesheet" type="text/css" href="', '">');
end;

procedure FormInput;
begin
  InsertTag('<input type="text" name="', '" id="" value="">');
end;

procedure FormLabel;
begin
  InsertTag('<label for="">', '</label>');
end;

procedure Comment;
begin
  InsertTag('<!--', '-->');
end;

procedure CharsUuml;
begin
  Editor.SelText := '&uuml;';
end;

procedure CharsBigUuml;
begin
  Editor.SelText := '&Uuml;';
end;

procedure CharsAuml;
begin
  Editor.SelText := '&auml;';
end;

procedure CharsBigAuml;
begin
  Editor.SelText := '&Auml;';
end;

procedure CharsOuml;
begin
  Editor.SelText := '&ouml;';
end;

procedure CharsBigOuml;
begin
  Editor.SelText := '&Ouml;';
end;

procedure CharsSzlig;
begin
  Editor.SelText := '&szlig;';
end;

procedure CharsSpace;
begin
  Editor.SelText := '&nbsp;';
end;

procedure CharsLeft;
begin
  Editor.SelText := '&lt;';
end;

procedure CharsRight;
begin
  Editor.SelText := '&gt;';
end;

procedure HtmlTagCompletion;
var
  Tag: String;
  start, len: Integer;
  ok: Boolean;
begin
  start := Editor.SelStart;
  Editor.SelText := '';
  len := 0;
  ok := True;
  while ok and (Copy(Editor.SelText, 1, 1) <> '<') do
  begin
    ok := Editor.SelStart > 0;
    if ok then
      ok := Pos(' ', Editor.SelText) = 0;
    if ok then
      ok := Pos(#13, Editor.SelText) = 0;
    if ok then
      ok := Pos(#10, Editor.SelText) = 0;
    if ok then
    begin
      Editor.SelStart := Editor.SelStart - 1;
      len := len + 1;
      Editor.SelLength := len;
    end;
  end;
  if ok then
  begin
    Editor.SelStart := Editor.SelStart + 1;
    len := len - 1;
    Editor.SelLength := len;
    Tag := LowerCase(Editor.SelText);
    if Copy(Tag, 1, 1) = '/' then
      ok := False
    else if Tag = 'br' then
      ok := False
    else if Tag = 'hr' then
      ok := False
    else if Tag = 'meta' then
      ok := False
    else if Tag = 'link' then
      ok := False
    else if Tag = 'area' then
      ok := False
    else if Tag = 'input' then
      ok := False
    else if Tag = 'img' then
      ok := False
    else if Tag = 'col' then
      ok := False;
  end;
  Editor.SelStart := start;
  Editor.SelText := '>';
  start := Editor.SelStart;
  if ok and (Length(Tag) > 0) then
    Editor.SelText := '</' + Tag + '>';
  Editor.SelStart := start; 
end;

procedure QuotationEntities;
var
  opt: Integer;
begin
  opt := Tools.RadioDialog('einfache deutsche Anführungszeichen (1)'#13#10
                         + 'doppelte deutsche Anfürhungszeichen (2)'#13#10
                         + 'einfache spitze deutsche Anfürhungszeichen (3)'#13#10
                         + 'doppelte spitze deutsche Anfürhungszeichen (4)'#13#10
                         + 'einfache englische Anfürhungszeichen (5)'#13#10
                         + 'doppelte englische Anführungszeichen (6)'#13#10
                         + 'einzelne schweizer Anfprhungszeichen (7)'#13#10
                         + 'doppelte schweizer Anführungszeichen (8)'#13#10
                         + 'einzelne französische Anfprhungszeichen (9)'#13#10
                         + 'doppelte französische Anfprhungszeichen (0)');
  case opt of
    0: InsertTag('&sbquo;', '&lsquo;');
    1: InsertTag('&bdquo;', '&ldquo;');    
    2: InsertTag('&rsaquo;', '&lsaquo;');
    3: InsertTag('&raquo;', '&laquo;');
    4: InsertTag('&lsquo;', '&rsquo;');
    5: InsertTag('&ldquo;', '&rdquo;');  
    6: InsertTag('&lsaquo;', '&rsaquo;');
    7: InsertTag('&laquo;', '&raquo;');
    8: InsertTag('&lsaquo;&thinsp;', '&thinsp;&rsaquo;');
    9: InsertTag('&laquo;&thinsp;', '&thinsp;&raquo;');
  end;
end;

procedure UnicodeEntities;
var
  s, r: String;
  i: Integer;
begin
  r := '';
  s := Editor.SelText;
  for i := 1 to Length(s) do
    r := r + '&#' + IntToStr(Ord(s[i])) + ';';
  Editor.SelText := r;
end;

const
  MODE_NONE = 0;
  MODE_PHP = 1;
  MODE_ASP = 2;
  MODE_STYLE = 3;
  MODE_SCRIPT = 4;
  MODE_TAG = 5;

procedure NamedEntities;
var
  s, r: String;
  i: Integer;
  Mode: Integer;
begin
  s := Editor.SelText;
  r := '';
  if Length(s) > 0 then
  begin
    Mode := MODE_NONE;
    for i := 1 to Length(s) do
    begin
      if Mode = MODE_PHP then
      begin
        if Copy(s, i - 2, 2) = '?>' then
          Mode := MODE_NONE;
      end
      else if Mode = MODE_ASP then
      begin
        if Copy(s, i - 2, 2) = '%>' then
          Mode := MODE_NONE;
      end
      else if Mode = MODE_STYLE then
      begin
        if Copy(s, i - 8, 8) = '</style>' then
          Mode := MODE_NONE;
      end
      else if Mode = MODE_SCRIPT then
      begin
        if Copy(s, i - 9, 9) = '</script>' then
          Mode := MODE_NONE;
      end
      else if Mode = MODE_TAG then
      begin
        if Copy(s, i - 1, 1) = '>' then
          Mode := MODE_NONE;
      end
      else
      begin
        if Copy(s, i, 2) = '<?' then
          Mode := MODE_PHP
        else if Copy(s, i, 2) = '<%' then
          Mode := MODE_ASP
        else if Copy(s, i, 6) = '<style' then
          Mode := MODE_STYLE
        else if Copy(s, i, 7) = '<script' then
          Mode := MODE_SCRIPT
        else if s[i] = '<' then
          if Copy(s, i + 1, 1) <> ' ' then
            Mode := MODE_TAG
      end;
      
      if Mode = 0 then
      begin
        case s[i] of
          '<': r := r + '&lt;';
          '>': r := r + '&gt;';
          '"': r := r + '&quot;';
          'ä': r := r + '&auml;';
          'Ä': r := r + '&Auml;';
          'ö': r := r + '&ouml;';
          'Ö': r := r + '&Ouml;';
          'ü': r := r + '&uuml;';
          'Ü': r := r + '&Uuml;';
          'ß': r := r + '&szlig;';
          '&':
            if Copy(s, i + 1, 1) = ' ' then
              r := r + '&amp;'
            else
              r := r + '&';
          else
            r := r + s[i];
        end;
      end
      else
        r := r + s[i];
    end;
  end;
  Editor.SelText := r;
end;

////////////////////////////////////////////////////////////////////////////////
// // LaTeX // LaTeX // LaTeX // LaTeX // LaTeX // LaTeX // LaTeX // LaTeX // //
////////////////////////////////////////////////////////////////////////////////

procedure LatexNewLine;
begin
  Editor.SelText := '\\' + #13#10 + StringOfChar(' ', GetIndent);
end;

procedure InsertCommand(const Command: String);
begin
  InsertTag('\' + Command + '{', '}');
end;

procedure Section;
begin
  InsertCommand('section');
end;

procedure SubSection;
begin
  InsertCommand('subsection');
end;

procedure SubSubSection;
begin
  InsertCommand('subsubsection');
end;

procedure Paragraph;
begin
  InsertCommand('paragraph');
end;

procedure SubParagraph;
begin
  InsertCommand('subparagraph');
end;

procedure SubSubParagraph;
begin
  InsertCommand('subsubparagraph');
end;

procedure UserCommand;
var
  Command: String;
begin
  if Tools.InputDlg('Befehl einfügen...', Command) then
    InsertCommand(Command);
end;

procedure LatexInlineEnv(const name: String);
begin
  InsertTag('\begin{' + name + '}', '\end{' + name + '}');
end;

procedure UserInlineEnv;
var
  Env: String;
begin
  if Tools.InputDlg('Umgebung einfügen...', Env) then
    LatexInlineEnv(Env);
end;

procedure LatexBlockEnv(const name: String);
var
  Indent: String;
begin
  Indent := StringOfChar(' ', GetIndent);
  if Copy(Editor.SelText, 1, Length(Indent)) = Indent then
    InsertTag(indent + '\begin{' + name + '}' + #13#10,
      #13#10 + Indent + '\end{' + name + '}')
  else
    InsertTag('\begin{' + name + '}' + #13#10 + Indent,
      #13#10 + Indent + '\end{' + name + '}');
end;

procedure UserBlockEnv;
var
  Env: String;
begin
  if Tools.InputDlg('Umgebung einfügen...', Env) then
    LatexBlockEnv(Env);
end;

procedure LatexEnvCompletion;
var
  Env: String;
  start: Integer;
begin
  Editor.SelText := '';
  start := Editor.SelStart;
  while (Editor.SelStart > 0) and (Editor.SelText <> '{') do
  begin
    Editor.SelStart := Editor.SelStart - 1;
    Editor.SelLength := 1;
  end;
  Editor.SelLength := start - Editor.SelStart;
  Env := Editor.SelText;
  // Env = "{environment"
  Editor.SelStart := Editor.SelStart - Length('\begin');
  Editor.SelLength := Length('\begin');
  if (Editor.SelText = '\begin') and (Length(Env) > 1) then
  begin
    Editor.SelStart := start;
    Editor.SelText := '}\end' + Env + '}';
    Editor.SelStart := start + 1;
  end
  else
  begin
    Editor.SelStart := start;
    Editor.SelText := '}';
  end;
end;

procedure LatexAlign;
begin
  LatexBlockEnv('align');
end;

procedure LatexPMatrix;
begin
  LatexBlockEnv('pmatrix');
end;

procedure LatexPMatrixInline;
begin
  LatexInlineEnv('pmatrix');
end;

procedure LatexEnumList;
begin
  LatexBlockEnv('enumerate');
  InsertTag('  \item ', '');
end;

procedure LatexItemList;
begin
  LatexBlockEnv('itemize');
  InsertTag('  \item ', '');
end;

procedure LatexVarEnumList;
begin
  LatexBlockEnv('varenumerate');
  InsertTag('  \item ', '');
end;

procedure LatexVarItemList;
begin
  LatexBlockEnv('varitemize');
  InsertTag('  \item ', '');
end;

procedure LatexCompactEnumList;
begin
  LatexBlockEnv('compactenum');
  InsertTag('  \item ', '');
end;

procedure LatexCompactItemList;
begin
  LatexBlockEnv('compactitem');
  InsertTag('  \item ', '');
end;

procedure LatexVarCompactEnumList;
begin
  LatexBlockEnv('varcompactenum');
  InsertTag('  \item ', '');
end;

procedure LatexVarCompactItemList;
begin
  LatexBlockEnv('varcompactitem');
  InsertTag('  \item ', '');
end;

procedure LatexBrackets(const pre, post: String);
var
  start, len: Integer;
  text: String;
begin
  start := Editor.SelStart;
  len := Editor.SelLength;
  text := Editor.SelText;
  
  if len = 0 then
  begin
    pre := pre + ' ';
    post := ' ' + post;
  end
  else
  begin
    if Copy(text, 1, 1) <> ' ' then
      pre := pre + ' ';
    if Copy(text, Length(text), 1) <> ' ' then
      post := ' ' + post;
  end;
  
  Editor.SelText := pre + text + post;
  Editor.SelStart := start + Length(pre);
  Editor.SelLength := len;
end;

procedure LatexBracketsRound;
begin
  LatexBrackets('(', ')');
end;

procedure LatexBracketsMatchingRound;
begin
  LatexBrackets('\left(', '\right)');
end;

procedure LatexBracketsAngle;
begin
  LatexBrackets('\langle', '\rangle');
end;

procedure LatexBracketsMatchingAngle;
begin
  LatexBrackets('\left\langle', '\right\rangle');
end;

procedure LatexBracketsSquare;
begin
  LatexBrackets('[', ']');
end;

procedure LatexBracketsMatchingSquare;
begin
  LatexBrackets('\left[', '\right]');
end;

procedure LatexBracketsCurly;
begin
  LatexBrackets('\{', '\}');
end;

procedure LatexBracketsMatchingCurly;
begin
  LatexBrackets('\left\{', '\right\}');
end;

procedure LatexBracketsAbs;
begin
  LatexBrackets('|', '|');
end;

procedure LatexBracketsMatchingAbs;
begin
  LatexBrackets('\left|', '\right|');
end;

procedure LatexBracketsVecAbs;
begin
  LatexBrackets('\|', '\|');
end;

procedure LatexBracketsMatchingVecAbs;
begin
  LatexBrackets('\left\|', '\right\|');
end;

procedure LatexFrac;
begin
  InsertTag('\frac{', '}{}');
end;

procedure LatexListItem;
begin
  InsertTag('\item', '');
end;

procedure LatexVector;
begin
  InsertCommand('vec');
end;

procedure LatexFormula;
begin
  LatexBrackets('\[', '\]');
end;

////////////////////////////////////////////////////////////////////////////////
// // Text // Text // Text // Text // Text // Text // Text // Text // Text // //
////////////////////////////////////////////////////////////////////////////////

procedure InsertDateTime;
var
  Dates: array[0..7] of String;
  DateString: String;
  i: Integer;
  res: Integer;
begin
  Dates[0] := 'dd.mm.yy';
  Dates[1] := 'dd.mm.yyyy';
  Dates[2] := 'd. mmmm yyyy';
  Dates[3] := 'dddd", "dd. mmmm yyyy';
  Dates[4] := 'dddd", der "dd. mmmm yyyy';
  Dates[5] := 'hh:mm:ss';
  Dates[6] := 'hh" Uhr';
  DateString := '';
  for i := 0 to 6 do
  begin
    Dates[i] := Tools.FormatDateTime(Dates[i], Tools.Now);
    DateString := DateString + Dates[i] + ' (Strg+F' + IntToStr(i+1) + ')' + #13#10;
  end;
  res := Tools.RadioDialog(DateString);
  if res > -1 then
    Editor.SelText := Dates[res];
end;

procedure InsertTabulator;
begin
  Editor.SelText := #9;
end;

////////////////////////////////////////////////////////////////////////////////
// // Anwendungen // Anwendungen // Anwendungen // Anwendungen // Anwendungen //
////////////////////////////////////////////////////////////////////////////////

procedure StartBrowser(const FileName: String; const BringBack: String);
begin
  if Editor.Save then
  begin
    Tools.RunApp('"' + FileName + '" "' + Editor.FileName + '"');
    Editor.SetGlobalGeekEditHotKey(BringBack);
  end;
end;

procedure FindBrowser(const FileName: String; const BringBack: String);
var
  Handle: LongWord;
begin
  if Editor.Save then
  begin
    Handle := Tools.FindApp(FileName, '');
    if Handle > 0 then
      Tools.InvokeKeystroke(Handle, 'F5')
    else
      Tools.RunApp('"' + FileName + '" "' + Editor.FileName + '"');
    Editor.SetGlobalGeekEditHotKey(BringBack);
  end;
end;

procedure FindBrowserChromePlus;
begin
  FindBrowser('C:\Programme\ChromePlus\chrome.exe', 'F9');
end;

procedure StartBrowserChromePlus;
begin
  StartBrowser('C:\Programme\ChromePlus\chrome.exe', 'F9');
end;

procedure FindBrowserIe;
begin
  FindBrowser('C:\Programme\Internet Explorer\iexplore.exe', 'F10');
end;

procedure StartBrowserIe;
begin
  StartBrowser('C:\Programme\Internet Explorer\iexplore.exe', 'F10');
end;

procedure FindBrowserFirefox;
begin
  FindBrowser('C:\Programme\Mozilla Firefox\firefox.exe', 'F11');
end;

procedure StartBrowserFirefox;
begin
  StartBrowser('C:\Programme\Mozilla Firefox\firefox.exe', 'F11');
end;

procedure StartConsole;
begin
  if Length(Editor.FileName) > 0 then
    Tools.RunApp('cmd /K cd "'
      + Tools.ExtractFilePath(Editor.FileName) + '"')
  else
    Tools.RunApp('cmd');
end;

procedure StartInternConsole;
begin
  if Length(Editor.FileName) > 0 then
    Editor.RunConsoleApp('cmd /K cd "'
      + Tools.ExtractFilePath(Editor.FileName) + '"')
  else
    Editor.RunConsoleApp('cmd');
end;

procedure ShowProperties;
begin
  if Length(Editor.FileName) > 0 then
    Tools.ShellExecute('properties', Editor.FileName);
end;

procedure OpenFolder;
begin
  if Length(Editor.FileName) > 0 then
    Tools.ShellExecute('open', Tools.ExtractFilePath(Editor.FileName));
end;

procedure CompileJava;
begin
  if Editor.Save then
    Editor.RunConsoleApp('javac "' + Editor.FileName + '"');
end;

procedure RunJava;
var
  cp: String;
begin
  cp := Tools.ExtractFilePath(Editor.FileName);
  if Copy(cp, Length(cp), 1) = '\' then
    Delete(cp, Length(cp), 1);
  Editor.RunConsoleApp('java -cp "' + cp
    + '" ' + Tools.ExtractFileBase(Editor.FileName));
end; 

procedure RunRuby;
begin
  // Ruby Options
  // -w enable warnings
  // -Ku set encoding to Unicode
  if Editor.Save then
    // Editor.RunConsoleApp('ruby -w -Ku ' + Editor.FileName);
    Editor.RunConsoleApp('ruby ' + Editor.FileName);
end;

procedure Latex;
begin
  if Editor.Save then
    Editor.RunConsoleApp('latex -src-specials -output-directory="' + Tools.ExtractFilePath(Editor.FileName) + '" "' + Editor.FileName + '"');
end;

procedure PdfLatex;
begin
  if Editor.Save then
    Editor.RunConsoleApp('pdflatex -output-directory="' + Tools.ExtractFilePath(Editor.FileName) + '" "' + Editor.FileName + '"');
end;

procedure Yap;
begin
  Editor.SetGlobalGeekEditHotKey('F10');
  Tools.RunApp('yap -1 -s "' + IntToStr(Editor.Row) + Editor.FileName + '" "' + Tools.ChangeFileExt(Editor.FileName, 'dvi'));
end;

procedure ShowPdf;
begin
  Tools.ShellExecute('open', Tools.ChangeFileExt(Editor.FileName, 'pdf'));
end;

procedure ShowAdobePdf;
begin
  Tools.RunApp('"C:\Programme\Adobe\Reader 10.0\Reader\AcroRd32.exe" "' + Tools.ChangeFileExt(Editor.FileName, 'pdf'));
end;

procedure DeployPdf;
begin
  if Editor.Save then
    Editor.RunConsoleBatchTool('deploy "' + Editor.FileName + '"');
end;

////////////////////////////////////////////////////////////////////////////////
// // Help // Help // Help // Help // Help // Help // Help // Help // Help // //
////////////////////////////////////////////////////////////////////////////////

procedure HelpHtmlMulti;
var
  w: String;
  opt: Integer;
begin
  w := Editor.CurWord;
  opt := Tools.RadioDialog('SelfHTML (F1)' + #13#10 + 'PHP Funktionsliste (F2)' + #13#10 + 'jQuery Dokumentation (F3)');
  case opt of
    0: if Length(w) > 0 then
         Tools.ShellExecute('open', 'http://de.selfhtml.org/navigation/suche/index.htm?Suchanfrage=' + w)
       else
         Tools.ShellExecute('open', 'http://de.selfhtml.org');
    1: if Length(w) > 0 then
         Tools.ShellExecute('open', 'http://www.php.net/manual-lookup.php?pattern=' + w)
       else
         Tools.ShellExecute('open', 'http://www.php.net/manual/de/');
    2: if Length(w) > 0 then
         Tools.ShellExecute('open', 'http://docs.jquery.com/Special:Search?search=' + w)
       else
         Tools.ShellExecute('open', 'http://docs.jquery.com');     
  end;
end;

procedure HelpLatex;
var
  w: String;
begin
  w := Editor.CurWord;
  if Length(w) > 0 then
     Tools.ShellExecute('open', 'http://www.google.de/search?q=latex+' + w);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
begin
  with Editor do
  begin
    // HTML
    
    RegisterMenu('', 'HtmlMenu', 'HTML');
    RegisterScript('HtmlMenu', 'Tag einfügen...', 'Strg+Y', 'UserTag');
    RegisterScript('HtmlMenu', 'Tabelle', 'Strg+T', 'Table');
    RegisterScript('HtmlMenu', 'Kommentar', 'Strg+#', 'Comment');
    
    RegisterMenu('HtmlMenu', 'EntitiesMenu', 'Entitäten');
    RegisterScript('EntitiesMenu', 'Anführungszeichen', 'Alt+2', 'QuotationEntities');
    RegisterScript('EntitiesMenu', 'alle Zeichen als Unicode-Nummern', 'Umsch+Strg+E', 'UnicodeEntities');
    RegisterScript('EntitiesMenu', 'HTML-eigene Zeichen und dt. Umlaute', 'Strg+E', 'NamedEntities');
    
    RegisterMenu('HtmlMenu', 'ListMenu', 'Liste');
    RegisterScript('ListMenu', 'unsortierte  Liste <ul>', 'Strg+U', 'List');
    RegisterScript('ListMenu', 'Listenelement <li>', 'Strg+.', 'ListElement');
    
    RegisterMenu('HtmlMenu', 'ParagraphMenu', 'Absatzsteuerung');
    RegisterScript('ParagraphMenu', 'Text', 'Strg+J', 'FormatText');
    RegisterScript('ParagraphMenu', 'Fülltext', 'Umsch+Strg+J', 'DummyText');
    RegisterScript('ParagraphMenu', 'Absatz', 'Strg+Eingabe', 'ParagraphSimple');
    RegisterScript('ParagraphMenu', 'Zeilenumbruch', 'Umsch+Eingabe', 'LineBreak');
    
    RegisterMenu('HtmlMenu', 'ImageMenu', 'Bild');
    RegisterScript('ImageMenu', 'Bild aus Datei...', 'Strg+I', 'Image');
    RegisterScript('ImageMenu', 'Bild', 'Strg+Umsch+I', 'ImageSimple');
    
    RegisterMenu('HtmlMenu', 'LinkMenu', 'Link')
    RegisterScript('LinkMenu', 'Link', 'Strg+L', 'LinkSimple');
    RegisterScript('LinkMenu', 'Link auf externe Website', 'Strg+Alt+L', 'LinkSimpleHttp');
    RegisterScript('LinkMenu', 'eMail-Link', 'Strg+Umsch+L', 'LinkSimpleMailto');
    RegisterScript('LinkMenu', 'Link auf Datei...', 'Strg+Alt+Umsch+L', 'LinkFile');
    
    RegisterMenu('HtmlMenu', 'DecoMenu', 'Auszeichnungen');
    RegisterScript('DecoMenu', 'emphatischer (betonter) Text <em>', 'Strg+Alt+K', 'DecoEm');
    RegisterScript('DecoMenu', 'stark emphatischer Text <strong>', 'Strg+B', 'DecoStrong');
    RegisterScript('DecoMenu', 'Variable <var>', 'Strg+Umsch+V', 'DecoVar');
    RegisterScript('DecoMenu', 'Quellcode <code>', 'Alt+K', 'DecoCode');
    RegisterMenu('DecoMenu', '', '-');
    RegisterScript('DecoMenu', 'fett <b>', 'Strg+Alt+B', 'DecoB');
    RegisterScript('DecoMenu', 'kursiv <i>', 'Strg+Alt+K', 'DecoI');

    RegisterMenu('HtmlMenu', 'HeadMenu', 'Überschriften');
    RegisterScript('HeadMenu', '1. Ordnung <h1>', 'Strg+Alt+1', 'Head1');
    RegisterScript('HeadMenu', '2. Ordnung <h2>', 'Strg+Alt+2', 'Head2');
    RegisterScript('HeadMenu', '3. Ordnung <h3>', 'Strg+Alt+3', 'Head3');
    RegisterScript('HeadMenu', '4. Ordnung <h4>', 'Strg+Alt+4', 'Head4');
    RegisterScript('HeadMenu', '5. Ordnung <h5>', 'Strg+Alt+5', 'Head5');
    RegisterScript('HeadMenu', '6. Ordnung <h6>', 'Strg+Alt+6', 'Head6');
    
    RegisterMenu('HtmlMenu', 'HeaderMenu', 'Kopfzeilen');
    RegisterScript('HeaderMenu', 'Doctype Strict', 'Umsch+Alt+D', 'HeaderStrict');
    RegisterScript('HeaderMenu', 'Doctype Loose / Transitional', 'Alt+D', 'HeaderLoose');    
    RegisterScript('HeaderMenu', 'Meta-Tags', 'Alt+M', 'HeaderMeta');
    
    RegisterMenu('HtmlMenu', 'ScriptMenu', 'JS && CSS');
    RegisterScript('ScriptMenu', 'JavaScript intern', '', 'ScriptJsIntern');
    RegisterScript('ScriptMenu', 'JavaScript extren', '', 'ScriptJsExtern');
    RegisterScript('ScriptMenu', 'CSS intern', '', 'ScriptCssIntern');
    RegisterScript('ScriptMenu', 'CSS extern', '', 'ScriptCssExtern');
    
    RegisterMenu('HtmlMenu', 'FormMenu', 'Formular');
    RegisterScript('FormMenu', 'Eingabefeld', 'Strg+Umsch+#', 'FormInput');
    RegisterScript('FormMenu', 'Label', 'Strg+Alt+Umsch+#', 'FormLabel');
    
    RegisterMenu('HtmlMenu', 'CharsMenu', 'Sonderzeichen');
    RegisterScript('CharsMenu', 'ü', 'Strg+ü', 'CharsUuml');
    RegisterScript('CharsMenu', 'Ü', 'Strg+Umsch+ü', 'CharsBigUuml');
    RegisterScript('CharsMenu', 'ä', 'Strg+ä', 'CharsAuml');
    RegisterScript('CharsMenu', 'Ä', 'Strg+Umsch+ä', 'CharsBigAuml');
    RegisterScript('CharsMenu', 'ö', 'Strg+ö', 'CharsOuml');
    RegisterScript('CharsMenu', 'Ö', 'Strg+Umsch+ö', 'CharsBigOuml');
    RegisterScript('CharsMenu', 'ß', 'Strg+ß', 'CharsSzlig');
    RegisterScript('CharsMenu', 'geschütztes Leerzeichen', 'Strg+Leertaste', 'CharsSpace');
    RegisterScript('CharsMenu', '<', 'Strg+<', 'CharsLeft');
    RegisterScript('CharsMenu', '>', 'Strg+Umsch+<', 'CharsRight');
    
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'HtmlMenu');
    SetSyntaxConditionalShortcut('SynHtmlErbMulti', 'HtmlMenu');
    
    RegisterActiveCharScript('>', 'SynHtmlMulti', 'HtmlTagCompletion');
    RegisterActiveCharScript('>', 'SynHtmlErbMulti', 'HtmlTagCompletion');
    
    // LaTeX
    
    RegisterMenu('', 'LatexMenu', 'LaTeX');
    
    RegisterScript('LatexMenu', 'Zeilenumbruch \\', 'Umsch+Eingabe', 'LatexNewLine');
    RegisterScript('LatexMenu', 'Befehl einfügen...', 'Strg+Y', 'UserCommand');
    RegisterScript('LatexMenu', 'Umgebung (mehrzeilig) einfügen...', 'Strg+D', 'UserBlockEnv');
    RegisterScript('LatexMenu', 'Umgebung (einzeilig) einfügen...', 'Strg+Umsch+D', 'UserInlineEnv');
    
    RegisterMenu('LatexMenu', 'SectionMenu', 'Abschnitte');
    RegisterScript('SectionMenu', '\section', 'Strg+Alt+1', 'Section');
    RegisterScript('SectionMenu', '\subsection', 'Strg+Alt+2', 'SubSection');
    RegisterScript('SectionMenu', '\subsubsection', 'Strg+Alt+3', 'SubSubSection');
    RegisterScript('SectionMenu', '\pargraph', 'Strg+Alt+4', 'Paragraph');
    RegisterScript('SectionMenu', '\subpargraph', 'Strg+Alt+5', 'SubParagraph');
    RegisterScript('SectionMenu', '\subsubpargraph', 'Strg+Alt+6', 'SubSubParagraph');
    
    RegisterMenu('LatexMenu', 'VectorMenu', 'Vektoren');
    RegisterScript('VectorMenu', '\vec', 'Strg+M', 'LatexVector');
    RegisterScript('VectorMenu', 'pmatrix (mehrzeilig)', 'Strg+,', 'LatexPMatrix');
    RegisterScript('VectorMenu', 'pmatrix (einzeilig)', 'Umsch+Strg+,', 'LatexPMatrixInline');
    
    RegisterMenu('LatexMenu', 'LatexListMenu', 'Listen');
    RegisterScript('LatexListMenu', '\item', 'Strg+.', 'LatexListItem');
    RegisterScript('LatexListMenu', 'Aufzählung enumerate', 'Strg+J', 'LatexEnumList');
    RegisterScript('LatexListMenu', 'kompakte Aufzählung compactenum', 'Strg+Alt+J', 'LatexCompactEnumList');
    RegisterScript('LatexListMenu', 'Aufzählung Variante varenumerate', 'Umsch+Strg+J', 'LatexVarEnumList');
    RegisterScript('LatexListMenu', 'kompakte Aufzählung Variante varcompactenum', 'Umsch+Strg+Alt+J', 'LatexVarCompactEnumList');
    RegisterScript('LatexListMenu', 'Liste itemize', 'Strg+H', 'LatexItemList');
    RegisterScript('LatexListMenu', 'kompakte Liste compactitem', 'Strg+Alt+H', 'LatexCompactItemList');
    RegisterScript('LatexListMenu', 'Liste Variante varitemize', 'Umsch+Strg+H', 'LatexVarItemList');
    RegisterScript('LatexListMenu', 'kompakte Liste Variante varcompactitem', 'Umsch+Strg+Alt+H', 'LatexVarCompactItemList');
    
    RegisterMenu('LatexMenu', 'FormulaMenu', 'Formeln');
    RegisterScript('FormulaMenu', '\[ \]', 'Strg+#', 'LatexFormula');
    RegisterScript('FormulaMenu', 'align', 'Strg+Umsch+#', 'LatexAlign');
    RegisterScript('FormulaMenu', 'Bruch \frac', 'Alt+7', 'LatexFrac');
    
    RegisterMenu('LatexMenu', 'BracketsMenu', 'Klammern');
    RegisterScript('BracketsMenu', 'runde Klammern \left( \right)', 'Alt+8', 'LatexBracketsMatchingRound');
    RegisterScript('BracketsMenu', 'runde Klammern ( )', 'Umsch+Alt+8', 'LatexBracketsRound');
    RegisterScript('BracketsMenu', 'eckige Klammern \left[ \right]', 'Alt+9', 'LatexBracketsMatchingSquare');
    RegisterScript('BracketsMenu', 'eckige Klammern [ ]', 'Umsch+Alt+9', 'LatexBracketsSquare');
    RegisterScript('BracketsMenu', 'geschweifte Klammern \left\{ \right\}', 'Alt+0', 'LatexBracketsMatchingCurly');
    RegisterScript('BracketsMenu', 'geschweifte Klammern \{ \}', 'Umsch+Alt+0', 'LatexBracketsCurly');
    RegisterScript('BracketsMenu', 'spitze Klammern \left\langle \right\rangle', 'Alt+<', 'LatexBracketsMatchingAngle');
    RegisterScript('BracketsMenu', 'spitze Klammern \langle \rangle', 'Umsch+Alt+<', 'LatexBracketsAngle');
    RegisterScript('BracketsMenu', 'Betrags-Klammern \left| \right|', 'Alt+ß', 'LatexBracketsMatchingAbs');
    RegisterScript('BracketsMenu', 'Betrags-Klammern | |', 'Umsch+Alt+ß', 'LatexBracketsAbs');
    RegisterScript('BracketsMenu', 'Vektor-Betrags-Klammern \left\| \right\|', 'Strg+Alt+ß', 'LatexBracketsMatchingVecAbs');
    RegisterScript('BracketsMenu', 'Vektor-Betrags-Klammern \| \|', 'Strg+Umsch+Alt+ß', 'LatexBracketsVecAbs');
    
    SetSyntaxConditionalShortcut('SynTex', 'LatexMenu');
    
    RegisterActiveCharScript('}', 'SynTex', 'LatexEnvCompletion');
    
    // Text
    
    RegisterMenu('', 'TextMenu', 'Text');
    RegisterScript('TextMenu', 'Datum && Uhrzeit einfügen...', 'Strg+F5', 'InsertDateTime');
    RegisterScript('TextMenu', 'Tabulator einfügen', 'Strg+Tab', 'InsertTabulator');
    
    // Anwendungen
    
    RegisterMenu('', 'ProgramsMenu', 'Anwendungen');
    RegisterScript('ProgramsMenu', 'ChromePlus aktualisieren...', 'F9', 'FindBrowserChromePlus');
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'FindBrowserChromePlusScriptMenu');
    SetSyntaxConditionalShortcut('SynCss', 'FindBrowserChromePlusScriptMenu');
    SetSyntaxConditionalShortcut('SynJs', 'FindBrowserChromePlusScriptMenu');
    SetSyntaxConditionalShortcut('SynVbs', 'FindBrowserChromePlusScriptMenu');
    RegisterScript('ProgramsMenu', 'ChromePlus starten...', 'Strg+F9', 'StartBrowserChromePlus');
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'StartBrowserChromePlusScriptMenu');
    SetSyntaxConditionalShortcut('SynCss', 'StartBrowserChromePlusScriptMenu');
    SetSyntaxConditionalShortcut('SynJs', 'StartBrowserChromePlusScriptMenu');
    SetSyntaxConditionalShortcut('SynVbs', 'StartBrowserChromePlusScriptMenu');
    
    RegisterScript('ProgramsMenu', 'Internet Explorer aktualisieren...', 'F10', 'FindBrowserIe');
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'FindBrowserIeScriptMenu');
    SetSyntaxConditionalShortcut('SynCss', 'FindBrowserIeScriptMenu');
    SetSyntaxConditionalShortcut('SynJs', 'FindBrowserIeScriptMenu');
    SetSyntaxConditionalShortcut('SynVbs', 'FindBrowserIeScriptMenu');
    RegisterScript('ProgramsMenu', 'Internet Explorer starten...', 'Strg+F10', 'StartBrowserIe');
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'StartBrowserIeScriptMenu');
    SetSyntaxConditionalShortcut('SynCss', 'StartBrowserIeScriptMenu');
    SetSyntaxConditionalShortcut('SynJs', 'StartBrowserIeScriptMenu');
    SetSyntaxConditionalShortcut('SynVbs', 'StartBrowserIeScriptMenu');
    
    RegisterScript('ProgramsMenu', 'Firefox aktualisieren...', 'F11', 'FindBrowserFirefox');
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'FindBrowserFirefoxScriptMenu');
    SetSyntaxConditionalShortcut('SynCss', 'FindBrowserFirefoxScriptMenu');
    SetSyntaxConditionalShortcut('SynJs', 'FindBrowserFirefoxScriptMenu');
    SetSyntaxConditionalShortcut('SynVbs', 'FindBrowserFirefoxScriptMenu');
    RegisterScript('ProgramsMenu', 'Firefox starten...', 'Strg+F11', 'StartBrowserFirefox');
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'StartBrowserFirefoxScriptMenu');
    SetSyntaxConditionalShortcut('SynCss', 'StartBrowserFirefoxScriptMenu');
    SetSyntaxConditionalShortcut('SynJs', 'StartBrowserFirefoxScriptMenu');
    SetSyntaxConditionalShortcut('SynVbs', 'StartBrowserFirefoxScriptMenu');
    
    RegisterMenu('ProgramsMenu', '', '-');
    RegisterScript('ProgramsMenu', 'Java compilieren', 'F9', 'CompileJava');
    SetSyntaxConditionalShortcut('SynJava', 'CompileJavaScriptMenu');
    RegisterScript('ProgramsMenu', 'Java ausführen', 'F10', 'RunJava');
    SetSyntaxConditionalShortcut('SynJava', 'RunJavaScriptMenu');
    
    RegisterMenu('ProgramsMenu', '', '-');
    RegisterScript('ProgramsMenu', 'Ruby ausführen', 'F9', 'RunRuby');
    SetSyntaxConditionalShortcut('SynRuby', 'RunRubyScriptMenu');
    
    RegisterMenu('ProgramsMenu', '', '-');
    RegisterScript('ProgramsMenu', 'LaTeX', 'F9', 'Latex');
    SetSyntaxConditionalShortcut('SynTex', 'LatexScriptMenu');
    RegisterScript('ProgramsMenu', 'DVI in YAP zeigen...', 'F10', 'Yap');
    SetSyntaxConditionalShortcut('SynTex', 'YapScriptMenu');
    RegisterScript('ProgramsMenu', 'pdfLaTeX', 'Strg+F9', 'PdfLatex');
    SetSyntaxConditionalShortcut('SynTex', 'PdfLatexScriptMenu');
    RegisterScript('ProgramsMenu', 'PDF anzeigen...', 'Strg+F10', 'ShowPdf');
    SetSyntaxConditionalShortcut('SynTex', 'ShowPdfScriptMenu');
    RegisterScript('ProgramsMenu', 'PDF mit Adobe anzeigen...', 'Umsch+F10', 'ShowAdobePdf');
    SetSyntaxConditionalShortcut('SynTex', 'ShowAdobePdfScriptMenu');
    RegisterScript('ProgramsMenu', 'PDF mit pdfLaTeX neu erzeugen (3x)', 'Umsch+F9', 'DeployPdf');
    SetSyntaxConditionalShortcut('SynTex', 'DeployPdfScriptMenu');
    
    RegisterMenu('ProgramsMenu', '', '-');
    RegisterScript('ProgramsMenu', 'Konsole...', 'Strg+K', 'StartConsole');
    RegisterScript('ProgramsMenu', 'interne Konsole', 'Strg+Umsch+K', 'StartInternConsole');
    RegisterScript('ProgramsMenu', 'Ordner öffnen...', 'Strg+Umsch+O', 'OpenFolder');
    RegisterScript('ProgramsMenu', 'Eigenschaften anzeigen...', 'Strg+Alt+O', 'ShowProperties');
    
    // Kontexthilfe
    
    RegisterMenu('', 'HelpMenu', 'Kontexthilfe');
    RegisterScript('HelpMenu', 'HTML, PHP && JS', 'F1', 'HelpHtmlMulti');
    SetSyntaxConditionalShortcut('SynHtmlMulti', 'HelpHtmlMultiScriptMenu');
    SetSyntaxConditionalShortcut('SynCss', 'HelpHtmlMultiScriptMenu');
    SetSyntaxConditionalShortcut('SynJs', 'HelpHtmlMultiScriptMenu');
    SetSyntaxConditionalShortcut('SynVbs', 'HelpHtmlMultiScriptMenu');
    RegisterScript('HelpMenu', 'LaTeX Google', 'F1', 'HelpLatex');
    SetSyntaxConditionalShortcut('SynTex', 'HelpLatexScriptMenu');
  end;
end.
