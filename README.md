CONFSUBST
=========

```ex
NAME
	confsubst - templating & variable interpolation CLI utility


SYNOPSIS
	confsubst [--elVvh] [-o DIR] [--] [-]|DIR|FILE...

	with no DIR|FILE... or if FILE is [-], read STDIN

.
DESCRIPTION
	confsubst is a simple cli tool for populating templates with user/system defined variables.

	with "-e, --env <FILE>" it loads variables from a file or the system env if left empty.

	it loads one or many template files.

	if the specifed path is a directory it loads all files recursively in that path.

	confsubst is "self-contained" & dont require any config file.

	the template destination path & other config are defined in the same template file
	it supports a vim modeline like syntax.
	the modeline can be placed anywhere in the file as a comment.
	eg:
.
		"-- mxc: path=$XDG_CONFIG_HOME/wezterm/color.lua label=wezterm"
		"# mxc: path=$XDG_CONFIG_HOME/kitty/kittheme.conf"
		"! mxc: path=$XDG_CONFIG_HOME/mxc/mxresources.xdefaults"


.
OPTIONS
	-e, --env <FILE>      environment overrides
	-l, --log <FILE>      verbose log file
	-o, --output <DIR>    output path
	-V, --verbose         be more verbose
	-q, --quiet, --silent inhibit the usual output
	-h, --help            display this help & exit
	-v, --version         display version & exit


EXAMPLES
	# substitute all files under templates/
	confsubst templates

	# substitute two files
	confsubst templates/wezterm-color.lua templates/nvim-colors.lua

	# substitute all files under templates/ override environment with .env file
	confsubst -e .env -- templates

	# substitute all files under templates/ with increased verbosity
	confsubst --verbose templates

	# substitute all files resulted from command & override output path
	confsubst -o myoutput - <(ls --zero | tr '\0' ' ')

	# substitute all files received as stdin & override log path
	find . -type f -print0 | confsubst -l /tmp/mylog


SEE ALSO
	envsubst(1), env(1), environment(5), environ(7), sed(1), awk(1), grep(1), tr(1)


AUTHOR
	metaory <metaory@gmail.com>, Jan 2024
```

#### Templating & Variable Interpolation CLI Utility

##### Render `STDIN|DIR|FILE...` with `[-e <FILE>]|env`

Substitute placeholders in file(s)

###### ● Substitutes Files Placeholders
###### ● Self-contained Options with vim modeline like syntax
###### ● ~~Pre/Post Hooks~~

## Features
-  `[-e <FILE>]` to override environment
-  `modeline` like syntax for optional _self-contained*_ file settings
-  `pre`/`post` hooks for other custom pre/post processing
-  `path` for replacing existing file

---

# Installation

- clone repo
- give execution permissions
- place it in your path

```ex
# Clone the repo
git clone git@github.com:metaory/confsubst.git

# Navigate to repo
cd confsubst

# Give execution permissions
chmod +x confsubst

# Link it somewhere in your PATH
ln -svf $PWD/confsubst /usr/bin/confsubst

# Use it anywhere

# Usage help
confsubst --help

# Render two templates
# With no -e, --env system environment variable is used
# With no -o, --output rendered templates will go to /tmp/mxc/*
# With modeline path present in template file rendered template will be copied
confsubst templates/wezterm-color.lua templates/nvim-colors.lua

# Render all files in mytemplate directory rendered with merged variables of ~/dummy/.env
confsubst -e ~/dummy/.env  mytemplate/
```

---

## Example Use Cases

#### Generate Environment Variables at Runtime & Substitute config file placeholders with it

`Pre Hook` to **generate** some variables at runtime

`Path` to define the **destination** path

`Post Hook` to then **restart** some service or app

#### Update Colorscheme System Wide
Substitute colorscheme variables in different applications with different formats

For example:
- terminal colorscheme config
- editor colorscheme config
- window manager theme
- tmux theme config
- xresources
- icon theme
- gtk theme
- ...

The `Pre Hook` could **generate** some random colorscheme on the fly

_or use system or `.env` values_

The `Path` would define the **destination** path

_or the output will be only on /tmp_

The `Post Hook` could then **reload** a terminal or window manager config

---

## Hooks
Hooks can be used to for any pre/post processing; like

A pre hook to produce dynamic values at runtime, Or any other pre steps

A post hook to do clean up, reload apps config, or run any other post steps.

> _hook path must executable_

---

## How it works

#### Source `.env` in current working directory

`if` found _(optional)_

> Syntax: simple "KEY=VAL" pairs on separate lines:

> ```ex
> MY_VAR_NAME=MY_VALUE
> ```

#### Parse `modeline` in the file

`if` (`mxc:`) is found _(optional)_

> An Optional Vim like syntax to define file settings

> `[text{white}]{mx:|mxc:}[white]{options}`

#### Exec Pre Hook

`if` (`pre=`) is found in `modeline` _(optional)_

> _should have execute permission (x)_

> To handle any custom user **pre processing steps** for a file

> `mxc: pre=~/bin/some_prehook`

