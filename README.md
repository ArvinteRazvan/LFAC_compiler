# LFAC compiler
As the final task for Formal Languages, Automata and Compilers( LFAC ), I developed this compiler using LEX and YACC.

As a sidenote, this task was done in Second year, First semester at FII UAIC, 2016-2017 and it was my first big homework.

I enjoyed working at this and I know that my solution might not be the best, but I consider it abstract and funny anyway.

The files have the following meanning:
linbaj.l - LEX file, here using regex I identified variables and keywords.
limbaj.y - YACC file, here I defined the language and some predifined functions.
lfac_header.h - Header file, here I defined what is a variable, a function and the logic.

If you are just passing by through this repository, a quick resume is:
  I stored the variables and functions like this:
```C++
  struct variable
{
	char name[100];
	char type[10];
	int*dimensions;
	int dimensions_nr;
	int initialized;
	void*starting_pt;
};

struct function
{
	char name[50];
	char type[10];
	int nr_of_param;
	char param[nr_max_param][10];
};
```

In rest I just builded the logic for them to work, data declaration, initialization and conversion.

Link to the course page: https://profs.info.uaic.ro/~mmoruz/labs/lfac.html
