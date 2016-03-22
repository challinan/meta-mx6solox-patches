This layer builds the patient monitor demo for i.mx6 SoloX Sabre SDB board.

The layer contains the conf file that should be duplicated in the MEL build.  This layer was tested with the following (Birch) releases:

Nucleus 2015.07
SCB 2014.11-96
MEL 2014.12-332

The conf files assume the following directory layout:

MEL installed in ${HOME}/mgc
Project (Build dir) located in /scratch/working/birch/build-mx6solox-memf-new
This layer located in /scratch/sandbox/meta-mx6solox-patches

Modify your build locations to suit your environment (at your peril!) :)

Scripts to populate the sdcard (mksdboot_mx6q.sh) and a wrapper script (sdcard-setup.sh) are included in mel-conf-files.  If you use the same install locations as described above, these will just work.  Of course, you will have to adjust --device to point to your mmc device on your host.
