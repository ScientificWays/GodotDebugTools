# GDConsole
A simple godot plugin implementing in-game debug console.


This plugin adds an autoload script that allows creating commands in any script and executing them in the in-game console.  
Commands can take arguments and _shouldn't_ crash the game if something fails. Error will be shown in console instead.  
Can also be used to print information using `GDConsole.print_line`, `GDConsole.print_warning`, `GDConsole.print_error`.  
Works only when ran in the editor or in debug build.


## Features
- **History**: Commands history navigatable using arrow keys.
- **Autocomplete**: Highlights matched command that can be autocompleted using tab.

## Usage
Create a command in `_ready()` or `_init()` using the autoload:
```GDScript
func _ready():
	GDConsole.create_command(my_func)

func my_func(arg):
	...
```
Then hit `~` in game to launch the console and run the command.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
