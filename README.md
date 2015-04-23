2014-VTESM-Crowd_Model
======================

This is an opensource agent-based model for crowd modelling.
This code should run in GNU Octave, and the analysis program (datareader.m) even
works in MATLAB. The most current development, as far as force functions, is in
the model-prototype branch. There is a parallel version in progress on
newpattern, but it presently has a critical bug in the goal force helper.

The experimental data, from Qualisys Track Manager, is available
[here](http://goo.gl/YM2Z22), and the final paper on this project is available
[here](http://goo.gl/L2YuRC).

Octave can be downloaded for Windows from several
[locations](http://wiki.octave.org/Octave_for_Microsoft_Windows), but the Cygwin
version is presently recommended as the parallel package should be buildable,
which is required for newpattern. Otherwise, or if turning off parallel in the
configuration, the MXE Build should be fine.

After downloading and extracting the archive, or cloning the repo, the model can
be run with or by modifying the demo script in the model directory. This will be
a bat file on Windows, or an sh file on OSX/Linux/Cygwin. It requires Octave to
be in the path. For Windows, add C:\Octave\Octave-[version]\bin
([see this](http://windowsitpro.com/systems-management/how-can-i-add-new-folder-my-system-path)).

The model can be adjusted by changing parameters in the demo script, and in the
force functions and engine M files.
