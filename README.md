# eGPU Setup
**eGPU Setup** for Mac is a user-friendly native macOS application written in **Swift**. **eGPU Setup** encompasses the eGPU community's techniques to enable external GPUs on all thunderbolt Macs, use unsupported external GPUs, and force applications to use external GPUs for *computation and rendering*.

## Basic Requirements
**eGPU Setup**, due to its nature of patches, requires:
- **macOS**: High Sierra (10.13.4+) or later
- **System Integrity Protection**: Must be disabled completely
- **Apple Boot Security**: Disabled completely

## Features
**eGPU Setup** is a high-fidelity macOS application that includes the following capabilities:
- Support for **AMD** or **NVIDIA** eGPUs
- Support for *all* thunderbolt Macs
- Support for *all* external GPU enclosures
- System **disk** & **EFI-level** patching mechanism options
- Unified application eGPU preference management system
- Software updates, troubleshooting, & additional support provisions
- eGPU notification system for additional steps for edge-case machines
- Menubar application for eGPU status monitoring

## User Interface
The setup process is *straight-forward, autonomous, and simple*. Every application page is descriptive & informative, with the ability to read more of what's happening & some tips & tricks for a seamless experience. The following procedures are automated:
- System configuration detection
- eGPU configuration detection
- System application eGPU preference detection

### eGPU Setup Introduction
- Retrieves your system configuration
- Retrieves your current system eGPU status
- Determines compatibility and edge cases

Screen Grab #1

### eGPU Preferences Manager
- Fetches all applications in *expected* locations
- Allows performing a deeper scan for other applications
- Allows setting/unsetting the eGPU preference for one or more applications
- Allows easy set/reset of eGPU preference for all applications

Screen Grab #2, #3

### eGPU Uninstallation
- Briefs the user on the uninstallation process
- Provides a *safe* general uninstallation mechanism
- Provides an option to uninstall *all* components, with fair warning
- Performs uninstallation with verification & system integrity checks

Screen Grab #3, #4

### eGPU Installation
- Automatically determines your eGPU configuration
- Allows manual adjustments for configuration settings as needed
- Provides an option for direct kernel patching or in-memory on-the-fly
- Performs a validated system patch
- Installs the **eGPU Setup Recovery Tool CLI** for recovery in **Single User Mode**

Screen Grab #4, #5

## System Patches
The following is a summary of system patches required for macs based on the system configuration and eGPU vendor.

## AMD eGPUs
All patches leverage the native AMD eGPU acceleration functionality. Additional patches are needed for older AMD eGPUs such as the R9 Fury, and some modern GPUs that Apple has not enabled support for, such as the RX 560.

### Thunderbolt
- **Thunderbolt 1/2**: Require the **AppleGPUWrangler Thunderbolt** patch for full native support. **AMDUnofficialSupport.kext** also required for older AMD GPUs.
- **Thunderbolt 3**: **AMDUnofficialSupport.kext** required for older AMD GPUs. Modern GPUs are natively supported and require no patches.

### Problematic Systems
- **Discrete NVIDIA GPUs**: Such macs have problems rendering on an external AMD GPU. A workaround is included, but has compromises at this time.
- **Old AMD eGPUs**: Not all older AMD GPUs may work. A workaround is included to attempt acceleration.

## NVIDIA eGPUs
All macs require system patches to enable NVIDIA eGPUs at this time. Patches support hot-plugging and booting with the eGPU plugged in, but there are a variety of complications involved. The patches auto-bypass thunderbolt limitations.

### Limitations
- **Hot-Disconnect**: Not possible with the current patching mechanism. Doing so will crash the system. The menubar eGPU ejection system is also disabled.
- **Discrete AMD GPUs**: Such macs require additional steps to achieve good UI performance.