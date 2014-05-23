# Jon Pascoe's DotFiles

My first stab at a dotfiles project was a modified clone of [Ryan Bates'](https://github.com/ryanb) excellent [dotfiles project](https://github.com/ryanb/dotfiles). Whilst this one draws heavily from that project, I've completely rewritten the installer/updater script to be a little more useful/maintainable.

I'm running on Mac OS X, but this project will likely work on Linux as well.

## Installation

Run the following commands in your terminal. You will be prompted before any changes are committed to your system. Check out the [Rakefile](https://github.com/pacso/dotfiles/blob/master/Rakefile) and the associated tasks in [/rakelib](https://github.com/pacso/dotfiles/blob/master/rakelib) to see exactly what it does.

```terminal
git clone git://github.com/pacso/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```

After installing, open a new terminal window to see the effects.

## Updating things

This project makes use of other open-source projects, such as [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). To simplify the job of keeping them all up to date, there is a master update task to do this for you:

```terminal
cd ~/.dotfiles
rake update
```

However, if for some reason you just want to update one component, you can use the namespaced update action instead:

```terminal
cd ~/.dotfiles
rake zsh:update
```

## Uninstall

To completely remove everything:

```terminal
cd ~/.dotfiles
rake uninstall
```
