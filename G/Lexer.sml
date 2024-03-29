local open Obj Lexing in


 open Lexing;

 exception LexicalError of string * (int * int) (* (message, (line, column)) *)

 val currentLine = ref 1
 val lineStartPos = ref [0]

 fun getPos lexbuf = getLineCol (getLexemeStart lexbuf)
				(!currentLine)
				(!lineStartPos)

 and getLineCol pos line (p1::ps) =
       if pos>=p1 then (line, pos-p1)
       else getLineCol pos (line-1) ps
   | getLineCol pos line [] = raise LexicalError ("",(0,0))

 fun lexerError lexbuf s = 
     raise LexicalError (s, getPos lexbuf)

 fun keyword (s, pos) =
     case s of
         "if"           => Parser.IF pos
       | "else"         => Parser.ELSE pos
       | "int"          => Parser.INT pos
       | "return"       => Parser.RETURN pos
       | "while"        => Parser.WHILE pos
       | "char"         => Parser.CHAR pos
       | _              => Parser.ID (s, pos)

 fun character (s, pos, lexbuf) =
     case Char.fromCString (String.substring(s, 1, String.size(s)-2)) of
          NONE      => lexerError lexbuf "Invalid character"
        | SOME c    => Parser.CHARCONST (c, pos)

 fun string (s, pos, lexbuf) =
     case String.fromCString (String.substring(s, 1, String.size(s)-2)) of
          NONE      => lexerError lexbuf "Invalid string"
        | SOME c    => Parser.STRINGCONST (c, pos)
 
fun action_22 lexbuf = (
 lexerError lexbuf "Illegal symbol in input" )
and action_21 lexbuf = (
 Parser.RBRACKET (getPos lexbuf) )
and action_20 lexbuf = (
 Parser.LBRACKET (getPos lexbuf) )
and action_19 lexbuf = (
 Parser.REF (getPos lexbuf) )
and action_18 lexbuf = (
 Parser.EQUAL (getPos lexbuf) )
and action_17 lexbuf = (
 Parser.RBLOCK (getPos lexbuf) )
and action_16 lexbuf = (
 Parser.LBLOCK (getPos lexbuf) )
and action_15 lexbuf = (
 Parser.EOF (getPos lexbuf) )
and action_14 lexbuf = (
 Parser.SEMICOLON (getPos lexbuf) )
and action_13 lexbuf = (
 Parser.COMMA (getPos lexbuf) )
and action_12 lexbuf = (
 Parser.RPAR (getPos lexbuf) )
and action_11 lexbuf = (
 Parser.LPAR (getPos lexbuf) )
and action_10 lexbuf = (
 Parser.ASSIGN (getPos lexbuf) )
and action_9 lexbuf = (
 Parser.LESS (getPos lexbuf) )
and action_8 lexbuf = (
 Parser.MINUS (getPos lexbuf) )
and action_7 lexbuf = (
 Parser.PLUS (getPos lexbuf) )
and action_6 lexbuf = (
 string (getLexeme lexbuf, getPos lexbuf, lexbuf) )
and action_5 lexbuf = (
 character (getLexeme lexbuf, getPos lexbuf, lexbuf) )
and action_4 lexbuf = (
 keyword (getLexeme lexbuf,getPos lexbuf) )
and action_3 lexbuf = (
 case Int.fromString (getLexeme lexbuf) of
                               NONE   => lexerError lexbuf "Bad integer"
                             | SOME i => Parser.NUM (i, getPos lexbuf) )
and action_2 lexbuf = (
 currentLine := !currentLine+1;
                          lineStartPos :=  getLexemeStart lexbuf
			                   :: !lineStartPos;
                          Token lexbuf )
and action_1 lexbuf = (
 Token lexbuf )
and action_0 lexbuf = (
 Token lexbuf )
and state_0 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #"A" andalso currChar <= #"Z" then  state_18 lexbuf
 else if currChar >= #"a" andalso currChar <= #"z" then  state_18 lexbuf
 else if currChar >= #"0" andalso currChar <= #"9" then  state_14 lexbuf
 else case currChar of
    #"\t" => state_3 lexbuf
 |  #"\r" => state_3 lexbuf
 |  #" " => state_3 lexbuf
 |  #"\n" => action_2 lexbuf
 |  #"\f" => action_2 lexbuf
 |  #"}" => action_17 lexbuf
 |  #"{" => action_16 lexbuf
 |  #"]" => action_21 lexbuf
 |  #"[" => action_20 lexbuf
 |  #"=" => state_17 lexbuf
 |  #"<" => action_9 lexbuf
 |  #";" => action_14 lexbuf
 |  #"/" => state_13 lexbuf
 |  #"-" => action_8 lexbuf
 |  #"," => action_13 lexbuf
 |  #"+" => action_7 lexbuf
 |  #"*" => action_19 lexbuf
 |  #")" => action_12 lexbuf
 |  #"(" => action_11 lexbuf
 |  #"'" => state_6 lexbuf
 |  #"\"" => state_5 lexbuf
 |  #"\^@" => action_15 lexbuf
 |  _ => action_22 lexbuf
 end)
