# DESim Frontend

The frontend graphical user interface (GUI) for DESim allows the user to toggle inputs and see outputs of their simulated circuit. A detailed description of the GUI is provided in the tutorial called _Using the DESim Application_. 

## Modifying the DESim Frontend

The GUI is written in Java 17.0.1 using IntelliJ IDEA 2021.3.1 (Community Edition). Complete each of the following sections to modify and update the DESim frontend. Currently, only MS Windows is supported. Linux support is to be added soon.

### Source Code

Download a copy of this _DESim GitHub Repository_ to your computer, using a tool of your choice such as _Command-Line Git_, _GitHub Desktop_, etc.

### Java

DESim requires _JDK_, _JavaFX_ and _JMods_. You can obtain _Open JDK_ from https://jdk.java.net/archive/.  On that website, scroll down to locate Verson 17.0.1. Click to download the appropriate format that matches your computer operating system. Now, to obtain _Open JavaFX SDK_ and _JMods_, navigagte to the website https://openjfx.io. Click the _Download_ link, which will open a download page, then use the provided dropdown menu to select _Version 17.0.15_ (or similar). You need to download both the JDK and JMods archives; download the appropriate format of both files that matches your computer operating system. Uncompress all three packages (JDK/JavaFX SDK/JMods) to a directory named Java. This Java directory should be in your GitHub folder alongside DESim; your directory structure should be similar to:

<pre>
./
+--DESim/
|  +--backend/
|  +--demos/
|  +--documentation/
|  +--frontend/
|  +--installer/
+--Java/
   +--javafx-jmods-17.0.15/
   +--javafx-sdk-17.0.15/
   +--jdk-17.0.1/
</pre>

### IntelliJ IDEA 2021.3.1

Next, you have to install IntelliJ IDEA Community Edition. You can obtain different versions of IntelliJ IDEA from the URL https://www.jetbrains.com/idea/download/other.html. We used version 2021.3.1, and we recommend that you use this version, but other versions might also work. Click on the appropriate link to download and install IntelliJ IDEA on your computer.

Start the IntelliJ software, and then open the _frontend_ project. The IntelliJ software has a dialogue that you can use to open a project. In this dialogue you click on the _Open_ button and then browse to select and open the folder named _frontend_. After opening the project, check the following settings:

1. Project SDK
    1. Open File -> Project Structure. 
    2. Check if Project Settings -> Project -> SDK  is set to an SDK for 17.0.1
    3. If an appropriate SDK does not exist (because you installed Java into a different folder from the one we suggested, or you installed a version other than 17.0.1), then create a new one under Platform Settings -> SDKs
        1. Navigate to Platform Settings -> SDKs in the Project Structure Dialog
        2. Click the + (Add New SDK)
        3. Select "Add JDK..."
        4. Navigate to and select the Java/jdk-17.0.1/ directory
        5. Click the OK button
        6. Give it a name such as "JDK for FPGAcademy"
        7. Go back to Project Settings -> Project -> SDK and set it to the new SDK
2. Libraries
    1. Open File -> Project Structure.
    2. Check Project Settings -> Libraries has a library named _lib_ for _JavaFX_
    3. If the library does not exist (because you installed Java into a different folder from the one we suggested, or you installed a version other than 17.0.15), create a new one.
        1. Click the + (New Project Library)
        2. Choose Java
        3. Navigate to and select the Java/javafx-sdk-17.0.15/lib/ directory
        4. Click the OK button
        5. The Java FX SDK should now be in the library list
3. Module-path
    1. Open Run -> Edit Configurations...
    2. Click on the _Modify Options_ dropdown and ensure that there is a checkmark beside _Add VM options_.
    3. Identify the VM Options Arguments box (it is the box with a lot of text inside it). On the righthand side of this box, click on the arrows to expand the size of the box.
    4. The first item in the VM Options Arguments should be "C:/GitHub/Java/javafx-sdk-17.0.15/lib". If this folder does not match the one where your Java library is installed, then modify it acccordingly.
    5. Click OK in the Edit Configurations to save your changes
4. Install the _DESim_ Application to your computer. This step is needed because it provides some files that will be read by DESim when run within IntelliJ.
     1. Navigate on the Internet to the URL https://fpgacademy.org/tools.html. In the DESim section select version 24.1 and then click to download the ZIP file labelled _Installation Files for Windows_.
     2. Uncompress the _DESim.zip_ file to your computer. We recommend storing this file in the location C:\DESim.
5. Install the simulator that you will be using with DESim. We recommend ModelSim, because it does not require a license, but you could also choose Questa, which is a more recent version. Instructions for installing ModelSim (or Questa) are provided on the Software tab of the website https://fpgacademy.org/tools.html. Ensure that your simulator can be found in your operating system's _Path_ environment variable, as this will be needed by IntelliJ. For example, your _Path_ might include C:\intelFPGA\20.1\modelsim_ase\win32aloem, or C:\intelFPGA_pro\24.1\questa_fse\win64
6. Configure Run-Time Options in IntelliJ
   1. As you did in Step 3. above, Open Run -> Edit Configurations
   2. Ensure that the Working Directory is set to C:\DESim (or whatever location you have used in Step 4.2 above)
   3. Click on the _Modify Options_ dropdown and ensure that there is a checkmark beside _Environment variables_.
   4. Ensure that the Enviorment Variables include both DESimPath and DESimulator, such as: DESimPath=C:\DESim;DESimulator=modelsim. If you installed DESim to a folder other than C:\DESim, then set DESimPath to that folder instead. Also, if are using the Questa simulator, then change this setting to DESimulator=questa.

Now that all the necessary settings have been checked, the frontend may be modified and tested using IntelliJ.

### Building the release version

If modification have been made to the frontend, a new release version should be create. The release version of the DESim frontend is a self contained Java VM. Follow these steps to build the release version:
1. Click Build -> Rebuild project within IntelliJ. This will compile the latest version of the frontend to the ./out directory.
2. Run the build_release.bat (on Windows) or build_release.sh (on Linux). This creates the self contained Java with DESim.
3. To run the release version, see the ../installer/windows/DESim_run.bat or ../installer/linux/DESim.sh
4. The DESim frontend is now ready to be added to a new version of the installer
