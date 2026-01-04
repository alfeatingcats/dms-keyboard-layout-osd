import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Modules.Plugins

PluginComponent {
    id: root
    
    property string currentLayout: ""
    property var osdInstance: null

    Component.onCompleted: {
        console.info("Keyboard Layout Watcher daemon started");
        
        var component = Qt.createComponent("KeyboardLayoutOSD.qml");
        if (component.status === Component.Ready) {
            osdInstance = component.createObject(root);
        } else {
            console.error("Failed to create OSD component:", component.errorString());
        }
    }
    
    Process {
        id: layoutMonitor
        running: true
        
        command: ["/bin/bash", "-c", `
            current=""
            while true; do
                output=$(niri msg keyboard-layouts 2>/dev/null)
                new=$(echo "$output" | grep '\\*' | sed 's/.*\\* [0-9]\\+ //' | xargs)
                
                if [ "$new" != "$current" ] && [ -n "$new" ]; then
                    echo "$new"
                    current="$new"
                fi
                
                sleep 0.3
            done
        `]
        
        stdout: SplitParser {
            onRead: layout => {
                var trimmedLayout = layout.trim();
                if (trimmedLayout && trimmedLayout !== root.currentLayout) {
                    root.currentLayout = trimmedLayout;
                    
                    if (root.osdInstance) {
                        root.osdInstance.updateLayout(trimmedLayout);
                    } else {
                        console.warn("OSD instance not available, using toast fallback");
                        ToastService.showInfo("Layout", trimmedLayout, 1500);
                    }
                    
                    console.log("Layout changed to:", trimmedLayout);
                }
            }
        }
        
        stderr: SplitParser {
            onRead: line => {
                if (line.trim()) {
                    console.error("Layout monitor error:", line);
                }
            }
        }
        
        onExited: (exitCode) => {
            if (exitCode !== 0) {
                console.error("Layout monitor process exited with code:", exitCode);
                restartTimer.start();
            }
        }
    }
    
    Timer {
        id: restartTimer
        interval: 5000
        repeat: false
        onTriggered: {
            console.info("Restarting layout monitor...");
            layoutMonitor.running = true;
        }
    }
    
    Component.onDestruction: {
        console.info("Keyboard Layout Watcher daemon stopped");
        if (osdInstance) {
            osdInstance.destroy();
        }
    }
}