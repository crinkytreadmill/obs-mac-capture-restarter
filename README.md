# OBS Mac Capture Restarter

An OBS Studio Lua script that automatically restarts frozen macOS screen captures and audio sources, solving common issues where these sources freeze when monitors are turned off, computers go into sleep mode, or audio devices are disconnected.

## Problem This Solves

On macOS, OBS Studio's screen capture and audio sources can freeze or become unresponsive when:
- Your monitor is turned off
- Your computer goes into sleep mode
- Power management events occur
- External displays are disconnected/reconnected
- Audio devices are disconnected/reconnected
- System audio routing changes

When this happens, your screen capture shows a static image and audio sources stop capturing sound, requiring manual intervention to restart the sources.

## How It Works

This script automatically monitors all screen capture and audio sources in your OBS Studio setup and:
- Checks every 15 seconds for frozen captures
- Detects when the "reactivate capture" option becomes available (indicating a frozen source)
- Automatically clicks the reactivate button to restart the source
- Logs when sources are restarted with specific source names for troubleshooting

### Supported Source Types

- **Screen Capture**: macOS screen capture sources
- **Audio Input**: Microphone and other input devices (coreaudio_input_capture)
- **Audio Output**: System audio and speaker output (coreaudio_output_capture)

## Installation

### Method 1: Download Script File

1. Download the `capture_restarter.lua` file from this repository
2. Save it to a location on your Mac (e.g., `~/Documents/OBS Scripts/`)

### Method 2: Clone Repository

```bash
git clone https://github.com/crinkytreadmill/obs-mac-capture-restarter.git
cd obs-mac-capture-restarter
```

## Usage

### Adding the Script to OBS Studio

1. Open **OBS Studio**
2. Go to **Tools** → **Scripts**
3. Click the **+** button (Add Scripts)
4. Navigate to and select `capture_restarter.lua`
5. Click **Open**

The script will automatically start running and monitoring your screen captures and audio sources.

### Verifying It's Working

1. In the Scripts window, you should see "OBS Mac Capture Restarter" listed
2. Check the **Script Log** tab for any messages
3. When the script starts, you'll see: `"Capture Restarter: Monitoring screen captures and audio sources every 15 seconds"`
4. When a source is restarted, you'll see messages like:
   - `"Restarted screen capture: Display 1"`
   - `"Restarted audio input: MacBook Pro Microphone"`
   - `"Restarted audio output: BlackHole 2ch"`

### Removing the Script

1. Go to **Tools** → **Scripts**
2. Select the script from the list
3. Click the **-** button (Remove Scripts)

## Configuration

The script runs automatically with these default settings:
- **Check interval**: 15 seconds
- **Target sources**: All macOS screen capture and audio sources
- **Auto-restart**: Enabled when reactivate option is available

Currently, there are no user-configurable options, but you can modify the script if needed:
- Change the timer interval by editing line 58: `obslua.timer_add(check_capture_status, 15000)` (15000 = 15 seconds)
- Add or remove source types by modifying the `SOURCE_TYPES` table at the top of the script

## Technical Details

- **Language**: Lua (OBS Studio scripting API)
- **Compatibility**: macOS with OBS Studio
- **Resource usage**: Minimal (15-second timer with efficient source enumeration)
- **Memory management**: Properly releases resources to prevent memory leaks

### How Detection Works

The script identifies frozen sources by checking if the "reactivate_capture" property is enabled on screen capture and audio sources. This property only becomes available when OBS detects that a source has become unresponsive.

## Troubleshooting

### Script Not Working

1. **Check OBS Version**: Ensure you're using a recent version of OBS Studio
2. **Verify Script is Loaded**: Check Tools → Scripts to confirm the script is listed
3. **Check Logs**: Look in the Script Log tab for error messages
4. **Source Type**: Ensure you're using supported source types:
   - macOS "Screen Capture" sources (not Display Capture or other types)
   - "Audio Input Capture" and "Audio Output Capture" sources

### High CPU Usage

If you experience performance issues:
1. Increase the check interval in the script (change `15000` to a higher value like `30000` for 30 seconds)
2. Reduce the number of monitored sources in your scenes

### Sources Still Freezing

- The script can only restart sources that OBS detects as frozen
- Some issues may require manual intervention or system-level fixes
- For screen captures: Consider using Window Capture instead of Screen Capture for specific applications
- For audio sources: Check macOS audio device settings and permissions

### Audio-Specific Issues

- **Audio permissions**: Ensure OBS has microphone and audio access in macOS System Preferences → Security & Privacy
- **Device conflicts**: Check that audio devices aren't being used exclusively by other applications
- **Sample rate mismatches**: Ensure audio device sample rates match OBS settings