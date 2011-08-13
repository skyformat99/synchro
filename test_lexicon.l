%option noyywrap nodefault
%{

#include "bstr/bstrlib.h"
#include "test_parser.tab.h"

int get_operator(char *input);

/* handle locations */
int yycolumn = 1;
int last_line =1;

#define YY_USER_ACTION { \
    if (yytext[0] == '\n') {\
        yylineno += 1; yycolumn = 1;\
    } \
    yylloc.last_line    = yylineno - 1; \
    yylloc.first_column = yycolumn; \
    yylloc.last_column  = yycolumn + yyleng - 1; \
    yycolumn += yyleng; \
}

%}

%x AT_COMMENT
%x AT_COPY
%x AT_COPY_AND_TEST

%%

"/*" {
    BEGIN AT_COMMENT;
}

<AT_COMMENT>"*/" {
    BEGIN INITIAL;
}

<AT_COMMENT>"#=" {
    BEGIN AT_COPY;
}

<AT_COPY>\n {
    BEGIN AT_COMMENT;
    return EOL;
}

<AT_COPY>[\(a-zA-Z0-9_].*; {
    yylval.s = bfromcstr(yytext);
    return SENTENCE;
}

<AT_COMMENT>"#!" {
    BEGIN AT_COPY_AND_TEST;
}

<AT_COPY_AND_TEST>\n {
    BEGIN AT_COMMENT;
    return EOL;
}

<INITIAL>^"#"[ \t]*include[ \t]*["<][^ \t\n\">]+[">] {
    yylval.s = bfromcstr(yytext);
    return INCLUDES;
}

<AT_COPY_AND_TEST>".==" {
    return EQU;
}

<AT_COPY_AND_TEST>".>=" {
    return GT_EQU;
}

<AT_COPY_AND_TEST>".<=" {
    return LT_EQU;
}

<AT_COPY_AND_TEST>".!=" {
    return N_EQU;
}

<AT_COPY_AND_TEST>".>" {
    return GT;
}

<AT_COPY_AND_TEST>".<" {
    return LT;
}

<AT_COPY_AND_TEST>[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.s = bfromcstr(yytext);
    return IDENTIFIER;
}

<AT_COPY_AND_TEST>0|\-?[1-9][0-9]* { 
    yylval.s = bfromcstr(yytext);
    return NUMBER;
}

<AT_COPY_AND_TEST>"\"".*"\"" {
    yylval.s = bfromcstr(yytext);
    return STRING;
}

<AT_COPY_AND_TEST>"(" {
    yylval.s = bfromcstr(yytext);
    return OP;
}

<AT_COPY_AND_TEST>")" {
    yylval.s = bfromcstr(yytext);
    return CP;
}

<AT_COPY_AND_TEST>"+"|"-"|"*"|"/"|"%"   {
    return get_operator(yytext);
}

<AT_COPY_AND_TEST>"," {
    yylval.s = bfromcstr(yytext);
    return COMMA;
}


<INITIAL,AT_COMMENT>\n {
    return EOL;
}

<INITIAL,AT_COMMENT,AT_COPY_AND_TEST,AT_COPY>[ \t] { }
<INITIAL,AT_COMMENT,AT_COPY_AND_TEST,AT_COPY>. { }
%%

int get_operator(char *input) {
    yylval.s = bfromcstr(input);
    //fprintf(stderr, "%s\n", bdata(str));
    return OPERATOR;
}