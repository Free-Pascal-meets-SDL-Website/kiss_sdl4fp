# kiss_sdl4fp

kiss_sdl4fp is a conversion project of the kiss_sdl GUI widget toolkit from C to Free Pascal.

kiss_sdl is a simple generic GUI widget toolkit for SDL2 written in C and
maintained by Tarvo Korrovits. You can find it here: https://github.com/actsl/kiss_sdl.

## Description

### Key Features

* keep it small and simple approach (hence kiss)
* doesn't need any external library, except for SDL2
* lightweight
* easy to use, fast to grasp
* highly flexible and extendable
* perfectly suitable for most SDL2 applications
* permissive software license

An extensive description and screenshots are found here: https://github.com/actsl/kiss_sdl. Some key quotes from this source by Tarvo:

This toolkit was made as simple as possible, to solve the problem of an immense complexity of many existing toolkits, which makes it impossible for many people to even use them. At that it was made general, many simpler toolkits don't enable you to do many things that you want, due to their restricted internal design. This toolkit implements an original innovative approach for a widget toolkit that i call principal GUI, going further from immediate GUI, this new approach enabled to make the widget toolkit simpler.

What is necessary for using the toolkit in a code is simple and straightforward. Every widget has three functions written for it, a function to create a new widget, a function to process the events, and a function to draw. The base functions implemented for the widgets, do all the automagical things, and the user can write one's own function, using a base function inside it, to do any additional things that the user may want to do.

### Widgets

* window
* label
* button
* selectbutton
* vertical scrollbar
* horizontal scrollbar
* progressbar
* entry box
* text box
* combo box

## Main Goal of kiss_sdl4fp

Keep the conversion (kiss_sdl4fp) as close as possible to the original code and
concept of kiss_sdl and avoidance of as many dependencies on other units as possible.

Nevertheless, the nature of Pascal made deviations from this rule necessary or
beneficial.

### Header and C Files are combined in Unit Files

kiss_sdl.h and the implementation c-files are combined into the following units:

* kiss_draw.pas (kiss_sdl.h, kiss_draw.c, ver. 1.2.0 and 1.2.4)
* kiss_general.pas (kiss_sdl.h, kiss_general.c, both ver. 1.2.0)
* kiss_posix.pas (kiss_sdl.h, kiss_posix.c, both ver. 1.2.0)
* kiss_widgets.pas (kiss_sdl.h, kiss_widgets.c, ver. 1.2.0 and 1.2.4)

### Pascal strings instead of C's char pointer

The work with Pascal's strings is much more convenient and less error prone, so
the benefit of implementing them, instead of directly converting C's char
pointers, is just too huge.

## Manual and Examples

The original project has an extensive manual, obviously written for C, but you
can learn a lot from it about using kiss_sdl4fp, too!

https://raw.githubusercontent.com/actsl/kiss_sdl/master/kiss_manual.pdf

Two example files are converted, too. These serve as major source for learning
how to use this toolkit. It is really simple, so just try it! Just compile the
plain source code files (kiss_example1.pas, kiss_example2.pas).

## To-Do

* check kiss_init(), esp. why acc. renderer doesn't work

## Version

1.0.0

## License

See LICENSE.md for information.