and state_3 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_0);
 let val currChar = getNextChar lexbuf in
 case currChar of
    #"\t" => state_39 lexbuf
 |  #"\r" => state_39 lexbuf
 |  #" " => state_39 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_5 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_22);
 let val currChar = getNextChar lexbuf in
 if currChar >= #"#" andalso currChar <= #"[" then  state_34 lexbuf
 else if currChar >= #"]" andalso currChar <= #"~" then  state_34 lexbuf
 else case currChar of
    #"!" => state_34 lexbuf
 |  #" " => state_34 lexbuf
 |  #"\\" => state_36 lexbuf
 |  #"\"" => action_6 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_6 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_22);
 let val currChar = getNextChar lexbuf in
 if currChar >= #"(" andalso currChar <= #"[" then  state_29 lexbuf
 else if currChar >= #"]" andalso currChar <= #"~" then  state_29 lexbuf
 else case currChar of
    #"!" => state_29 lexbuf
 |  #" " => state_29 lexbuf
 |  #"&" => state_29 lexbuf
 |  #"%" => state_29 lexbuf
 |  #"$" => state_29 lexbuf
 |  #"#" => state_29 lexbuf
 |  #"\\" => state_30 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_13 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_22);
 let val currChar = getNextChar lexbuf in
 case currChar of
    #"*" => state_26 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_14 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_3);
 let val currChar = getNextChar lexbuf in
 if currChar >= #"0" andalso currChar <= #"9" then  state_25 lexbuf
 else backtrack lexbuf
 end)
and state_17 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_10);
 let val currChar = getNextChar lexbuf in
 case currChar of
    #"=" => action_18 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_18 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_4);
 let val currChar = getNextChar lexbuf in
 if currChar >= #"0" andalso currChar <= #"9" then  state_23 lexbuf
 else if currChar >= #"A" andalso currChar <= #"Z" then  state_23 lexbuf
 else if currChar >= #"a" andalso currChar <= #"z" then  state_23 lexbuf
 else case currChar of
    #"_" => state_23 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_23 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_4);
 let val currChar = getNextChar lexbuf in
 if currChar >= #"0" andalso currChar <= #"9" then  state_23 lexbuf
 else if currChar >= #"A" andalso currChar <= #"Z" then  state_23 lexbuf
 else if currChar >= #"a" andalso currChar <= #"z" then  state_23 lexbuf
 else case currChar of
    #"_" => state_23 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_25 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_3);
 let val currChar = getNextChar lexbuf in
 if currChar >= #"0" andalso currChar <= #"9" then  state_25 lexbuf
 else backtrack lexbuf
 end)
and state_26 lexbuf = (
 let val currChar = getNextChar lexbuf in
 case currChar of
    #"*" => state_27 lexbuf
 |  #"\^@" => backtrack lexbuf
 |  _ => state_26 lexbuf
 end)
and state_27 lexbuf = (
 let val currChar = getNextChar lexbuf in
 case currChar of
    #"/" => action_1 lexbuf
 |  #"\^@" => backtrack lexbuf
 |  _ => state_26 lexbuf
 end)
and state_29 lexbuf = (
 let val currChar = getNextChar lexbuf in
 case currChar of
    #"'" => action_5 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_30 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #" " andalso currChar <= #"/" then  state_29 lexbuf
 else if currChar >= #"2" andalso currChar <= #"~" then  state_29 lexbuf
 else case currChar of
    #"1" => state_31 lexbuf
 |  #"0" => state_31 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_31 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #"0" andalso currChar <= #"9" then  state_33 lexbuf
 else case currChar of
    #"'" => action_5 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_33 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #"0" andalso currChar <= #"9" then  state_29 lexbuf
 else backtrack lexbuf
 end)
and state_34 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #"#" andalso currChar <= #"[" then  state_34 lexbuf
 else if currChar >= #"]" andalso currChar <= #"~" then  state_34 lexbuf
 else case currChar of
    #"!" => state_34 lexbuf
 |  #" " => state_34 lexbuf
 |  #"\\" => state_36 lexbuf
 |  #"\"" => action_6 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_36 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #" " andalso currChar <= #"/" then  state_34 lexbuf
 else if currChar >= #"2" andalso currChar <= #"~" then  state_34 lexbuf
 else case currChar of
    #"1" => state_37 lexbuf
 |  #"0" => state_37 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_37 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #"#" andalso currChar <= #"/" then  state_34 lexbuf
 else if currChar >= #":" andalso currChar <= #"[" then  state_34 lexbuf
 else if currChar >= #"]" andalso currChar <= #"~" then  state_34 lexbuf
 else if currChar >= #"0" andalso currChar <= #"9" then  state_38 lexbuf
 else case currChar of
    #"!" => state_34 lexbuf
 |  #" " => state_34 lexbuf
 |  #"\\" => state_36 lexbuf
 |  #"\"" => action_6 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_38 lexbuf = (
 let val currChar = getNextChar lexbuf in
 if currChar >= #"#" andalso currChar <= #"[" then  state_34 lexbuf
 else if currChar >= #"]" andalso currChar <= #"~" then  state_34 lexbuf
 else case currChar of
    #"!" => state_34 lexbuf
 |  #" " => state_34 lexbuf
 |  #"\\" => state_36 lexbuf
 |  #"\"" => action_6 lexbuf
 |  _ => backtrack lexbuf
 end)
and state_39 lexbuf = (
 setLexLastPos lexbuf (getLexCurrPos lexbuf);
 setLexLastAction lexbuf (magic action_0);
 let val currChar = getNextChar lexbuf in
 case currChar of
    #"\t" => state_39 lexbuf
 |  #"\r" => state_39 lexbuf
 |  #" " => state_39 lexbuf
 |  _ => backtrack lexbuf
 end)
and Token lexbuf =
  (setLexLastAction lexbuf (magic dummyAction);
   setLexStartPos lexbuf (getLexCurrPos lexbuf);
   state_0 lexbuf)

(* The following checks type consistency of actions *)
val _ = fn _ => [action_22, action_21, action_20, action_19, action_18, action_17, action_16, action_15, action_14, action_13, action_12, action_11, action_10, action_9, action_8, action_7, action_6, action_5, action_4, action_3, action_2, action_1, action_0];

end