#### Populate(substitute) the file(s) with System or `.env` values
> using [envsubst](https://man.archlinux.org/man/envsubst.1.en)

#### Exec **Post Hook**

`if` (`post=`) is found in `modeline` _(optional)_

> _should have execute permission (x)_

> To handle any custom user **post processing steps** for a file

> `mxc: post=~/bin/my_post_hook`

#### Copy the populated file in tmp with the original name
> `/tmp/mxc/somename.whatever` for example

> `~/dummy/kitty.conf` would produce `/tmp/kitty.conf`

#### Copy the populated file to a secondary path
`if` (`path=`) is found in `modeline` _(optional)_

> `mxc: path=~/.config/nvim/lua/my_theme.lua

---

## Config (template) files
- All provided files (or all files in provided directory) will parsed & populated

- The file can be any ascii charset file with any name & extension

- Optionally there can be a **modeline** comment somewhere in the file

#### modeline syntax
The **modeline** follows similar syntax to the first form of (n)Vim modeline [:h modeline](https://neovim.io/doc/user/options.html#modeline)

The **modeline** & **all** its keys are **optional**

```cpp
[text{white}]{mx:|mxc:}[white]{options}

[text{white}]       empty or any text followed by at least one blank character (<Space> or <Tab>)
{mx:|mxc:}          the string "mx:" or "mxc:"
[white]             optional white space
{options}           a list of key-value options, separated with white space
```

#### modeline can have the following keys _(all are optional)_
- `label` display label
- `path`  secondary destination path
- `pre`   pre hook executable path
- `post`  post hook executable path

###### Example modeline:

`# mxc: label=[label] path={dest_path} pre=[script_path] post=[script_path]`

`// mxc: label=kitty_theme path=$XDG_CONFIG_HOME/kitty/kitty-theme.conf post=~/bin/reload_kitty.sh`

`; mx: label=xresources path=~/.Xresources post=~/bin/merge_xrdb.sh`

---

## Environments

- You can View your current environment values with `printenv` or `env`
_from the [coreutils](https://archlinux.org/packages/core/x86_64/coreutils/)_

#### You can Override the environment by providing an file or with `.env` in CWD

## Sample .env file

> Syntax: simple "KEY=VAL" pairs on separate lines: _[man pam_env.conf](https://man.archlinux.org/man/pam_env.conf.5.en#:~:text=Now%20some-,simple)_

```ex
# .env
SOME_VAR=FOO
SOME_PATH="$HOME/.config/nvim/init.lua"
SOME_NUM=2200
SOME_BOOL=true
```

## Sample template files

```ex
ls -a .
# .env
# wezterm_color.lua
# kitty_theme.conf
# nvim_color.lua
# awesomewm_color.lua
# meta.tmuxtheme
# xresources-colors.xdefaults
# papirus-colors.gtk
# numix.gtk
```

`cat .env`
```ex
XFG='#668899'
XBG='#222233'
C00='#333344'
C01='#bb4466'
C02='#11cc99'
C03='#cc9955'
C04='#2277dd'
C05='#7766cc'
C06='#11bbee'
C07='#668899'
C08='#445566'
```

`cat wezterm_color.lua`
```lua
-- mxc: path=~/.config/wezterm/wez_color.lua
return {
  foreground = "$XFG",
  background = "$XBG",
  ansi= {
    "$C00",
    "$C01",
    "$C02",
    "$C03",
    "$C04",
    "$C05",
    "$C06",
    "$C07",
    "$C08"
  }
}
```

`cat kitty-theme.conf`
```ex
# mxc: path=$XDG_CONFIG_HOME/kitty/kitty-theme.conf post=~/bin/reload_kitty.sh

background $XBG
foreground $XFG
color0     $C00
color1     $C01
color2     $C02
color3     $C03
color4     $C04
color5     $C05
color6     $C06
color7     $C07
color8     $C08
```

---

# Requirements

All of Current requirements are part of the [base](https://archlinux.org/packages/core/any/base)

- `env` provided by [gnu coreutils](https://archlinux.org/packages/core/x86_64/coreutils)
- `envsubst` provided by [gnu gettext](https://archlinux.org/packages/core/x86_64/gettext)

# Optional Requirements

- ~~[Pastel](https://github.com/sharkdp/pastel) - color preview~~

---

# TODOs

- [x] variable substitution
- [x] handle directories
- [x] parse modeline
- [ ] pre/post hooks
- [ ] inline hooks

---

### Environment File POSIX Definition

[8.1 Environment Variable Definition](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html)

>  These strings have the form name=value; names shall not contain the character '='. For values to be portable across systems conforming to POSIX.1-2017, the value shall be composed of characters from the portable character set (except NUL & as indicated below). There is no meaning associated with the order of strings in the environment. If more than one string in an environment of a process has the same name, the consequences are undefined.

> Environment variable names used by the utilities in the Shell & Utilities volume of POSIX.1-2017 consist solely of uppercase letters, digits, & the <underscore> ( '_' ) from the characters defined in Portable Character Set & do not begin with a digit. Other characters may be permitted by an implementation; applications shall tolerate the presence of such names. Uppercase & lowercase letters shall retain their unique identities & shall not be folded together. The name space of environment variable names containing lowercase letters is reserved for applications. Applications can define any environment variables with names from this name space without modifying the behavior of the standard utilities.

---

## License

[MIT](LICENSE)
